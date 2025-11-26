# app/services/sii_client.py
from __future__ import annotations

from datetime import datetime
import json
import xml.etree.ElementTree as ET
from typing import Callable, Optional
from copy import deepcopy
from functools import lru_cache
import base64

from sqlalchemy.orm import Session

from cryptography.hazmat.primitives.serialization.pkcs12 import (
    load_key_and_certificates,
)
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding

from app.db.session import SessionLocal
from app.models.document import Document
from app.models.log_event import LogEvent
from app.services.caf_service import (
    CafParsed,
    get_caf_for_document,
    parse_caf_xml,
)
from app.services.envio_dte import build_envio_dte_xml, send_envio_dte_dummy
from app.services.xml_validator import validate_dte, validate_enviodte
from app.core.config import get_settings

settings = get_settings()

# Namespaces
SII_NS = "http://www.sii.cl/SiiDte"
DS_NS = "http://www.w3.org/2000/09/xmldsig#"

NS = f"{{{SII_NS}}}"
DS = f"{{{DS_NS}}}"

# Registrar namespaces globales
ET.register_namespace("", SII_NS)
ET.register_namespace("ds", DS_NS)


def sii(tag: str) -> str:
    """Devuelve el nombre calificado con el namespace SII."""
    return f"{NS}{tag}"


def normalize_rut(rut: Optional[str]) -> Optional[str]:
    """Elimina puntos y pasa a mayúsculas para cumplir el patrón [0-9]+-([0-9]|K)."""
    if rut is None:
        return None
    return rut.replace(".", "").upper()


# ---------- Helpers de logging ----------


def add_log(
    db: Session,
    *,
    document: Optional[Document],
    client_id: Optional[int],
    level: str = "INFO",
    origin: str = "INTERNAL",
    message: str,
    payload: Optional[dict] = None,
) -> None:
    """Registra un evento en log_events."""
    log = LogEvent(
        document_id=document.id if document else None,
        client_id=client_id,
        level=level,
        origin=origin,
        message=message,
        payload=json.dumps(payload, default=str) if payload is not None else None,
    )
    db.add(log)
    db.commit()


def log_xml_validation_errors(
    db: Session,
    *,
    document: Optional[Document],
    client_id: Optional[int],
    kind: str,
    errors: list[str],
) -> None:
    """
    Registra en log_events los errores de validación XML.
    kind: 'DTE' o 'EnvioDTE'
    """
    add_log(
        db,
        document=document,
        client_id=client_id,
        level="ERROR",
        origin="SII",
        message=f"Errores de validación XML {kind}",
        payload={"errors": errors},
    )


# ---------- Carga de la llave desde el .pfx (opcional) ----------


@lru_cache
def _get_signing_key():
    """
    Devuelve la private key RSA del .pfx si:
    - settings.enable_real_signature = True
    - la ruta y password son válidas

    Si algo falla -> devuelve None y seguimos con PLACEHOLDER.
    """
    if not getattr(settings, "enable_real_signature", False):
        return None

    pfx_path = getattr(settings, "sii_cert_pfx_path", None)
    if not pfx_path:
        return None

    try:
        with open(pfx_path, "rb") as f:
            pfx_data = f.read()

        password_str = getattr(settings, "sii_cert_pfx_password", "") or ""
        password_bytes = password_str.encode("utf-8") if password_str else None

        private_key, cert, _ = load_key_and_certificates(
            pfx_data,
            password_bytes,
        )
        return private_key
    except Exception:
        # Si falla la carga, no rompemos el flujo
        return None


def sign_dd_with_cert(dd_element: ET.Element) -> Optional[str]:
    """
    Firma el nodo <DD> con SHA1withRSA usando la llave del .pfx.
    Devuelve el Base64 para poner en <FRMT>, o None si no se pudo firmar.
    """
    key = _get_signing_key()
    if key is None:
        return None

    # Canonicalización simple (para pruebas)
    dd_c14n = ET.tostring(dd_element, encoding="utf-8")

    signature = key.sign(
        dd_c14n,
        padding.PKCS1v15(),
        hashes.SHA1(),  # SII usa SHA1withRSA
    )

    return base64.b64encode(signature).decode("ascii")


# ---------- Construcción de XML DTE ----------


def build_dte_xml(document: Document, caf_parsed: Optional[CafParsed]) -> str:
    """
    Punto de entrada para construir el XML del DTE.

    Según el tipo de DTE, delega en la función correspondiente.
    """
    builders: dict[int, Callable[[Document, Optional[CafParsed]], str]] = {
        33: build_dte_xml_33,
        # Aquí podrías agregar otros tipos: 34, 39, 41, 56, 61, etc.
    }

    builder = builders.get(document.tipo_dte)
    if not builder:
        raise ValueError(f"Tipo DTE no soportado aún: {document.tipo_dte}")

    return builder(document, caf_parsed)


def build_dte_xml_33(document: Document, caf_parsed: Optional[CafParsed]) -> str:
    """
    Construye un DTE de tipo 33 (Factura Afecta) usando el namespace del SII.
    Incluye TED (estructura real) y TmstFirma.
    """
    # --- Nodo raíz DTE ---
    dte = ET.Element(sii("DTE"))
    dte.set("version", "1.0")

    # ID del Documento, algo como F33T{id_doc}
    doc_id = f"F33T{document.id}"

    # --- Documento ---
    documento = ET.SubElement(dte, sii("Documento"))
    documento.set("ID", doc_id)

    # --- Encabezado ---
    encabezado = ET.SubElement(documento, sii("Encabezado"))

    # IdDoc
    iddoc = ET.SubElement(encabezado, sii("IdDoc"))

    tipo_dte_el = ET.SubElement(iddoc, sii("TipoDTE"))
    tipo_dte_el.text = str(document.tipo_dte)

    # Folio real desde CAF
    folio_el = ET.SubElement(iddoc, sii("Folio"))
    folio_el.text = str(document.folio) if document.folio is not None else "0"

    # Fecha emisión (xs:date)
    fch_emis_el = ET.SubElement(iddoc, sii("FchEmis"))
    fch_emis_el.text = datetime.utcnow().date().isoformat()

    # Emisor
    emisor = ET.SubElement(encabezado, sii("Emisor"))

    rut_emisor_el = ET.SubElement(emisor, sii("RUTEmisor"))
    rut_emisor_el.text = normalize_rut(document.emitter.rut_emisor)

    rzn_soc_emisor_el = ET.SubElement(emisor, sii("RznSoc"))
    rzn_soc_emisor_el.text = document.emitter.razon_social

    if document.emitter.giro:
        giro_emis_el = ET.SubElement(emisor, sii("GiroEmis"))
        giro_emis_el.text = document.emitter.giro

    # Para satisfacer el XSD: Telefono/CorreoEmisor/Acteco pueden ir aquí.
    # Usamos Acteco dummy por ahora.
    acteco_el = ET.SubElement(emisor, sii("Acteco"))
    acteco_el.text = "000000"

    if document.emitter.direccion:
        dir_origen_el = ET.SubElement(emisor, sii("DirOrigen"))
        dir_origen_el.text = document.emitter.direccion

    if document.emitter.comuna:
        cmna_origen_el = ET.SubElement(emisor, sii("CmnaOrigen"))
        cmna_origen_el.text = document.emitter.comuna

    # Receptor
    receptor = ET.SubElement(encabezado, sii("Receptor"))

    rut_recep_el = ET.SubElement(receptor, sii("RUTRecep"))
    rut_recep_el.text = normalize_rut(document.receptor_rut)

    rzn_soc_recep_el = ET.SubElement(receptor, sii("RznSocRecep"))
    rzn_soc_recep_el.text = document.receptor_razon_social

    if document.receptor_direccion:
        dir_recep_el = ET.SubElement(receptor, sii("DirRecep"))
        dir_recep_el.text = document.receptor_direccion

    if document.receptor_comuna:
        cmna_recep_el = ET.SubElement(receptor, sii("CmnaRecep"))
        cmna_recep_el.text = document.receptor_comuna

    # Totales
    totales = ET.SubElement(encabezado, sii("Totales"))

    mnt_neto_el = ET.SubElement(totales, sii("MntNeto"))
    mnt_neto_el.text = str(int(document.monto_neto))

    iva_el = ET.SubElement(totales, sii("IVA"))
    iva_el.text = str(int(document.monto_iva))

    mnt_total_el = ET.SubElement(totales, sii("MntTotal"))
    mnt_total_el.text = str(int(document.monto_total))

    # --- Detalle(s) ---
    for idx, item in enumerate(document.items, start=1):
        detalle = ET.SubElement(documento, sii("Detalle"))

        nro_lin_det_el = ET.SubElement(detalle, sii("NroLinDet"))
        nro_lin_det_el.text = str(idx)

        nmb_item_el = ET.SubElement(detalle, sii("NmbItem"))
        nmb_item_el.text = item.descripcion

        qty_el = ET.SubElement(detalle, sii("QtyItem"))
        qty_el.text = str(item.cantidad)

        prc_item_el = ET.SubElement(detalle, sii("PrcItem"))
        prc_item_el.text = str(item.precio_unitario)

        if item.descuento and item.descuento != 0:
            desc_monto_el = ET.SubElement(detalle, sii("DescuentoMonto"))
            desc_monto_el.text = str(item.descuento)

        monto_item_el = ET.SubElement(detalle, sii("MontoItem"))
        monto_item_el.text = str(int(item.total_linea))

    # TED + TmstFirma
    add_ted_real_and_timestamp(documento, document, caf_parsed)

    # Firma dummy dentro del DTE para que el XSD no reclame Signature
    signature = ET.SubElement(dte, f"{DS}Signature")

    signed_info = ET.SubElement(signature, f"{DS}SignedInfo")
    ET.SubElement(
        signed_info,
        f"{DS}CanonicalizationMethod",
        Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315",
    )
    ET.SubElement(
        signed_info,
        f"{DS}SignatureMethod",
        Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1",
    )

    ref = ET.SubElement(signed_info, f"{DS}Reference", URI="")
    ET.SubElement(
        ref,
        f"{DS}DigestMethod",
        Algorithm="http://www.w3.org/2000/09/xmldsig#sha1",
    )
    # base64 dummy válido
    ET.SubElement(ref, f"{DS}DigestValue").text = "AA=="

    ET.SubElement(signature, f"{DS}SignatureValue").text = "AA=="

    key_info = ET.SubElement(signature, f"{DS}KeyInfo")
    ET.SubElement(key_info, f"{DS}KeyValue")  # estructura mínima compatible con XSD

    # Serializar con encoding ISO-8859-1
    xml_bytes = ET.tostring(dte, encoding="iso-8859-1", xml_declaration=True)
    return xml_bytes.decode("iso-8859-1")


# ---------- TED REAL (estructura) ----------


def build_ted_real(document: Document, caf_parsed: Optional[CafParsed]) -> ET.Element:
    """
    Construye el TED real en el namespace SII:
    <TED>
      <DD>...</DD>
      <FRMT algoritmo="SHA1withRSA">...</FRMT>
    </TED>
    """

    ted = ET.Element(sii("TED"))
    ted.set("version", "1.0")

    dd = ET.SubElement(ted, sii("DD"))

    # RE: RUT emisor
    re_text = (
        normalize_rut(caf_parsed.rut_emisor)
        if caf_parsed and caf_parsed.rut_emisor
        else normalize_rut(document.emitter.rut_emisor)
    )
    re_el = ET.SubElement(dd, sii("RE"))
    re_el.text = re_text

    # TD: tipo DTE
    td_el = ET.SubElement(dd, sii("TD"))
    td_el.text = str(document.tipo_dte)

    # F: folio DTE
    f_el = ET.SubElement(dd, sii("F"))
    f_el.text = str(document.folio) if document.folio is not None else "0"

    # FE: fecha emisión (xs:date)
    fe_el = ET.SubElement(dd, sii("FE"))
    fe_el.text = datetime.utcnow().date().isoformat()

    # RR: RUT receptor
    rr_el = ET.SubElement(dd, sii("RR"))
    rr_el.text = normalize_rut(document.receptor_rut)

    # RSR: razón social receptor (máx 40 chars, mayúsculas)
    rsr_el = ET.SubElement(dd, sii("RSR"))
    rsr_el.text = (document.receptor_razon_social or "")[:40].upper()

    # MNT: monto total
    mnt_el = ET.SubElement(dd, sii("MNT"))
    mnt_el.text = str(int(document.monto_total))

    # IT1: descripción principal (primer item, 40 chars)
    it1_el = ET.SubElement(dd, sii("IT1"))
    if document.items:
        it1_el.text = document.items[0].descripcion[:40]
    else:
        it1_el.text = "SIN DETALLE"

    # CAF dentro del DD (si se pudo parsear)
    if caf_parsed:
        try:
            root = ET.fromstring(caf_parsed.raw_xml)
            caf_el = root.find(".//CAF")
            if caf_el is not None:
                dd.append(deepcopy(caf_el))
        except Exception:
            # si el XML del CAF está malo, seguimos sin él
            pass

    # TSTED: timestamp del TED
    tsted_el = ET.SubElement(dd, sii("TSTED"))
    tsted_el.text = datetime.utcnow().replace(microsecond=0).isoformat()

    # FRMT: firma DD (real o placeholder)
    frma_el = ET.SubElement(ted, sii("FRMT"))
    frma_el.set("algoritmo", "SHA1withRSA")

    frma_value = sign_dd_with_cert(dd)
    if frma_value:
        frma_el.text = frma_value
    else:
        frma_el.text = "PLACEHOLDER"

    return ted


def add_ted_real_and_timestamp(
    documento_el: ET.Element,
    document: Document,
    caf_parsed: Optional[CafParsed],
) -> None:
    """Inserta TED y TmstFirma dentro del <Documento> (namespace SII)."""
    ted_el = build_ted_real(document, caf_parsed)
    documento_el.append(ted_el)

    tmst_firma_el = ET.SubElement(documento_el, sii("TmstFirma"))
    tmst_firma_el.text = datetime.utcnow().replace(microsecond=0).isoformat()


# ---------- Flujo principal: DTE + EnvioDTE DUMMY ----------


def process_document_send_to_sii(
    document_id: int,
    *,
    raise_on_error: bool = True,
) -> None:
    """
    Procesa y 'envía' un documento al SII (modo dummy):
    - Abre su propia sesión
    - Carga el Document
    - Busca el CAF correspondiente al folio
    - Genera XML DTE (con TED real firmado si hay .pfx)
    - Valida DTE contra DTE_v10.xsd (solo logea errores)
    - Genera sobre EnvioDTE (Carátula + SetDTE)
    - Valida EnvioDTE contra EnvioDTE_v10.xsd (solo logea errores)
    - 'Envía' el EnvioDTE con send_envio_dte_dummy (sin HTTP real)
    - Actualiza estado y track_id
    - Loggea todo
    """
    db = SessionLocal()
    try:
        document = db.query(Document).filter(Document.id == document_id).first()
        if not document:
            return

        client_id = document.client_id

        add_log(
            db,
            document=document,
            client_id=client_id,
            level="INFO",
            origin="SII",
            message="Iniciando construcción de XML DTE",
        )

        # Buscar CAF para este documento (por folio en rango)
        caf = get_caf_for_document(db, document)
        caf_parsed: Optional[CafParsed] = None

        if caf:
            try:
                caf_parsed = parse_caf_xml(caf)
            except Exception as caf_exc:  # error al parsear CAF
                add_log(
                    db,
                    document=document,
                    client_id=client_id,
                    level="WARNING",
                    origin="SII",
                    message=(
                        "Error al parsear CAF, se generará TED sin CAF incrustado: "
                        f"{caf_exc}"
                    ),
                )
                caf_parsed = None
        else:
            add_log(
                db,
                document=document,
                client_id=client_id,
                level="WARNING",
                origin="SII",
                message=(
                    "No se encontró CAF para el documento; "
                    "TED se generará sin CAF incrustado"
                ),
            )

        # Generar XML DTE
        dte_xml = build_dte_xml(document, caf_parsed)
        document.raw_xml = dte_xml

        add_log(
            db,
            document=document,
            client_id=client_id,
            level="INFO",
            origin="SII",
            message="XML DTE generado",
        )

        # -------- Validación DTE (solo logging) --------
        dte_errors = validate_dte(dte_xml)
        if dte_errors:
            log_xml_validation_errors(
                db,
                document=document,
                client_id=client_id,
                kind="DTE",
                errors=dte_errors,
            )
            add_log(
                db,
                document=document,
                client_id=client_id,
                level="WARNING",
                origin="SII",
                message=(
                    "XML DTE con errores de validación XSD, "
                    "se continúa flujo igualmente (modo dummy)"
                ),
            )

        # Generar EnvioDTE (sobre)
        envio_xml = build_envio_dte_xml(
            dte_xml=dte_xml,
            tipo_dte=document.tipo_dte,
            rut_emisor=document.emitter.rut_emisor,
        )
        document.envio_xml = envio_xml  # guardar el sobre

        add_log(
            db,
            document=document,
            client_id=client_id,
            level="INFO",
            origin="SII",
            message="EnvioDTE generado (dummy)",
        )

        # -------- Validación EnvioDTE (solo logging) --------
        envio_errors = validate_enviodte(envio_xml)
        if envio_errors:
            log_xml_validation_errors(
                db,
                document=document,
                client_id=client_id,
                kind="EnvioDTE",
                errors=envio_errors,
            )
            add_log(
                db,
                document=document,
                client_id=client_id,
                level="WARNING",
                origin="SII",
                message=(
                    "EnvioDTE con errores de validación XSD, "
                    "se continúa flujo igualmente (modo dummy)"
                ),
            )

        # 'Enviar' al SII (dummy)
        track_id = send_envio_dte_dummy(envio_xml)
        document.sii_track_id = track_id
        document.sii_state = "ENVIADO"

        add_log(
            db,
            document=document,
            client_id=client_id,
            level="INFO",
            origin="SII",
            message="EnvioDTE enviado al SII (dummy)",
            payload={"track_id": track_id},
        )

        db.commit()

    except Exception as exc:  # noqa: BLE001
        db.rollback()
        try:
            document = db.query(Document).filter(Document.id == document_id).first()
            client_id = document.client_id if document else None
            add_log(
                db,
                document=document,
                client_id=client_id,
                level="ERROR",
                origin="SII",
                message=f"Error al procesar envío a SII: {exc}",
            )
        finally:
            if raise_on_error:
                raise
    finally:
        db.close()

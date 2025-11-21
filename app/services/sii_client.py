from __future__ import annotations

from datetime import datetime
import uuid
import json
import xml.etree.ElementTree as ET
from typing import Callable, Optional
from copy import deepcopy

from sqlalchemy.orm import Session

from app.db.session import SessionLocal
from app.models.document import Document
from app.models.log_event import LogEvent
from app.services.caf_service import (
    CafParsed,
    get_caf_for_document,
    parse_caf_xml,
)

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


# ---------- Construcción de XML DTE ----------


def build_dte_xml(document: Document, caf_parsed: Optional[CafParsed]) -> str:
    """
    Punto de entrada para construir el XML del DTE.

    Según el tipo de DTE, delega en la función correspondiente.
    Así, si el formato de un documento cambia, solo tocas su función.
    """
    builders: dict[int, Callable[[Document, Optional[CafParsed]], str]] = {
        33: build_dte_xml_33,
        # 34: build_dte_xml_34,
        # 39: build_dte_xml_boleta,
        # 41: build_dte_xml_boleta_exenta,
        # 56: build_dte_xml_nota_debito,
        # 61: build_dte_xml_nota_credito,
    }

    builder = builders.get(document.tipo_dte)
    if not builder:
        raise ValueError(f"Tipo DTE no soportado aún: {document.tipo_dte}")

    return builder(document, caf_parsed)


def build_dte_xml_33(document: Document, caf_parsed: Optional[CafParsed]) -> str:
    """
    Construye un DTE de tipo 33 (Factura Afecta) con estructura similar al formato SII.
    Incluye TED (estructura real) y TmstFirma.
    """

    # --- Nodo raíz DTE ---
    dte = ET.Element("DTE")
    dte.set("version", "1.0")

    # ID del Documento, algo como F33T{id_doc}
    doc_id = f"F33T{document.id}"

    # --- Documento ---
    documento = ET.SubElement(dte, "Documento")
    documento.set("ID", doc_id)

    # --- Encabezado ---
    encabezado = ET.SubElement(documento, "Encabezado")

    # IdDoc
    iddoc = ET.SubElement(encabezado, "IdDoc")

    tipo_dte_el = ET.SubElement(iddoc, "TipoDTE")
    tipo_dte_el.text = str(document.tipo_dte)

    # Folio real desde CAF
    folio_el = ET.SubElement(iddoc, "Folio")
    folio_el.text = str(document.folio) if document.folio is not None else "0"

    # Fecha emisión
    fch_emis_el = ET.SubElement(iddoc, "FchEmis")
    fch_emis_el.text = datetime.utcnow().date().isoformat()

    # Emisor
    emisor = ET.SubElement(encabezado, "Emisor")
    rut_emisor_el = ET.SubElement(emisor, "RUTEmisor")
    rut_emisor_el.text = document.emitter.rut_emisor

    rzn_soc_emisor_el = ET.SubElement(emisor, "RznSoc")
    rzn_soc_emisor_el.text = document.emitter.razon_social

    if document.emitter.giro:
        giro_emis_el = ET.SubElement(emisor, "GiroEmis")
        giro_emis_el.text = document.emitter.giro

    if document.emitter.direccion:
        dir_origen_el = ET.SubElement(emisor, "DirOrigen")
        dir_origen_el.text = document.emitter.direccion

    if document.emitter.comuna:
        cmna_origen_el = ET.SubElement(emisor, "CmnaOrigen")
        cmna_origen_el.text = document.emitter.comuna

    # Receptor
    receptor = ET.SubElement(encabezado, "Receptor")

    rut_recep_el = ET.SubElement(receptor, "RUTRecep")
    rut_recep_el.text = document.receptor_rut

    rzn_soc_recep_el = ET.SubElement(receptor, "RznSocRecep")
    rzn_soc_recep_el.text = document.receptor_razon_social

    if document.receptor_direccion:
        dir_recep_el = ET.SubElement(receptor, "DirRecep")
        dir_recep_el.text = document.receptor_direccion

    if document.receptor_comuna:
        cmna_recep_el = ET.SubElement(receptor, "CmnaRecep")
        cmna_recep_el.text = document.receptor_comuna

    # Totales
    totales = ET.SubElement(encabezado, "Totales")

    mnt_neto_el = ET.SubElement(totales, "MntNeto")
    mnt_neto_el.text = str(int(document.monto_neto))

    iva_el = ET.SubElement(totales, "IVA")
    iva_el.text = str(int(document.monto_iva))

    mnt_total_el = ET.SubElement(totales, "MntTotal")
    mnt_total_el.text = str(int(document.monto_total))

    # --- Detalle(s) ---
    for idx, item in enumerate(document.items, start=1):
        detalle = ET.SubElement(documento, "Detalle")

        nro_lin_det_el = ET.SubElement(detalle, "NroLinDet")
        nro_lin_det_el.text = str(idx)

        nmb_item_el = ET.SubElement(detalle, "NmbItem")
        nmb_item_el.text = item.descripcion

        qty_el = ET.SubElement(detalle, "QtyItem")
        qty_el.text = str(item.cantidad)

        prc_item_el = ET.SubElement(detalle, "PrcItem")
        prc_item_el.text = str(item.precio_unitario)

        if item.descuento and item.descuento != 0:
            desc_monto_el = ET.SubElement(detalle, "DescuentoMonto")
            desc_monto_el.text = str(item.descuento)

        monto_item_el = ET.SubElement(detalle, "MontoItem")
        monto_item_el.text = str(int(item.total_linea))

    # TED + TmstFirma
    add_ted_real_and_timestamp(documento, document, caf_parsed)

    # Serializar con encoding ISO-8859-1
    xml_bytes = ET.tostring(dte, encoding="iso-8859-1", xml_declaration=True)
    return xml_bytes.decode("iso-8859-1")


# ---------- TED REAL (estructura) ----------


def build_ted_real(document: Document, caf_parsed: Optional[CafParsed]) -> ET.Element:
    """
    Construye el TED con estructura real:
    <TED>
      <DD>...</DD>
      <FRMA algoritmo="SHA1withRSA">...</FRMA>
    </TED>
    FRMA queda como PLACEHOLDER por ahora.
    """

    ted = ET.Element("TED")
    ted.set("version", "1.0")

    dd = ET.SubElement(ted, "DD")

    # RE: RUT emisor
    re_text = (
        caf_parsed.rut_emisor
        if caf_parsed and caf_parsed.rut_emisor
        else document.emitter.rut_emisor
    )
    re_el = ET.SubElement(dd, "RE")
    re_el.text = re_text

    # TD: tipo DTE
    td_el = ET.SubElement(dd, "TD")
    td_el.text = str(document.tipo_dte)

    # F: folio DTE
    f_el = ET.SubElement(dd, "F")
    f_el.text = str(document.folio) if document.folio is not None else "0"

    # FE: fecha emisión AAAAMMDD
    fe_el = ET.SubElement(dd, "FE")
    fe_el.text = datetime.utcnow().date().strftime("%Y%m%d")

    # RR: RUT receptor
    rr_el = ET.SubElement(dd, "RR")
    rr_el.text = document.receptor_rut

    # RSR: razón social receptor (máx 40 chars, mayúsculas)
    rsr_el = ET.SubElement(dd, "RSR")
    rsr_el.text = (document.receptor_razon_social or "")[:40].upper()

    # MNT: monto total
    mnt_el = ET.SubElement(dd, "MNT")
    mnt_el.text = str(int(document.monto_total))

    # IT1: descripción principal (primer item, 40 chars)
    it1_el = ET.SubElement(dd, "IT1")
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
    tsted_el = ET.SubElement(dd, "TSTED")
    tsted_el.text = datetime.utcnow().replace(microsecond=0).isoformat()

    # FRMA: firma DD (placeholder)
    frma_el = ET.SubElement(ted, "FRMA")
    frma_el.set("algoritmo", "SHA1withRSA")
    frma_el.text = "PLACEHOLDER"

    return ted


def add_ted_real_and_timestamp(
    documento_el: ET.Element,
    document: Document,
    caf_parsed: Optional[CafParsed],
) -> None:
    """Inserta TED y TmstFirma dentro del <Documento>."""
    ted_el = build_ted_real(document, caf_parsed)
    documento_el.append(ted_el)

    tmst_firma_el = ET.SubElement(documento_el, "TmstFirma")
    tmst_firma_el.text = datetime.utcnow().replace(microsecond=0).isoformat()


# ---------- Simulación de envío al SII ----------


def send_xml_to_sii_dummy(xml_str: str) -> str:
    """Simula el envío del DTE al SII y devuelve un track_id ficticio."""
    fake_track_id = uuid.uuid4().hex[:12].upper()
    return fake_track_id


def process_document_send_to_sii(document_id: int, *, raise_on_error: bool = True) -> None:
    """
    Procesa y envía un documento al SII (dummy).
    - Abre su propia sesión
    - Carga el Document
    - Busca el CAF correspondiente al folio
    - Genera XML (build_dte_xml con TED real)
    - 'Envía' al SII (dummy)
    - Actualiza estado y track_id
    - Loggea todo
    Si raise_on_error=True, cualquier error se relanza después de loguearse.
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
                    message=f"Error al parsear CAF, se generará TED sin CAF incrustado: {caf_exc}",
                )
                caf_parsed = None
        else:
            add_log(
                db,
                document=document,
                client_id=client_id,
                level="WARNING",
                origin="SII",
                message="No se encontró CAF para el documento; TED se generará sin CAF incrustado",
            )

        # Generar XML
        xml_str = build_dte_xml(document, caf_parsed)
        document.raw_xml = xml_str

        add_log(
            db,
            document=document,
            client_id=client_id,
            level="INFO",
            origin="SII",
            message="XML DTE generado",
        )

        # Simulación de envío al SII
        track_id = send_xml_to_sii_dummy(xml_str)
        document.sii_track_id = track_id
        document.sii_state = "ENVIADO"

        add_log(
            db,
            document=document,
            client_id=client_id,
            level="INFO",
            origin="SII",
            message="Documento enviado al SII (dummy)",
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
                # muy importante: relanzar para que el POST falle y sepamos que algo está mal
                raise
    finally:
        db.close()

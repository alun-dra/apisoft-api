from __future__ import annotations

from datetime import datetime
import uuid
import json
import xml.etree.ElementTree as ET
from typing import Callable

from sqlalchemy.orm import Session

from app.db.session import SessionLocal
from app.models.document import Document
from app.models.log_event import LogEvent


# ---------- Helpers de logging ----------


def add_log(
    db: Session,
    *,
    document: Document | None,
    client_id: int | None,
    level: str = "INFO",
    origin: str = "INTERNAL",
    message: str,
    payload: dict | None = None,
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


def build_dte_xml(document: Document) -> str:
    """
    Punto de entrada para construir el XML del DTE.

    Según el tipo de DTE, delega en la función correspondiente.
    Así, si el formato de un documento cambia, solo tocas su función.
    """
    builders: dict[int, Callable[[Document], str]] = {
        33: build_dte_xml_33,
        # 34: build_dte_xml_34,   # factura exenta (a futuro)
        # 39: build_dte_xml_boleta,  # boleta afecta
        # 41: build_dte_xml_boleta_exenta,
        # 56: build_dte_xml_nota_debito,
        # 61: build_dte_xml_nota_credito,
    }

    builder = builders.get(document.tipo_dte)
    if not builder:
        raise ValueError(f"Tipo DTE no soportado aún: {document.tipo_dte}")

    return builder(document)


def build_dte_xml_33(document: Document) -> str:
    """
    Construye un DTE de tipo 33 (Factura Afecta) con estructura similar al formato SII.
    Incluye TED placeholder y TmstFirma. En producción deberás reemplazar el
    TED por uno generado usando el CAF real.
    """

    # --- Nodo raíz DTE ---
    dte = ET.Element("DTE")
    dte.set("version", "1.0")

    # ID del Documento, algo como F33T2 (puedes afinarlo luego)
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

    # Fecha emisión = hoy por ahora (podrías agregar campo específico en el modelo)
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
    # Un <Detalle> por cada item del documento
    for idx, item in enumerate(document.items, start=1):
        detalle = ET.SubElement(documento, "Detalle")

        # NroLinDet es requerido
        nro_lin_det_el = ET.SubElement(detalle, "NroLinDet")
        nro_lin_det_el.text = str(idx)

        # Descripción
        nmb_item_el = ET.SubElement(detalle, "NmbItem")
        nmb_item_el.text = item.descripcion

        # Cantidad
        qty_el = ET.SubElement(detalle, "QtyItem")
        qty_el.text = str(item.cantidad)

        # Precio unitario
        prc_item_el = ET.SubElement(detalle, "PrcItem")
        prc_item_el.text = str(item.precio_unitario)

        # Descuento (si aplica)
        if item.descuento and item.descuento != 0:
            desc_monto_el = ET.SubElement(detalle, "DescuentoMonto")
            desc_monto_el.text = str(item.descuento)

        # Monto de la línea
        monto_item_el = ET.SubElement(detalle, "MontoItem")
        monto_item_el.text = str(int(item.total_linea))

    # 👉 Agregar TED (placeholder) y TmstFirma
    add_ted_and_timestamp(documento, document)

    # Serializar con encoding ISO-8859-1, como pide el SII
    xml_bytes = ET.tostring(dte, encoding="iso-8859-1", xml_declaration=True)
    return xml_bytes.decode("iso-8859-1")


def build_ted_placeholder(document: Document) -> ET.Element:
    """
    Construye un TED de ejemplo / placeholder.
    En producción debes reemplazar esto con la generación real usando el CAF.
    """
    ted = ET.Element("TED")
    ted.set("version", "1.0")

    dd = ET.SubElement(ted, "DD")
    # Aquí irían los tags reales del DD (RE, TD, F, FE, RR, etc.) según el CAF.
    td_el = ET.SubElement(dd, "TD")
    td_el.text = str(document.tipo_dte)

    f_el = ET.SubElement(dd, "F")
    f_el.text = str(document.id)  # en real: folio DTE

    re_el = ET.SubElement(dd, "RE")
    re_el.text = document.emitter.rut_emisor

    rr_el = ET.SubElement(dd, "RR")
    rr_el.text = document.receptor_rut

    mnt_el = ET.SubElement(dd, "MNT")
    mnt_el.text = str(int(document.monto_total))

    # Aquí iría FRMA (firma del DD con la llave del CAF)
    frma_el = ET.SubElement(ted, "FRMA")
    frma_el.set("algoritmo", "SHA1withRSA")
    frma_el.text = "PLACEHOLDER"  # aquí debe ir la firma real del DD

    return ted


def add_ted_and_timestamp(documento_el: ET.Element, document: Document) -> None:
    """
    Inserta el nodo TED y TmstFirma dentro del <Documento>.
    documento_el es el nodo <Documento> que ya tiene Encabezado + Detalle.
    """
    # TED
    ted_el = build_ted_placeholder(document)
    documento_el.append(ted_el)

    # TmstFirma (timestamp de firma)
    tmst_firma_el = ET.SubElement(documento_el, "TmstFirma")
    tmst_firma_el.text = datetime.utcnow().replace(microsecond=0).isoformat()


# ---------- Simulación de envío al SII ----------


def send_xml_to_sii_dummy(xml_str: str) -> str:
    """
    Simula el envío del DTE al SII y devuelve un track_id ficticio.
    Luego conectaremos esto al endpoint real del SII.
    """
    fake_track_id = uuid.uuid4().hex[:12].upper()
    return fake_track_id


def process_document_send_to_sii(document_id: int) -> None:
    """
    Función pensada para ejecutarse en background.
    - Abre su propia sesión
    - Carga el Document
    - Genera XML (build_dte_xml)
    - 'Envía' al SII (dummy)
    - Actualiza estado y track_id
    - Loggea todo
    """
    db = SessionLocal()
    try:
        document = db.query(Document).filter(Document.id == document_id).first()
        if not document:
            # no hay log porque no tenemos client_id, pero dejamos constancia
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

        # 🔥 Aquí llamamos al generador general, que decide según tipo_dte
        xml_str = build_dte_xml(document)

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
        # Intentamos loggear el error si alcanzamos a tener el document
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
        except Exception:
            # si hasta el log falla, ya fue, pero no queremos romper más
            pass
    finally:
        db.close()

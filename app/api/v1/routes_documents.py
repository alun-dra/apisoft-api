from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import PlainTextResponse
from xml.dom import minidom
from decimal import Decimal
import logging

from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import get_current_client
from app.models.client import Client
from app.models.document import Document, DocumentItem
from app.schemas.document import DocumentCreate, DocumentRead
from app.services.sii_client import process_document_send_to_sii
from app.services.caf_service import assign_folio_from_caf, NoAvailableFolio

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/documents", tags=["documents"])


@router.post("/", response_model=DocumentRead, status_code=status.HTTP_201_CREATED)
def create_document(
    payload: DocumentCreate,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    # ---------- Cálculo de montos ----------
    monto_neto = Decimal("0")
    for item in payload.items:
        line_total = Decimal(str(item.cantidad)) * Decimal(str(item.precio_unitario))
        if item.descuento:
            line_total -= Decimal(str(item.descuento))
        monto_neto += line_total

    monto_iva = (monto_neto * Decimal("0.19")).quantize(Decimal("1."))  # IVA 19%
    monto_total = monto_neto + monto_iva

    # ---------- Asignar folio desde CAF ----------
    try:
        caf, folio = assign_folio_from_caf(
            db,
            emitter_id=payload.emitter_id,
            tipo_dte=payload.tipo_dte,
        )
    except NoAvailableFolio as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        )

    # ---------- Crear documento ----------
    document = Document(
        client_id=current_client.id,
        emitter_id=payload.emitter_id,
        tipo_dte=payload.tipo_dte,
        folio=folio,  # folio real desde CAF
        receptor_rut=payload.receptor.rut,
        receptor_razon_social=payload.receptor.razon_social,
        receptor_direccion=payload.receptor.direccion,
        receptor_comuna=payload.receptor.comuna,
        monto_neto=monto_neto,
        monto_iva=monto_iva,
        monto_total=monto_total,
        sii_state="CREADO",
    )

    db.add(document)
    db.flush()  # para tener document.id

    # ---------- Items ----------
    for item in payload.items:
        line_total = Decimal(str(item.cantidad)) * Decimal(str(item.precio_unitario))
        if item.descuento:
            line_total -= Decimal(str(item.descuento))

        db_item = DocumentItem(
            document_id=document.id,
            descripcion=item.descripcion,
            cantidad=item.cantidad,
            precio_unitario=item.precio_unitario,
            descuento=item.descuento,
            total_linea=line_total,
        )
        db.add(db_item)

    # commit incluye documento, items y actualización de caf.folio_actual
    db.commit()
    db.refresh(document)

    # 🔥 Enviar al “SII” (dummy/real según sii_client.py) de forma síncrona
    try:
        process_document_send_to_sii(document.id)
        db.refresh(document)  # para traer raw_xml, sii_state, sii_track_id, etc.
    except Exception as exc:  # noqa: BLE001
        logger.exception(
            "Error al procesar envío a SII para document_id=%s", document.id
        )
        # No botamos el documento, solo marcamos error
        document.sii_state = "ERROR"
        document.error_last_message = str(exc)
        db.commit()
        db.refresh(document)

    return document


@router.get("/{document_id}", response_model=DocumentRead)
def get_document(
    document_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    document = (
        db.query(Document)
        .filter(
            Document.id == document_id,
            Document.client_id == current_client.id,
        )
        .first()
    )

    if not document:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Document not found",
        )

    return document


@router.get("/{document_id}/xml", response_class=PlainTextResponse)
def get_document_xml(
    document_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    document = (
        db.query(Document)
        .filter(
            Document.id == document_id,
            Document.client_id == current_client.id,
        )
        .first()
    )

    if not document:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Document not found",
        )

    # Si el XML ya existe → lo devolvemos
    if document.raw_xml:
        parsed = minidom.parseString(document.raw_xml.encode("iso-8859-1"))
        return parsed.toprettyxml(indent="  ")

    # ---------- Intentar generarlo usando el mismo flujo del envío ----------
    try:
        process_document_send_to_sii(document.id)
        db.refresh(document)
    except Exception as exc:  # noqa: BLE001
        logger.exception(
            "Error al regenerar XML para document_id=%s: %s", document.id, exc
        )

    if document.raw_xml:
        parsed = minidom.parseString(document.raw_xml.encode("iso-8859-1"))
        return parsed.toprettyxml(indent="  ")

    # ---------- Si después de todo no se pudo generar ----------
    raise HTTPException(
        status_code=500,
        detail="XML could not be generated",
    )



@router.get("/{document_id}/envio-xml", response_class=PlainTextResponse)
def get_envio_xml(document_id: int, db: Session = Depends(get_db)):
    doc = db.query(Document).filter(Document.id == document_id).first()
    if not doc:
        raise HTTPException(404, "Documento no encontrado")

    if not doc.envio_xml:
        raise HTTPException(404, "EnvioDTE aún no generado")

    return doc.envio_xml
# app/api/v1/routes_documents.py
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import PlainTextResponse
from xml.dom import minidom
from decimal import Decimal
import logging

from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import get_current_client, get_current_user
from app.core.audit_actions import AuditAction  # 👈 NUEVO
from app.models.client import Client
from app.models.user import User
from app.models.document import Document, DocumentItem
from app.schemas.document import DocumentCreate, DocumentRead
from app.services.sii_client import process_document_send_to_sii
from app.services.caf_service import assign_folio_from_caf, NoAvailableFolio
from app.services.audit_service import log_user_activity

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/documents", tags=["documents"])


@router.post("/", response_model=DocumentRead, status_code=status.HTTP_201_CREATED)
def create_document(
    payload: DocumentCreate,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
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
        # Log de intento fallido de creación por falta de folios
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.CREATE_DOCUMENT,
            path="/api/v1/documents",
            method="POST",
            status_code=status.HTTP_400_BAD_REQUEST,
            success=False,
            error_message=str(exc),
            extra={
                "emitter_id": payload.emitter_id,
                "tipo_dte": payload.tipo_dte,
            },
        )
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

        # Log de creación + envío OK
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.CREATE_DOCUMENT,
            path="/api/v1/documents",
            method="POST",
            status_code=status.HTTP_201_CREATED,
            success=True,
            extra={
                "document_id": document.id,
                "tipo_dte": document.tipo_dte,
                "emitter_id": document.emitter_id,
                "monto_total": str(document.monto_total),
                "sii_state": document.sii_state,
                "sii_track_id": document.sii_track_id,
            },
        )

    except Exception as exc:  # noqa: BLE001
        logger.exception(
            "Error al procesar envío a SII para document_id=%s", document.id
        )
        # No botamos el documento, solo marcamos error
        document.sii_state = "ERROR"
        document.error_last_message = str(exc)
        db.commit()
        db.refresh(document)

        # Log de fallo al enviar al SII
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.SEND_DOCUMENT_SII,
            path="/api/v1/documents",
            method="POST",
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            success=False,
            error_message=str(exc),
            extra={"document_id": document.id},
        )

    return document


@router.get("/{document_id}", response_model=DocumentRead)
def get_document(
    document_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
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
        # Log de intento de lectura fallido
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.GET_DOCUMENT,
            path=f"/api/v1/documents/{document_id}",
            method="GET",
            status_code=status.HTTP_404_NOT_FOUND,
            success=False,
            error_message="Document not found",
            extra={"document_id": document_id},
        )

        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Document not found",
        )

    # Log de lectura exitosa
    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.GET_DOCUMENT,
        path=f"/api/v1/documents/{document_id}",
        method="GET",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"document_id": document.id},
    )

    return document


@router.get("/{document_id}/xml", response_class=PlainTextResponse)
def get_document_xml(
    document_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
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
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.GET_DOCUMENT_XML,
            path=f"/api/v1/documents/{document_id}/xml",
            method="GET",
            status_code=status.HTTP_404_NOT_FOUND,
            success=False,
            error_message="Document not found",
            extra={"document_id": document_id},
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Document not found",
        )

    # Si el XML ya existe → lo devolvemos
    if document.raw_xml:
        parsed = minidom.parseString(document.raw_xml.encode("iso-8859-1"))

        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.GET_DOCUMENT_XML,
            path=f"/api/v1/documents/{document_id}/xml",
            method="GET",
            status_code=status.HTTP_200_OK,
            success=True,
            extra={"document_id": document.id, "from_cache": True},
        )

        return parsed.toprettyxml(indent="  ")

    # ---------- Intentar generarlo usando el mismo flujo del envío ----------
    try:
        process_document_send_to_sii(document.id)
        db.refresh(document)
    except Exception as exc:  # noqa: BLE001
        logger.exception(
            "Error al regenerar XML para document_id=%s: %s", document.id, exc
        )

        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            # sigue siendo parte del flujo de GET_DOCUMENT_XML
            action=AuditAction.GET_DOCUMENT_XML,
            path=f"/api/v1/documents/{document_id}/xml",
            method="GET",
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            success=False,
            error_message=str(exc),
            extra={"document_id": document.id, "step": "regenerate_xml"},
        )

    if document.raw_xml:
        parsed = minidom.parseString(document.raw_xml.encode("iso-8859-1"))

        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.GET_DOCUMENT_XML,
            path=f"/api/v1/documents/{document_id}/xml",
            method="GET",
            status_code=status.HTTP_200_OK,
            success=True,
            extra={"document_id": document.id, "from_cache": False},
        )

        return parsed.toprettyxml(indent="  ")

    # ---------- Si después de todo no se pudo generar ----------
    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.GET_DOCUMENT_XML,
        path=f"/api/v1/documents/{document_id}/xml",
        method="GET",
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        success=False,
        error_message="XML could not be generated",
        extra={"document_id": document_id},
    )

    raise HTTPException(
        status_code=500,
        detail="XML could not be generated",
    )


@router.get("/{document_id}/envio-xml", response_class=PlainTextResponse)
def get_envio_xml(
    document_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
):
    doc = (
        db.query(Document)
        .filter(
            Document.id == document_id,
            Document.client_id == current_client.id,
        )
        .first()
    )

    if not doc:
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.GET_ENVIO_XML,
            path=f"/api/v1/documents/{document_id}/envio-xml",
            method="GET",
            status_code=status.HTTP_404_NOT_FOUND,
            success=False,
            error_message="Documento no encontrado",
            extra={"document_id": document_id},
        )
        raise HTTPException(404, "Documento no encontrado")

    if not doc.envio_xml:
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.GET_ENVIO_XML,
            path=f"/api/v1/documents/{document_id}/envio-xml",
            method="GET",
            status_code=status.HTTP_404_NOT_FOUND,
            success=False,
            error_message="EnvioDTE aún no generado",
            extra={"document_id": document_id},
        )
        raise HTTPException(404, "EnvioDTE aún no generado")

    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.GET_ENVIO_XML,
        path=f"/api/v1/documents/{document_id}/envio-xml",
        method="GET",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"document_id": document_id},
    )

    return doc.envio_xml

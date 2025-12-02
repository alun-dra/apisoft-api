# app/api/v1/routes_incoming_documents.py
from datetime import datetime
from typing import Optional, List

from fastapi import APIRouter, Depends, Query, HTTPException, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import get_current_client, get_current_user
from app.core.audit_actions import AuditAction
from app.models.client import Client
from app.models.user import User
from app.models.incoming_document import IncomingDocument
from app.schemas.incoming_document import IncomingDocumentRead
from app.services.audit_service import log_user_activity
from app.services.incoming_dte_service import (   # 👈 NUEVO
    sync_incoming_documents_from_sii,
)

router = APIRouter(prefix="/incoming-documents", tags=["incoming-dte"])


@router.get("/", response_model=List[IncomingDocumentRead])
def list_incoming_documents(
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
    emitter_rut: Optional[str] = Query(None, description="Filtrar por RUT emisor"),
    tipo_dte: Optional[int] = Query(None, description="Filtrar por tipo DTE (33, 39, etc.)"),
    from_date: Optional[datetime] = Query(None, description="Desde fecha emisión"),
    to_date: Optional[datetime] = Query(None, description="Hasta fecha emisión"),
    limit: int = Query(100, ge=1, le=1000),
    offset: int = Query(0, ge=0),
):
    """
    Lista los DTE (facturas/boletas) RECIBIDOS por el cliente actual.
    """

    q = db.query(IncomingDocument).filter(
        IncomingDocument.client_id == current_client.id
    )

    if emitter_rut:
        q = q.filter(IncomingDocument.emitter_rut == emitter_rut)

    if tipo_dte is not None:
        q = q.filter(IncomingDocument.tipo_dte == tipo_dte)

    if from_date is not None:
        q = q.filter(IncomingDocument.fecha_emision >= from_date)

    if to_date is not None:
        q = q.filter(IncomingDocument.fecha_emision <= to_date)

    docs = (
        q.order_by(IncomingDocument.fecha_emision.desc())
        .offset(offset)
        .limit(limit)
        .all()
    )

    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.LIST_INCOMING_DTE,
        path="/api/v1/incoming-documents",
        method="GET",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"count": len(docs)},
    )

    return docs


@router.get("/{incoming_id}", response_model=IncomingDocumentRead)
def get_incoming_document(
    incoming_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
):
    """
    Obtiene el detalle de un DTE recibido.
    """
    doc = (
        db.query(IncomingDocument)
        .filter(
            IncomingDocument.id == incoming_id,
            IncomingDocument.client_id == current_client.id,
        )
        .first()
    )

    if not doc:
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.GET_INCOMING_DTE,
            path=f"/api/v1/incoming-documents/{incoming_id}",
            method="GET",
            status_code=status.HTTP_404_NOT_FOUND,
            success=False,
            error_message="Incoming document not found",
            extra={"incoming_id": incoming_id},
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Incoming document not found",
        )

    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.GET_INCOMING_DTE,
        path=f"/api/v1/incoming-documents/{incoming_id}",
        method="GET",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"incoming_id": doc.id},
    )

    return doc


@router.post("/sync")
def sync_incoming_documents(
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
    from_date: Optional[datetime] = Query(
        None,
        description="Opcional: sincronizar desde esta fecha de emisión. "
                    "Si se omite, se usan ~30 días atrás (dummy).",
    ),
):
    """
    Sincroniza DTE recibidos desde el SII (por ahora dummy).

    🔧 En producción:
        - Esta ruta seguirá igual.
        - Solo cambiarás la implementación interna de
          `sync_incoming_documents_from_sii` para hablar con el SII real.
    """
    try:
        synced = sync_incoming_documents_from_sii(
            db=db,
            client=current_client,
            since=from_date,
        )
    except Exception as exc:  # noqa: BLE001
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.SYNC_INCOMING_DTE,
            path="/api/v1/incoming-documents/sync",
            method="POST",
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            success=False,
            error_message=str(exc),
        )
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Error syncing incoming documents",
        )

    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.SYNC_INCOMING_DTE,
        path="/api/v1/incoming-documents/sync",
        method="POST",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"synced": synced},
    )

    return {"synced": synced}

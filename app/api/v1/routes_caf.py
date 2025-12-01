# app/api/v1/routes_caf.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import get_current_client, get_current_user
from app.core.audit_actions import AuditAction  # 👈 NUEVO
from app.models.client import Client
from app.models.user import User
from app.models.emitter import Emitter
from app.models.caf import Caf
from app.schemas.caf import CafCreate, CafRead
from app.services.audit_service import log_user_activity

router = APIRouter(prefix="/caf", tags=["caf"])


@router.post("/", response_model=CafRead, status_code=status.HTTP_201_CREATED)
def create_caf(
    payload: CafCreate,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
):
    # Verificar que el emisor pertenezca al cliente actual
    emitter = (
        db.query(Emitter)
        .filter(
            Emitter.id == payload.emitter_id,
            Emitter.client_id == current_client.id,
        )
        .first()
    )
    if not emitter:
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.CREATE_CAF,
            path="/api/v1/caf",
            method="POST",
            status_code=status.HTTP_404_NOT_FOUND,
            success=False,
            error_message="Emitter not found for current client",
            extra={"emitter_id": payload.emitter_id, "tipo_dte": payload.tipo_dte},
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Emitter not found for current client",
        )

    # Crear CAF
    caf = Caf(
        emitter_id=payload.emitter_id,
        tipo_dte=payload.tipo_dte,
        folio_inicial=payload.folio_inicial,
        folio_final=payload.folio_final,
        folio_actual=payload.folio_inicial,  # empezamos en el primer folio
        fecha_autorizacion=payload.fecha_autorizacion,
        fecha_vencimiento=payload.fecha_vencimiento,
        caf_xml=payload.caf_xml,
        is_active=True,
    )

    db.add(caf)
    try:
        db.commit()
    except Exception as exc:  # noqa: BLE001
        db.rollback()
        # puede ser por el UniqueConstraint
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.CREATE_CAF,
            path="/api/v1/caf",
            method="POST",
            status_code=status.HTTP_400_BAD_REQUEST,
            success=False,
            error_message=str(exc),
            extra={
                "emitter_id": payload.emitter_id,
                "tipo_dte": payload.tipo_dte,
                "folio_inicial": payload.folio_inicial,
                "folio_final": payload.folio_final,
            },
        )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="CAF range already exists for this emitter and type",
        )

    db.refresh(caf)

    # Log de creación exitosa
    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.CREATE_CAF,
        path="/api/v1/caf",
        method="POST",
        status_code=status.HTTP_201_CREATED,
        success=True,
        extra={
            "caf_id": caf.id,
            "emitter_id": caf.emitter_id,
            "tipo_dte": caf.tipo_dte,
            "folio_inicial": caf.folio_inicial,
            "folio_final": caf.folio_final,
        },
    )

    return caf


@router.get("/", response_model=list[CafRead])
def list_caf(
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
):
    # CAF solo del cliente actual, vía join con Emitter
    caf_list = (
        db.query(Caf)
        .join(Emitter)
        .filter(Emitter.client_id == current_client.id)
        .order_by(Caf.emitter_id, Caf.tipo_dte, Caf.folio_inicial)
        .all()
    )

    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.LIST_CAF,
        path="/api/v1/caf",
        method="GET",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"count": len(caf_list)},
    )

    return caf_list


@router.get("/{caf_id}", response_model=CafRead)
def get_caf(
    caf_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
):
    caf = (
        db.query(Caf)
        .join(Emitter)
        .filter(
            Caf.id == caf_id,
            Emitter.client_id == current_client.id,
        )
        .first()
    )
    if not caf:
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.GET_CAF,
            path=f"/api/v1/caf/{caf_id}",
            method="GET",
            status_code=status.HTTP_404_NOT_FOUND,
            success=False,
            error_message="CAF not found",
            extra={"caf_id": caf_id},
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="CAF not found",
        )

    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.GET_CAF,
        path=f"/api/v1/caf/{caf_id}",
        method="GET",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"caf_id": caf.id},
    )

    return caf

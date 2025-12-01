# app/api/v1/routes_emitters.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import get_current_client, get_current_user
from app.core.audit_actions import AuditAction  # 👈 NUEVO
from app.models.client import Client
from app.models.user import User
from app.models.emitter import Emitter
from app.schemas.emitter import EmitterCreate, EmitterRead
from app.services.audit_service import log_user_activity

router = APIRouter(prefix="/emitters", tags=["emitters"])


@router.post("/", response_model=EmitterRead, status_code=status.HTTP_201_CREATED)
def create_emitter(
    payload: EmitterCreate,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
):
    emitter = Emitter(
        client_id=current_client.id,
        rut_emisor=payload.rut_emisor,
        razon_social=payload.razon_social,
        direccion=payload.direccion,
        comuna=payload.comuna,
        giro=payload.giro,
        sii_environment=payload.sii_environment,
        sii_status="PENDIENTE",
    )
    db.add(emitter)
    try:
        db.commit()
    except Exception as exc:  # noqa: BLE001
        db.rollback()
        # Log de error al crear emisor
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.CREATE_EMITTER,
            path="/api/v1/emitters",
            method="POST",
            status_code=status.HTTP_400_BAD_REQUEST,
            success=False,
            error_message=str(exc),
            extra={
                "rut_emisor": payload.rut_emisor,
                "razon_social": payload.razon_social,
            },
        )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error creating emitter",
        )

    db.refresh(emitter)

    # Log de creación exitosa
    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.CREATE_EMITTER,
        path="/api/v1/emitters",
        method="POST",
        status_code=status.HTTP_201_CREATED,
        success=True,
        extra={
            "emitter_id": emitter.id,
            "rut_emisor": emitter.rut_emisor,
            "razon_social": emitter.razon_social,
        },
    )

    return emitter


@router.get("/", response_model=list[EmitterRead])
def list_emitters(
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
):
    emitters = (
        db.query(Emitter)
        .filter(Emitter.client_id == current_client.id)
        .order_by(Emitter.id)
        .all()
    )

    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.LIST_EMITTERS,
        path="/api/v1/emitters",
        method="GET",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"count": len(emitters)},
    )

    return emitters


@router.get("/{emitter_id}", response_model=EmitterRead)
def get_emitter(
    emitter_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
):
    emitter = (
        db.query(Emitter)
        .filter(
            Emitter.id == emitter_id,
            Emitter.client_id == current_client.id,
        )
        .first()
    )

    if not emitter:
        log_user_activity(
            db,
            user=current_user,
            client=current_client,
            action=AuditAction.GET_EMITTER,
            path=f"/api/v1/emitters/{emitter_id}",
            method="GET",
            status_code=status.HTTP_404_NOT_FOUND,
            success=False,
            error_message="Emitter not found",
            extra={"emitter_id": emitter_id},
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Emitter not found",
        )

    log_user_activity(
        db,
        user=current_user,
        client=current_client,
        action=AuditAction.GET_EMITTER,
        path=f"/api/v1/emitters/{emitter_id}",
        method="GET",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"emitter_id": emitter.id},
    )

    return emitter

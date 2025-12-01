# app/api/v1/routes_audit.py
from datetime import datetime
from typing import Optional, List

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import get_current_client, get_current_user
from app.core.audit_actions import AuditAction          # 👈 NUEVO
from app.models.client import Client
from app.models.user import User
from app.models.user_activity import UserActivity
from app.schemas.audit import UserActivityRead

router = APIRouter(prefix="/audit", tags=["audit"])


@router.get("/", response_model=List[UserActivityRead])
def list_activities(
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
    user_id: Optional[int] = Query(None, description="Filtrar por user_id"),
    action: Optional[AuditAction] = Query(  # 👈 Enum en vez de string
        None,
        description="Filtrar por acción exacta (enum AuditAction)",
    ),
    success: Optional[bool] = Query(None, description="Filtrar por éxito / error"),
    from_date: Optional[datetime] = Query(
        None, description="Desde fecha/hora (ISO 8601)"
    ),
    to_date: Optional[datetime] = Query(
        None, description="Hasta fecha/hora (ISO 8601)"
    ),
    limit: int = Query(100, ge=1, le=1000, description="Cantidad máxima de registros"),
    offset: int = Query(0, ge=0, description="Desplazamiento para paginación"),
):
    """
    Lista actividades de usuario del cliente actual, con filtros opcionales.
    """

    q = db.query(UserActivity).filter(UserActivity.client_id == current_client.id)

    if user_id is not None:
        q = q.filter(UserActivity.user_id == user_id)

    if action is not None:
        # AuditAction hereda de str, pero usamos .value por claridad
        q = q.filter(UserActivity.action == action.value)

    if success is not None:
        q = q.filter(UserActivity.success == success)

    if from_date is not None:
        q = q.filter(UserActivity.created_at >= from_date)

    if to_date is not None:
        q = q.filter(UserActivity.created_at <= to_date)

    activities = (
        q.order_by(UserActivity.created_at.desc())
        .offset(offset)
        .limit(limit)
        .all()
    )

    return activities


@router.get("/{activity_id}", response_model=UserActivityRead)
def get_activity(
    activity_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
    current_user: User = Depends(get_current_user),
):
    """
    Obtiene el detalle de una actividad específica del cliente actual.
    """
    activity = (
        db.query(UserActivity)
        .filter(
            UserActivity.id == activity_id,
            UserActivity.client_id == current_client.id,
        )
        .first()
    )

    if not activity:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Activity not found",
        )

    return activity

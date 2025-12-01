# app/services/audit_service.py
import logging
from typing import Any, Dict, Optional

from sqlalchemy.orm import Session

from app.models.user import User
from app.models.client import Client
from app.models.user_activity import UserActivity

logger = logging.getLogger(__name__)


def log_user_activity(
    db: Session,
    *,
    user: Optional[User],
    client: Optional[Client],
    action: str,
    path: str,
    method: str,
    status_code: int,
    success: bool = True,
    error_message: Optional[str] = None,
    extra: Optional[Dict[str, Any]] = None,
    ip_address: Optional[str] = None,
    user_agent: Optional[str] = None,
) -> None:
    """
    Registra un movimiento del usuario en la tabla user_activity.
    No lanza excepción si falla, solo loggea.
    """
    try:
        activity = UserActivity(
            user_id=user.id if user else None,
            client_id=client.id if client else None,
            action=action,
            path=path,
            method=method,
            status_code=status_code,
            success=success,
            error_message=error_message,
            extra=extra,
            ip_address=ip_address,
            user_agent=user_agent,
        )
        db.add(activity)
        # commit separado para no afectar la lógica principal
        db.commit()
    except Exception as exc:  # noqa: BLE001
        logger.exception("Error al registrar UserActivity: %s", exc)
        db.rollback()

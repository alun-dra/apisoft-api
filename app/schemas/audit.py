# app/schemas/audit.py
from datetime import datetime
from typing import Any, Dict, Optional
from app.core.audit_actions import AuditAction
from pydantic import BaseModel, ConfigDict


class UserActivityRead(BaseModel):
    id: int
    user_id: Optional[int]
    client_id: Optional[int]

    action: AuditAction
    method: str
    path: str
    status_code: int
    success: bool
    error_message: Optional[str]

    ip_address: Optional[str]
    user_agent: Optional[str]

    extra: Optional[Dict[str, Any]]
    created_at: datetime

    # Para permitir objetos ORM (SQLAlchemy) en Pydantic v2
    model_config = ConfigDict(from_attributes=True)

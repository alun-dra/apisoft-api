# app/models/user_activity.py
from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    DateTime,
    Text,
)
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.sql import func

from app.db.session import Base


class UserActivity(Base):
    __tablename__ = "user_activity"

    id = Column(Integer, primary_key=True, index=True)

    # Relación lógica con usuario y cliente
    user_id = Column(Integer, index=True, nullable=True)
    client_id = Column(Integer, index=True, nullable=True)

    # Info de la request
    action = Column(String(100), nullable=False)          # ej: CREATE_DOCUMENT
    method = Column(String(10), nullable=False)           # GET / POST / PUT / DELETE
    path = Column(String(255), nullable=False)            # /api/v1/documents/1
    status_code = Column(Integer, nullable=False)

    success = Column(Boolean, default=True, nullable=False)
    error_message = Column(Text, nullable=True)

    # Metadatos útiles
    ip_address = Column(String(50), nullable=True)
    user_agent = Column(String(255), nullable=True)

    # Datos adicionales del contexto (ID del doc, tipo_dte, etc.)
    extra = Column(JSONB, nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now(), index=True)

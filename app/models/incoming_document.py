# app/models/incoming_document.py
from datetime import datetime
from sqlalchemy import Column, Integer, String, Numeric, DateTime, Text, ForeignKey
from sqlalchemy.orm import relationship

from app.db.session import Base


class IncomingDocument(Base):
    __tablename__ = "incoming_documents"

    id = Column(Integer, primary_key=True, index=True)

    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False)

    # Datos del emisor externo
    emitter_rut = Column(String(20), nullable=False)
    emitter_name = Column(String(255), nullable=True)

    # Datos del DTE
    tipo_dte = Column(Integer, nullable=False)      # 33, 39, 61, etc.
    folio = Column(Integer, nullable=False)
    fecha_emision = Column(DateTime, nullable=False)

    monto_neto = Column(Numeric(18, 2), nullable=True)
    monto_iva = Column(Numeric(18, 2), nullable=True)
    monto_total = Column(Numeric(18, 2), nullable=False)

    # Estado en el SII (opcional)
    sii_state = Column(String(50), nullable=True)   # RECIBIDO, ACEPTADO, RECLAMADO, etc.

    # DTE/XML completo opcional
    raw_xml = Column(Text, nullable=True)

    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    client = relationship("Client", backref="incoming_documents")

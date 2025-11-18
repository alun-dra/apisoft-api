from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    Numeric,
    Text,
)
from sqlalchemy.orm import relationship
from app.db.session import Base


class Document(Base):
    __tablename__ = "documents"

    id = Column(Integer, primary_key=True, index=True)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False)
    emitter_id = Column(Integer, ForeignKey("emitters.id"), nullable=False)

    tipo_dte = Column(Integer, nullable=False)  # 33, 34, 39, etc.
    folio = Column(Integer, nullable=True)

    receptor_rut = Column(String(20), nullable=False)
    receptor_razon_social = Column(String(255), nullable=False)
    receptor_direccion = Column(String(255), nullable=True)
    receptor_comuna = Column(String(100), nullable=True)

    monto_neto = Column(Numeric(15, 2), nullable=False)
    monto_iva = Column(Numeric(15, 2), nullable=False)
    monto_total = Column(Numeric(15, 2), nullable=False)

    sii_track_id = Column(String(50), nullable=True, index=True)
    sii_state = Column(String(50), default="CREADO")
    error_last_message = Column(Text, nullable=True)

    raw_xml = Column(Text, nullable=True)
    pdf_path = Column(String(255), nullable=True)

    client = relationship("Client", back_populates="documents")
    emitter = relationship("Emitter", back_populates="documents")
    items = relationship("DocumentItem", back_populates="document", cascade="all, delete-orphan")
    logs = relationship("LogEvent", back_populates="document", cascade="all, delete-orphan")


class DocumentItem(Base):
    __tablename__ = "document_items"

    id = Column(Integer, primary_key=True, index=True)
    document_id = Column(Integer, ForeignKey("documents.id"), nullable=False)

    descripcion = Column(String(255), nullable=False)
    cantidad = Column(Numeric(15, 2), nullable=False)
    precio_unitario = Column(Numeric(15, 2), nullable=False)
    descuento = Column(Numeric(15, 2), nullable=True)
    total_linea = Column(Numeric(15, 2), nullable=False)

    document = relationship("Document", back_populates="items")

from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.db.session import Base


class Emitter(Base):
    __tablename__ = "emitters"

    id = Column(Integer, primary_key=True, index=True)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False)

    rut_emisor = Column(String(20), nullable=False, index=True)
    razon_social = Column(String(255), nullable=False)
    direccion = Column(String(255), nullable=True)
    comuna = Column(String(100), nullable=True)
    giro = Column(String(255), nullable=True)

    cert_alias = Column(String(100), nullable=True)
    sii_environment = Column(String(10), default="CERT")  # CERT / PROD
    sii_status = Column(String(50), default="PENDIENTE")

    client = relationship("Client", back_populates="emitters")
    documents = relationship("Document", back_populates="emitter")

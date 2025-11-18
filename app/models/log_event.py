from sqlalchemy import Column, Integer, String, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.db.session import Base


class LogEvent(Base):
    __tablename__ = "log_events"

    id = Column(Integer, primary_key=True, index=True)
    document_id = Column(Integer, ForeignKey("documents.id"), nullable=True)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=True)

    level = Column(String(20), default="INFO")  # INFO/WARN/ERROR
    origin = Column(String(50), nullable=True)  # API/SII/INTERNAL
    message = Column(String(255), nullable=False)
    payload = Column(Text, nullable=True)  # JSON string si quieres

    document = relationship("Document", back_populates="logs")

# app/models/caf.py
from sqlalchemy import (
    Column,
    Integer,
    Boolean,
    Date,
    Text,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship

from app.db.session import Base


class Caf(Base):
    __tablename__ = "caf"

    id = Column(Integer, primary_key=True, index=True)

    emitter_id = Column(Integer, ForeignKey("emitters.id"), nullable=False)
    tipo_dte = Column(Integer, nullable=False)

    folio_inicial = Column(Integer, nullable=False)
    folio_final = Column(Integer, nullable=False)
    folio_actual = Column(Integer, nullable=False)  # próximo folio a usar

    fecha_autorizacion = Column(Date, nullable=False)
    fecha_vencimiento = Column(Date, nullable=True)

    caf_xml = Column(Text, nullable=False)

    is_active = Column(Boolean, nullable=False, default=True)

    # Un CAF pertenece a un emisor
    emitter = relationship("Emitter", back_populates="caf_list")

    __table_args__ = (
        UniqueConstraint(
            "emitter_id",
            "tipo_dte",
            "folio_inicial",
            "folio_final",
            name="uix_caf_emitter_tipo_rango",
        ),
    )

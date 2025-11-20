# app/schemas/caf.py
from datetime import date
from pydantic import BaseModel


class CafBase(BaseModel):
    emitter_id: int
    tipo_dte: int
    folio_inicial: int
    folio_final: int
    fecha_autorizacion: date
    fecha_vencimiento: date | None = None
    caf_xml: str


class CafCreate(CafBase):
    pass


class CafRead(CafBase):
    id: int
    folio_actual: int
    is_active: bool

    class Config:
        from_attributes = True  # FastAPI v0.95+ / Pydantic v2

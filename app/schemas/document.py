from typing import List, Optional
from pydantic import BaseModel, Field


class DocumentItemCreate(BaseModel):
    descripcion: str
    cantidad: float = Field(gt=0)
    precio_unitario: float = Field(gt=0)
    descuento: float | None = None


class DocumentReceptor(BaseModel):
    rut: str
    razon_social: str
    direccion: str | None = None
    comuna: str | None = None


class DocumentCreate(BaseModel):
    emitter_id: int
    tipo_dte: int
    receptor: DocumentReceptor
    items: List[DocumentItemCreate]


class DocumentItemRead(BaseModel):
    id: int
    descripcion: str
    cantidad: float
    precio_unitario: float
    descuento: float | None
    total_linea: float

    class Config:
        from_attributes = True


class DocumentRead(BaseModel):
    id: int
    client_id: int
    emitter_id: int
    tipo_dte: int
    monto_neto: float
    monto_iva: float
    monto_total: float
    sii_state: str
    sii_track_id: Optional[str]

    items: List[DocumentItemRead]

    class Config:
        from_attributes = True

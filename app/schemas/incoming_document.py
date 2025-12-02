# app/schemas/incoming_document.py
from datetime import datetime
from decimal import Decimal
from typing import Optional

from pydantic import BaseModel, ConfigDict


class IncomingDocumentBase(BaseModel):
    emitter_rut: str
    emitter_name: Optional[str] = None
    tipo_dte: int
    folio: int
    fecha_emision: datetime
    monto_neto: Optional[Decimal] = None
    monto_iva: Optional[Decimal] = None
    monto_total: Decimal
    sii_state: Optional[str] = None


class IncomingDocumentRead(IncomingDocumentBase):
    id: int
    client_id: int
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

from pydantic import BaseModel


class EmitterBase(BaseModel):
    rut_emisor: str
    razon_social: str
    direccion: str | None = None
    comuna: str | None = None
    giro: str | None = None
    sii_environment: str = "CERT"  # CERT / PROD


class EmitterCreate(EmitterBase):
    pass


class EmitterRead(EmitterBase):
    id: int
    client_id: int
    sii_status: str

    class Config:
        from_attributes = True

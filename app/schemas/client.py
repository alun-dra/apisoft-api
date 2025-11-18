from pydantic import BaseModel, EmailStr


class ClientBase(BaseModel):
    name: str
    contact_email: EmailStr


class ClientCreate(ClientBase):
    pass


class ClientRead(ClientBase):
    id: int
    is_active: bool

    class Config:
        from_attributes = True

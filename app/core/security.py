from fastapi import Depends, HTTPException, status
from fastapi.security import APIKeyHeader
from sqlalchemy.orm import Session

from app.core.config import get_settings
from app.db.session import get_db
from app.models.client import Client

settings = get_settings()

api_key_header = APIKeyHeader(
    name=settings.api_key_header_name,
    auto_error=False,
)


def get_current_client(
    api_key: str | None = Depends(api_key_header),
    db: Session = Depends(get_db),
) -> Client:
    if not api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing API key",
        )

    client = db.query(Client).filter(
        Client.api_key == api_key,
        Client.is_active == True,  # noqa: E712
    ).first()

    if not client:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or inactive API key",
        )

    return client

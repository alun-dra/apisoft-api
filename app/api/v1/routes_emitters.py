from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import get_current_client
from app.models.client import Client
from app.models.emitter import Emitter
from app.schemas.emitter import EmitterCreate, EmitterRead

router = APIRouter(prefix="/emitters", tags=["emitters"])


@router.post("/", response_model=EmitterRead, status_code=status.HTTP_201_CREATED)
def create_emitter(
    payload: EmitterCreate,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    emitter = Emitter(
        client_id=current_client.id,
        rut_emisor=payload.rut_emisor,
        razon_social=payload.razon_social,
        direccion=payload.direccion,
        comuna=payload.comuna,
        giro=payload.giro,
        sii_environment=payload.sii_environment,
        sii_status="PENDIENTE",
    )
    db.add(emitter)
    db.commit()
    db.refresh(emitter)
    return emitter


@router.get("/", response_model=list[EmitterRead])
def list_emitters(
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    emitters = (
        db.query(Emitter)
        .filter(Emitter.client_id == current_client.id)
        .order_by(Emitter.id)
        .all()
    )
    return emitters


@router.get("/{emitter_id}", response_model=EmitterRead)
def get_emitter(
    emitter_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    emitter = (
        db.query(Emitter)
        .filter(
            Emitter.id == emitter_id,
            Emitter.client_id == current_client.id,
        )
        .first()
    )

    if not emitter:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Emitter not found",
        )

    return emitter

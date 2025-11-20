# app/api/v1/routes_caf.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import get_current_client
from app.models.client import Client
from app.models.emitter import Emitter
from app.models.caf import Caf
from app.schemas.caf import CafCreate, CafRead

router = APIRouter(prefix="/caf", tags=["caf"])


@router.post("/", response_model=CafRead, status_code=status.HTTP_201_CREATED)
def create_caf(
    payload: CafCreate,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    # Verificar que el emisor pertenezca al cliente actual
    emitter = (
        db.query(Emitter)
        .filter(
            Emitter.id == payload.emitter_id,
            Emitter.client_id == current_client.id,
        )
        .first()
    )
    if not emitter:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Emitter not found for current client",
        )

    # Crear CAF
    caf = Caf(
        emitter_id=payload.emitter_id,
        tipo_dte=payload.tipo_dte,
        folio_inicial=payload.folio_inicial,
        folio_final=payload.folio_final,
        folio_actual=payload.folio_inicial,  # empezamos en el primer folio
        fecha_autorizacion=payload.fecha_autorizacion,
        fecha_vencimiento=payload.fecha_vencimiento,
        caf_xml=payload.caf_xml,
        is_active=True,
    )

    db.add(caf)
    try:
        db.commit()
    except Exception:
        db.rollback()
        # puede ser por el UniqueConstraint
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="CAF range already exists for this emitter and type",
        )

    db.refresh(caf)
    return caf


@router.get("/", response_model=list[CafRead])
def list_caf(
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    # CAF solo del cliente actual, vía join con Emitter
    caf_list = (
        db.query(Caf)
        .join(Emitter)
        .filter(Emitter.client_id == current_client.id)
        .order_by(Caf.emitter_id, Caf.tipo_dte, Caf.folio_inicial)
        .all()
    )
    return caf_list


@router.get("/{caf_id}", response_model=CafRead)
def get_caf(
    caf_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    caf = (
        db.query(Caf)
        .join(Emitter)
        .filter(
            Caf.id == caf_id,
            Emitter.client_id == current_client.id,
        )
        .first()
    )
    if not caf:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="CAF not found",
        )
    return caf

from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks
from fastapi.responses import PlainTextResponse

from sqlalchemy.orm import Session

from app.db.session import get_db
from app.core.security import get_current_client
from app.models.client import Client
from app.models.document import Document, DocumentItem
from app.schemas.document import DocumentCreate, DocumentRead
from app.services.sii_client import process_document_send_to_sii

router = APIRouter(prefix="/documents", tags=["documents"])


@router.post("/", response_model=DocumentRead, status_code=status.HTTP_201_CREATED)
def create_document(
    payload: DocumentCreate,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    from decimal import Decimal

    # Calcular montos
    monto_neto = Decimal("0")
    for item in payload.items:
        line_total = Decimal(str(item.cantidad)) * Decimal(str(item.precio_unitario))
        if item.descuento:
            line_total -= Decimal(str(item.descuento))
        monto_neto += line_total

    monto_iva = (monto_neto * Decimal("0.19")).quantize(Decimal("1."))  # IVA 19%
    monto_total = monto_neto + monto_iva

    # Crear documento
    document = Document(
        client_id=current_client.id,
        emitter_id=payload.emitter_id,
        tipo_dte=payload.tipo_dte,
        receptor_rut=payload.receptor.rut,
        receptor_razon_social=payload.receptor.razon_social,
        receptor_direccion=payload.receptor.direccion,
        receptor_comuna=payload.receptor.comuna,
        monto_neto=monto_neto,
        monto_iva=monto_iva,
        monto_total=monto_total,
        sii_state="CREADO",
    )

    db.add(document)
    db.flush()  # para tener document.id

    # Items
    for item in payload.items:
        line_total = Decimal(str(item.cantidad)) * Decimal(str(item.precio_unitario))
        if item.descuento:
            line_total -= Decimal(str(item.descuento))

        db_item = DocumentItem(
            document_id=document.id,
            descripcion=item.descripcion,
            cantidad=item.cantidad,
            precio_unitario=item.precio_unitario,
            descuento=item.descuento,
            total_linea=line_total,
        )
        db.add(db_item)

    db.commit()
    db.refresh(document)

    # 🔥 Encolar envío al SII (por ahora dummy) como tarea en background
    background_tasks.add_task(process_document_send_to_sii, document.id)

    return document


@router.get("/{document_id}", response_model=DocumentRead)
def get_document(
    document_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    document = (
        db.query(Document)
        .filter(
            Document.id == document_id,
            Document.client_id == current_client.id,
        )
        .first()
    )

    if not document:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Document not found",
        )

    return document



from xml.dom import minidom

@router.get("/{document_id}/xml", response_class=PlainTextResponse)
def get_document_xml(
    document_id: int,
    db: Session = Depends(get_db),
    current_client: Client = Depends(get_current_client),
):
    document = (
        db.query(Document)
        .filter(
            Document.id == document_id,
            Document.client_id == current_client.id,
        )
        .first()
    )

    if not document:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Document not found",
        )

    if not document.raw_xml:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="XML not generated yet",
        )

    # 🔥 Formatear XML bonito
    parsed = minidom.parseString(document.raw_xml.encode("iso-8859-1"))
    pretty_xml = parsed.toprettyxml(indent="  ")

    return pretty_xml


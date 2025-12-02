# app/services/incoming_dte_service.py
from datetime import datetime, timedelta
from decimal import Decimal
from typing import List, Dict, Any, Optional

from sqlalchemy.orm import Session

from app.models.client import Client
from app.models.incoming_document import IncomingDocument


def _fetch_incoming_from_sii_dummy(
    client: Client,
    since: Optional[datetime],
) -> List[Dict[str, Any]]:
    """
    Dummy que simula traer DTE recibidos desde el SII.

    👉 En producción, aquí deberías:
       - Llamar al webservice real del SII
       - Autenticarte con certificado del contribuyente
       - Traer documentos donde el RUT receptor = client.rut (lo que uses)
    """
    if since is None:
        since = datetime.utcnow() - timedelta(days=30)

    # Ejemplo fijo para pruebas; puedes ajustar como quieras:
    return [
        {
            "emitter_rut": "76111111-1",
            "emitter_name": "Proveedor Uno SpA",
            "tipo_dte": 33,
            "folio": 1001,
            "fecha_emision": datetime.utcnow() - timedelta(days=2),
            "monto_neto": Decimal("100000"),
            "monto_iva": Decimal("19000"),
            "monto_total": Decimal("119000"),
            "sii_state": "RECIBIDO",
            "raw_xml": None,  # si quisieras guardar el XML real, va acá
        },
        {
            "emitter_rut": "76222222-2",
            "emitter_name": "Proveedor Dos Ltda.",
            "tipo_dte": 33,
            "folio": 5005,
            "fecha_emision": datetime.utcnow() - timedelta(days=1),
            "monto_neto": Decimal("50000"),
            "monto_iva": Decimal("9500"),
            "monto_total": Decimal("59500"),
            "sii_state": "RECIBIDO",
            "raw_xml": None,
        },
    ]


def sync_incoming_documents_from_sii(
    db: Session,
    client: Client,
    since: Optional[datetime] = None,
) -> int:
    """
    Sincroniza DTE recibidos para un client dado.

    - Usa un dummy que simula el SII.
    - En producción, reemplazas _fetch_incoming_from_sii_dummy()
      por una integración real con el webservice del SII.
    """
    data_list = _fetch_incoming_from_sii_dummy(client, since)
    synced = 0

    for data in data_list:
        emitter_rut = data["emitter_rut"]
        tipo_dte = data["tipo_dte"]
        folio = data["folio"]

        # Intentamos ver si ya existe (para hacer upsert)
        doc = (
            db.query(IncomingDocument)
            .filter(
                IncomingDocument.client_id == client.id,
                IncomingDocument.emitter_rut == emitter_rut,
                IncomingDocument.tipo_dte == tipo_dte,
                IncomingDocument.folio == folio,
            )
            .first()
        )

        if doc:
            # Update básico
            doc.emitter_name = data.get("emitter_name")
            doc.fecha_emision = data["fecha_emision"]
            doc.monto_neto = data.get("monto_neto")
            doc.monto_iva = data.get("monto_iva")
            doc.monto_total = data["monto_total"]
            doc.sii_state = data.get("sii_state")
            if data.get("raw_xml") is not None:
                doc.raw_xml = data["raw_xml"]
        else:
            doc = IncomingDocument(
                client_id=client.id,
                emitter_rut=emitter_rut,
                emitter_name=data.get("emitter_name"),
                tipo_dte=tipo_dte,
                folio=folio,
                fecha_emision=data["fecha_emision"],
                monto_neto=data.get("monto_neto"),
                monto_iva=data.get("monto_iva"),
                monto_total=data["monto_total"],
                sii_state=data.get("sii_state"),
                raw_xml=data.get("raw_xml"),
            )
            db.add(doc)

        synced += 1

    db.commit()
    return synced

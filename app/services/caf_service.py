from __future__ import annotations

from sqlalchemy.orm import Session

from app.models.caf import Caf


class NoAvailableFolio(Exception):
    """No hay folios disponibles en CAF para ese emisor/tipo."""


def assign_folio_from_caf(
    db: Session,
    *,
    emitter_id: int,
    tipo_dte: int,
) -> tuple[Caf, int]:
    """
    Busca un CAF activo para el emisor+tipo_dte, bloquea la fila
    y entrega el próximo folio disponible, incrementando folio_actual.
    """

    # CAF activo con folios disponibles (folio_actual <= folio_final)
    caf = (
        db.query(Caf)
        .filter(
            Caf.emitter_id == emitter_id,
            Caf.tipo_dte == tipo_dte,
            Caf.is_active.is_(True),
            Caf.folio_actual <= Caf.folio_final,
        )
        .order_by(Caf.fecha_autorizacion.desc())
        .with_for_update()
        .first()
    )

    if not caf:
        raise NoAvailableFolio(
            f"No hay CAF activo con folios disponibles para emisor={emitter_id}, tipo_dte={tipo_dte}"
        )

    folio = caf.folio_actual
    caf.folio_actual = caf.folio_actual + 1

    # No hacemos commit aquí; lo hará la vista que nos llamó
    return caf, folio

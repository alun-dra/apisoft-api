# app/services/caf_service.py

from __future__ import annotations

from dataclasses import dataclass
from typing import Optional

import xml.etree.ElementTree as ET
from sqlalchemy.orm import Session

from app.models.caf import Caf
from app.models.document import Document


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

    # No hacemos commit aquí; lo hace la vista que nos llamó
    return caf, folio


# ---------- PARSEO DEL CAF ----------

@dataclass
class CafParsed:
    rut_emisor: str
    razon_social: Optional[str]
    tipo_dte: int
    folio_desde: int
    folio_hasta: int
    rsapk: Optional[str]
    idk: Optional[str]
    frma_caf: Optional[str]
    raw_xml: str


def parse_caf_xml(caf: Caf) -> CafParsed:
    """
    Parsea el XML del CAF y devuelve una estructura Python.
    Pensado para usarse al generar el TED real.
    """

    # El CAF completo suele venir envuelto en <AUTORIZACION>...</AUTORIZACION>
    xml_str = caf.caf_xml
    root = ET.fromstring(xml_str)

    # Dependiendo del formato, el nodo <CAF> puede estar dentro de <AUTORIZACION>
    # Ej habitual SII:
    # <AUTORIZACION>
    #   <CAF> ... </CAF>
    #   <RSAPK>...</RSAPK>
    #   <RSAPKI>...</RSAPKI>
    #   <IDK>...</IDK>
    # </AUTORIZACION>

    caf_el = root.find(".//CAF")
    if caf_el is None:
        # algunos proveedores pueden guardar solo el nodo <CAF>; en ese caso root es CAF
        if root.tag == "CAF":
            caf_el = root
        else:
            raise ValueError("CAF XML no tiene nodo <CAF>")

    da_el = caf_el.find("DA")
    if da_el is None:
        raise ValueError("CAF XML no tiene nodo <DA>")

    re_el = da_el.findtext("RE")  # RUT emisor
    rs_el = da_el.findtext("RS")  # Razón social emisor (opcional)
    td_el = da_el.findtext("TD")  # Tipo DTE

    rng_el = da_el.find("RNG")
    if rng_el is None:
        raise ValueError("CAF XML no tiene nodo <RNG>")

    d_el = rng_el.findtext("D")   # Folio desde
    h_el = rng_el.findtext("H")   # Folio hasta

    # Firma del CAF sobre el DD autorizado
    frma_caf_el = caf_el.findtext("FRMA")

    # Public key y IDK suelen ir en el nodo padre <AUTORIZACION>
    rsapk_el = root.findtext("RSAPK")
    idk_el = root.findtext("IDK")

    return CafParsed(
        rut_emisor=re_el or "",
        razon_social=rs_el,
        tipo_dte=int(td_el) if td_el else caf.tipo_dte,
        folio_desde=int(d_el) if d_el else caf.folio_inicial,
        folio_hasta=int(h_el) if h_el else caf.folio_final,
        rsapk=rsapk_el,
        idk=idk_el,
        frma_caf=frma_caf_el,
        raw_xml=xml_str,
    )


def get_caf_for_document(db: Session, document: Document) -> Optional[Caf]:
    """
    Devuelve el CAF cuyo rango contiene el folio del documento.
    Si no lo encuentra, devuelve None.
    """
    if document.folio is None:
        return None

    return (
        db.query(Caf)
        .filter(
            Caf.emitter_id == document.emitter_id,
            Caf.tipo_dte == document.tipo_dte,
            Caf.is_active.is_(True),
            Caf.folio_inicial <= document.folio,
            Caf.folio_final >= document.folio,
        )
        .order_by(Caf.fecha_autorizacion.desc())
        .first()
    )

# app/services/envio_dte.py
from __future__ import annotations

from datetime import datetime
import uuid
import xml.etree.ElementTree as ET

from app.core.config import get_settings

settings = get_settings()

SII_NS = "http://www.sii.cl/SiiDte"
DS_NS = "http://www.w3.org/2000/09/xmldsig#"

# Para que salga <ds:Signature ...>
ET.register_namespace("ds", DS_NS)


def build_envio_dte_xml(*, dte_xml: str, tipo_dte: int, rut_emisor: str) -> str:
    """
    Crea el sobre EnvioDTE con:
    - <Caratula> (RutEmisor, RutEnvia, RutReceptor, FchResol, NroResol, SubTotDTE)
    - <SetDTE> que contiene el DTE ya generado
    - <ds:Signature> GLOBAL (dummy por ahora)

    Devuelve el XML como string ISO-8859-1.
    """

    # ---------- raíz EnvioDTE ----------
    envio = ET.Element("EnvioDTE", attrib={"version": "1.0", "xmlns": SII_NS})

    # ---------- SetDTE ----------
    set_id = "SetDoc_" + datetime.utcnow().strftime("%Y%m%d%H%M%S")
    set_dte = ET.SubElement(envio, "SetDTE", ID=set_id)

    # ---------- Carátula ----------
    caratula = ET.SubElement(set_dte, "Caratula", version="1.0")

    rut_envia = settings.sii_rut_envia or rut_emisor
    rut_receptor = settings.sii_rut_receptor

    fch_resol = settings.sii_fch_resol or "2020-01-01"
    nro_resol = settings.sii_nro_resol if settings.sii_nro_resol is not None else 0

    ET.SubElement(caratula, "RutEmisor").text = rut_emisor
    ET.SubElement(caratula, "RutEnvia").text = rut_envia
    ET.SubElement(caratula, "RutReceptor").text = rut_receptor
    ET.SubElement(caratula, "FchResol").text = fch_resol
    ET.SubElement(caratula, "NroResol").text = str(nro_resol)
    ET.SubElement(caratula, "TmstFirmaEnv").text = (
        datetime.utcnow().replace(microsecond=0).isoformat()
    )

    # SubTotDTE (por ahora siempre 1 DTE de un tipo)
    sub_tot = ET.SubElement(caratula, "SubTotDTE")
    ET.SubElement(sub_tot, "TpoDTE").text = str(tipo_dte)
    ET.SubElement(sub_tot, "NroDte").text = "1"

    # ---------- insertar el DTE dentro de SetDTE ----------
    # dte_xml viene con encoding iso-8859-1
    dte_root = ET.fromstring(dte_xml.encode("iso-8859-1"))
    set_dte.append(dte_root)

    # ---------- Signature GLOBAL (dummy) ----------
    signature = ET.SubElement(envio, f"{{{DS_NS}}}Signature")

    signed_info = ET.SubElement(signature, f"{{{DS_NS}}}SignedInfo")
    ET.SubElement(
        signed_info,
        f"{{{DS_NS}}}CanonicalizationMethod",
        Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315",
    )
    ET.SubElement(
        signed_info,
        f"{{{DS_NS}}}SignatureMethod",
        Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1",
    )

    ref = ET.SubElement(signed_info, f"{{{DS_NS}}}Reference", URI="")
    ET.SubElement(
        ref,
        f"{{{DS_NS}}}DigestMethod",
        Algorithm="http://www.w3.org/2000/09/xmldsig#sha1",
    )
    ET.SubElement(ref, f"{{{DS_NS}}}DigestValue").text = "DIGEST_PLACEHOLDER"

    ET.SubElement(signature, f"{{{DS_NS}}}SignatureValue").text = "SIGNATURE_PLACEHOLDER"

    key_info = ET.SubElement(signature, f"{{{DS_NS}}}KeyInfo")
    ET.SubElement(key_info, f"{{{DS_NS}}}KeyName").text = "CERT_PLACEHOLDER"

    # ---------- Serializar ----------
    envio_bytes = ET.tostring(envio, encoding="iso-8859-1", xml_declaration=True)
    return envio_bytes.decode("iso-8859-1")


def send_envio_dte_dummy(envio_xml: str) -> str:
    """
    Dummy de envío al SII:
    - NO hace HTTP
    - Solo genera un track_id ficticio basado en UUID
    """
    # En caso de que quieras mirarlo en consola:
    # print("===== EnvioDTE DUMMY =====")
    # print(envio_xml)
    fake_track_id = "DUMMY-" + uuid.uuid4().hex[:10].upper()
    return fake_track_id

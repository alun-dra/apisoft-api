# app/services/envio_dte.py
from __future__ import annotations

from datetime import datetime
import uuid
import xml.etree.ElementTree as ET

from app.core.config import get_settings

settings = get_settings()

SII_NS = "http://www.sii.cl/SiiDte"
DS_NS = "http://www.w3.org/2000/09/xmldsig#"
XSI_NS = "http://www.w3.org/2001/XMLSchema-instance"

NS = f"{{{SII_NS}}}"
DS = f"{{{DS_NS}}}"
XSI = f"{{{XSI_NS}}}"


def sii(tag: str) -> str:
    """Devuelve el nombre calificado con el namespace SII."""
    return f"{NS}{tag}"


# Namespaces
ET.register_namespace("", SII_NS)
ET.register_namespace("ds", DS_NS)
ET.register_namespace("xsi", XSI_NS)


def build_envio_dte_xml(*, dte_xml: str, tipo_dte: int, rut_emisor: str) -> str:
    """
    Crea el sobre EnvioDTE con:
    - <Caratula> (RutEmisor, RutEnvia, RutReceptor, FchResol, NroResol, SubTotDTE)
    - <SetDTE> que contiene el DTE ya generado
    - <ds:Signature> GLOBAL (dummy pero XSD-compatible)

    Devuelve el XML como string ISO-8859-1.
    """

    # ---------- raíz EnvioDTE ----------
    envio = ET.Element(sii("EnvioDTE"))
    envio.set("version", "1.0")
    envio.set(f"{XSI}schemaLocation", "http://www.sii.cl/SiiDte EnvioDTE_v10.xsd")

    # ---------- SetDTE ----------
    set_id = "SetDoc_" + datetime.utcnow().strftime("%Y%m%d%H%M%S")
    set_dte = ET.SubElement(envio, sii("SetDTE"), ID=set_id)

    # ---------- Carátula ----------
    caratula = ET.SubElement(set_dte, sii("Caratula"))
    caratula.set("version", "1.0")

    rut_envia = settings.sii_rut_envia or rut_emisor
    rut_receptor = settings.sii_rut_receptor

    fch_resol = settings.sii_fch_resol or "2020-01-01"
    nro_resol = (
        settings.sii_nro_resol
        if getattr(settings, "sii_nro_resol", None) is not None
        else 0
    )

    ET.SubElement(caratula, sii("RutEmisor")).text = rut_emisor
    ET.SubElement(caratula, sii("RutEnvia")).text = rut_envia
    ET.SubElement(caratula, sii("RutReceptor")).text = rut_receptor
    ET.SubElement(caratula, sii("FchResol")).text = fch_resol
    ET.SubElement(caratula, sii("NroResol")).text = str(nro_resol)
    ET.SubElement(caratula, sii("TmstFirmaEnv")).text = (
        datetime.utcnow().replace(microsecond=0).isoformat()
    )

    # SubTotDTE (por ahora siempre 1 DTE de un tipo)
    sub_tot = ET.SubElement(caratula, sii("SubTotDTE"))
    ET.SubElement(sub_tot, sii("TpoDTE")).text = str(tipo_dte)
    ET.SubElement(sub_tot, sii("NroDTE")).text = "1"

    # ---------- insertar el DTE dentro de SetDTE ----------
    dte_root = ET.fromstring(dte_xml.encode("iso-8859-1"))
    set_dte.append(dte_root)

    # ---------- Signature GLOBAL (dummy pero XSD-compatible) ----------
    signature = ET.SubElement(envio, f"{DS}Signature")

    signed_info = ET.SubElement(signature, f"{DS}SignedInfo")
    ET.SubElement(
        signed_info,
        f"{DS}CanonicalizationMethod",
        Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315",
    )
    ET.SubElement(
        signed_info,
        f"{DS}SignatureMethod",
        Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1",
    )

    ref = ET.SubElement(signed_info, f"{DS}Reference", URI="")
    ET.SubElement(
        ref,
        f"{DS}DigestMethod",
        Algorithm="http://www.w3.org/2000/09/xmldsig#sha1",
    )
    # base64 dummy válido
    ET.SubElement(ref, f"{DS}DigestValue").text = "AA=="

    ET.SubElement(signature, f"{DS}SignatureValue").text = "AA=="

    key_info = ET.SubElement(signature, f"{DS}KeyInfo")
    x509 = ET.SubElement(key_info, f"{DS}X509Data")
    ET.SubElement(x509, f"{DS}X509Certificate").text = "AA=="

    # ---------- Serializar ----------
    envio_bytes = ET.tostring(envio, encoding="iso-8859-1", xml_declaration=True)
    return envio_bytes.decode("iso-8859-1")


def send_envio_dte_dummy(envio_xml: str) -> str:
    """
    Dummy de envío al SII:
    - NO hace HTTP
    - Solo genera un track_id ficticio basado en UUID
    """
    fake_track_id = "DUMMY-" + uuid.uuid4().hex[:10].upper()
    return fake_track_id

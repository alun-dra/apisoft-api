# app/services/xml_validator.py
from lxml import etree
from pathlib import Path

BASE_PATH = Path(__file__).resolve().parent.parent / "sii_schemas"

def load_schema(name: str) -> etree.XMLSchema:
    """Carga un archivo XSD desde /sii_schemas y devuelve el XMLSchema compilado."""
    xsd_path = BASE_PATH / name
    with open(xsd_path, "rb") as f:
        xmlschema_doc = etree.parse(f)
    return etree.XMLSchema(xmlschema_doc)


def validate_xml(xml_str: str, schema_name: str) -> list[str]:
    """
    Valida un XML string contra un XSD por nombre
    Devuelve una lista de errores (vacía si está OK)
    """
    try:
        schema = load_schema(schema_name)
        xml_doc = etree.fromstring(xml_str.encode("iso-8859-1"))
        schema.validate(xml_doc)
        errors = [str(e) for e in schema.error_log]
        return errors
    except Exception as e:
        return [f"Exception: {e}"]


def validate_dte(xml_str: str) -> list[str]:
    """Valida el DTE usando DTE_v10.xsd"""
    return validate_xml(xml_str, "DTE_v10.xsd")


def validate_enviodte(xml_str: str) -> list[str]:
    """Valida el EnvioDTE usando EnvioDTE_v10.xsd"""
    return validate_xml(xml_str, "EnvioDTE_v10.xsd")

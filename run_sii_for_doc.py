# run_sii_for_doc.py
from app.services.sii_client import process_document_send_to_sii

if __name__ == "__main__":
    # cambia 11 por el id del documento que quieras procesar
    process_document_send_to_sii(11)
    print("Listo, procesado process_document_send_to_sii(11)")

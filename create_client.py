import secrets

from app.db.session import SessionLocal, Base, engine
from app.models.client import Client          # 👈 minúsculas
from app.models.emitter import Emitter        # solo para registrar la clase
from app.models.document import Document, DocumentItem
from app.models.log_event import LogEvent


# Solo por si aún no existen las tablas
Base.metadata.create_all(bind=engine)


def create_client(name: str, email: str) -> Client:
    db = SessionLocal()
    try:
        api_key = secrets.token_urlsafe(32)

        client = Client(
            name=name,
            contact_email=email,
            api_key=api_key,
            is_active=True,
        )
        db.add(client)
        db.commit()
        db.refresh(client)

        print("✅ Client created:")
        print(f"  ID: {client.id}")
        print(f"  Name: {client.name}")
        print(f"  Email: {client.contact_email}")
        print("")
        print("⚠️ API KEY (guárdala bien, no se vuelve a mostrar):")
        print(api_key)
        print("")

        return client
    finally:
        db.close()


if __name__ == "__main__":
    name = input("Nombre del cliente: ").strip()
    email = input("Email de contacto: ").strip()
    create_client(name, email)

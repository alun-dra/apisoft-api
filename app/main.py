# app/main.py
from fastapi import FastAPI
from fastapi.openapi.utils import get_openapi
from fastapi.middleware.cors import CORSMiddleware  # 👈 NUEVO

from app.api.v1.routes_documents import router as documents_router
from app.api.v1.routes_emitters import router as emitters_router
from app.api.v1.routes_caf import router as caf_router
from app.api.v1.routes_auth import router as auth_router
from app.api.v1.routes_audit import router as audit_router
from app.api.v1.routes_incoming_documents import router as incoming_documents_router

from app.db.session import Base, engine
from app.core.config import get_settings

# 👇 IMPORTA TODOS LOS MODELOS PARA QUE SQLALCHEMY REGISTRE LAS TABLAS
import app.models  # noqa: F401

settings = get_settings()

# 👇 CREA TODAS LAS TABLAS (incluyendo users)
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.app_name,
    debug=settings.debug,
)

# =======================
# CORS
# =======================
origins = [str(o) for o in settings.backend_cors_origins]

# Si no hay nada configurado en el .env, en desarrollo dejamos "*"
if not origins:
    origins = ["*"]

# Si alguien puso "*" explícito, normalizamos
if "*" in origins:
    origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =======================
# OPENAPI + API KEY
# =======================
def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema

    openapi_schema = get_openapi(
        title=settings.app_name,
        version="1.0.0",
        description="Microservicio de Facturación SII",
        routes=app.routes,
    )

    # 👉 Definimos el esquema de seguridad ApiKeyAuth
    openapi_schema["components"]["securitySchemes"] = {
        "ApiKeyAuth": {
            "type": "apiKey",
            "name": settings.api_key_header_name,  # X-API-Key
            "in": "header",
        }
    }

    # 👉 Por defecto todos los endpoints requieren ApiKeyAuth,
    #    EXCEPTO los de /api/v1/auth/*
    for path, methods in openapi_schema["paths"].items():
        if path.startswith("/api/v1/auth"):
            for method in methods:
                methods[method].pop("security", None)
            continue

        for method in methods:
            methods[method]["security"] = [{"ApiKeyAuth": []}]

    app.openapi_schema = openapi_schema
    return app.openapi_schema


app.openapi = custom_openapi


@app.get("/health")
def health_check():
    return {"status": "ok"}


# Routers
app.include_router(auth_router, prefix="/api/v1")
app.include_router(audit_router, prefix="/api/v1")
app.include_router(incoming_documents_router, prefix="/api/v1")
app.include_router(emitters_router, prefix="/api/v1")
app.include_router(documents_router, prefix="/api/v1")
app.include_router(caf_router, prefix="/api/v1")

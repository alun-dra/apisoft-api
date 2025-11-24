from fastapi import FastAPI
from fastapi.openapi.utils import get_openapi

from app.api.v1.routes_documents import router as documents_router
from app.api.v1.routes_emitters import router as emitters_router
from app.api.v1.routes_caf import router as caf_router  # 👈 NUEVO
from app.db.session import Base, engine
from app.core.config import get_settings

settings = get_settings()

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.app_name,
    debug=settings.debug,
)


# 🔥 AQUI AGREGAMOS EL ESQUEMA DE API KEY PARA SWAGGER
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

    # 👉 Hacemos que TODOS los endpoints requieran ApiKeyAuth
    for path in openapi_schema["paths"]:
        for method in openapi_schema["paths"][path]:
            openapi_schema["paths"][path][method]["security"] = [{"ApiKeyAuth": []}]

    app.openapi_schema = openapi_schema
    return app.openapi_schema


# ⚡ ACTUALIZAR OPENAPI EN LA APP
app.openapi = custom_openapi


@app.get("/health")
def health_check():
    return {"status": "ok"}


# Routers
app.include_router(emitters_router, prefix="/api/v1")
app.include_router(documents_router, prefix="/api/v1")
app.include_router(caf_router, prefix="/api/v1")  
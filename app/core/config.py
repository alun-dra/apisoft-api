# app/core/config.py
from functools import lru_cache
from typing import List

from pydantic_settings import BaseSettings
from pydantic import AnyHttpUrl


class Settings(BaseSettings):
    app_name: str = "SII Microservice"
    environment: str = "local"
    debug: bool = True

    # ============================
    # DATABASE SETTINGS
    # ============================
    db_host: str
    db_port: int = 5432
    db_name: str
    db_user: str
    db_password: str

    api_key_header_name: str = "X-API-Key"

    # ============================
    # CERTIFICADOS Y SII
    # ============================
    sii_cert_pfx_path: str | None = None
    sii_cert_pfx_password: str | None = None

    caf_private_key_path: str | None = None
    caf_private_key_password: str | None = None

    enable_real_signature: bool = False

    sii_rut_envia: str | None = None
    sii_rut_receptor: str = "60803000-K"
    sii_fch_resol: str | None = None
    sii_nro_resol: int | None = None

    # ============================
    # JWT CONFIG
    # ============================
    jwt_secret_key: str = "CAMBIA_ESTA_CLAVE_SUPER_SECRETA"
    jwt_algorithm: str = "HS256"
    jwt_access_token_expire_minutes: int = 60

    # ============================
    # CORS CONFIG (PARA EL FRONTEND)
    # ============================
    # En el .env puedes poner:
    # BACKEND_CORS_ORIGINS=http://localhost:4200,http://localhost:5173
    backend_cors_origins: List[AnyHttpUrl] = []

    # ============================
    # DB URL BUILDER
    # ============================
    @property
    def database_url(self) -> str:
        return (
            f"postgresql+psycopg://{self.db_user}:"
            f"{self.db_password}@{self.db_host}:"
            f"{self.db_port}/{self.db_name}"
        )

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


@lru_cache
def get_settings() -> Settings:
    return Settings()

# app/core/config.py
from functools import lru_cache
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_name: str = "SII Microservice"
    environment: str = "local"
    debug: bool = True

    # DB
    db_host: str
    db_port: int = 5432
    db_name: str
    db_user: str
    db_password: str

    api_key_header_name: str = "X-API-Key"

    # Certificado .pfx para firma TED / EnvioDTE
    sii_cert_pfx_path: str | None = None   # SII_CERT_PFX_PATH
    sii_cert_pfx_password: str | None = None  # SII_CERT_PFX_PASSWORD

    # (opcionales por ahora)
    caf_private_key_path: str | None = None
    caf_private_key_password: str | None = None

    # Activar firma real del TED
    enable_real_signature: bool = False  # ENABLE_REAL_SIGNATURE

    # Datos para EnvioDTE
    sii_rut_envia: str | None = None        # SII_RUT_ENVIA
    sii_rut_receptor: str = "60803000-K"    # SII_RUT_RECEPTOR
    sii_fch_resol: str | None = None        # SII_FCH_RESOL
    sii_nro_resol: int | None = None        # SII_NRO_RESOL

    # 🔐 JWT
    jwt_secret_key: str = "CAMBIA_ESTA_CLAVE_SUPER_SECRETA"
    jwt_algorithm: str = "HS256"
    jwt_access_token_expire_minutes: int = 60

    # 👉 URL de la base de datos para SQLAlchemy
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

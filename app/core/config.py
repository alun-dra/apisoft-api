from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    app_name: str = "SII Microservice"
    environment: str = "local"
    debug: bool = True

    db_host: str
    db_port: int = 5432
    db_name: str
    db_user: str
    db_password: str

    api_key_header_name: str = "X-API-Key"

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

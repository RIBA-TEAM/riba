"""Application configuration."""
import os
from typing import Optional

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings."""

    # Application
    app_name: str = "RIBA API"
    app_version: str = "1.0.0"
    debug: bool = os.getenv("DEBUG", "False") == "True"

    # API
    api_prefix: str = "/api/v1"
    
    # Database
    firebase_project_id: Optional[str] = os.getenv("FIREBASE_PROJECT_ID")
    firebase_api_key: Optional[str] = os.getenv("FIREBASE_API_KEY")

    # External Services
    n8n_base_url: str = os.getenv("N8N_BASE_URL", "http://localhost:5678")
    n8n_api_key: Optional[str] = os.getenv("N8N_API_KEY")
    
    llm_api_key: Optional[str] = os.getenv("LLM_API_KEY")
    llm_model: str = os.getenv("LLM_MODEL", "gpt-3.5-turbo")

    # Server
    host: str = "0.0.0.0"
    port: int = 8000

    class Config:
        """Configuration."""

        env_file = ".env"
        case_sensitive = False


settings = Settings()

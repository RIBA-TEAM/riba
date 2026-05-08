"""RIBA Backend Application."""
import logging
import os
from pathlib import Path

import firebase_admin
from dotenv import load_dotenv
from firebase_admin import credentials

logger = logging.getLogger(__name__)


def _load_env_file() -> None:
    """`.env` dosyasını birkaç olası konumdan yükle.

    Aranacak yerler (ilk bulunan kazanır):
    1. Mevcut çalışma dizini       (uvicorn'un çalıştığı dizin)
    2. backend/.env                (`backend` klasöründen çalıştırılınca)
    3. <repo_root>/.env            (üst dizin – bu dosyaya göre)
    """
    here = Path(__file__).resolve()
    candidates = [
        Path.cwd() / ".env",
        here.parent.parent / ".env",       # backend/.env
        here.parent.parent.parent / ".env",  # repo_root/.env
    ]
    for candidate in candidates:
        if candidate.is_file():
            load_dotenv(dotenv_path=candidate, override=False)
            logger.info("Loaded environment from %s", candidate)
            return
    logger.warning(
        "No .env file found in: %s",
        ", ".join(str(c) for c in candidates),
    )


_load_env_file()


# Initialize Firebase
try:
    if not firebase_admin._apps:
        cred_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
        # Path'in çevresindeki olası tırnakları temizle.
        if cred_path:
            cred_path = cred_path.strip().strip('"').strip("'")
        if cred_path and os.path.exists(cred_path):
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred)
            logger.info("Firebase initialized with credentials file: %s", cred_path)
        else:
            firebase_admin.initialize_app()
            logger.info("Firebase initialized with default credentials")
except Exception as e:  # noqa: BLE001
    logger.warning("Firebase initialization warning: %s", e)

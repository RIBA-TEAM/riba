"""V1 API router - registers all v1 endpoints."""
from fastapi import APIRouter

from app.api.v1.endpoints import auth, chat, observation, risk, teacher_panel

router = APIRouter()

# Include endpoint routers
router.include_router(auth.router, prefix="/auth", tags=["auth"])
router.include_router(chat.router, prefix="/chat", tags=["chat"])
router.include_router(observation.router, prefix="/observation", tags=["observation"])
router.include_router(risk.router, prefix="/risk", tags=["risk"])
router.include_router(
    teacher_panel.router, prefix="/teacher-panel", tags=["teacher-panel"]
)

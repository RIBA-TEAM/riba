"""Chat endpoints."""
import logging
from typing import List, Optional

from fastapi import APIRouter
from pydantic import BaseModel, Field

from app.integrations.llm_client import LLMClient

router = APIRouter()
logger = logging.getLogger(__name__)
llm_client = LLMClient()


class HistoryTurn(BaseModel):
    """Tek bir konuşma turu."""

    role: str = Field(..., description="'user' veya 'bot'")
    text: str


class MessageRequest(BaseModel):
    """Öğrenciden gelen sohbet mesajı."""

    text: str = Field(..., description="Öğrencinin yazdığı mesaj")
    mood: Optional[str] = Field(
        None, description="Seçili duygu durumu (örn. 'kaygılı', 'mutlu')"
    )
    history: Optional[List[HistoryTurn]] = Field(
        default=None, description="Önceki turlar (son 10 tane gönderilebilir)"
    )


@router.get("/")
async def get_chats():
    """Get all chats."""
    return {"message": "Get chats endpoint", "chats": []}


@router.post("/")
async def create_chat(message: str):
    """Create new chat."""
    return {"message": "Create chat endpoint", "chat_id": "123"}


@router.get("/{chat_id}")
async def get_chat(chat_id: str):
    """Get chat by ID."""
    return {"message": "Get chat endpoint", "chat_id": chat_id, "messages": []}


@router.post("/{chat_id}/message")
async def send_message(chat_id: str, request: MessageRequest):
    """Öğrenci mesajı + mood -> RIBA cevabı."""
    try:
        user_text = (request.text or "").strip()
        if not user_text:
            return {
                "success": False,
                "chat_id": chat_id,
                "error": "Mesaj boş olamaz.",
            }

        mood = request.mood.strip() if request.mood else None
        history = (
            [turn.model_dump() for turn in request.history]
            if request.history
            else None
        )

        logger.info(
            "Chat %s | mood=%s | msg=%r", chat_id, mood, user_text[:120]
        )

        reply = llm_client.reply_to_student(
            student_message=user_text,
            mood=mood,
            history=history,
        )

        return {
            "success": True,
            "chat_id": chat_id,
            "user_message": user_text,
            "mood": mood,
            "reply": reply,
            "bot_response": reply,  # geriye uyumluluk
        }
    except Exception as e:  # noqa: BLE001
        logger.exception("Error in send_message: %s", e)
        return {
            "success": False,
            "chat_id": chat_id,
            "error": str(e),
        }

"""Chat endpoints."""
from fastapi import APIRouter

router = APIRouter()


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
    return {"message": "Get chat endpoint", "chat_id": chat_id}


@router.post("/{chat_id}/message")
async def send_message(chat_id: str, text: str):
    """Send message in chat."""
    return {"message": "Message sent", "chat_id": chat_id}

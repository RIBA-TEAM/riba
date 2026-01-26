"""Authentication endpoints."""
from fastapi import APIRouter

router = APIRouter()


@router.post("/login")
async def login(username: str, password: str):
    """Login endpoint."""
    return {"message": "Login endpoint", "username": username}


@router.post("/logout")
async def logout():
    """Logout endpoint."""
    return {"message": "Logout endpoint"}


@router.post("/register")
async def register(username: str, email: str, password: str):
    """Register endpoint."""
    return {"message": "Register endpoint", "username": username}

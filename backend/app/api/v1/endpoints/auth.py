"""Authentication endpoints."""
import logging
from datetime import datetime
from typing import Optional

from fastapi import APIRouter
from firebase_admin import firestore
from pydantic import BaseModel

router = APIRouter()
logger = logging.getLogger(__name__)

# Initialize Firestore
try:
    db = firestore.client()
except Exception as e:
    logger.error(f"Failed to initialize Firestore: {str(e)}")
    db = None


class LoginRequest(BaseModel):
    """Request model for login."""
    email: str
    password: str
    role: str = "student"  # student, teacher, parent
    user_type: Optional[str] = None  # Temporary backward compatibility


class RegisterRequest(BaseModel):
    """Request model for registration."""
    email: str
    password: str
    full_name: str
    role: Optional[str] = None
    user_type: Optional[str] = None  # Temporary backward compatibility


class LoginResponse(BaseModel):
    """Response model for login."""
    success: bool
    user_id: str = None
    role: str = None
    full_name: str = None
    message: str = None


def _resolve_role(role: Optional[str], user_type: Optional[str]) -> str:
    """Resolve role from role/user_type fields during transition."""
    resolved = (role or user_type or "student").strip().lower()
    return resolved


@router.post("/login", response_model=LoginResponse)
async def login(request: LoginRequest):
    """Login endpoint - authenticate user from Firestore."""
    try:
        if not db:
            return LoginResponse(
                success=False,
                message="Database not available"
            )
        
        requested_role = _resolve_role(request.role, request.user_type)
        logger.info(f"Login attempt for: {request.email} ({requested_role})")
        
        user_doc = None
        user_data = None
        
        # Query Firestore based on role
        if requested_role == "student":
            # For students, search in 'students' collection by school_no
            students_ref = db.collection("students")
            query = students_ref.where("school_no", "==", request.email)
            docs = query.stream()
            
            for doc in docs:
                user_doc = doc
                break
        else:
            # For teacher/parent, search in 'users' collection by email
            users_ref = db.collection("users")
            query = users_ref.where("email", "==", request.email).where(
                "role", "==", requested_role
            )
            docs = query.stream()

            for doc in docs:
                user_doc = doc
                break

            # Backward-compatible fallback for pre-migration documents.
            if not user_doc:
                legacy_query = users_ref.where("email", "==", request.email).where(
                    "user_type", "==", requested_role
                )
                docs = legacy_query.stream()
                for doc in docs:
                    user_doc = doc
                    # Backfill role during login for smooth migration.
                    doc.reference.update({"role": requested_role})
                    break
        
        if not user_doc:
            logger.warning(f"User not found: {request.email} ({requested_role})")
            return LoginResponse(
                success=False,
                message="Invalid credentials or user type"
            )
        
        user_data = user_doc.to_dict()
        
        # Simple password check (in production, use bcrypt or similar)
        if user_data.get("password") != request.password:
            logger.warning(f"Wrong password for: {request.email}")
            return LoginResponse(
                success=False,
                message="Invalid password"
            )
        
        # Update last login
        user_doc.reference.update({"last_login": datetime.now().isoformat()})
        
        logger.info(f"Login successful for: {request.email}")
        
        return LoginResponse(
            success=True,
            user_id=user_doc.id,
            role=requested_role,
            full_name=user_data.get("full_name") or user_data.get("name"),
            message="Login successful"
        )
    
    except Exception as e:
        logger.error(f"Login error: {str(e)}")
        return LoginResponse(
            success=False,
            message=f"Error: {str(e)}"
        )


@router.post("/logout")
async def logout():
    """Logout endpoint."""
    try:
        logger.info("Logout successful")
        return {
            "success": True,
            "message": "Logout successful"
        }
    except Exception as e:
        logger.error(f"Logout error: {str(e)}")
        return {
            "success": False,
            "message": f"Error: {str(e)}"
        }


@router.post("/register")
async def register(request: RegisterRequest):
    """Register endpoint - create new user in Firestore."""
    try:
        if not db:
            return {
                "success": False,
                "message": "Database not available"
            }
        
        requested_role = _resolve_role(request.role, request.user_type)
        logger.info(f"Registration attempt for: {request.email} ({requested_role})")
        
        # Check if user already exists
        users_ref = db.collection("users")
        query = users_ref.where("email", "==", request.email)
        docs = list(query.stream())
        
        if docs:
            logger.warning(f"User already exists: {request.email}")
            return {
                "success": False,
                "message": "Email already registered"
            }
        
        # Create new user
        user_data = {
            "email": request.email,
            "password": request.password,  # In production, hash this!
            "full_name": request.full_name,
            "role": requested_role,
            "created_at": datetime.now().isoformat(),
            "status": "active"
        }
        
        doc_ref = db.collection("users").document()
        doc_ref.set(user_data)
        
        logger.info(f"User registered successfully: {request.email}")
        
        return {
            "success": True,
            "user_id": doc_ref.id,
            "message": "Registration successful"
        }
    
    except Exception as e:
        logger.error(f"Registration error: {str(e)}")
        return {
            "success": False,
            "message": f"Error: {str(e)}"
        }

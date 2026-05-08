"""Observation endpoints."""
import logging
from fastapi import APIRouter
from pydantic import BaseModel
from datetime import datetime
import firebase_admin
from firebase_admin import firestore

router = APIRouter()
logger = logging.getLogger(__name__)

# Initialize Firestore
try:
    db = firestore.client()
    logger.info("Firestore client initialized successfully")
except Exception as e:
    logger.error(f"Failed to initialize Firestore: {str(e)}")
    db = None

OBSERVATIONS_COLLECTION = "observations"


class ObservationRequest(BaseModel):
    """Request model for creating observations.

    Schema kept aligned with the Flutter `observation_entry_screen.dart`
    so that records written via the API are visible in the parent
    messages screen (which filters on `parent_id`).
    """
    student_id: str
    teacher_id: str
    observation_type: str  # "behavioral", "academic", "emotional"
    notes: str
    date: str = None
    risk_factors: list = []
    # Optional fields used by the Flutter client / parent UI
    parent_id: str = None
    title: str = None
    message: str = None
    behavior: str = None
    academic: str = None
    risk_level: str = None  # "low" | "medium" | "high"
    source: str = "guidance"


class ObservationUpdate(BaseModel):
    """Request model for updating observations."""
    notes: str = None
    risk_factors: list = None
    status: str = None


@router.get("/")
async def get_observations(student_id: str = None, teacher_id: str = None):
    """Get all observations, optionally filtered by student or teacher."""
    try:
        if not db:
            return {"success": False, "error": "Database not available"}
        
        query = db.collection(OBSERVATIONS_COLLECTION)
        
        if student_id:
            query = query.where("student_id", "==", student_id)
        
        if teacher_id:
            query = query.where("teacher_id", "==", teacher_id)
        
        docs = query.stream()
        observations = []
        
        for doc in docs:
            obs = doc.to_dict()
            obs["id"] = doc.id
            observations.append(obs)
        
        logger.info(f"Retrieved {len(observations)} observations")
        return {
            "success": True,
            "observations": observations,
            "count": len(observations)
        }
    except Exception as e:
        logger.error(f"Error getting observations: {str(e)}")
        return {
            "success": False,
            "error": str(e)
        }


@router.post("/")
async def create_observation(request: ObservationRequest):
    """Create new observation."""
    try:
        if not db:
            return {"success": False, "error": "Database not available"}
        
        now_iso = datetime.now().isoformat()
        observation = {
            "student_id": request.student_id,
            "teacher_id": request.teacher_id,
            "observation_type": request.observation_type,
            "notes": request.notes,
            "note": request.notes,  # alias used by parent UI
            "risk_factors": request.risk_factors,
            "date": request.date or now_iso,
            "created_at": now_iso,
            "status": "active",
            # Fields needed by the parent-side messages stream
            "parent_id": request.parent_id,
            "title": request.title,
            "message": request.message or request.notes,
            "behavior": request.behavior,
            "academic": request.academic,
            "risk_level": request.risk_level,
            "source": request.source or "guidance",
        }
        
        doc_ref = db.collection(OBSERVATIONS_COLLECTION).add(observation)
        obs_id = doc_ref[1].id
        
        logger.info(f"Created observation: {obs_id}")
        
        return {
            "success": True,
            "observation_id": obs_id,
            "observation": observation
        }
    except Exception as e:
        logger.error(f"Error creating observation: {str(e)}")
        return {
            "success": False,
            "error": str(e)
        }


@router.get("/{observation_id}")
async def get_observation(observation_id: str):
    """Get observation by ID."""
    try:
        if not db:
            return {"success": False, "error": "Database not available"}
        
        doc = db.collection(OBSERVATIONS_COLLECTION).document(observation_id).get()
        
        if not doc.exists:
            return {
                "success": False,
                "error": f"Observation {observation_id} not found"
            }
        
        observation = doc.to_dict()
        observation["id"] = doc.id
        
        logger.info(f"Retrieved observation: {observation_id}")
        
        return {
            "success": True,
            "observation": observation
        }
    except Exception as e:
        logger.error(f"Error getting observation: {str(e)}")
        return {
            "success": False,
            "error": str(e)
        }


@router.put("/{observation_id}")
async def update_observation(observation_id: str, request: ObservationUpdate):
    """Update observation."""
    try:
        if not db:
            return {"success": False, "error": "Database not available"}
        
        doc_ref = db.collection(OBSERVATIONS_COLLECTION).document(observation_id)
        
        if not doc_ref.get().exists:
            return {
                "success": False,
                "error": f"Observation {observation_id} not found"
            }
        
        update_data = {"updated_at": datetime.now().isoformat()}
        
        if request.notes:
            update_data["notes"] = request.notes
        if request.risk_factors:
            update_data["risk_factors"] = request.risk_factors
        if request.status:
            update_data["status"] = request.status
        
        doc_ref.update(update_data)
        
        logger.info(f"Updated observation: {observation_id}")
        
        return {
            "success": True,
            "message": "Observation updated"
        }
    except Exception as e:
        logger.error(f"Error updating observation: {str(e)}")
        return {
            "success": False,
            "error": str(e)
        }


@router.delete("/{observation_id}")
async def delete_observation(observation_id: str):
    """Delete observation."""
    try:
        if not db:
            return {"success": False, "error": "Database not available"}
        
        doc_ref = db.collection(OBSERVATIONS_COLLECTION).document(observation_id)
        
        if not doc_ref.get().exists:
            return {
                "success": False,
                "error": f"Observation {observation_id} not found"
            }
        
        doc_ref.delete()
        
        logger.info(f"Deleted observation: {observation_id}")
        
        return {
            "success": True,
            "message": "Observation deleted"
        }
    except Exception as e:
        logger.error(f"Error deleting observation: {str(e)}")
        return {
            "success": False,
            "error": str(e)
        }

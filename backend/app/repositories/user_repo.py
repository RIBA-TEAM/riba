"""User repository for user data operations."""
import logging

logger = logging.getLogger(__name__)


class UserRepository:
    """Repository for user data operations."""

    def __init__(self, firestore_repo):
        """Initialize user repository."""
        self.firestore_repo = firestore_repo
        logger.info("Initializing User repository")

    async def create_user(self, user_data: dict) -> str:
        """Create new user."""
        logger.info("Creating user")
        return await self.firestore_repo.create("users", user_data)

    async def get_user(self, user_id: str) -> dict:
        """Get user by ID."""
        logger.info(f"Getting user {user_id}")
        return await self.firestore_repo.read("users", user_id)

    async def update_user(self, user_id: str, user_data: dict) -> bool:
        """Update user."""
        logger.info(f"Updating user {user_id}")
        return await self.firestore_repo.update("users", user_id, user_data)

    async def delete_user(self, user_id: str) -> bool:
        """Delete user."""
        logger.info(f"Deleting user {user_id}")
        return await self.firestore_repo.delete("users", user_id)

    async def list_users(self) -> list:
        """List all users."""
        logger.info("Listing all users")
        return await self.firestore_repo.list("users")

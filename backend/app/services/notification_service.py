"""Notification service for sending notifications."""
import logging

logger = logging.getLogger(__name__)


class NotificationService:
    """Service for sending notifications to users."""

    @staticmethod
    def send_email(recipient: str, subject: str, body: str) -> bool:
        """Send email notification."""
        logger.info(f"Sending email to {recipient}")
        return True

    @staticmethod
    def send_push_notification(user_id: str, message: str) -> bool:
        """Send push notification."""
        logger.info(f"Sending push notification to {user_id}")
        return True

    @staticmethod
    def send_sms(phone: str, message: str) -> bool:
        """Send SMS notification."""
        logger.info(f"Sending SMS to {phone}")
        return True

"""NLP service for natural language processing."""
import logging
from typing import Dict, List

logger = logging.getLogger(__name__)


class NLPService:
    """Service for natural language processing tasks."""

    # Keywords associated with different risk factors
    RISK_KEYWORDS = {
        "aggressive_behavior": [
            "aggressive", "violence", "fighting", "hitting", "kicking",
            "threatening", "assault", "conflict", "angry", "rage"
        ],
        "withdrawal": [
            "withdrawn", "isolated", "quiet", "antisocial", "lonely",
            "alone", "avoid", "distant", "detached", "socially withdrawn"
        ],
        "poor_grades": [
            "failing", "failing grades", "low grades", "academic struggle",
            "not concentrating", "not understanding", "behind"
        ],
        "truancy": [
            "absent", "skipping", "truancy", "not attending", "missing class",
            "absent from school", "cutting class"
        ],
        "peer_conflicts": [
            "bullying", "bullied", "bullies", "peer conflict", "friend conflict",
            "social problems", "doesn't get along"
        ],
        "substance_abuse": [
            "drugs", "alcohol", "smoking", "substance", "addiction",
            "intoxicated", "high", "using"
        ],
        "self_harm_indicators": [
            "self-harm", "self harm", "cutting", "hurts self", "scratching",
            "injury", "wounds", "marks on arms"
        ],
        "suicidal_ideation": [
            "suicidal", "suicide", "want to die", "don't want to live",
            "kill myself", "end it", "better off dead", "no point"
        ],
    }

    @staticmethod
    def analyze_sentiment(text: str) -> Dict:
        """
        Analyze sentiment of given text.
        Returns: positive, negative, or neutral
        """
        try:
            if not text:
                logger.warning("Empty text provided for sentiment analysis")
                return {"sentiment": "neutral", "score": 0.0}

            text_lower = text.lower()

            # Simple keyword-based sentiment analysis
            negative_words = [
                "sad", "angry", "depressed", "anxious", "worried", "scared",
                "hate", "terrible", "horrible", "awful", "bad", "worst",
                "useless", "failure", "stupid", "worthless"
            ]

            positive_words = [
                "happy", "good", "great", "excellent", "love", "wonderful",
                "amazing", "fantastic", "awesome", "best", "proud", "grateful"
            ]

            negative_count = sum(1 for word in negative_words if word in text_lower)
            positive_count = sum(1 for word in positive_words if word in text_lower)

            if negative_count > positive_count:
                sentiment = "negative"
                score = min(1.0, negative_count / 10.0)
            elif positive_count > negative_count:
                sentiment = "positive"
                score = min(1.0, positive_count / 10.0)
            else:
                sentiment = "neutral"
                score = 0.5

            logger.info(f"Sentiment analysis: {sentiment} (score: {score:.2f})")

            return {
                "sentiment": sentiment,
                "score": score,
                "explanation": f"Text contains {negative_count} negative and {positive_count} positive indicators"
            }

        except Exception as e:
            logger.error(f"Error in sentiment analysis: {str(e)}")
            return {"sentiment": "error", "score": 0.0, "error": str(e)}

    @staticmethod
    def extract_risk_factors(text: str) -> Dict:
        """
        Extract risk factors from text based on keyword matching.
        Returns detected risk factors and their confidence scores.
        """
        try:
            if not text:
                logger.warning("Empty text provided for risk factor extraction")
                return {"detected_factors": [], "risk_factors": {}}

            text_lower = text.lower()
            detected_factors = []
            risk_factors = {}

            for factor, keywords in NLPService.RISK_KEYWORDS.items():
                matches = sum(1 for keyword in keywords if keyword in text_lower)
                if matches > 0:
                    confidence = min(1.0, matches / 3.0)  # Normalize to 0-1
                    detected_factors.append(factor)
                    risk_factors[factor] = {
                        "matches": matches,
                        "confidence": confidence
                    }

            logger.info(
                f"Extracted risk factors: {detected_factors} "
                f"(total: {len(detected_factors)})"
            )

            return {
                "detected_factors": detected_factors,
                "risk_factors": risk_factors,
                "total_risk_factors": len(detected_factors)
            }

        except Exception as e:
            logger.error(f"Error extracting risk factors: {str(e)}")
            return {"detected_factors": [], "error": str(e)}

    @staticmethod
    def extract_entities(text: str) -> List[Dict]:
        """Extract entities from text."""
        try:
            if not text:
                logger.warning("Empty text provided for entity extraction")
                return []

            entities = []
            # Simple pattern matching for common entities
            
            # This would be enhanced with more sophisticated NLP
            logger.info(f"Extracted entities from text")

            return entities

        except Exception as e:
            logger.error(f"Error extracting entities: {str(e)}")
            return []

    @staticmethod
    def classify_text(text: str, high_risk_only: bool = False) -> Dict:
        """
        Classify text into categories and optionally filter by risk level.
        
        Args:
            text: Text to classify
            high_risk_only: If True, only return if text indicates high risk
        """
        try:
            if not text:
                logger.warning("Empty text provided for classification")
                return {"category": "empty", "risk_level": "none"}

            # Combine sentiment and risk factor analysis
            sentiment_result = NLPService.analyze_sentiment(text)
            risk_result = NLPService.extract_risk_factors(text)

            # Determine risk level
            if len(risk_result.get("detected_factors", [])) >= 2:
                risk_level = "high"
            elif len(risk_result.get("detected_factors", [])) == 1:
                risk_level = "medium"
            else:
                risk_level = "low"

            # If high_risk_only is True, filter out non-high-risk classifications
            if high_risk_only and risk_level != "high":
                return {
                    "category": "filtered",
                    "risk_level": risk_level,
                    "filtered_out": True
                }

            return {
                "category": "classified",
                "risk_level": risk_level,
                "sentiment": sentiment_result.get("sentiment"),
                "detected_factors": risk_result.get("detected_factors", []),
                "confidence": sentiment_result.get("score", 0.0)
            }

        except Exception as e:
            logger.error(f"Error classifying text: {str(e)}")
            return {"category": "error", "error": str(e)}

    @staticmethod
    def analyze_observation_notes(notes: str, filter_high_risk: bool = True) -> Dict:
        """
        Analyze observation notes and optionally filter by high-risk indicators.
        This is the main method for teacher observations.
        """
        try:
            sentiment = NLPService.analyze_sentiment(notes)
            risk_factors = NLPService.extract_risk_factors(notes)
            classification = NLPService.classify_text(notes, high_risk_only=filter_high_risk)

            should_display = True
            if filter_high_risk and classification.get("risk_level") != "high":
                should_display = False

            logger.info(
                f"Analyzed observation notes: "
                f"risk_level={classification.get('risk_level')}, "
                f"should_display={should_display}"
            )

            return {
                "analysis_type": "observation_notes",
                "sentiment": sentiment,
                "risk_factors": risk_factors,
                "classification": classification,
                "should_display_to_counselor": should_display,
                "high_risk_filter_applied": filter_high_risk
            }

        except Exception as e:
            logger.error(f"Error analyzing observation notes: {str(e)}")
            return {"error": str(e)}

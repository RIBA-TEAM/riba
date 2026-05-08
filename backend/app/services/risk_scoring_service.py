"""Risk scoring service for calculating risk scores."""
import logging
from typing import Dict, List

logger = logging.getLogger(__name__)


class RiskScoringService:
    """Service for calculating risk scores based on observations."""

    # Risk factors and their weights
    RISK_FACTORS = {
        "aggressive_behavior": 0.15,
        "withdrawal": 0.12,
        "poor_grades": 0.10,
        "truancy": 0.15,
        "peer_conflicts": 0.10,
        "substance_abuse": 0.18,
        "self_harm_indicators": 0.20,
        "suicidal_ideation": 0.20,  # Highest priority
    }

    @staticmethod
    def calculate_risk_score(observation_data: Dict) -> float:
        """
        Calculate risk score from observation data.
        Score ranges from 0.0 (no risk) to 1.0 (highest risk).
        """
        if not observation_data:
            logger.warning("Empty observation data provided")
            return 0.0

        try:
            total_score = 0.0
            detected_factors = []

            for factor, weight in RiskScoringService.RISK_FACTORS.items():
                if factor in observation_data:
                    # Get the factor value (could be boolean, count, or severity score)
                    factor_value = observation_data.get(factor, 0)
                    
                    if isinstance(factor_value, bool):
                        if factor_value:
                            total_score += weight
                            detected_factors.append(factor)
                    elif isinstance(factor_value, (int, float)):
                        # Normalize to 0-1 range if needed
                        normalized = min(1.0, factor_value)
                        total_score += weight * normalized
                        if factor_value > 0:
                            detected_factors.append(factor)

            # Normalize total score to 0-1 range
            final_score = min(1.0, total_score)
            
            logger.info(
                f"Calculated risk score: {final_score:.2f} "
                f"(factors: {detected_factors})"
            )
            
            return final_score

        except Exception as e:
            logger.error(f"Error calculating risk score: {str(e)}")
            return 0.5  # Default to medium risk on error

    @staticmethod
    def get_risk_level(score: float) -> str:
        """
        Get risk level label from numeric score.
        
        Risk levels:
        - low: 0.0 - 0.33
        - medium: 0.34 - 0.66
        - high: 0.67 - 1.0
        """
        if score < 0.33:
            return "low"
        elif score < 0.67:
            return "medium"
        else:
            return "high"

    @staticmethod
    def assess_multiple(observations: List[Dict]) -> Dict:
        """Assess risk for multiple observations."""
        if not observations:
            logger.warning("No observations provided for multiple assessment")
            return {
                "average_risk": 0.0,
                "max_risk": 0.0,
                "high_risk_count": 0,
                "assessments": []
            }

        try:
            scores = []
            assessments = []

            for obs in observations:
                score = RiskScoringService.calculate_risk_score(obs)
                risk_level = RiskScoringService.get_risk_level(score)
                scores.append(score)
                assessments.append({
                    "score": score,
                    "risk_level": risk_level,
                    "observation": obs
                })

            avg_score = sum(scores) / len(scores) if scores else 0.0
            max_score = max(scores) if scores else 0.0
            high_risk_count = sum(1 for score in scores if score >= 0.67)

            logger.info(
                f"Multiple assessment: avg={avg_score:.2f}, "
                f"max={max_score:.2f}, high_risk={high_risk_count}"
            )

            return {
                "average_risk": avg_score,
                "max_risk": max_score,
                "high_risk_count": high_risk_count,
                "total_observations": len(observations),
                "assessments": assessments
            }

        except Exception as e:
            logger.error(f"Error in multiple assessment: {str(e)}")
            return {
                "error": str(e),
                "average_risk": 0.5,
                "assessments": []
            }

    @staticmethod
    def get_risk_factors_list() -> Dict:
        """Get list of all risk factors and their weights."""
        return {
            "factors": RiskScoringService.RISK_FACTORS,
            "total_weight": sum(RiskScoringService.RISK_FACTORS.values()),
            "description": "Risk factors used in scoring system"
        }

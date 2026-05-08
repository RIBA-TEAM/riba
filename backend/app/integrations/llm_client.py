"""LLM client for Large Language Model integration (RIBA persona)."""
import logging
import os
import httpx
from typing import List, Dict, Optional

logger = logging.getLogger(__name__)


RIBA_SYSTEM_PROMPT = """Sen RIBA isimli bir öğrenci destek asistanısın. Görevin
öğrencilerin duygu durumlarını anlamak, onları yargılamadan dinlemek ve doğal,
samimi, güven veren cevaplar vermektir.

Davranış kuralları:
- Her cevabı öğrencinin mesajına özel üret.
- Asla aynı veya kalıp cevapları tekrar etme.
- Robot gibi konuşma.
- "Seni anlıyorum", "Bu zor olmalı" gibi ifadeleri sürekli tekrar etme.
- Öğrencinin yazdığı detaya göre cevap ver.
- Önce öğrencinin duygusunu anlamaya çalış.
- Sonra kısa ve doğal bir destek ver.
- Gerekirse yalnızca 1 tane açık uçlu soru sor.
- Çok uzun paragraflar yazma (2-4 cümle yeterli).
- Maddeli liste kullanma.
- Öğüt veren öğretmen gibi konuşma.
- Fazla resmi konuşma.
- Samimi ama profesyonel ol.
- Türkçe cevap ver.
- Emoji kullanma.
- Cevaplar gerçek bir gençlik danışmanı gibi doğal hissettirmeli.

Öğrenci üzgünse: duygusunu küçümseme; "Boşver", "takma kafana" deme.
Öğrenci kaygılıysa: sakinleştirici ve güven veren bir ton kullan.
Öğrenci mutluysa: enerjisini destekle ama abartma.
Öğrenci yalnız hissediyorsa: anlaşılmış hissetmesini sağla.

Eğer öğrenci kendine zarar verme, şiddet, taciz, istismar, silah, ölüm isteği
veya ciddi risk içeren bir şey yazarsa: çok sakin ve destekleyici cevap ver,
yargılama yapma, yalnız olmadığını hissettir, güvendiği bir yetişkin / ebeveyn
veya rehber öğretmenle konuşmasını öner ve acil destek istemesinin önemini
nazikçe belirt.

Asla: tanı koyma, terapi yapma, kesin psikolojik yorum yapma, tıbbi tavsiye
verme, kullanıcıyı suçlama, yapay zeka olduğunu gereksiz yere tekrar etme.

Cevap stilin: kısa, doğal, sıcak, kişiselleştirilmiş ve sohbet gibi olmalı.
"""


class LLMClient:
    """Client for Google Gemini (RIBA persona)."""

    def __init__(self) -> None:
        logger.info("Initializing LLM client")
        self.api_key = os.getenv("LLM_API_KEY", "").strip()
        # NOT: gemini-1.5-* modelleri 2025 sonunda emekliye ayrıldı.
        # 2026 itibarıyla aktif olanlar: gemini-2.5-flash / 2.5-pro / 3-* serisi.
        self.model = os.getenv("LLM_MODEL", "gemini-2.5-flash").strip()
        api_version = os.getenv("LLM_API_VERSION", "v1beta").strip() or "v1beta"
        self.api_version = api_version
        self.api_base = "https://generativelanguage.googleapis.com"
        self.api_url = (
            f"{self.api_base}/{api_version}/models/{self.model}:generateContent"
        )
        self.max_tokens = int(os.getenv("LLM_MAX_TOKENS", "300"))
        self.temperature = float(os.getenv("LLM_TEMPERATURE", "0.85"))
        logger.info(
            "LLM endpoint configured: model=%s api_version=%s",
            self.model,
            api_version,
        )

    def reply_to_student(
        self,
        student_message: str,
        mood: Optional[str] = None,
        history: Optional[List[Dict[str, str]]] = None,
    ) -> str:
        """Build prompt with RIBA persona + mood and return Gemini reply.

        history: önceki konuşma turları (opsiyonel)
            [{"role": "user"|"bot", "text": "..."}, ...]
        """
        if not self.api_key:
            logger.warning("LLM_API_KEY not set; returning fallback message")
            return (
                "Şu an asistan tam çalışmıyor (sunucu tarafında API anahtarı "
                "eksik). Yine de yazdıklarını okuyorum, biraz sonra tekrar dener misin?"
            )

        contents = self._build_contents(student_message, mood, history)
        payload = {
            "contents": contents,
            "generationConfig": {
                "maxOutputTokens": self.max_tokens,
                "temperature": self.temperature,
                "topP": 0.9,
            },
            "safetySettings": [
                {
                    "category": "HARM_CATEGORY_HARASSMENT",
                    "threshold": "BLOCK_ONLY_HIGH",
                },
                {
                    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                    "threshold": "BLOCK_ONLY_HIGH",
                },
            ],
        }

        url_with_key = f"{self.api_url}?key={self.api_key}"
        try:
            with httpx.Client(timeout=20.0) as client:
                response = client.post(url_with_key, json=payload)
                response.raise_for_status()
                result = response.json()
        except httpx.HTTPStatusError as e:
            status = e.response.status_code
            body_preview = e.response.text[:300] if e.response is not None else ""
            logger.error("Gemini HTTP %s: %s", status, body_preview)
            if status == 400:
                return "İsteğin bu sefer işlenemedi. Biraz farklı yazıp tekrar dener misin?"
            if status in (401, 403):
                return "Sunucu kimlik doğrulama hatası. Yöneticiye haber vermek iyi olur."
            if status == 404:
                # Geliştirici loguna kullanılabilir modelleri yaz.
                self._log_available_models()
                return (
                    "Yapılandırma hatası: model bulunamadı "
                    "(LLM_MODEL veya LLM_API_VERSION). Sunucu logunda "
                    "kullanılabilir modeller listelendi."
                )
            if status == 429:
                return "Şu an çok yoğunum, biraz sonra tekrar yazar mısın?"
            return "Sunucu cevap veremedi. Biraz sonra tekrar dener misin?"
        except httpx.RequestError as e:
            logger.error("Gemini request error: %s", e)
            return "Bağlantı problemi yaşadım. Biraz sonra tekrar dener misin?"
        except Exception as e:  # noqa: BLE001
            logger.exception("Unexpected error in reply_to_student: %s", e)
            return "Beklenmeyen bir şey oldu. Biraz sonra tekrar dener misin?"

        return self._extract_text(result)

    def _build_contents(
        self,
        student_message: str,
        mood: Optional[str],
        history: Optional[List[Dict[str, str]]],
    ) -> List[Dict]:
        """Gemini `contents` listesi: system + history + son user mesajı."""
        contents: List[Dict] = []

        mood_line = f"Öğrencinin şu anki duygu durumu: {mood}\n" if mood else ""
        contents.append(
            {
                "role": "user",
                "parts": [
                    {
                        "text": (
                            RIBA_SYSTEM_PROMPT
                            + "\n"
                            + mood_line
                            + "Aşağıdaki konuşmayı bu kurallara göre sürdür."
                        )
                    }
                ],
            }
        )
        contents.append(
            {
                "role": "model",
                "parts": [
                    {
                        "text": "Tamam, RIBA olarak sıcak ve doğal şekilde cevap vereceğim."
                    }
                ],
            }
        )

        if history:
            for turn in history[-10:]:
                role = "user" if turn.get("role") == "user" else "model"
                text = (turn.get("text") or "").strip()
                if not text:
                    continue
                contents.append({"role": role, "parts": [{"text": text}]})

        contents.append(
            {"role": "user", "parts": [{"text": student_message}]}
        )
        return contents

    @staticmethod
    def _extract_text(result: Dict) -> str:
        candidates = result.get("candidates") or []
        if not candidates:
            logger.error("Gemini returned no candidates: %s", result)
            return "Şu an cevap üretemedim, tekrar dener misin?"
        content = candidates[0].get("content") or {}
        parts = content.get("parts") or []
        text = "".join(p.get("text", "") for p in parts).strip()
        if not text:
            finish = candidates[0].get("finishReason")
            logger.warning("Gemini empty text. finishReason=%s", finish)
            if finish == "SAFETY":
                return (
                    "Bu konuda sana doğrudan cevap veremiyorum, ama yalnız "
                    "değilsin. Güvendiğin bir yetişkinle ya da rehber "
                    "öğretmeninle konuşmanı çok isterim."
                )
            return "Şu an cevap üretemedim, tekrar dener misin?"
        return text

    def chat_completion(self, messages: List[Dict[str, str]]) -> str:
        """Geriye uyumluluk için: eski kullanım."""
        if not messages:
            return ""
        last = messages[-1]
        return self.reply_to_student(last.get("content", ""))

    def _log_available_models(self) -> None:
        """Kullanılabilir modelleri ListModels ile çekip loga yaz."""
        if not self.api_key:
            return
        try:
            url = f"{self.api_base}/{self.api_version}/models?key={self.api_key}"
            with httpx.Client(timeout=10.0) as client:
                resp = client.get(url)
            if resp.status_code != 200:
                logger.warning(
                    "ListModels failed (%s): %s", resp.status_code, resp.text[:200]
                )
                return
            data = resp.json()
            usable = []
            for m in data.get("models", []):
                methods = m.get("supportedGenerationMethods", []) or []
                if "generateContent" in methods:
                    name = m.get("name", "").replace("models/", "")
                    usable.append(name)
            if usable:
                logger.error(
                    "Bu API anahtarı ile generateContent destekleyen modeller "
                    "(%s):\n  - %s\nÇözüm: .env içindeki LLM_MODEL'i bunlardan "
                    "biriyle değiştir, ardından sunucuyu yeniden başlat.",
                    self.api_version,
                    "\n  - ".join(sorted(usable)),
                )
            else:
                logger.error(
                    "Bu API anahtarı ile generateContent destekleyen model yok."
                )
        except Exception as e:  # noqa: BLE001
            logger.warning("ListModels probe failed: %s", e)

import json
from services.chatbot.redis_client import redis_client

EXPIRE_SECONDS = 3600


def get_conversation_state(conversation_id: str) -> dict:
    key = f"chat:{conversation_id}"
    raw = redis_client.get(key)

    if raw:
        return json.loads(raw)

    return {
        "category": None,
        "price_max": None
    }


def save_conversation_state(conversation_id: str, state: dict):
    key = f"chat:{conversation_id}"
    redis_client.set(key, json.dumps(state), ex=EXPIRE_SECONDS)

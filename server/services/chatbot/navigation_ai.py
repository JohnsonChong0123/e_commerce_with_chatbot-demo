import json
from sqlalchemy.orm import Session
from .gemini_client import client
from models.product import Product
import re
from services.chatbot.redis_state import (
    get_conversation_state,
    save_conversation_state
)

def clean_gemini_json(text: str) -> dict:
    try:
        cleaned = re.sub(r"```(?:json)?", "", text, flags=re.IGNORECASE)
        cleaned = cleaned.strip()
        return json.loads(cleaned)
    except Exception as e:
        raise ValueError(f"Invalid Gemini JSON output: {text}") from e
    
def parse_navigation(
    text: str,
    db: Session,
    conversation_id: str
) -> dict:

    state = get_conversation_state(conversation_id)

    prompt = f"""
You are an E-commerce Conversational Shopping Assistant.

Conversation state:
- category: {state["category"]}
- price_max: {state["price_max"]}

User input:
"{text}"

Rules:
1. If user provides missing info, update it
2. If info still missing, ask ONLY for missing info
3. If all info is ready, intent = search_product
4. Output JSON only

JSON format:
{{
  "intent": "",
  "filters": {{
    "category": null,
    "price_max": null
  }},
  "reply": ""
}}
"""

    result = client.models.generate_content(
        model="",
        contents=
    )

    ai = clean_gemini_json(result.text)
    print(ai)

    if ai["filters"]["category"]:
        state["category"] = ai["filters"]["category"]

    if ai["filters"]["price_max"]:
        state["price_max"] = ai["filters"]["price_max"]

    save_conversation_state(conversation_id, state)

    products = []

    if state["category"] and state["price_max"]:
        query = db.query(Product)

        query = query.filter(
            Product.categories.ilike(f"%{state['category']}%")
        )

        query = query.filter(
            Product.final_prices <= float(state["price_max"])
        )

        results = query.limit(5).all()

        products = [
            {
                "asin": p.asin,
                "title": p.title,
                "final_prices": p.final_prices,
                "image_url": p.image_url,
                "description": p.description,
                "rating": p.rating,
                "reviews_count": p.reviews_count,
                "initial_prices": p.initial_prices,
            }
            for p in results
        ]

    return {
        "reply": ai["reply"],
        "products": products,
        # "state": state
    }





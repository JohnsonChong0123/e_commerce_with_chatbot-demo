from fastapi import APIRouter, Depends
from pydantic import BaseModel
from requests import Session
from database import get_db
from models.product import Product
from services.chatbot.navigation_ai import parse_navigation

router = APIRouter()

class UserPrompt(BaseModel):
    conversation_id: str
    text: str

@router.post("/navigate")
def ai_navigation(body: UserPrompt, db: Session = Depends(get_db)):
    return parse_navigation(body.text, db, body.conversation_id)




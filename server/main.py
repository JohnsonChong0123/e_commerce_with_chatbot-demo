from fastapi import FastAPI
from models.base import Base
from routes import chatbot, product
from database import engine

app = FastAPI()

app.include_router(product.router, prefix="/product")
app.include_router(chatbot.router, prefix="/chatbot")

Base.metadata.create_all(engine)
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from database import get_db
from models.product import Product

router = APIRouter()

@router.get('/allproduct')
def list_product(db: Session = Depends(get_db)):
    products = db.query(Product).all()
    return products
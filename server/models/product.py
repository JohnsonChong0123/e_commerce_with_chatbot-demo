from sqlalchemy import TEXT, VARCHAR, Column, INT, FLOAT
from models.base import Base


class Product(Base):
    __tablename__ = 'product'

    title = Column(TEXT)
    brand = Column(TEXT)
    description = Column(TEXT)
    reviews_count = Column(INT)
    categories = Column(TEXT)
    asin = Column(VARCHAR(20), primary_key=True)
    url = Column(TEXT)
    image_url = Column(TEXT)
    rating = Column(FLOAT)
    top_review = Column(TEXT)
    initial_prices = Column(FLOAT)
    final_prices = Column(FLOAT)
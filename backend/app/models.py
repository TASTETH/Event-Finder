from sqlalchemy import Column, Integer, String, Boolean, Float, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from .database import Base
import datetime

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String, nullable=True)
    age = Column(Integer, nullable=True)
    city = Column(String, nullable=True)
    avatar_url = Column(String, nullable=True)
    rating = Column(Float, default=0.0)
    is_organizer = Column(Boolean, default=False)
    events = relationship("Event", back_populates="owner")

class Event(Base):
    __tablename__ = "events"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True, nullable=False)
    address = Column(String, nullable=False)
    brief_description = Column(String, nullable=False)
    detailed_description = Column(String, nullable=True)
    contact_info = Column(String, nullable=True)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    date = Column(DateTime, default=datetime.datetime.utcnow)
    age_restriction = Column(Boolean, default=False)
    owner_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="events")

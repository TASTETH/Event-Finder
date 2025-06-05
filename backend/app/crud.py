from sqlalchemy.orm import Session
from . import models, schemas, auth
import datetime

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def get_user(db: Session, username: str):
    return db.query(models.User).filter(models.User.username == username).first()

def create_user(db: Session, user: schemas.UserCreate):
    fake_hashed_password = auth.get_password_hash(user.password)
    db_user = models.User(
        email=user.email,
        username=user.username,
        hashed_password=fake_hashed_password,
        full_name=user.full_name,
        age=user.age,
        city=user.city,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def create_event(db: Session, event: schemas.EventCreate, user_id: int):
    db_event = models.Event(
        title=event.title,
        address=event.address,
        brief_description=event.brief_description,
        detailed_description=event.detailed_description,
        contact_info=event.contact_info,
        latitude=event.latitude,
        longitude=event.longitude,
        date=event.date,
        age_restriction=event.age_restriction,
        owner_id=user_id
    )
    db.add(db_event)
    db.commit()
    db.refresh(db_event)
    return db_event

def get_events(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Event).offset(skip).limit(limit).all()

def get_event(db: Session, event_id: int):
    return db.query(models.Event).filter(models.Event.id == event_id).first()

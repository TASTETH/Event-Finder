from pydantic import BaseModel, EmailStr
from typing import Optional
import datetime

class UserCreate(BaseModel):
    email: EmailStr
    username: str
    password: str
    full_name: Optional[str] = None
    age: Optional[int] = None
    city: Optional[str] = None

class UserOut(BaseModel):
    id: int
    email: EmailStr
    username: str
    full_name: Optional[str]
    age: Optional[int]
    city: Optional[str]
    avatar_url: Optional[str]
    rating: float
    is_organizer: bool

    class Config:
        orm_mode = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: Optional[str] = None

class EventBase(BaseModel):
    title: str
    address: str
    brief_description: str
    detailed_description: Optional[str] = None
    contact_info: Optional[str] = None
    latitude: float
    longitude: float
    date: datetime.datetime
    age_restriction: bool

class EventCreate(EventBase):
    pass

class EventOut(EventBase):
    id: int
    owner_id: int

    class Config:
        orm_mode = True

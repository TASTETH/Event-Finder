from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from . import schemas, models, crud, auth, database
from fastapi.security import OAuth2PasswordRequestForm
from typing import List
import uvicorn

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

# Dependency
def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/register", response_model=schemas.UserOut)
def register(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)

@app.post("/token", response_model=schemas.Token)
def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = auth.authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = auth.create_access_token(
        data={"sub": user.username}
    )
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/users/me", response_model=schemas.UserOut)
def read_users_me(current_user: models.User = Depends(auth.get_current_user)):
    return current_user

@app.post("/events/", response_model=schemas.EventOut)
def create_user_event(event: schemas.EventCreate, db: Session = Depends(get_db), current_user: models.User = Depends(auth.get_current_user)):
    return crud.create_event(db=db, event=event, user_id=current_user.id)

@app.get("/events/", response_model=List[schemas.EventOut])
def read_events(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return crud.get_events(db, skip=skip, limit=limit)

@app.get("/events/{event_id}", response_model=schemas.EventOut)
def read_event(event_id: int, db: Session = Depends(get_db)):
    db_event = crud.get_event(db, event_id=event_id)
    if db_event is None:
        raise HTTPException(status_code=404, detail="Event not found")
    return db_event

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)

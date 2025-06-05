import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Ниже должна быть точно та же строка, которую вы проверили в test_db.py:
# Если вы не используете переменную окружения DATABASE_URL, 
# вставьте строку напрямую в кавычках:
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:123@localhost:5432/mobil2"
)

# Для диагностики: раскомментируйте следующую строку,
# чтобы при старте приложения он выводил в консоль, какую строку он реально использует.
print("DEBUG: DATABASE_URL в app/database.py =", DATABASE_URL)

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

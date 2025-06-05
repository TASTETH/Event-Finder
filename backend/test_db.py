# D:\event_finder\backend\test_db.py

import os
from sqlalchemy import create_engine, text
from sqlalchemy.exc import OperationalError

# Задаём ту же строку подключения, что и в вашем FastAPI:
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:123@localhost:5432/mobilki_db"
)

print("Попытка подключения к БД по адресу:", DATABASE_URL)

# Создаём движок SQLAlchemy
engine = create_engine(DATABASE_URL, pool_pre_ping=True)

try:
    with engine.connect() as conn:
        # Оборачиваем строку в text(), иначе SQLAlchemy 2.x не выполнит её напрямую
        result = conn.execute(text("SELECT version();"))
        version = result.scalar_one()
        print("Успешно подключились! Версия PostgreSQL:", version)
except OperationalError as e:
    print("Не удалось подключиться к БД. Полный текст ошибки:")
    print(e)                       # краткое сообщение
    print("---- repr(e) ----")
    print(repr(e))                 # более детальное представление
    print("---- e.orig ----")
    print(getattr(e, 'orig', 'У e нет атрибута orig'))
    print("---- e.args ----")
    print(e.args)

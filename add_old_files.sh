#!/usr/bin/env bash
# Copies the code from the OLD repo into the NEW repo structure.
# - If a file already exists in the new repo (e.g. an empty placeholder) -> its content is replaced with the old code.
# - If a file does not exist -> it is created (folders are created too).
#
# RUN THIS FROM INSIDE YOUR NEW REPO ROOT (the folder that contains backend/, frontend/, data/ ...):
#     cd Local_Smart_Notebook
#     bash add_old_files.sh
set -e

if [ ! -d "backend" ]; then
  echo "ERROR: run this script from the root of the new repo (the folder containing backend/)."
  exit 1
fi

put () {  # put <path>  (content comes from stdin)
  mkdir -p "$(dirname "$1")"
  if [ -e "$1" ]; then echo "updated : $1"; else echo "created : $1"; fi
  cat > "$1"
}

put 'backend/.env.example' << '__EOF_1__'
# Copy this file to .env and fill it in. Never commit .env
# Generate a key with:  python -c "import secrets; print(secrets.token_hex(32))"
SECRET_KEY=paste-a-long-random-string-here
ACCESS_TOKEN_EXPIRE_MINUTES=1440
__EOF_1__

put 'backend/.gitignore' << '__EOF_2__'
.env
.venv/
__pycache__/
*.pyc
.pytest_cache/
*.db
__EOF_2__

put 'backend/alembic.ini' << '__EOF_3__'
# A generic, single database configuration.

[alembic]
# path to migration scripts.
# this is typically a path given in POSIX (e.g. forward slashes)
# format, relative to the token %(here)s which refers to the location of this
# ini file
script_location = %(here)s/alembic

# template used to generate migration file names; The default value is %%(rev)s_%%(slug)s
# Uncomment the line below if you want the files to be prepended with date and time
# see https://alembic.sqlalchemy.org/en/latest/tutorial.html#editing-the-ini-file
# for all available tokens
# file_template = %%(year)d_%%(month).2d_%%(day).2d_%%(hour).2d%%(minute).2d-%%(rev)s_%%(slug)s
# Or organize into date-based subdirectories (requires recursive_version_locations = true)
# file_template = %%(year)d/%%(month).2d/%%(day).2d_%%(hour).2d%%(minute).2d_%%(second).2d_%%(rev)s_%%(slug)s

# sys.path path, will be prepended to sys.path if present.
# defaults to the current working directory.  for multiple paths, the path separator
# is defined by "path_separator" below.
prepend_sys_path = .


# timezone to use when rendering the date within the migration file
# as well as the filename.
# If specified, requires the tzdata library which can be installed by adding
# `alembic[tz]` to the pip requirements.
# string value is passed to ZoneInfo()
# leave blank for localtime
# timezone =

# max length of characters to apply to the "slug" field
# truncate_slug_length = 40

# set to 'true' to run the environment during
# the 'revision' command, regardless of autogenerate
# revision_environment = false

# set to 'true' to allow .pyc and .pyo files without
# a source .py file to be detected as revisions in the
# versions/ directory
# sourceless = false

# version location specification; This defaults
# to <script_location>/versions.  When using multiple version
# directories, initial revisions must be specified with --version-path.
# The path separator used here should be the separator specified by "path_separator"
# below.
# version_locations = %(here)s/bar:%(here)s/bat:%(here)s/alembic/versions

# path_separator; This indicates what character is used to split lists of file
# paths, including version_locations and prepend_sys_path within configparser
# files such as alembic.ini.
# The default rendered in new alembic.ini files is "os", which uses os.pathsep
# to provide os-dependent path splitting.
#
# Note that in order to support legacy alembic.ini files, this default does NOT
# take place if path_separator is not present in alembic.ini.  If this
# option is omitted entirely, fallback logic is as follows:
#
# 1. Parsing of the version_locations option falls back to using the legacy
#    "version_path_separator" key, which if absent then falls back to the legacy
#    behavior of splitting on spaces and/or commas.
# 2. Parsing of the prepend_sys_path option falls back to the legacy
#    behavior of splitting on spaces, commas, or colons.
#
# Valid values for path_separator are:
#
# path_separator = :
# path_separator = ;
# path_separator = space
# path_separator = newline
#
# Use os.pathsep. Default configuration used for new projects.
path_separator = os

# set to 'true' to search source files recursively
# in each "version_locations" directory
# new in Alembic version 1.10
# recursive_version_locations = false

# the output encoding used when revision files
# are written from script.py.mako
# output_encoding = utf-8

# database URL.  This is consumed by the user-maintained env.py script only.
# other means of configuring database URLs may be customized within the env.py
# file.
sqlalchemy.url = sqlite:///./local_smart_notebook.db


[post_write_hooks]
# post_write_hooks defines scripts or Python functions that are run
# on newly generated revision scripts.  See the documentation for further
# detail and examples

# format using "black" - use the console_scripts runner, against the "black" entrypoint
# hooks = black
# black.type = console_scripts
# black.entrypoint = black
# black.options = -l 79 REVISION_SCRIPT_FILENAME

# lint with attempts to fix using "ruff" - use the module runner, against the "ruff" module
# hooks = ruff
# ruff.type = module
# ruff.module = ruff
# ruff.options = check --fix REVISION_SCRIPT_FILENAME

# Alternatively, use the exec runner to execute a binary found on your PATH
# hooks = ruff
# ruff.type = exec
# ruff.executable = ruff
# ruff.options = check --fix REVISION_SCRIPT_FILENAME

# Logging configuration.  This is also consumed by the user-maintained
# env.py script only.
[loggers]
keys = root,sqlalchemy,alembic

[handlers]
keys = console

[formatters]
keys = generic

[logger_root]
level = WARNING
handlers = console
qualname =

[logger_sqlalchemy]
level = WARNING
handlers =
qualname = sqlalchemy.engine

[logger_alembic]
level = INFO
handlers =
qualname = alembic

[handler_console]
class = StreamHandler
args = (sys.stderr,)
level = NOTSET
formatter = generic

[formatter_generic]
format = %(levelname)-5.5s [%(name)s] %(message)s
datefmt = %H:%M:%S
__EOF_3__

put 'backend/alembic/README' << '__EOF_4__'
Generic single-database configuration.
__EOF_4__

put 'backend/alembic/env.py' << '__EOF_5__'
from logging.config import fileConfig

from sqlalchemy import engine_from_config
from sqlalchemy import pool

from alembic import context

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# Interpret the config file for Python logging.
# This line sets up loggers basically.
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# add your model's MetaData object here
# for 'autogenerate' support
# from myapp import mymodel
# target_metadata = mymodel.Base.metadata
target_metadata = None

from app.database.database import Base
from app.database.models import User, Notebook, Document, Conversation, Message
target_metadata = Base.metadata

# other values from the config, defined by the needs of env.py,
# can be acquired:
# my_important_option = config.get_main_option("my_important_option")
# ... etc.


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode.

    This configures the context with just a URL
    and not an Engine, though an Engine is acceptable
    here as well.  By skipping the Engine creation
    we don't even need a DBAPI to be available.

    Calls to context.execute() here emit the given string to the
    script output.

    """
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode.

    In this scenario we need to create an Engine
    and associate a connection with the context.

    """
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
__EOF_5__

put 'backend/alembic/script.py.mako' << '__EOF_6__'
"""${message}

Revision ID: ${up_revision}
Revises: ${down_revision | comma,n}
Create Date: ${create_date}

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
${imports if imports else ""}

# revision identifiers, used by Alembic.
revision: str = ${repr(up_revision)}
down_revision: Union[str, Sequence[str], None] = ${repr(down_revision)}
branch_labels: Union[str, Sequence[str], None] = ${repr(branch_labels)}
depends_on: Union[str, Sequence[str], None] = ${repr(depends_on)}


def upgrade() -> None:
    """Upgrade schema."""
    ${upgrades if upgrades else "pass"}


def downgrade() -> None:
    """Downgrade schema."""
    ${downgrades if downgrades else "pass"}
__EOF_6__

put 'backend/alembic/versions/542a9b135937_create_initial_tables.py' << '__EOF_7__'
"""Create initial tables

Revision ID: 542a9b135937
Revises: 
Create Date: 2026-10-14 00:57:03.058170

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '542a9b135937'
down_revision: Union[str, Sequence[str], None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('users',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('email', sa.String(), nullable=False),
    sa.Column('hashed_password', sa.String(), nullable=False),
    sa.Column('created_at', sa.DateTime(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_users_email'), 'users', ['email'], unique=True)
    op.create_index(op.f('ix_users_id'), 'users', ['id'], unique=False)
    op.create_table('notebooks',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('title', sa.String(), nullable=False),
    sa.Column('description', sa.String(), nullable=True),
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('created_at', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_notebooks_id'), 'notebooks', ['id'], unique=False)
    op.create_table('conversations',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('title', sa.String(), nullable=False),
    sa.Column('notebook_id', sa.Integer(), nullable=False),
    sa.Column('created_at', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['notebook_id'], ['notebooks.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_conversations_id'), 'conversations', ['id'], unique=False)
    op.create_table('documents',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('filename', sa.String(), nullable=False),
    sa.Column('file_path', sa.String(), nullable=False),
    sa.Column('file_type', sa.String(), nullable=False),
    sa.Column('notebook_id', sa.Integer(), nullable=False),
    sa.Column('uploaded_at', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['notebook_id'], ['notebooks.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_documents_id'), 'documents', ['id'], unique=False)
    op.create_table('messages',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('conversation_id', sa.Integer(), nullable=False),
    sa.Column('sender', sa.String(), nullable=False),
    sa.Column('content', sa.Text(), nullable=False),
    sa.Column('timestamp', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['conversation_id'], ['conversations.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_messages_id'), 'messages', ['id'], unique=False)
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_index(op.f('ix_messages_id'), table_name='messages')
    op.drop_table('messages')
    op.drop_index(op.f('ix_documents_id'), table_name='documents')
    op.drop_table('documents')
    op.drop_index(op.f('ix_conversations_id'), table_name='conversations')
    op.drop_table('conversations')
    op.drop_index(op.f('ix_notebooks_id'), table_name='notebooks')
    op.drop_table('notebooks')
    op.drop_index(op.f('ix_users_id'), table_name='users')
    op.drop_index(op.f('ix_users_email'), table_name='users')
    op.drop_table('users')
    # ### end Alembic commands ###
__EOF_7__

put 'backend/app/api/auth.py' << '__EOF_8__'
from fastapi import APIRouter, Depends, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.database.database import get_db
from app.database.models import User
from app.schemas.auth_schema import Token, UserCreate, UserResponse
from app.services import auth_service

router = APIRouter(prefix="/auth", tags=["Auth"])


@router.post(
    "/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED
)
def register(data: UserCreate, db: Session = Depends(get_db)):
    return auth_service.register(db, data)


@router.post("/login", response_model=Token)
def login(form: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    # OAuth2 forms call the field "username"; we use it for the e-mail address.
    return Token(access_token=auth_service.login(db, form.username, form.password))


@router.get("/me", response_model=UserResponse)
def me(current_user: User = Depends(get_current_user)):
    return current_user
__EOF_8__

put 'backend/app/api/deps.py' << '__EOF_9__'
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session

from app.core.security import decode_access_token
from app.database.database import get_db
from app.database.models import Conversation, Document, Notebook, User
from app.database.repositories import user_repo

# Must match the real login path (if Task 4 adds a prefix like /api/v1, change it)
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


def get_current_user(
    token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)
) -> User:
    """Authentication: who is calling? Raises 401 if the token is missing/invalid."""
    user_id = decode_access_token(token)
    user = user_repo.get(db, user_id) if user_id is not None else None
    if user is None:
        raise HTTPException(
            status.HTTP_401_UNAUTHORIZED,
            "Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user


# ---- Authorization: may this user touch this object? -----------------------
# We answer 404 (not 403) so nobody can probe which ids exist.

def get_owned_notebook(
    notebook_id: int,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> Notebook:
    notebook = db.get(Notebook, notebook_id)
    if notebook is None or notebook.user_id != user.id:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Notebook not found")
    return notebook


def get_owned_document(
    document_id: int,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> Document:
    document = db.get(Document, document_id)
    if document is None or document.notebook.user_id != user.id:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Document not found")
    return document


def get_owned_conversation(
    conversation_id: int,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> Conversation:
    conversation = db.get(Conversation, conversation_id)
    if conversation is None or conversation.notebook.user_id != user.id:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Conversation not found")
    return conversation
__EOF_9__

put 'backend/app/api/notebooks.py' << '__EOF_10__'
from typing import List

from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user, get_owned_notebook
from app.database.database import get_db
from app.database.models import Notebook, User
from app.schemas.notebook_schema import NotebookCreate, NotebookResponse

router = APIRouter(prefix="/notebooks", tags=["Notebooks"])


# 1. CREATE: the notebook belongs to whoever is logged in
@router.post(
    "/", response_model=NotebookResponse, status_code=status.HTTP_201_CREATED
)
def create_notebook(
    notebook: NotebookCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    db_notebook = Notebook(
        title=notebook.title,
        description=notebook.description,
        user_id=current_user.id,
    )
    db.add(db_notebook)
    db.commit()
    db.refresh(db_notebook)
    return db_notebook


# 2. READ: only MY notebooks
@router.get("/", response_model=List[NotebookResponse])
def get_notebooks(
    db: Session = Depends(get_db), current_user: User = Depends(get_current_user)
):
    return db.query(Notebook).filter(Notebook.user_id == current_user.id).all()


# 3. UPDATE: get_owned_notebook returns 404 if it is not mine
@router.put("/{notebook_id}", response_model=NotebookResponse)
def update_notebook(
    notebook_update: NotebookCreate,
    db: Session = Depends(get_db),
    db_notebook: Notebook = Depends(get_owned_notebook),
):
    db_notebook.title = notebook_update.title
    db_notebook.description = notebook_update.description
    db.commit()
    db.refresh(db_notebook)
    return db_notebook


# 4. DELETE: same ownership check
@router.delete("/{notebook_id}")
def delete_notebook(
    db: Session = Depends(get_db),
    db_notebook: Notebook = Depends(get_owned_notebook),
):
    db.delete(db_notebook)
    db.commit()
    return {"message": "Notebook deleted successfully"}
__EOF_10__

put 'backend/app/core/config.py' << '__EOF_11__'
from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict

# config.py -> core -> app -> backend
BACKEND_DIR = Path(__file__).resolve().parents[2]


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=BACKEND_DIR / ".env", extra="ignore")

    # --- security (Task 2) ---
    secret_key: str = "dev-only-change-me"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 60 * 24  # tokens last 24 hours


settings = Settings()
__EOF_11__

put 'backend/app/core/security.py' << '__EOF_12__'
from datetime import datetime, timedelta, timezone

import jwt
from pwdlib import PasswordHash
from pwdlib.exceptions import UnknownHashError

from app.core.config import settings

_password_hash = PasswordHash.recommended()  # Argon2


def hash_password(password: str) -> str:
    return _password_hash.hash(password)


def verify_password(password: str, hashed: str) -> bool:
    try:
        return _password_hash.verify(password, hashed)
    except UnknownHashError:  # e.g. a placeholder value like "fakepassword"
        return False


# Burns the same CPU time when an e-mail does not exist (see auth_service.login)
DUMMY_HASH = hash_password("not-a-real-password")


def create_access_token(user_id: int) -> str:
    expire = datetime.now(timezone.utc) + timedelta(
        minutes=settings.access_token_expire_minutes
    )
    payload = {"sub": str(user_id), "exp": expire}  # the JWT standard wants a string
    return jwt.encode(payload, settings.secret_key, algorithm=settings.jwt_algorithm)


def decode_access_token(token: str) -> int | None:
    """Return the user id stored in the token, or None if invalid/expired."""
    try:
        payload = jwt.decode(
            token, settings.secret_key, algorithms=[settings.jwt_algorithm]
        )
        return int(payload["sub"])
    except (jwt.PyJWTError, KeyError, ValueError, TypeError):
        return None
__EOF_12__

put 'backend/app/database/database.py' << '__EOF_13__'
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# رابط قاعدة بيانات SQLite المحلية
SQLALCHEMY_DATABASE_URL = "sqlite:///./local_smart_notebook.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
__EOF_13__

put 'backend/app/database/main.py' << '__EOF_14__'
from fastapi import FastAPI
from app.database.database import engine, Base
from app.database import models

# إنشاء الجداول فوراً في قاعدة البيانات SQLite محلياً
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Local Smart Notebook API")

@app.get("/")
def read_root():
    return {"message": "Local Smart Notebook Backend is up and running successfully!"}
__EOF_14__

put 'backend/app/database/models.py' << '__EOF_15__'
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database.database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    notebooks = relationship("Notebook", back_populates="owner", cascade="all, delete-orphan")

class Notebook(Base):
    __tablename__ = "notebooks"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(String, nullable=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    owner = relationship("User", back_populates="notebooks")
    documents = relationship("Document", back_populates="notebook", cascade="all, delete-orphan")
    conversations = relationship("Conversation", back_populates="notebook", cascade="all, delete-orphan")

class Document(Base):
    __tablename__ = "documents"
    id = Column(Integer, primary_key=True, index=True)
    filename = Column(String, nullable=False)
    file_path = Column(String, nullable=False)
    file_type = Column(String, nullable=False)
    notebook_id = Column(Integer, ForeignKey("notebooks.id"), nullable=False)
    uploaded_at = Column(DateTime, default=datetime.utcnow)

    notebook = relationship("Notebook", back_populates="documents")

class Conversation(Base):
    __tablename__ = "conversations"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    notebook_id = Column(Integer, ForeignKey("notebooks.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    notebook = relationship("Notebook", back_populates="conversations")
    messages = relationship("Message", back_populates="conversation", cascade="all, delete-orphan")

class Message(Base):
    __tablename__ = "messages"
    id = Column(Integer, primary_key=True, index=True)
    conversation_id = Column(Integer, ForeignKey("conversations.id"), nullable=False)
    sender = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow)

    conversation = relationship("Conversation", back_populates="messages")
__EOF_15__

put 'backend/app/database/repositories/user_repo.py' << '__EOF_16__'
from sqlalchemy.orm import Session

from app.database.models import User


def get(db: Session, user_id: int) -> User | None:
    return db.get(User, user_id)


def get_by_email(db: Session, email: str) -> User | None:
    return db.query(User).filter(User.email == email.lower()).first()


def create(db: Session, *, email: str, hashed_password: str) -> User:
    user = User(email=email.lower(), hashed_password=hashed_password)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user
__EOF_16__

put 'backend/app/main.py' << '__EOF_17__'
from fastapi import FastAPI
from app.database.database import engine, Base
from app.database import models
from app.api import auth, notebooks  # استيراد ملف الراوتر الجديد

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Local Smart Notebook API")

# تسجيل الراوتر عشان يظهر في الـ API
app.include_router(auth.router)
app.include_router(notebooks.router)

@app.get("/")
def read_root():
    return {"message": "Local Smart Notebook Backend is running successfully!"}
__EOF_17__

put 'backend/app/schemas/auth_schema.py' << '__EOF_18__'
from datetime import datetime

from pydantic import BaseModel, ConfigDict, EmailStr, Field


class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)


class UserResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    email: EmailStr
    created_at: datetime


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
__EOF_18__

put 'backend/app/schemas/notebook_schema.py' << '__EOF_19__'
from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

# 1. Schema لإنشاء نوت بوك جديد (اللي المستخدم بيبعتهم في الـ Body)
class NotebookCreate(BaseModel):
    title: str
    description: Optional[str] = None

# 2. Schema للرد (Response) اللي بيترجع للمستخدم بعد ما العملية تنجح
class NotebookResponse(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    user_id: int
    created_at: datetime

    class Config:
        from_attributes = True  # عشان يقرأ البيانات من نماذج SQLAlchemy مباشرة
__EOF_19__

put 'backend/app/services/auth_service.py' << '__EOF_20__'
from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.core.security import (
    DUMMY_HASH,
    create_access_token,
    hash_password,
    verify_password,
)
from app.database.models import User
from app.database.repositories import user_repo
from app.schemas.auth_schema import UserCreate


def register(db: Session, data: UserCreate) -> User:
    if user_repo.get_by_email(db, data.email):
        raise HTTPException(status.HTTP_409_CONFLICT, "Email already registered")
    return user_repo.create(
        db, email=data.email, hashed_password=hash_password(data.password)
    )


def login(db: Session, email: str, password: str) -> str:
    user = user_repo.get_by_email(db, email)
    if user is None:
        verify_password(password, DUMMY_HASH)  # same timing if the user is unknown
    if user is None or not verify_password(password, user.hashed_password):
        raise HTTPException(
            status.HTTP_401_UNAUTHORIZED,
            "Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return create_access_token(user.id)
__EOF_20__

put 'backend/pytest.ini' << '__EOF_21__'
[pytest]
pythonpath = .
testpaths = tests
__EOF_21__

put 'backend/requirements.txt' << '__EOF_22__'
aiohappyeyeballs==2.7.1
aiohttp==3.14.3
aiosignal==1.4.0
alembic==1.20.0
annotated-doc==0.0.5
annotated-types==0.8.0
anyio==4.14.2
attrs==26.1.0
bcrypt==5.0.0
beautifulsoup4==4.15.0
build==1.5.0
certifi==2026.7.22
charset-normalizer==3.4.9
chromadb==1.5.9
click==8.4.2
cloudscraper==1.2.71
colorama==0.4.6
distro==1.9.0
durationpy==0.10
fastapi==0.141.1
feedparser==6.0.14
feedparser-sgmllib==2.1.0
filelock==3.32.3
flatbuffers==25.12.19
frozenlist==1.8.0
fsspec==2026.7.0
googleapis-common-protos==1.75.1
greenlet==3.5.5
grpcio==1.83.0
h11==0.16.0
hf-xet==1.6.0
httpcore==1.0.9
httptools==0.8.0
httpx==0.28.1
httpx-sse==0.4.3
huggingface_hub==1.27.0
idna==3.18
importlib_resources==7.1.0
jsonpatch==1.33
jsonpointer==3.1.1
jsonschema==4.26.0
jsonschema-specifications==2025.9.1
kubernetes==36.0.3
langchain==1.3.15
langchain-chroma==1.1.0
langchain-classic==1.0.8
langchain-community==0.4.2
langchain-core==1.5.5
langchain-huggingface==1.2.2
langchain-ollama==1.1.0
langchain-protocol==0.0.18
langchain-text-splitters==1.1.2
langgraph==1.2.11
langgraph-checkpoint==4.2.0
langgraph-prebuilt==1.1.0
langgraph-sdk==0.4.2
langsmith==0.11.0
lxml==6.1.1
Mako==1.4.3
markdown-it-py==4.2.0
MarkupSafe==3.0.4
mdurl==0.1.2
mmh3==5.2.1
multidict==6.7.1
numpy==2.5.2
oauthlib==3.3.1
ollama==0.6.2
onnxruntime==1.28.0
opentelemetry-api==1.44.0
opentelemetry-exporter-otlp-proto-common==1.44.0
opentelemetry-exporter-otlp-proto-grpc==1.44.0
opentelemetry-proto==1.44.0
opentelemetry-sdk==1.44.0
opentelemetry-semantic-conventions==0.65b0
orjson==3.12.0
ormsgpack==1.12.2
overrides==7.7.0
packaging==26.3
propcache==0.5.2
protobuf==7.35.1
pybase64==1.5.0
pydantic==2.13.4
pydantic-settings==2.15.0
pydantic_core==2.46.4
Pygments==2.20.0
pyparsing==3.3.2
pypdf==6.16.1
PyPika==0.51.1
pyproject_hooks==1.2.0
python-dateutil==2.9.0.post0
python-dotenv==1.2.2
python-multipart==0.0.32
PyYAML==6.0.3
referencing==0.37.0
regex==2026.7.19
requests==2.34.2
requests-oauthlib==2.0.0
requests-toolbelt==1.0.0
rich==15.0.0
rpds-py==2026.6.3
safetensors==0.8.0
sentence-transformers==5.7.0
shellingham==1.5.4
six==1.17.0
sniffio==1.3.1
soupsieve==2.9.2
SQLAlchemy==2.0.52
starlette==1.6.0
tenacity==9.1.4
tokenizers==0.22.2
torch==2.13.0
tqdm==4.70.0
transformers==5.15.0
typer==0.27.1
typing-inspection==0.4.4
typing_extensions==4.16.0
urllib3==2.7.0
uuid_utils==0.17.0
uvicorn==0.52.3
watchfiles==1.2.0
websocket-client==1.9.0
websockets==15.0.1
windows-curses==2.4.2
xxhash==4.0.0
yarl==1.24.5
zstandard==0.25.0
PyJWT>=2.8
pwdlib[argon2]>=0.2
email-validator>=2.1
pytest>=8.0

# ---- added for the new architecture ----
qdrant-client
python-docx
python-pptx
openpyxl
pandas
matplotlib
pytesseract
Pillow
rank-bm25
__EOF_22__

put 'backend/tests/conftest.py' << '__EOF_23__'
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.database.database import Base, get_db
from app.main import app


@pytest.fixture()
def db():
    """A fresh in-memory database for every test (your real .db file is untouched)."""
    engine = create_engine(
        "sqlite://", connect_args={"check_same_thread": False}, poolclass=StaticPool
    )
    Base.metadata.create_all(engine)
    session = sessionmaker(bind=engine, autoflush=False, autocommit=False)()
    yield session
    session.close()


@pytest.fixture()
def client(db):
    def override_get_db():
        yield db

    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()


@pytest.fixture()
def login(client):
    """login("a@x.com") registers the user (if new) and returns the auth headers."""

    def _login(email="ibrahim@example.com", password="secret123"):
        client.post("/auth/register", json={"email": email, "password": password})
        form = {"username": email, "password": password}
        token = client.post("/auth/login", data=form).json()["access_token"]
        return {"Authorization": f"Bearer {token}"}

    return _login
__EOF_23__

put 'backend/tests/test_auth.py' << '__EOF_24__'
from datetime import datetime, timedelta, timezone

import jwt

from app.core.config import settings


def do_login(client, email, password):
    form = {"username": email, "password": password}
    return client.post("/auth/login", data=form)


def test_register_login_me(client, login):
    r = client.post(
        "/auth/register", json={"email": "A@Example.com", "password": "secret123"}
    )
    assert r.status_code == 201
    assert "password" not in r.text  # no password or hash is ever returned
    assert r.json()["email"] == "a@example.com"  # stored lower-case

    headers = login("a@example.com")
    me = client.get("/auth/me", headers=headers)
    assert me.status_code == 200 and me.json()["email"] == "a@example.com"


def test_validation_errors(client):
    bad_email = {"email": "nope", "password": "secret123"}
    short_pw = {"email": "a@example.com", "password": "123"}
    assert client.post("/auth/register", json=bad_email).status_code == 422
    assert client.post("/auth/register", json=short_pw).status_code == 422


def test_duplicate_email_and_wrong_credentials(client):
    body = {"email": "a@example.com", "password": "secret123"}
    assert client.post("/auth/register", json=body).status_code == 201
    assert client.post("/auth/register", json=body).status_code == 409

    wrong_pw = do_login(client, "a@example.com", "wrong-pass")
    no_user = do_login(client, "x@example.com", "secret123")
    assert wrong_pw.status_code == no_user.status_code == 401
    assert wrong_pw.json() == no_user.json()  # don't reveal which e-mails exist


def test_protected_routes_need_a_valid_token(client):
    assert client.get("/auth/me").status_code == 401
    garbage = {"Authorization": "Bearer not-a-real-token"}
    assert client.get("/auth/me", headers=garbage).status_code == 401

    # a correctly signed token that has already expired
    expired = jwt.encode(
        {"sub": "1", "exp": datetime.now(timezone.utc) - timedelta(minutes=1)},
        settings.secret_key,
        algorithm=settings.jwt_algorithm,
    )
    headers = {"Authorization": f"Bearer {expired}"}
    assert client.get("/auth/me", headers=headers).status_code == 401


def test_token_for_a_deleted_user_is_rejected(client, db, login):
    headers = login("gone@example.com")
    from app.database.models import User

    db.query(User).filter(User.email == "gone@example.com").delete()
    db.commit()
    assert client.get("/auth/me", headers=headers).status_code == 401


def test_placeholder_hash_does_not_crash_login(client, db):
    """Task 1's old test user ('fakepassword') must give 401, not a server error."""
    from app.database.models import User

    db.add(User(email="test@example.com", hashed_password="fakepassword"))
    db.commit()
    assert do_login(client, "test@example.com", "fakepassword").status_code == 401
__EOF_24__

put 'backend/tests/test_notebooks_privacy.py' << '__EOF_25__'
def test_notebooks_require_login(client):
    assert client.get("/notebooks/").status_code == 401
    assert client.post("/notebooks/", json={"title": "x"}).status_code == 401


def test_users_only_see_and_change_their_own_notebooks(client, login):
    alice = login("alice@example.com")
    bob = login("bob@example.com")

    r = client.post("/notebooks/", json={"title": "Alice only"}, headers=alice)
    assert r.status_code == 201
    notebook_id = r.json()["id"]

    assert client.get("/notebooks/", headers=bob).json() == []
    assert len(client.get("/notebooks/", headers=alice).json()) == 1

    url = f"/notebooks/{notebook_id}"
    assert client.put(url, json={"title": "hacked"}, headers=bob).status_code == 404
    assert client.delete(url, headers=bob).status_code == 404

    renamed = client.put(url, json={"title": "renamed"}, headers=alice)
    assert renamed.status_code == 200
    assert client.delete(url, headers=alice).status_code == 200
__EOF_25__

put 'backend/tests/test_ownership.py' << '__EOF_26__'
import pytest
from fastapi import HTTPException

from app.api import deps
from app.database.models import Conversation, Document, Notebook, User


def make_world(db):
    alice = User(email="alice@example.com", hashed_password="x")
    bob = User(email="bob@example.com", hashed_password="x")
    db.add_all([alice, bob])
    db.commit()
    notebook = Notebook(title="Alice's notebook", user_id=alice.id)
    db.add(notebook)
    db.commit()
    document = Document(
        filename="a.txt",
        file_path="/tmp/a.txt",
        file_type="txt",
        notebook_id=notebook.id,
    )
    conversation = Conversation(title="First chat", notebook_id=notebook.id)
    db.add_all([document, conversation])
    db.commit()
    return alice, bob, notebook, document, conversation


def test_owner_gets_access(db):
    alice, _, notebook, document, conversation = make_world(db)
    assert deps.get_owned_notebook(notebook.id, db, alice) is notebook
    assert deps.get_owned_document(document.id, db, alice) is document
    assert deps.get_owned_conversation(conversation.id, db, alice) is conversation


def test_other_users_and_missing_ids_get_404(db):
    _, bob, notebook, document, conversation = make_world(db)
    cases = [
        (deps.get_owned_notebook, notebook.id),
        (deps.get_owned_document, document.id),
        (deps.get_owned_conversation, conversation.id),
    ]
    for dependency, object_id in cases:
        for wanted_id in (object_id, 9999):  # someone else's object / no such object
            with pytest.raises(HTTPException) as err:
                dependency(wanted_id, db, bob)
            assert err.value.status_code == 404
__EOF_26__


# ---- README: add the project description at the top if it is not there yet ----
if ! grep -q "Privacy-first, offline AI workspace" README.md 2>/dev/null; then
  {
    echo "# Local-Smart-Notebook"
    echo "Privacy-first, offline AI workspace powered by local LLMs, featuring multi-document RAG, intelligent summarization, multi-agent workflows, spreadsheet analytics, infographic generation and automated presentation generation."
    echo ""
    [ -f README.md ] && tail -n +2 README.md
  } > README.tmp && mv README.tmp README.md
  echo "updated : README.md"
fi

echo ""
echo "All old files added. Now commit & push:"
echo "  git add ."
echo '  git commit -m "Add code from old repo (auth, notebooks, database, alembic, tests)"'
echo "  git push"

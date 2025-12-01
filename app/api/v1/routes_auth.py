# app/api/v1/routes_auth.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserLogin, UserOut, Token
from app.core.security import (
    hash_password,
    verify_password,
    create_access_token,
    get_current_user,
)
from app.services.audit_service import log_user_activity  # 👈 NUEVO
from app.core.audit_actions import AuditAction          # 👈 NUEVO

router = APIRouter(prefix="/auth", tags=["Auth"])


@router.post("/register", response_model=Token, status_code=status.HTTP_201_CREATED)
def register(user_in: UserCreate, db: Session = Depends(get_db)):
    # ¿Existe usuario con ese email o username?
    existing = (
        db.query(User)
        .filter((User.email == user_in.email) | (User.username == user_in.username))
        .first()
    )
    if existing:
        # Log de registro fallido
        log_user_activity(
            db,
            user=None,
            client=None,
            action=AuditAction.REGISTER_FAILED,
            path="/api/v1/auth/register",
            method="POST",
            status_code=status.HTTP_400_BAD_REQUEST,
            success=False,
            error_message="El usuario ya existe (email o username en uso)",
            extra={"email": user_in.email, "username": user_in.username},
        )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El usuario ya existe (email o username en uso)",
        )

    user = User(
        email=user_in.email,
        username=user_in.username,
        hashed_password=hash_password(user_in.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    token = create_access_token({"sub": str(user.id)})

    # Log de registro exitoso
    log_user_activity(
        db,
        user=user,
        client=None,
        action=AuditAction.REGISTER_SUCCESS,
        path="/api/v1/auth/register",
        method="POST",
        status_code=status.HTTP_201_CREATED,
        success=True,
        extra={"user_id": user.id, "email": user.email, "username": user.username},
    )

    return Token(
        access_token=token,
        user=user,
    )


@router.post("/login", response_model=Token)
def login(credentials: UserLogin, db: Session = Depends(get_db)):
    user = (
        db.query(User)
        .filter(User.username == credentials.username)
        .first()
    )
    if not user:
        # Log de login fallido (usuario no existe)
        log_user_activity(
            db,
            user=None,
            client=None,
            action=AuditAction.LOGIN_FAILED,
            path="/api/v1/auth/login",
            method="POST",
            status_code=status.HTTP_400_BAD_REQUEST,
            success=False,
            error_message="Credenciales incorrectas (usuario no existe)",
            extra={"username": credentials.username},
        )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Credenciales incorrectas",
        )

    if not verify_password(credentials.password, user.hashed_password):
        # Log de login fallido (password incorrecto)
        log_user_activity(
            db,
            user=user,
            client=None,
            action=AuditAction.LOGIN_FAILED,
            path="/api/v1/auth/login",
            method="POST",
            status_code=status.HTTP_400_BAD_REQUEST,
            success=False,
            error_message="Credenciales incorrectas (password inválido)",
            extra={"user_id": user.id, "username": user.username},
        )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Credenciales incorrectas",
        )

    if not user.is_active:
        # Log de login fallido (usuario inactivo)
        log_user_activity(
            db,
            user=user,
            client=None,
            action=AuditAction.LOGIN_FAILED,
            path="/api/v1/auth/login",
            method="POST",
            status_code=status.HTTP_400_BAD_REQUEST,
            success=False,
            error_message="Usuario inactivo",
            extra={"user_id": user.id, "username": user.username},
        )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Usuario inactivo",
        )

    token = create_access_token({"sub": str(user.id)})

    # Log de login exitoso
    log_user_activity(
        db,
        user=user,
        client=None,
        action=AuditAction.LOGIN_SUCCESS,
        path="/api/v1/auth/login",
        method="POST",
        status_code=status.HTTP_200_OK,
        success=True,
        extra={"user_id": user.id, "username": user.username},
    )

    return Token(
        access_token=token,
        user=user,
    )


@router.get("/me", response_model=UserOut)
def read_current_user(
    current_user: User = Depends(get_current_user),
):
    # Opcional: podrías loguear también este endpoint con un AuditAction nuevo tipo GET_PROFILE.
    return current_user

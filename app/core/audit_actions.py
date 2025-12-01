# app/core/audit_actions.py
from enum import Enum


class AuditAction(str, Enum):

    # ============================
    # AUTH / SESIÓN
    # ============================
    LOGIN_SUCCESS = "LOGIN_SUCCESS"
    LOGIN_FAILED = "LOGIN_FAILED"
    REGISTER_SUCCESS = "REGISTER_SUCCESS"
    REGISTER_FAILED = "REGISTER_FAILED"
    LOGOUT = "LOGOUT"

    # ============================
    # EMITTERS
    # ============================
    CREATE_EMITTER = "CREATE_EMITTER"
    LIST_EMITTERS = "LIST_EMITTERS"
    GET_EMITTER = "GET_EMITTER"
    UPDATE_EMITTER = "UPDATE_EMITTER"
    DELETE_EMITTER = "DELETE_EMITTER"

    # ============================
    # CAF
    # ============================
    CREATE_CAF = "CREATE_CAF"
    LIST_CAF = "LIST_CAF"
    GET_CAF = "GET_CAF"
    DELETE_CAF = "DELETE_CAF"

    # ============================
    # DOCUMENTOS
    # ============================
    CREATE_DOCUMENT = "CREATE_DOCUMENT"
    GET_DOCUMENT = "GET_DOCUMENT"
    LIST_DOCUMENTS = "LIST_DOCUMENTS"
    GET_DOCUMENT_XML = "GET_DOCUMENT_XML"
    GET_ENVIO_XML = "GET_ENVIO_XML"
    SEND_DOCUMENT_SII = "SEND_DOCUMENT_SII"

    # ============================
    # SISTEMA / ESPECIALES
    # ============================
    API_RATE_LIMIT = "API_RATE_LIMIT"
    SERVER_ERROR = "SERVER_ERROR"
    INVALID_PAYLOAD = "INVALID_PAYLOAD"

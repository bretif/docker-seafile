#!/bin/bash

if [ `grep -c "#DOCKER CONFIG DONE" /opt/seafile/seahub_settings.py` -eq 0 ]; then
    echo "seahub_settings.py not configured. Add docker container conf"
    echo "Configure EMAIL section of seahub_settings.con"
#    EMAIL_USE_TLS=${EMAIL_USE_TLS:-False}
#    EMAIL_HOST=${EMAIL_HOST:-127.0.0.1}
#    EMAIL_HOST_USER=${EMAIL_HOST_USER:-False}
#    EMAIL_HOST_PASSWORD=${EMAIL_HOST_PASSWORD:-False}
#    EMAIL_PORT=${EMAIL_PORT:-25}
#    DEFAULT_FROM_EMAIL=${DEFAULT_FROM_EMAIL:-${SEAHUB_ADMIN_EMAIL}}
#    SERVER_EMAIL=${EMAIL_HOST_USER:-EMAIL_HOST_USER}}
    echo EMAIL_USE_TLS = ${EMAIL_USE_TLS} >> /opt/seafile/seahub_settings.py
    echo EMAIL_HOST = ${EMAIL_HOST} >> /opt/seafile/seahub_settings.py
    echo EMAIL_HOST_USER = ${EMAIL_HOST_USER} >> /opt/seafile/seahub_settings.py
    echo EMAIL_HOST_PASSWORD = ${EMAIL_HOST_PASSWORD} >> /opt/seafile/seahub_settings.py
    echo EMAIL_PORT = ${EMAIL_PORT} >> /opt/seafile/seahub_settings.py
    echo DEFAULT_FROM_EMAIL = ${DEFAULT_FROM_EMAIL} >> /opt/seafile/seahub_settings.py
    echo SERVER_EMAIL = ${SERVER_EMAIL} >> /opt/seafile/seahub_settings.py
    echo "" >> /opt/seafile/seahub_settings.py
 
    echo "Configure Password section of seahub_settings.con"
#    REPO_PASSWORD_MIN_LENGTH=${REPO_PASSWORD_MIN_LENGTH:-8}
#    USER_PASSWORD_MIN_LENGTH=${USER_PASSWORD_MIN_LENGTH:-6}
#    USER_PASSWORD_STRENGTH_LEVEL=${USER_PASSWORD_STRENGTH_LEVEL:-3}
#    USER_STRONG_PASSWORD_REQUIRED=${USER_STRONG_PASSWORD_REQUIRED:-False}
    echo REPO_PASSWORD_MIN_LENGTH = ${REPO_PASSWORD_MIN_LENGTH} >> /opt/seafile/seahub_settings.py
    echo USER_PASSWORD_MIN_LENGTH = ${USER_PASSWORD_MIN_LENGTH} >> /opt/seafile/seahub_settings.py
    echo USER_PASSWORD_STRENGTH_LEVEL = ${USER_PASSWORD_STRENGTH_LEVEL} >> /opt/seafile/seahub_settings.py
    echo USER_STRONG_PASSWORD_REQUIRED = ${USER_STRONG_PASSWORD_REQUIRED} >> /opt/seafile/seahub_settings.py
    echo "" >> /opt/seafile/seahub_settings.py

    echo "Configure Cloud section of seahub_settings.con"
#    CLOUD_MODE=${CLOUD_MODE:-False}
#    ENABLE_SIGNUP=${ENABLE_SIGNUP:-False}
#    ACTIVATE_AFTER_REGISTRATION=${ACTIVATE_AFTER_REGISTRATION:-False}
    echo CLOUD_MODE = ${CLOUD_MODE} >> /opt/seafile/seahub_settings.py
    echo ENABLE_SIGNUP = ${ENABLE_SIGNUP} >> /opt/seafile/seahub_settings.py
    echo ACTIVATE_AFTER_REGISTRATION = ${ACTIVATE_AFTER_REGISTRATION} >> /opt/seafile/seahub_settings.py
    echo "" >> /opt/seafile/seahub_settings.py

    echo "Configure other options of seahub_settings.con"
#    TIME_ZONE=${TIME_ZONE:-UTC}
#    SITE_BASE=${SITE_BASE:-https://${NAME}.${DOMAIN}/}
#    SITE_NAME=${SITE_NAME:-${NAME}}
#    SITE_TITLE=${SITE_TITLE:-Seafile ${NAME}}
#    SITE_ROOT=${SITE_ROOT:-/}
#    USE_PDFJS=${USE_PDFJS:-True}
#    SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER=${SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER:-True}
#    SEND_EMAIL_ON_RESETTING_USER_PASSWD=${SEND_EMAIL_ON_RESETTING_USER_PASSWD:-True}
#    FILE_PREVIEW_MAX_SIZE=${FILE_PREVIEW_MAX_SIZE:-30M}
#    SESSION_COOKIE_AGE=${SESSION_COOKIE_AGE:-1209600}
#    SESSION_SAVE_EVERY_REQUEST=${SESSION_SAVE_EVERY_REQUEST:-False}
#    SESSION_EXPIRE_AT_BROWSER_CLOSE=${SESSION_EXPIRE_AT_BROWSER_CLOSE:-False}
#    ENABLE_MAKE_GROUP_PUBLIC=${ENABLE_MAKE_GROUP_PUBLIC:-False}
#    ENABLE_THUMBNAIL=${ENABLE_THUMBNAIL:-True}
#    THUMBNAIL_ROOT=${THUMBNAIL_ROOT:-/haiwen/seahub-data/thumbnail/thumb/}
#    THUMBNAIL_EXTENSION=${THUMBNAIL_EXTENSION:-png}
#    THUMBNAIL_DEFAULT_SIZE=${ENABLE_THUMBNAIL:-24}
#    PREVIEW_DEFAULT_SIZE=${PREVIEW_DEFAULT_SIZE:-100}
    echo TIME_ZONE = ${TIME_ZONE} >> /opt/seafile/seahub_settings.py
    echo SITE_BASE = ${SITE_BASE} >> /opt/seafile/seahub_settings.py
    echo SITE_NAME = ${SITE_NAME} >> /opt/seafile/seahub_settings.py
    echo SITE_TITLE = ${SITE_TITLE} >> /opt/seafile/seahub_settings.py
    echo SITE_ROOT = ${SITE_ROOT} >> /opt/seafile/seahub_settings.py
    echo USE_PDFJS = ${USE_PDFJS} >> /opt/seafile/seahub_settings.py
    echo SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = ${SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER} >> /opt/seafile/seahub_settings.py
    echo SEND_EMAIL_ON_RESETTING_USER_PASSWD = ${SEND_EMAIL_ON_RESETTING_USER_PASSWD} >> /opt/seafile/seahub_settings.py
    echo FILE_PREVIEW_MAX_SIZE = ${FILE_PREVIEW_MAX_SIZE} >> /opt/seafile/seahub_settings.py
    echo SESSION_COOKIE_AGE = ${SESSION_COOKIE_AGE} >> /opt/seafile/seahub_settings.py
    echo SESSION_SAVE_EVERY_REQUEST = ${SESSION_SAVE_EVERY_REQUEST} >> /opt/seafile/seahub_settings.py
    echo SESSION_EXPIRE_AT_BROWSER_CLOSE = ${SESSION_EXPIRE_AT_BROWSER_CLOSE} >> /opt/seafile/seahub_settings.py
    echo ENABLE_MAKE_GROUP_PUBLIC = ${ENABLE_MAKE_GROUP_PUBLIC} >> /opt/seafile/seahub_settings.py
    echo ENABLE_THUMBNAIL = ${ENABLE_THUMBNAIL} >> /opt/seafile/seahub_settings.py
    echo THUMBNAIL_ROOT = ${THUMBNAIL_ROOT} >> /opt/seafile/seahub_settings.py
    echo THUMBNAIL_EXTENSION = ${THUMBNAIL_EXTENSION} >> /opt/seafile/seahub_settings.py
    echo THUMBNAIL_DEFAULT_SIZE = ${THUMBNAIL_DEFAULT_SIZE} >> /opt/seafile/seahub_settings.py
    echo PREVIEW_DEFAULT_SIZE = ${PREVIEW_DEFAULT_SIZE} >> /opt/seafile/seahub_settings.py
    echo "#DOCKER CONFIG DONE" >> /opt/seafile/seahub_settings.py
else
    echo "seahub_settings.py already configured. Skipped configuration"
    exit 0
fi


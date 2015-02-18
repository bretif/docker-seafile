#!/bin/bash

if [ `grep -c "#DOCKER CONFIG DONE" /opt/seafile/seahub_settings.py` -eq 0 ]; then
    echo "seahub_settings.py not configured. Add docker container conf"
    echo "Configure EMAIL section of seahub_settings.con"
    echo EMAIL_USE_TLS = ${SHS_EMAIL_USE_TLS} >> /opt/seafile/seahub_settings.py
    echo EMAIL_HOST = ${SHS_EMAIL_HOST} >> /opt/seafile/seahub_settings.py
    echo EMAIL_HOST_USER = ${SHS_EMAIL_HOST_USER} >> /opt/seafile/seahub_settings.py
    echo EMAIL_HOST_PASSWORD = ${SHS_EMAIL_HOST_PASSWORD} >> /opt/seafile/seahub_settings.py
    echo EMAIL_PORT = ${SHS_EMAIL_PORT} >> /opt/seafile/seahub_settings.py
    echo DEFAULT_FROM_EMAIL = ${SHS_DEFAULT_FROM_EMAIL} >> /opt/seafile/seahub_settings.py
    echo SERVER_EMAIL = ${SHS_SERVER_EMAIL} >> /opt/seafile/seahub_settings.py
    echo "" >> /opt/seafile/seahub_settings.py
 
    echo "Configure Password section of seahub_settings.con"
    echo REPO_PASSWORD_MIN_LENGTH = ${SHS_REPO_PASSWORD_MIN_LENGTH} >> /opt/seafile/seahub_settings.py
    echo USER_PASSWORD_MIN_LENGTH = ${SHS_USER_PASSWORD_MIN_LENGTH} >> /opt/seafile/seahub_settings.py
    echo USER_PASSWORD_STRENGTH_LEVEL = ${SHS_USER_PASSWORD_STRENGTH_LEVEL} >> /opt/seafile/seahub_settings.py
    echo USER_STRONG_PASSWORD_REQUIRED = ${SHS_USER_STRONG_PASSWORD_REQUIRED} >> /opt/seafile/seahub_settings.py
    echo "" >> /opt/seafile/seahub_settings.py

    echo "Configure Cloud section of seahub_settings.con"
    echo CLOUD_MODE = ${SHS_CLOUD_MODE} >> /opt/seafile/seahub_settings.py
    echo ENABLE_SIGNUP = ${SHS_ENABLE_SIGNUP} >> /opt/seafile/seahub_settings.py
    echo ACTIVATE_AFTER_REGISTRATION = ${SHS_ACTIVATE_AFTER_REGISTRATION} >> /opt/seafile/seahub_settings.py
    echo "" >> /opt/seafile/seahub_settings.py

    echo "Configure other options of seahub_settings.con"
    echo TIME_ZONE = ${SHS_TIME_ZONE} >> /opt/seafile/seahub_settings.py
    echo SITE_BASE = ${SHS_SITE_BASE} >> /opt/seafile/seahub_settings.py
    echo SITE_NAME = ${SHS_SITE_NAME} >> /opt/seafile/seahub_settings.py
    echo SITE_TITLE = ${SHS_SITE_TITLE} >> /opt/seafile/seahub_settings.py
    echo SITE_ROOT = ${SHS_SITE_ROOT} >> /opt/seafile/seahub_settings.py
    echo USE_PDFJS = ${SHS_USE_PDFJS} >> /opt/seafile/seahub_settings.py
    echo SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = ${SHS_SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER} >> /opt/seafile/seahub_settings.py
    echo SEND_EMAIL_ON_RESETTING_USER_PASSWD = ${SHS_SEND_EMAIL_ON_RESETTING_USER_PASSWD} >> /opt/seafile/seahub_settings.py
    echo FILE_PREVIEW_MAX_SIZE = ${SHS_FILE_PREVIEW_MAX_SIZE} >> /opt/seafile/seahub_settings.py
    echo SESSION_COOKIE_AGE = ${SHS_SESSION_COOKIE_AGE} >> /opt/seafile/seahub_settings.py
    echo SESSION_SAVE_EVERY_REQUEST = ${SHS_SESSION_SAVE_EVERY_REQUEST} >> /opt/seafile/seahub_settings.py
    echo SESSION_EXPIRE_AT_BROWSER_CLOSE = ${SHS_SESSION_EXPIRE_AT_BROWSER_CLOSE} >> /opt/seafile/seahub_settings.py
    echo ENABLE_MAKE_GROUP_PUBLIC = ${SHS_ENABLE_MAKE_GROUP_PUBLIC} >> /opt/seafile/seahub_settings.py
    echo ENABLE_THUMBNAIL = ${SHS_ENABLE_THUMBNAIL} >> /opt/seafile/seahub_settings.py
    echo THUMBNAIL_ROOT = ${SHS_THUMBNAIL_ROOT} >> /opt/seafile/seahub_settings.py
    echo THUMBNAIL_EXTENSION = ${SHS_THUMBNAIL_EXTENSION} >> /opt/seafile/seahub_settings.py
    echo THUMBNAIL_DEFAULT_SIZE = ${SHS_THUMBNAIL_DEFAULT_SIZE} >> /opt/seafile/seahub_settings.py
    echo PREVIEW_DEFAULT_SIZE = ${SHS_PREVIEW_DEFAULT_SIZE} >> /opt/seafile/seahub_settings.py
    echo "#DOCKER CONFIG DONE" >> /opt/seafile/seahub_settings.py
else
    echo "seahub_settings.py already configured. Skipped configuration"
    exit 0
fi


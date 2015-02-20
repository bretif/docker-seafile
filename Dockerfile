FROM		sudokeys/baseimage
MAINTAINER	Bertrand RETIF <bertrand@sudokeys.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	ca-certificates \
	python2.7 \
	python-setuptools \
	python-simplejson \
	python-imaging \
	sqlite3 \
	python-mysqldb 

RUN ulimit -n 30000
ENV SEAFILE_VERSION 4.0.5


RUN useradd -d /opt/seafile -m seafile
VOLUME /opt/seafile

# Config env variables
ENV AUTO_START true
ENV AUTO_CONF_DB true
ENV AUTO_CONF_NGINX false
ENV FCGI false
ENV CCNET_PORT 10001
ENV CCNET_NAME my-seafile
ENV SEAFILE_PORT 12001
ENV FILESERVER_PORT 8082
ENV MYSQL_HOST mysql-container
ENV MYSQL_PORT 3306
ENV MYSQL_USER seafileuser
ENV SEAHUB_ADMIN_EMAIL seaadmin@sea.com
ENV CCNET_DB_NAME ccnet-db
ENV SEAFILE_DB_NAME seafile-db
ENV SEAHUB_DB_NAME seahub-db
ENV SEAHUB_PORT 8000
ENV STATIC_FILES_DIR /opt/seafile/nginx/
ENV NGINX_SSL_KEY false
ENV NGINX_SSL_CERT false
ENV NGINX_URLS false
ENV SSL_BASE_DIR /etc/nginx/certs

ENV SHS_EMAIL_USE_TLS False
ENV SHS_EMAIL_HOST '127.0.0.1'
ENV SHS_EMAIL_HOST_USER False
ENV SHS_EMAIL_HOST_PASSWORD False
ENV SHS_EMAIL_PORT '25'
ENV SHS_DEFAULT_FROM_EMAIL "${SEAHUB_ADMIN_EMAIL}"
ENV SHS_SERVER_EMAIL "${SEAHUB_ADMIN_EMAIL}"
ENV SHS_REPO_PASSWORD_MIN_LENGTH 8
ENV SHS_USER_PASSWORD_MIN_LENGTH 6
ENV SHS_USER_PASSWORD_STRENGTH_LEVEL 3
ENV SHS_USER_STRONG_PASSWORD_REQUIRED False
ENV SHS_CLOUD_MODE False
ENV SHS_ENABLE_SIGNUP False
ENV SHS_ACTIVATE_AFTER_REGISTRATION False
ENV SHS_TIME_ZONE 'UTC'
ENV SHS_SITE_BASE "https://${DOMAIN}/"
ENV SHS_SITE_NAME "${NAME}"
ENV SHS_SITE_TITLE "Seafile ${CCNET_NAME}"
ENV SHS_SITE_ROOT '/'
ENV SHS_USE_PDFJS True
ENV SHS_SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER True
ENV SHS_SEND_EMAIL_ON_RESETTING_USER_PASSWD True
ENV SHS_FILE_PREVIEW_MAX_SIZE '30M'
ENV SHS_SESSION_COOKIE_AGE 1209600
ENV SHS_SESSION_SAVE_EVERY_REQUEST False
ENV SHS_SESSION_EXPIRE_AT_BROWSER_CLOSE False
ENV SHS_ENABLE_MAKE_GROUP_PUBLIC False
ENV SHS_ENABLE_THUMBNAIL True
ENV SHS_THUMBNAIL_ROOT  '/haiwen/seahub-data/thumbnail/thumb/'
ENV SHS_THUMBNAIL_EXTENSION 'png'
ENV SHS_THUMBNAIL_DEFAULT_SIZE 24
ENV SHS_PREVIEW_DEFAULT_SIZE 100

RUN mkdir -p /etc/my_init.d

#Adding all our scripts
COPY scripts/deploy-seafile.sh /etc/my_init.d/10_deploy-seafile.sh
COPY scripts/setup-seafile-mysql.sh /etc/my_init.d/20_setup-seafile-mysql.sh
COPY scripts/setup-seahub_settings.sh /etc/my_init.d/25_setup-seahub_settings.sh
COPY scripts/create_nginx_config.sh /etc/my_init.d/30_create_nginx_config.sh
COPY scripts/check_init_admin.py /root/check_init_admin.py
COPY scripts/setup-seafile-mysql.py /root/setup-seafile-mysql.py
COPY nginx.conf /root/seafile.conf

# Seafile daemons
RUN mkdir /etc/service/seafile /etc/service/seahub
COPY scripts/seafile.sh /etc/service/seafile/run
COPY scripts/seahub.sh /etc/service/seahub/run

#EXPOSE 10001 12001 8000 8082

# Baseimage init process
ENTRYPOINT ["/sbin/my_init"]


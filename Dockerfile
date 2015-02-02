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

RUN mkdir -p /etc/my_init.d

#Adding all our scripts
COPY scripts/deploy-seafile.sh /etc/my_init.d/00_deploy-seafile.sh
COPY scripts/setup-seafile-mysql.sh /etc/my_init.d/10_setup-seafile-mysql.sh
COPY scripts/create_nginx_config.sh /etc/my_init.d/20_create_nginx_config.sh
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


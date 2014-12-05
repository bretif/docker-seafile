FROM		guilhem30/sudokeys:0.1
MAINTAINER	Guilhem Berna  <guilhem.berna@gmail.com>

RUN apt-get update && apt-get install -y \
	ca-certificates \
	python2.7 \
	python-setuptools \
	python-simplejson \
	python-imaging \
	sqlite3 \
	python-mysqldb 

RUN ulimit -n 30000

ENV SEAFILE_VERSION 3.1.7
ENV autostart true
ENV autoconf true
ENV fcgi false
ENV CCNET_PORT 10001
ENV CCNET_NAME my-seafile
ENV SEAFILE_PORT 12001
ENV FILESERVER_PORT 8082
ENV EXISTING_DB false
ENV MYSQL_HOST mysql-container
ENV MYSQL_PORT 3306
ENV MYSQL_USER seafileuser
ENV SEAHUB_ADMIN_EMAIL seaadmin@sea.com
ENV CCNET_DB_NAME ccnet-db
ENV SEAFILE_DB_NAME seafile-db
ENV SEAHUB_DB_NAME seahub-db

# Interface the environment
RUN useradd -d /opt/seafile -m seafile
WORKDIR /opt/seafile
RUN curl -L -O https://bitbucket.org/haiwen/seafile/downloads/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
RUN tar xzf seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
RUN rm seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
RUN mv seafile-server* seafile-server
RUN mkdir -p logs
#RUN ln -sf /dev/stdout /opt/seafile/logs/seafile.log
RUN rm seafile-server/check_init_admin.py
RUN rm seafile-server/setup-seafile-mysql.py
#Seafile configuration at startup
RUN mkdir -p /etc/my_init.d
ADD scripts/setup-seafile-mysql.sh /etc/my_init.d/setup-seafile-mysql.sh
ADD scripts/check_init_admin.py /opt/seafile/seafile-server/check_init_admin.py
ADD scripts/setup-seafile-mysql.py /opt/seafile/seafile-server/setup-seafile-mysql.py
RUN chown -R seafile:seafile /opt/seafile

# Seafile daemons
RUN mkdir /etc/service/seafile /etc/service/seahub
ADD scripts/seafile.sh /etc/service/seafile/run
ADD scripts/seahub.sh /etc/service/seahub/run

VOLUME /opt/seafile
#EXPOSE 10001 12001 8000 8082

# Baseimage init process
ENTRYPOINT ["/sbin/my_init"]

# Clean up for smaller image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

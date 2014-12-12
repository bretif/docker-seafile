FROM		guilhem30/sudokeys
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

ENV SEAFILE_VERSION 4.0.1
ENV autostart true
ENV autoconf true
ENV fcgi true
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
ENV SEAHUB_PORT 8000
# Interface the environment
RUN useradd -d /opt/seafile -m seafile
WORKDIR /opt/seafile
RUN curl -L -O https://bitbucket.org/haiwen/seafile/downloads/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
RUN tar xzf seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
RUN rm seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz

#Move seahub dir to Volume and make symbolic link
RUN mkdir -p /var/www/seafile/${CCNET_IP}
RUN mv seafile-server-${SEAFILE_VERSION}/seahub /var/www/seafile/${CCNET_IP}/
RUN ln -s /var/www/seafile/${CCNET_IP}/seahub seafile-server-${SEAFILE_VERSION}/seahub

RUN mkdir -p logs
RUN rm seafile-server-${SEAFILE_VERSION}/check_init_admin.py
RUN rm seafile-server-${SEAFILE_VERSION}/setup-seafile-mysql.py
#Seafile configuration at startup
RUN mkdir -p /etc/my_init.d
ADD scripts/setup-seafile-mysql.sh /etc/my_init.d/setup-seafile-mysql.sh
ADD scripts/check_init_admin.py /opt/seafile/seafile-server-${SEAFILE_VERSION}/check_init_admin.py
ADD scripts/setup-seafile-mysql.py /opt/seafile/seafile-server-${SEAFILE_VERSION}/setup-seafile-mysql.py
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

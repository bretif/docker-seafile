#!/bin/bash

if [ -d /opt/seafile/seafile-server-latest ]
then
        echo "Seafile installation found."
        exit 0
else
        echo "No seafile installation found, download and extract seafile ${SEAFILE_VERSION}"
fi


cd /opt/seafile
curl -L -O https://bitbucket.org/haiwen/seafile/downloads/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
tar xzf seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz
mkdir -p logs

#Removing default seafile installation scripts to replace them with our own
rm seafile-server-${SEAFILE_VERSION}/check_init_admin.py
rm seafile-server-${SEAFILE_VERSION}/setup-seafile-mysql.py

#Replace install scripts by our unattended ones
mv /root/check_init_admin.py /opt/seafile/seafile-server-${SEAFILE_VERSION}/check_init_admin.py
mv /root/setup-seafile-mysql.py /opt/seafile/seafile-server-${SEAFILE_VERSION}/setup-seafile-mysql.py

chown -R seafile:seafile /opt/seafile


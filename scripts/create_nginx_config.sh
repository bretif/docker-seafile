#!/bin/bash
#set -e

sslBaseDir="/etc/nginx/certs"
sslFullDir="${sslBaseDir}/${CCNET_IP}"
nginxConfFile="${CCNET_IP}.conf"

[ "${autonginx}" = 'true' ] || exit 0
if [ -f /etc/nginx/sites-enabled/"${nginxConfFile}" ]
then
	echo "Nginx configuration Found, no need to create it"
else
	cd /etc/nginx/sites-enabled/
	echo "No Nginx configuration found, Creating it from the template"
	mv /root/seafile.conf ./"${nginxConfFile}"
    mkdir $sslFullDir
	export RANDFILE="${sslFullDir}"/.rnd
    openssl genrsa -out "${sslFullDir}"/$CCNET_IP.key 2048
    openssl req -new -x509 -key "${sslFullDir}"/$CCNET_IP.key -out "${sslFullDir}"/$CCNET_IP.crt -days 1825 -subj "/C=FR/ST=France/L=Paris/O=phosphore/CN=$CCNET_IP" 
	sed -i "s/#SEAFILE IP#/$SEAFILE_IP/g" "${nginxConfFile}"
	sed -i "s/#SEAHUB PORT#/$SEAHUB_PORT/g" "${nginxConfFile}"
	sed -i "s/#FILESERVER PORT#/$FILESERVER_PORT/g" "${nginxConfFile}"
	sed -i "s/#DOMAIN NAME#/$CCNET_IP/g" "${nginxConfFile}"
	sed -i 's|#SSL CERTIFICATE#|'$sslFullDir/$CCNET_IP'.crt|g' "${nginxConfFile}"
    sed -i 's|#SSL KEY#|'$sslFullDir/$CCNET_IP'.key|g' "${nginxConfFile}"
fi

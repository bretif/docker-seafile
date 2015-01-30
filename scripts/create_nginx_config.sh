#!/bin/bash

sslBaseDir="/etc/nginx/certs"
sslFullDir="${sslBaseDir}/${DOMAIN}"
nginxConfFile="${DOMAIN}.conf"

[ "${AUTO_CONF_NGINX}" = 'true' ] || exit 0

if [ ! -d /etc/nginx ]
then
	echo "Nginx directory not found! Have you mounted a volume for seafile to write nginx config ?"
	exit 1
fi
if [ -f /etc/nginx/sites-available/"${nginxConfFile}" ]
then
	echo "Nginx configuration Found, no need to create it"
else
	cd /etc/nginx/sites-available/
	echo "No Nginx configuration found, Creating it from the template"
	mv /root/seafile.conf ./"${nginxConfFile}"
	mkdir -p $sslFullDir
	export RANDFILE="${sslFullDir}"/.rnd #fix openssl error when generating certificates
	openssl genrsa -out "${sslFullDir}"/${DOMAIN}.key 2048
	openssl req -new -x509 -key "${sslFullDir}"/${DOMAIN}.key -out "${sslFullDir}"/${DOMAIN}.crt -days 1825 -subj "/C=FR/ST=France/L=Paris/O=Phosphore/CN=${DOMAIN}" 
	sed -i "s/#SEAFILE IP#/${SEAFILE_IP}/g" "${nginxConfFile}"
	sed -i "s/#SEAHUB PORT#/$SEAHUB_PORT/g" "${nginxConfFile}"
	sed -i "s/#FILESERVER PORT#/$FILESERVER_PORT/g" "${nginxConfFile}"
	sed -i "s/#DOMAIN NAME#/${DOMAIN}/g" "${nginxConfFile}"
	sed -i 's|#SSL CERTIFICATE#|'$sslFullDir/${DOMAIN}'.crt|g' "${nginxConfFile}"
	sed -i 's|#SSL KEY#|'$sslFullDir/${DOMAIN}'.key|g' "${nginxConfFile}"
	sed -i 's|#MEDIA DIR#|'${STATIC_FILES_DIR}${DOMAIN}'|g' "${nginxConfFile}"
	ln -s /etc/nginx/sites-available/"${nginxConfFile}" /etc/nginx/sites-enabled/"${nginxConfFile}"
fi


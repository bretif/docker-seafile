#!/bin/bash
#set -e

sslDir="/etc/nginx/certs"
nginxConfFile="seafile.conf"

[ "${autoconf}" = 'true' ] || exit 0
if [ -f /etc/nginx/conf.d/"${nginxConfFile}" ]
then
	echo "Configuration Found, Loading it"
else
	cd /etc/nginx/conf.d/
	echo "No configuration found, Creating it from the template"
	mv /root/seafile.conf ./"${nginxConfFile}"
        mkdir $sslDir
	export RANDFILE="${sslDir}"/.rnd
        openssl genrsa -out "${sslDir}"/$DOMAIN_NAME.key 2048
        openssl req -new -x509 -key "${sslDir}"/$DOMAIN_NAME.key -out "${sslDir}"/$DOMAIN_NAME.crt -days 1825 -subj "/C=FR/ST=France/L=Paris/O=phosphore/CN=$DOMAIN_NAME" 
	sed -i "s/#SEAFILE IP#/$SEAFILE_IP/g" "${nginxConfFile}"
	sed -i "s/#SEAHUB PORT#/$SEAHUB_PORT/g" "${nginxConfFile}"
	sed -i "s/#FILESERVER PORT#/$FILESERVER_PORT/g" "${nginxConfFile}"
	sed -i "s/#DOMAIN NAME#/$DOMAIN_NAME/g" "${nginxConfFile}"
	sed -i 's|#SSL CERTIFICATE#|'$sslDir/$DOMAIN_NAME'.crt|g' "${nginxConfFile}"
        sed -i 's|#SSL KEY#|'$sslDir/$DOMAIN_NAME'.key|g' "${nginxConfFile}"

fi


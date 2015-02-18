#!/bin/bash

SSL_FULL_DIR="${SSL_BASE_DIR}/${DOMAIN}"
NGINX_CONF_FILE="${DOMAIN}.conf"

[ "${AUTO_CONF_NGINX}" = 'true' ] || exit 0

if [ ! -d /etc/nginx ]
then
	echo "Nginx directory not found! Have you mounted a volume for seafile to write nginx config ?"
	exit 1
fi

if [ -f /etc/nginx/sites-available/"${NGINX_CONF_FILE}" ]
then
	echo "Nginx configuration Found, no need to create it"
else
	cd /etc/nginx/sites-available/
	echo "No Nginx configuration found, Creating it from the template"
	mv /root/seafile.conf ./"${NGINX_CONF_FILE}"
    if [[ -d "${SSL_FULL_DIR}" ]]; then
        echo "SSL - Use provided certificat"
        if [[ ! -f ${NGINX_SSL_CERT} ]];  then 
            echo "ERROR - No certif file ${NGINX_SSL_CERT}"
            exit 2
        fi
        if [[ ! -f ${NGINX_SSL_KEY} ]];  then 
            echo "ERROR - No key file ${NGINX_SSL_CERT}"
            exit 2
        fi
    else
        echo "SSL - Create certificate"
	    mkdir -p $SSL_FULL_DIR
        NGINX_SSL_KEY=${SSL_FULL_DIR}/${DOMAIN}-generate.key
        NGINX_SSL_CERT=${SSL_FULL_DIR}/${DOMAIN}-generate.crt
	    export RANDFILE="${SSL_FULL_DIR}"/.rnd #fix openssl error when generating certificates
	    openssl genrsa -out ${NGINX_SSL_KEY} 2048
	    openssl req -new -x509 -key ${NGINX_SSL_KEY} -out ${NGINX_SSL_CERT} -days 1825 -subj "/C=FR/ST=France/L=NIMES/O=SUDOKEYS/CN=${DOMAIN}" 
    fi 
	sed -i "s/#SEAFILE IP#/${SEAFILE_IP}/g" "${NGINX_CONF_FILE}"
	sed -i "s/#SEAHUB PORT#/$SEAHUB_PORT/g" "${NGINX_CONF_FILE}"
	sed -i "s/#FILESERVER PORT#/$FILESERVER_PORT/g" "${NGINX_CONF_FILE}"
	sed -i "s/#DOMAIN NAME#/${DOMAIN}/g" "${NGINX_CONF_FILE}"
	sed -i "s|#SSL CERTIFICATE#|${NGINX_SSL_CERT}|g" "${NGINX_CONF_FILE}"
	sed -i "s|#SSL KEY#|${NGINX_SSL_KEY}|g" "${NGINX_CONF_FILE}"
	sed -i 's|#MEDIA DIR#|'${STATIC_FILES_DIR}/${DOMAIN}'|g' "${NGINX_CONF_FILE}"
	ln -s /etc/nginx/sites-available/"${NGINX_CONF_FILE}" /etc/nginx/sites-enabled/"${NGINX_CONF_FILE}"
fi


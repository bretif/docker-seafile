#!/bin/sh

[ "${AUTO_START}" = 'true' -a -x /opt/seafile/seafile-server-latest/seafile.sh ] || exit 0

if [ `grep -c "FILE_SERVER_ROOT" /opt/seafile/seahub_settings.py` -eq 0 ] && [ "${FCGI}" = 'true' ]; then
    echo "Configure seafile for fastcgi with nginx over https"
	echo "FILE_SERVER_ROOT = 'https://${DOMAIN}/seafhttp'" >> /opt/seafile/seahub_settings.py
	sed -i "s/^SERVICE_URL.*/SERVICE_URL = https:\/\/${DOMAIN}/g" /opt/seafile/ccnet/ccnet.conf

    echo "Move seahub dir to Volume and make symbolic link"
	mkdir -p ${STATIC_FILES_DIR}/${DOMAIN}
	cp -R /opt/seafile/seafile-server-${SEAFILE_VERSION}/seahub/media ${STATIC_FILES_DIR}/${DOMAIN}
	rm -R /opt/seafile/seafile-server-${SEAFILE_VERSION}/seahub/media
	ln -s ${STATIC_FILES_DIR}/${DOMAIN}/media /opt/seafile/seafile-server-${SEAFILE_VERSION}/seahub/media

    echo "Move avatars to nginx container static volume and make symbolic link"
	rm -rf ${STATIC_FILES_DIR}/${DOMAIN}/media/avatars
	cp -rf /opt/seafile/seahub-data/avatars ${STATIC_FILES_DIR}/${DOMAIN}/media/
	rm -rf /opt/seafile/seahub-data/avatars
	ln -s ${STATIC_FILES_DIR}/${DOMAIN}/media/avatars /opt/seafile/seahub-data/avatars

	chown -R seafile:seafile ${STATIC_FILES_DIR}
	chown -h seafile:seafile /opt/seafile/seafile-server-${SEAFILE_VERSION}/seahub/media
	chown -h seafile:seafile /opt/seafile/seahub-data/avatars
fi

su -c "/opt/seafile/seafile-server-latest/seafile.sh start" seafile

# Script should not exit unless seafile died
while pgrep -f "seafile-controller" 2>&1 >/dev/null; do
	sleep 10;
done

exit 1

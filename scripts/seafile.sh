#!/bin/sh
if [ `grep -c "FILE_SERVER_ROOT" /opt/seafile/seahub_settings.py` -eq 0 ] && [ "${fcgi}" = 'true' ]; then
	echo "FILE_SERVER_ROOT = 'https://$CCNET_IP/seafhttp'" >> /opt/seafile/seahub_settings.py
	sed -i "s/^SERVICE_URL.*/SERVICE_URL = https:\/\/$CCNET_IP/g" /opt/seafile/ccnet/ccnet.conf

fi
[ "${autostart}" = 'true' -a -x /opt/seafile/seafile-server-latest/seafile.sh ] || exit 0

su -c "/opt/seafile/seafile-server-latest/seafile.sh start" seafile

# Script should not exit unless seafile died
while pgrep -f "seafile-controller" 2>&1 >/dev/null; do
	sleep 10;
done

exit 1

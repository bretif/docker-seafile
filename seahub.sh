#!/bin/sh

[ "${autostart}" = 'true' -a -x /opt/seafile/seafile-server-latest/seahub.sh ] || exit 0

if [ "${fcgi}" = 'true' ];
then
    /opt/seafile/seafile-server-latest/seahub.sh start start-fastcgi 8000 >> /opt/seafile/logs/seafile.log 2>&1
else
    /opt/seafile/seafile-server-latest/seahub.sh start >> /opt/seafile/logs/seafile.log 2>&1
fi

# Script should not exit unless seahub died
while pgrep -f "manage.py run_gunicorn" 2>&1 >/dev/null; do
	sleep 10;
done

exit 1

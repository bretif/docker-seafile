# Seafile 4 for Docker

[Seafile](http://www.seafile.com/) is a "next-generation open source cloud storage
with advanced features on file syncing, privacy protection and teamwork".

This Dockerfile is based on JensErat/docker-seafile

This Dockerfile install an environment to run seafile.
Seafile will be autoconfigurated with the default parameters and running at the container startup

## Setup Db
You can use a mysql/mariadb container or any other database you already have installed.

Run it

    docker run -d --name="mariadb" guilhem30/mariadb

Get mariadb root password

    docker logs mariadb 

## Setup Seafile

The image install seafile and configure it according to the default environment variables in the Dockerfile and the variables you give it at runtime. 

Seafile can create his own databases or it can be installed with existing (empty) ones.

In any case **you need to provide at least the IP adress of the interface to listen on and some user/password info**

If you don't choose a password it will be randomly generated if possible and written to "docker logs"

###Auto create databases with seafile
If you want seafile to automatically create databases for you, you need to provide him the root user and password.

You might also want to provide a seahub admin email if you don't want the default one

example :

    docker run -d --name "myseafile" \
      -p 10001:10001 -p 12001:12001 -p 8000:8000 -p 8082:8082 \
      --link mariadb:mysql-container \
      -e "CCNET_IP=192.168.0.100" -e "MYSQL_ROOT_USER=dataadmin" \ 
      -e "MYSQL_ROOT_PASSWORD=rootpass" -e "SEAHUB_ADMIN_EMAIL=seafileadmin@yourdomain.com" \
      guilhem30/seafile 
      

###Existing databases (no root password needed)
If you want to use existing databases you need to provide the mysql user and password for those databases and their names (or the script will look for the default ones).

:warning: Databases must be empty at seafile installation or it will crash!

For example, you could use

    docker run -d --name "myseafile" \
      -p 10001:10001 -p 12001:12001 -p 8000:8000 -p 8082:8082 \
      --link mariadb:mysql-container \
      -e "CCNET_IP=192.168.0.100" -e "EXISTING_DB=true" -e "SEAHUB_ADMIN_EMAIL=seafileadmin@yourdomain.com" \
      -e "MYSQL_USER=myseafileuser" -e "MYSQL_PASSWORD=myseafilepass" \
      guilhem30/seafile   
      
##Auto-configure Nginx
Run nginx first with a volume where you want to store static files

    docker run -d --name nginx -p 80:80 -p 443:443 -v /opt/seafile/nginx guilhem30/nginx
    
then run seafile with --volumes-from to allow it to create the configuration file, ssl certificates and copy his static files

For SEAFILE_IP you can use the static ip of the container (not very flexible), the host ip if you expose ports, or some dns discovery like skydock/skydns (used in this example)

     docker run -d --name "myseafile"  -e fcgi=true -e autonginx=true -e "CCNET_IP=myfiles.mydomain.com" \
     -e "MYSQL_ROOT_USER=root" -e "MYSQL_ROOT_PASSWORD=rootpass" \
     -e "SEAHUB_ADMIN_EMAIL=admin@yourdomain.com" -e "SEAFILE_IP=myseafile.seafile.dev.docker" \
     -e "MYSQL_HOST=mydatabase.mariadb.dev.docker" --volumes-from nginx seafile

just restart nginx after each new seafile container launch to make it reload his configuration

    docker restart nginx
    
##All configuration options      

All the environment variables and their default values

    AUTO_START :            If seafile daemons start automatically. Defaults to true
    DOMAIN :                This is the IP or domain asked by Seafile during installation. Mandatory. No defaults
    SEAHUB_ADMIN_EMAIL :    Seafile container admin email. Defaults to seaadmin@sea.com
    SEAFILE_IP :            You can use the IP of the container (not very flexible), the docker host IP if you expose ports or some DNS discovery like skydock/skydns. Mandatory for nginx conf. No defaults
    CCNET_NAME :  		    This is the server name asked by Seafile during installation. Defaults to my-seafile
    CCNET_PORT :            CCNET daemon port. Defaults to 10001
    SEAFILE_PORT : 			Seafile server port. Defaults to 12001
    FILESERVER_PORT : 		Fileserver port. Defaults to 8082
    SEAHUB_PORT 			Seahub port. Defaults to 8000
    AUTO_CONF_DB :          Create automatically DB. Need to set DB_ROOT_* variables. Defaults to true
    SEAHUB_DB_NAME :		SEAHUB database name. Defaults to seahub-db
    CCNET_DB_NAME :	    	CCNET database name. Defaults to ccnet-db
    SEAFILE_DB_NAME :		SEAFILE databse name. Defaults to seafile-db
    MYSQL_HOST :	    	IP or DNS name of mariadb/mysql host. Defaults to mysql-container
    MYSQL_PORT :            Mariadb/mysql pourt. Defaults to 3306
    MYSQL_ROOT_USER :       Mariadb/mysql root user. Defaults to root
    MYSQL_ROOT_PASSWORD :   Mariadb/mysql root password. Defaults to root
    MYSQL_USER :            Mariadb/mysql seafile container user. Defaults to seafileuser
    MYSQL_PASSWORD :        Mariadb/mysql seafile container user password. Defaults is randomly generated
    SEAHUB_ADMIN_PASSWORD : Seafile container admin email. Defaults is randomly generated
    AUTO_CONF_NGINX :       Create automatically nginx vhost. Defaults set to false
    FCGI :                  Configure seahub to run as fastcgi. Need to have reverse proxy configured. Defaults to false
    STATIC_FILES_DIR :      Where static files are stored. Defaults to /opt/seafile/nginx/


You can also configure seahub settings. Please refer to seafile doc for more details. http://manual.seafile.com/config/seahub_settings_py.html

    EMAIL_USE_TLS :         Defaults to False
    EMAIL_HOST :            Defaults to 127.0.0.1
    EMAIL_HOST_USER :       Defaults to False
    EMAIL_HOST_PASSWORD :   Defaults to False
    EMAIL_PORT :            Defaults to 25
    DEFAULT_FROM_EMAIL :    Default to $SEAHUB_ADMIN_EMAIL
    SERVER_EMAIL :          Defaults to $EMAIL_HOST_USER
    
    REPO_PASSWORD_MIN_LENGTH :      Defaults to 8
    USER_PASSWORD_MIN_LENGTH :      Defaults to 6
    USER_PASSWORD_STRENGTH_LEVEL :  Defaults to 3
    USER_STRONG_PASSWORD_REQUIRED : Defaults to False

    CLOUD_MODE :                    Default to False
    ENABLE_SIGNUP :                 Default to False
    ACTIVATE_AFTER_REGISTRATION :   Defaults to False

    TIME_ZONE :                     Defaults to UTC. http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
    SITE_BASE :                     Defaults to https://$NAME.$DOMAIN/'
    SITE_NAME :                     Defaults to $NAME
    SITE_TITLE :                    Defaults to 'Seafile $NAME'
    SITE_ROOT :                     Defaults to /
    USE_PDFJS :                     Defaults to True
    SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER :    Defaults to True
    SEND_EMAIL_ON_RESETTING_USER_PASSWD :   Defaults to  True
    FILE_PREVIEW_MAX_SIZE :                 Defaults to 30M
    SESSION_COOKIE_AGE :                    Defaults to 1209600 (2 weeks)
    SESSION_SAVE_EVERY_REQUEST :            Defaults to False
    SESSION_EXPIRE_AT_BROWSER_CLOSE :       Defaults to False
    ENABLE_MAKE_GROUP_PUBLIC :              Defaults to  False
    ENABLE_THUMBNAIL :                      Defaults to True
    THUMBNAIL_ROOT :                        Defaults to /haiwen/seahub-data/thumbnail/thumb/
    THUMBNAIL_EXTENSION :                   Defaults to png
    THUMBNAIL_DEFAULT_SIZE :                Defaults to 24
    PREVIEW_DEFAULT_SIZE :                  Defaults to 100



## Updates and Maintenance

The Seafile directory is stored in the permanent volume `/opt/seafile`. To update the base system or the seafile running options, just stop the container, update the image using `docker pull guilhem30/seafile` and run another container with autoconf disabled and the --volumes-from option

example :

    docker run -d --name "myseafile2" \
     -p 10001:10001 -p 12001:12001 -p 8000:8000 -p 8082:8082 \
     --link mariadb:mysql-container \ 
     -e "autoconf=false" \
     --volumes-from myseafile \
     guilhem30/seafile   

To update Seafile, you should start another container with the same volume mounted but also AUTO_START disabled and then follow the normal upgrade process described in the [Seafile upgrade manual](http://manual.seafile.com/deploy/upgrade.html). 

example :

    docker run -d --name "seafileUpdater" \
     -p 10001:10001 -p 12001:12001 -p 8000:8000 -p 8082:8082 \
     --link mariadb:mysql-container \ 
     -e "autoconf=false" \
     -e "AUTO_START=false" \
     --volumes-from myseafile \
     guilhem30/seafile   

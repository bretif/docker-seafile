# Seafile 3 for Docker

[Seafile](http://www.seafile.com/) is a "next-generation open source cloud storage
with advanced features on file syncing, privacy protection and teamwork".

This Dockerfile is based on JensErat/docker-seafile

This Dockerfile install an environment for running seafile including startup scripts.
You run the container and store the volume on your filesystem.

## Setup Db
You can use a mysql/mariadb container, I personally use bretif/mariadb container

Run it

    docker run -d --name="mariadb" -p 127.0.0.1:3306:3306 -e USER="root" -e PASS="$(pwgen -s -1 16)" bretif/mariadb

Get mariadb root password

    docker logs mariadb 

As seafile installer create account @locahost in db, you need to create manually user and db
From your host launch mysql client, and create users and dbs

## Setup Seafile

The image only prepares the base system and provides some support during installation. [Read through the setup manual](https://github.com/haiwen/seafile/wiki/Download-and-setup-seafile-server) before setting up Seafile.

Run the image in a container, exposing ports as needed and making `/opt/seafile` permanent. For setting seafile up, maintaining its configuration or performing updates, make sure to start a shell. As the image builds on [`phusion/baseimage`](https://github.com/phusion/baseimage-docker), do so by attaching `-- /bin/bash` as parameter.

For example, you could use

    docker run -t -i \
      -p 10001:10001 \
      -p 12001:12001 \
      -p 8000:8000 \
      -p 8082:8082 \
      --link mariadb:db \
      -v /srv/seafile:/opt/seafile \
      bretif/seafile -- /bin/bash

Consider using a reverse proxy for using HTTPs.

1. Run `/opt/seafile/seafile-server-3.*/setup-seafile-mysql.sh`, and go through the setup assistant. Do not change the port and storage location defaults, but change the run command appropriately.
The db host is 'db' thant to --link
3. Run `/opt/seafile/seafile-server-latest/seahub.sh start` for configuring the web UI.
4. If you want, do more configuration of Seafile. You can also already try it out.
5. Setting up Seafile is finished, `exit` the container.

## Running Seafile

Run the image again, this time you probably want to give it a name for using some startup scripts. You will not need an interactive shell for normal operation. **The image will autostart the `seafile` and `seahub` processes if the environment variable `autostart=true` is set.** A reasonable docker command is

    docker run -d \
      --name seafile \
      -p 10001:10001 \
      -p 12001:12001 \
      -p 8000:8000 \
      -p 8082:8082 \
      --link mariadb:db \
      -v /srv/seafile:/opt/seafile \
      -e autostart=true \
      bretif/seafile

If you want tio use a proxy, you can start seahub with fastcgi option:

    docker run -d \
      --name seafile \
      -p 10001:10001 \
      -p 12001:12001 \
      -p 8000:8000 \
      -p 8082:8082 \
      --link mariadb:db \
      -v /srv/seafile:/opt/seafile \
      -e autostart=true \
      -e fcgi=true \
      bretif/seafile


## Updates and Maintenance

The Seafile binaries are stored in the permanent volume `/opt/seafile`. To update the base system, just stop and drop the container, update the image using `docker pull bretif/seafile` and run it again. To update Seafile, follow the normal upgrade process described in the [Seafile upgrade manual](https://github.com/haiwen/seafile/wiki/Upgrading-Seafile-Server). `download-seafile` might help you with the first steps if already updated to the newest version.

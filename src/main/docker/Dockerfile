# Version 1.0.1

FROM dockeredcom/debian-oraclejdk:latest

MAINTAINER Yves Vindevogel (yves.vindevogel@asynchrone.com / yves.vindevogel@dockered.com)

ARG DEBIAN_FRONTEND=noninteractive

# All environment variables needed in scripts.
# Each one of these variable should be set using either an environment file or using environment variables.
# The variables are used in start.sh to download the sources and bake the site.
# They are also used in refresh.sh to pull the latest version of the sources and bake the site again.

ENV GIT_USER=git
ENV GIT_PASSWORD=password
ENV GIT_PROTOCOL=http
ENV GIT_REPO=git.server.net/repo.git
ENV GIT_BRANCH=master
ENV GIT_SSLVERIFY=true
ENV JBAKE_SOURCE=.
ENV JBAKE_INTERVAL="*/15 * * * *"

# Standard shell variable as found everywhere

ENV SHELL=/bin/bash

# Easy to be in /srv, where all the action will be

WORKDIR /srv

# Yves Vindevogel
# 2018-08-16
# By default, Debian installs version 1.10.3, whereas Nginx itselfs indicates that they are at 1.14.0 (stable releases).
# Therefore, using the packages provided by Nginx instead of the ones coming with Debian.

COPY ./nginx.list   /etc/apt/sources.list.d/nginx.list

# The startup script for starting nginx.

COPY ./start.sh     /srv/script/start.sh

# The refresh script. It will run periodically to do a git pull and bake the site again.
# This keeps the site up-to-date once started without the need to start the image again.

COPY ./refresh.sh   /srv/script/refresh.sh

# The nginx.conf pointing to /srv/nginx. This directory will be created by the jbake --bake command later.
# For now, it's copied to /tmp because we need to overwrite the file that will be installed by nginx with this one.

COPY ./nginx.conf   /tmp/nginx.conf

# From here on, only RUN !

# Enabling execution of the scripts we just copied.

RUN chmod +x /srv/script/start.sh
RUN chmod +x /srv/script/refresh.sh

# Installation of JBake using SDKMAN.

RUN /bin/bash -l -c "sdk install jbake"

# Installation of packages.

RUN apt-get update --yes
RUN apt-get upgrade --yes

# Supporting packages.

RUN apt-get install dialog --yes --no-install-recommends

# Installing nginx main package (version 1.14.0).

RUN apt-get install nginx --yes --no-install-recommends

# Removing the default.conf, it's no longer needed, nor even included in the nginx.conf.
# Moving our own config file in.

RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/nginx.conf
RUN mv /tmp/nginx.conf /etc/nginx/

# Installing git.

RUN apt-get install git --yes --no-install-recommends

# Installing cron to be able to run a refresh from time to time.

RUN apt-get install cron --yes --no-install-recommends

# Adding a cron job to refresh the site using a Git pull.

RUN echo "$JBAKE_INTERVAL root /srv/script/refresh.sh" > /etc/cron.d/jbake

# Default cleanup.

RUN apt-get autoremove --yes
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Default port for http.

EXPOSE 80

# Running the start script that starts nginx (not as a daemon!).
# Basically, you don't need the /bin/bash to keep the container running.
# Nginx is running and keeping the container alive.

ENTRYPOINT ["/srv/script/start.sh"]

CMD ["/bin/bash"]

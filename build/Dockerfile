FROM dockeredcom/debian-oraclejdk:latest

MAINTAINER Yves Vindevogel (yves.vindevogel@asynchrone.com / yves.vindevogel@dockered.com)

ARG DEBIAN_FRONTEND=noninteractive

ENV GIT_USER=git
ENV GIT_PASSWORD=password
ENV GIT_PROTOCOL=http
ENV GIT_REPO=git.server.net/repo.git
ENV GIT_BRANCH=master
ENV GIT_SSLVERIFY=true
ENV JBAKE_SOURCE=.
ENV JBAKE_INTERVAL="*/15 * * * *"
ENV SHELL=/bin/bash

WORKDIR /srv

COPY ./nginx.list   /etc/apt/sources.list.d/nginx.list
COPY ./start.sh     /srv/script/start.sh
COPY ./refresh.sh   /srv/script/refresh.sh
COPY ./nginx.conf   /tmp/nginx.conf

RUN set -x && \ 
    chmod +x /srv/script/start.sh && \ 
    chmod +x /srv/script/refresh.sh && \ 
    /bin/bash -l -c "sdk install jbake" && \ 
    apt-get update --yes && \ 
    apt-get upgrade --yes && \ 
    apt-get install dialog --yes --no-install-recommends && \ 
    apt-get install nginx --yes --no-install-recommends && \ 
    rm -f /etc/nginx/conf.d/default.conf && \ 
    rm -f /etc/nginx/nginx.conf && \ 
    mv /tmp/nginx.conf /etc/nginx/ && \ 
    apt-get install git --yes --no-install-recommends && \ 
    apt-get install cron --yes --no-install-recommends && \ 
    echo "$JBAKE_INTERVAL root /srv/script/refresh.sh" > /etc/cron.d/jbake && \ 
    apt-get autoremove --yes && \ 
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80

ENTRYPOINT ["/srv/script/start.sh"]

CMD ["/bin/bash"]

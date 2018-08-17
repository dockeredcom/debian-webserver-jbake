#!/bin/bash

###
#
# Yves Vindevogel
# 2018-08-16
# Version 1.0.0
#
# This script is when the server starts. It starts cron, gets the sources from Git and bakes the website.
# Finally, it launches the webserver.
#
###

# Making sure that cron is started because we need this for the refresh.sh script.

service cron start

# TODO: I could not download from gitlab.asynchrone.net, although there's a valid certificate coming from Comodo
# This is a workaround.  You can set the SSL verification to false for now, if you have an error with the git clone.

git config --global http.sslverify $GIT_SSLVERIFY

# If the directory /srv/jbake does not yet exist, clone the repo.

if [ ! -d "/srv/jbake" ]; then
    mkdir -p /srv/jbake
    git clone https://$GIT_USER:"$GIT_PASSWORD"@$GIT_REPO /srv/jbake
fi

# Make sure we have the correct branch and the latest source.
# This is also important when we restart the image.

cd /srv/jbake
git fetch
git checkout $GIT_BRANCH
git pull origin $GIT_BRANCH

# Make sure JAVA_HOME is exported (remember, we are not logged in!).

source /etc/profile.d/java.sh

# The sdkman-init script is added in the .bashrc file during installation.
# Without calling that file, jbake is not on the path.
# Which is not dramatic, but then you must hard-code the full path.

source /root/.bashrc

# Yves Vindevogel
# 2018-08-16
# The JBAKE_SOURCE allows to specify a subdirectory within the git repository where the real root of the Jbake site is.
# For my builds, this is the /src/jbake directory. I use Gradle and a project structure close to Groovy and Java
# applications. This approach is copied for Jbake projects, so sources are in /src/jbake.

jbake -b /srv/jbake/$JBAKE_SOURCE /srv/nginx

# /opt/sdkman/candidates/jbake/current/bin/jbake

# We are running and halting the nginx command here.
# This prevents the script to stop, which is what we need.
# A docker container is running as long as a command is running (hence often using docker run /bin/bash).
# See: https://stackoverflow.com/questions/18861300/how-to-run-nginx-within-a-docker-container-without-halting

/usr/sbin/nginx


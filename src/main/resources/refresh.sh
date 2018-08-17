#!/bin/bash

###
#
# Yves Vindevogel
# 2018-08-16
# Version 1.0.0
#
# This script is run from cron to update the sources from Git and bake a new site.
#
###

# TODO: Check for changes on the Git branch and exit if none are there without baking

# Make sure we have the correct branch and the latest source.

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

# Baking a new version of the site.

jbake -b /srv/jbake/$JBAKE_SOURCE /srv/nginx


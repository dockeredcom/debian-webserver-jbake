# Purpose

This image uses a combination of Nginx and Jbake to run a web server with a static site.

## 1. Flow

1. The developer works on a JBake site and commits the sources to a Git server (GitLab or GitHub, anything for Git) in a certain branch.
2. The code is checked out on start up of the image and is refreshed periodically using a cron job. 
3. The static site is baked using JBake into a certain directory.
4. Nginx serves this static directory. 

## 2. Current versions

JBake is not available on Debian Stretch, so it is installed using their preferred way: SDKMAN.  Nginx provided by Debian is also outdated, so it is installed using the repositories provided by the Nginx team. The JDK is Oracle's JDK provided by the upstream image.

- Jbake: 2.6.1.
- Nginx: 1.14.0.
- Oracle JDK: 8u181-b13 as provided by the debian-oracle image, only needed by JBake.
- Git: as provided by Debian.

## 3. Usage

### 3.1 Environment variables
This image has several environment variables that are used in the scripts to fetch data from the right repository and branch, set the location where the Jbake sources are and set the refresh timing. You can either provide them as separate environments or through an environment file when you run the image. 

```
GIT_USER=XXX
GIT_PASSWORD=YYY
GIT_PROTOCOL=https
GIT_REPO=gitlab.asynchrone.net/jbake-site-repo.git
GIT_BRANCH=master
GIT_SSLVERIFY=true
JBAKE_SOURCE=src/jbake
JBAKE_INTERVAL="*/1 * * * *"
```

##### GIT_USER

The user used to connect to the Git server (for instance GitLab). 

##### GIT_PASSWORD

The password for the user above.

##### GIT_PROTOCOL

The protocol (http or https) to connect to the Git server.

##### GIT_REPO

The URL of the repo (without the protocol).

##### GIT_BRANCH

The branch you want to checkout. This allows you to deploy a site in different environments according to the lifecycle of development (dev, qa, prod).

##### GIT_SSLVERIFY

This is a workaround for the moment used because the git clone command throws an error when connecting to some Git servers. To be solved in the future, but, if you have an authentication failure, set this to "false".

##### JBAKE_SOURCE

The root directory within your git repository where you did the "jbake -i" command. For me (vindevoy), I put my sources in /src/jbake. If you have the root directory of Jbake also as root of your repo, you can use a dot.

##### JBAKE_INTERVAL

The refresh interval for doing a Git pull and a new bake. This is a standard cron expression.  The above example refreshes the site every minute, which is most likely what you want for development but not for production.

### 3.2 Running the container

There are 2 important things to keep in mind when you run this container:

1. You must specify all the environment properties as described above.
2. You must call the /srv/script/start.sh script to start the container with (not /bin/bash). This script will pull the code, bake the site and start the Nginx server.


```
docker run --rm -t -d -p 80:80 --env-file /full-path-to/your-envionment-file.properties --name jbake1 dockeredcom/debian-webserver-jbake /srv/script/start.sh
```

# Support

This image is supported and maintained by Asynchrone.  Asynchrone is the owner of dockered.com (and user dockeredcom). If you have any problems, bugs or questions, please contact info@dockered.com or info@asynchrone.com. Asynchrone will provide the best support possible. However, as this is a free and open source image, Asynchrone cannot guarantee any timing, nor solution. If you want a higher level of support, you may want to consider a paid support option. Contact yves.vindevogel@asynchrone.com for paid support questions.

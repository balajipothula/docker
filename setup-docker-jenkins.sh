#!/bin/bash

# Author      : BALAJI POTHULA <balaji.pothula@techie.com>,
# Date        : 12 June 2019,
# Description : Installing Static Docker Binaries on Ubuntu or Redhat,
#               Installing Static Tomcat Binaries on Ubuntu or Redhat,
#               Deploying Generic Jenkins WAR into Tomcat8 App Server.

# Note: Please run this script with root privilages.

readonly DOCKER_VER=18.09.6
readonly TOMCAT_MAJOR_VER=8
readonly TOMCAT_VER=${TOMCAT_MAJOR_VER}.5.42

# uninstalling old versions of docker.
# for ubuntu uncomment below cmd.
# apt -y remove docker.io

# downloading docker static binaries.
wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VER}.tgz -O docker.tgz

# extracting docker tar ball
# and rename docker directory
# and remove docker tar ball.
tar xzf docker.tgz && mv docker .docker && rm -rf docker.tgz

# setting docker path.
export PATH="$PATH:/root/.docker"

# executing docker daemon.
dockerd &

# sleep 10 seconds.
sleep 10

# downloading tomcat static binaries.
wget https://www-us.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VER}/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz -O tomcat.tar.gz

# extracting tomcat tar ball
# renaming   tomcat directory
# removing   tomcat tar ball.
tar xzf tomcat.tar.gz && mv apache-tomcat-${TOMCAT_VER} .tomcat && rm -rf tomcat.tar.gz

# removing non essential text files.
find /root/.tomcat -maxdepth 1 -type f -delete

# removing non essential bat  files.
find /root/.tomcat/bin -maxdepth 1 -type f -name *.bat -delete

# removing non essential apps.
rm -rf /root/.tomcat/webapps/ROOT         \
       /root/.tomcat/webapps/docs         \
       /root/.tomcat/webapps/examples     \
       /root/.tomcat/webapps/host-manager \
       /root/.tomcat/webapps/manager

# downloading generic jenkins.war file.
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war -O /root/.tomcat/webapps/ROOT.war

# pulling docker image.
docker pull balajipothula/jenkins:latest

# running docker container.
docker run --name jenkins -d -i -p 8080:8080 --privileged -v /root/.tomcat:/root/.tomcat -v /root/.jenkins:/root/.jenkins -v /root/.m2:/root/.m2 balajipothula/jenkins:latest sh

# executing tomcat on container.
docker exec -i jenkins /root/.tomcat/bin/startup.sh

# jenkins initial admin password.
# cat /root/.jenkins/secrets/initialAdminPassword

#!/bin/bash

# Author      : BALAJI POTHULA <balaji.pothula@techie.com>,
# Date        : 12 June 2019,
# Description : Installing Static Docker Binaries on Ubuntu or Redhat,
#               Installing Static Tomcat Binaries on Ubuntu or Redhat,
#               Deploying  Generic Jenkins WAR into Tomcat App Server.

# Note: Please run this script with root privilages.

# uninstalling old versions of docker.
# for ubuntu uncomment below cmd.
# apt -y remove docker.io

# downloading docker static binaries.
wget https://download.docker.com/linux/static/stable/x86_64/docker-18.09.6.tgz -O docker.tgz

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
wget https://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz -O tomcat.tar.gz

# extracting tomcat tar ball
# renaming   tomcat directory
# removing   tomcat tar ball.
tar xzf tomcat.tar.gz && mv apache-tomcat-8.5.42 .tomcat && rm -rf tomcat.tar.gz

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
docker run --name jenkins -d -i -p 8080:8080 --privileged -v /root/.jenkins:/root/.jenkins -v /root/.tomcat:/root/.tomcat balajipothula/jenkins:latest sh

# executing tomcat on container.
docker exec -i jenkins /root/.tomcat/bin/startup.sh

# sleep 10 seconds.
sleep 10

# echo statement.
echo "$(tput setaf 2)jenkins admin password $(tput sgr 0)"

# jenkins initial admin password.
cat /root/.jenkins/secrets/initialAdminPassword

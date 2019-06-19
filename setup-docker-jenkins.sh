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

readonly ROOT=/root
readonly DOCKER_ROOT=${ROOT}/.docker
readonly TOMCAT_ROOT=${ROOT}/.tomcat
readonly M2_ROOT=${ROOT}/.m2
readonly JENKINS_ROOT=${ROOT}/.jenkins
readonly PROFILE=${ROOT}/.profile

# uninstalling old versions of docker.
# for ubuntu uncomment below cmd.
apt -y remove docker.io

# downloading docker static binaries.
wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VER}.tgz -O ${ROOT}/docker.tgz

# extracting docker tar ball
# and rename docker directory
# and remove docker tar ball.
tar xzf ${ROOT}/docker.tgz && mv ${ROOT}/docker ${ROOT}/.docker && rm -rf ${ROOT}/docker.tgz

# setting docker path.
export PATH="$PATH:${DOCKER_ROOT}"

# setting docker path permanently.
echo 'export PATH="$PATH:/root/.docker"' >> ${PROFILE}

# loading docker path in current shell
source ${PROFILE}

# executing docker daemon.
dockerd &

# sleep 10 seconds.
sleep 10

# downloading tomcat static binaries.
wget https://www-us.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VER}/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz -O ${ROOT}/tomcat.tar.gz

# extracting tomcat tar ball
# renaming   tomcat directory
# removing   tomcat tar ball.
tar xzf ${ROOT}/tomcat.tar.gz && mv ${ROOT}/apache-tomcat-${TOMCAT_VER} ${TOMCAT_ROOT} && rm -rf ${ROOT}/tomcat.tar.gz

# removing non essential text files.
find ${TOMCAT_ROOT} -maxdepth 1 -type f -delete

# removing non essential bat  files.
find ${TOMCAT_ROOT}/bin -maxdepth 1 -type f -name *.bat -delete

# removing non essential apps.
rm -rf ${TOMCAT_ROOT}/webapps/ROOT         \
       ${TOMCAT_ROOT}/webapps/docs         \
       ${TOMCAT_ROOT}/webapps/examples     \
       ${TOMCAT_ROOT}/webapps/host-manager \
       ${TOMCAT_ROOT}/webapps/manager

# downloading generic jenkins.war file.
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war -O ${TOMCAT_ROOT}/webapps/ROOT.war

# pulling docker image.
docker pull balajipothula/jenkins:latest

# running docker container.
docker run --name jenkins -d -i -p 8080:8080 --privileged -v ${TOMCAT_ROOT}:${TOMCAT_ROOT} -v ${JENKINS_ROOT}:${JENKINS_ROOT} -v ${M2_ROOT}:${M2_ROOT} balajipothula/jenkins:latest sh

# executing tomcat on container.
docker exec -i jenkins ${TOMCAT_ROOT}/bin/startup.sh

# jenkins initial admin password.
# cat /root/.jenkins/secrets/initialAdminPassword

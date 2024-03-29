#!/bin/bash

# Author      : BALAJI POTHULA <balaji.pothula@techie.com>,
# Date        : 12 June 2019,
# Description : Installing Static Docker Binaries on Ubuntu.

# Note: Please run this script with root privilages.

# uninstalling old versions of docker.
apt-get -y remove docker docker-engine docker.io

# updating apt package index.
apt-get update

# updating apt package index.
apt-get -y dist-upgrade

# installing packages to allow apt to use repository over https.
apt-get -y install apt-transport-https \
                   ca-certificates     \
                   curl                \
                   software-properties-common

# adding docker official gpg key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# verifying gpg key.
#apt-key fingerprint 0EBFCD88

# deleting old docker gpg key(s).
#apt-key del 2C52609D

# setting up the stable docker repository.
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# updating apt package index.
apt-get update

# installing latest version of docker ce.
apt-get -y install docker-ce

# installing specific version of docker ce
#apt-get -y install docker-ce='17.12.0~ce-0~ubuntu'

# running docker as non-sudoer.
usermod -a -G docker $USER

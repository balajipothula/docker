#!/bin/bash

# Author      : BALAJI POTHULA <balaji.pothula@techie.com>,
# Date        : 31 August 2016,
# Description : Setup Tomcat8.

wget http://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz -O $HOME/root/tomcat.tar.gz && \
tar xzf $HOME/root/tomcat.tar.gz -C $HOME/root/                                                                                && \
mv $HOME/root/apache-tomcat-8.5.42 $HOME/root/.tomcat                                                                          && \
rm -rf $HOME/root/tomcat.tar.gz                                                                                                && \
find $HOME/root/.tomcat -maxdepth 1 -type f -delete                                                                            && \
find $HOME/root/.tomcat/bin -maxdepth 1 -name "*.bat" -type f -delete                                                          && \
rm -rf $HOME/root/.tomcat/webapps/docs $HOME/root/.tomcat/webapps/examples $HOME/root/.tomcat/webapps/host-manager

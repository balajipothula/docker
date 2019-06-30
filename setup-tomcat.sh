#!/bin/bash

# Author      : BALAJI POTHULA <balaji.pothula@techie.com>,
# Date        : 31 August 2016,
# Description : Setup Tomcat8.

wget http://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz  && \
tar xzf apache-tomcat-8.5.42.tar.gz                                                                 && \
mv apache-tomcat-8.5.42 /root/.tomcat                                                               && \
rm -rf apache-tomcat-8.5.42.tar.gz                                                                  && \
find /root/.tomcat -maxdepth 1 -type f -delete                                                      && \
find /root/.tomcat/bin -maxdepth 1 -name "*.bat" -type f -delete                                    && \
rm -rf /root/.tomcat/webapps/docs /root/.tomcat/webapps/examples /root/.tomcat/webapps/host-manager

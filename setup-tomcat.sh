FROM alpine:3.9
RUN apk update && apk upgrade && apk add --no-cache openjdk8-jre tomcat-native && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*
VOLUME /root/.tomcat
CMD ["/root/.tomcat/bin/catalina.sh", "run"]

docker build -t balajipothula/tomcat:openjdk8-jre .

mkdir root

curl http://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz -o $HOME/root/tomcat.tar.gz &&
tar xzf $HOME/root/tomcat.tar.gz -C $HOME/root/                                                                                &&
mv $HOME/root/apache-tomcat-8.5.42 $HOME/root/.tomcat                                                                          &&
rm -rf $HOME/root/tomcat.tar.gz                                                                                                &&
find $HOME/root/.tomcat -maxdepth 1 -type f -delete                                                                            &&
find $HOME/root/.tomcat/bin -maxdepth 1 -name "*.bat" -type f -delete                                                          &&
rm -rf $HOME/root/.tomcat/webapps/docs $HOME/root/.tomcat/webapps/examples $HOME/root/.tomcat/webapps/host-manager

docker run --name tomcat -d -i --privileged --restart always -p 8080:8080 -v $HOME/root/.tomcat:/root/.tomcat balajipothula/tomcat:openjdk8-jre

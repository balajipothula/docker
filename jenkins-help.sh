curl http://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz -o $HOME/root/tomcat.tar.gz && \
tar xzf $HOME/root/tomcat.tar.gz -C $HOME/root/                                                                                && \
mv $HOME/root/apache-tomcat-8.5.42 $HOME/root/.tomcat                                                                          && \
rm -rf $HOME/root/tomcat.tar.gz                                                                                                && \
find $HOME/root/.tomcat -maxdepth 1 -type f -delete                                                                            && \
find $HOME/root/.tomcat/bin -maxdepth 1 -name "*.bat" -type f -delete                                                          && \
rm -rf $HOME/root/.tomcat/webapps/docs $HOME/root/.tomcat/webapps/examples $HOME/root/.tomcat/webapps/host-manager

curl -L https://updates.jenkins-ci.org/latest/jenkins.war -o $HOME/root/.tomcat/webapps/ROOT.war

docker pull balajipothula/jenkins:openjdk8

docker run --name jenkins -d -i --privileged --restart always -p 8080:8080 -v $HOME/root/.tomcat:/root/.tomcat -v $HOME/root/.jenkins:/root/.jenkins -v $HOME/root/.m2:/root/.m2 balajipothula/jenkins:openjdk8

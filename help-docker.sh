#!/bin/bash

# Author      : BALAJI POTHULA <balaji.pothula@techie.com>
# Date        : 21 JUNE 2018,
# Description : Docker commands

# Creating or Building image from Dockerfile.
# username/repo:tag.
docker build -t balajipothula/webapp:3.9 .

# reTagging docker image.
# username/repo:tag.
docker tag 30fb3a7c5f75 balajipothula/webapp:3.9
docker tag balajipothula/webapp:3.9 balajipothula/webapp:RC3.9

# Saving docker image offline into local machine.
docker save -o webapp-3.9.docker balajipothula/webapp:3.9
docker save balajipothula/webapp:3.9 -o webapp-3.9.docker

# Exporting docker container as docker image.
docker export webapp_container > webapp_3.9.docker

# Loading offline docker image into machine.
docker load -i webapp-3.9.docker

# Commiting docker image from existing container.
docker container commit container_id balajipothula/webapp:3.9.1

# Commiting docker image entry point.
docker container commit --change='CMD ["ash"]' webapp:3.9

# Running temporary container.
docker run --name webapp_3_9 -i -t balajipothula/webapp:3.9
docker container run --name webapp --network host --detached --tty busybox

# Running docker container with auto restart volume(-v) stdin(-i) daemon(-d) with port(-p) 8080.
# (It will create a volume inside the container)
docker run --name jenkins -d -i --privileged --restart always -p 8080:8080 -v $HOME/root/.tomcat:/root/.tomcat -v $HOME/root/.jenkins:/root/.jenkins -v $HOME/root/.m2:/root/.m2 balajipothula/jenkins:2.176.1

# Running docker container with volume(-v) stdin(-i) daemon(-d) with port(-p) 80, 443.
# (It will create a volume inside the container)
docker run --name webapp -d -i -p 80:80 -p 443:443 --privileged -v `pwd`/webapp:/webapp balajipothula/webapp:3.9 sh

# Running docker container with volume(-v) stdin(-i) daemon(-d) with port(-p) 8080.
# (It will create a volume inside the container)
docker run --name jenkins -d -i -p 8080:8080 --privileged -v /root/.jenkins:/root/.jenkins -v /root/.m2:/root/.m2 -v /root/.tomcat:/root/.tomcat balajipothula/jenkins:latest sh

# Executing docker container by name with stdin(-i), tomcat process.
docker exec -i jenkins /root/.tomcat/bin/startup.sh

# Executing docker container by name with stdin(-i), nginx process with config file.
docker exec -i webapp nginx -c /webapp/nginx/conf/nginx.conf

# Executing docker container by name with stdin(-i), nginx process with config file
# and Reloading nginx process.
docker exec -i webapp nginx -c /webapp/nginx/conf/nginx.conf -s reload

# Executing docker container by name with stdin(-i), redis process with config file. 
docker exec -i webapp redis-server /webapp/redis/conf/redis.conf

# Login into docker container.
docker exec -i -t webapp sh

# Executing redis-cli on docker container.
docker exec -i -t webapp redis-cli

# Starting docker container with name.
docker start webapp

# Stoping docker container with name.
docker stop webapp

# Running health check container.
docker run --name health_checker -d -t --health-cmd "curl --fail 127.0.0.1" --health-interval=5s --health-retries=1 busybox sh

# Removing dangling / untagged docker images.
docker image prune
# Removing dangling / unmapped docker images with containers.
docker image prune -a

# Docker bridge.
docker network ls
docker network create --driver bridge webapp_bridge
docker network inspect webapp_bridge
docker container run --name webapp --network webapp_bridge --detached --tty busybox:latest

# Docker swarm initialisation.
docker swarm init --advertise-addr 142.93.214.57
docker service create --name high_availability_webapp --replicas 3 balajipothula/webapp:3.9
docker service scale high_availability_webapp=6
docker node ls
docker service ls
docker service ps high_availability_webapp
docker service rm high_availability_webapp

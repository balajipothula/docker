#!/bin/bash

# Author      : BALAJI POTHULA <balaji.pothula@techie.com>
# Date        : 21 JUNE 2018,
# Description : Docker commands

# Creating or Building image from Dockerfile.
# username/repo:tag.
docker build -t balajipothula/webapp:3.9 .

# Saving docker image offline into local machine.
docker save -o webapp-3.9.docker balajipothula/webapp:3.9

# Loading offline docker image into machine.
docker load -i webapp-3.9.docker

# Running temporary container.
docker run --name webapp_3_9 -i -t balajipothula/webapp:3.9

# Running docker image with volume(-v) stdin(-i) daemon(-d) with port(-p) 80, 443.
# (It will create a volume inside the container)
docker run --name webapp -d -i -p 80:80 -p 443:443 --privileged -v `pwd`/webapp:/webapp balajipothula/webapp:3.9 sh

# Running docker image with volume(-v) stdin(-i) daemon(-d) with port(-p) 8080.
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

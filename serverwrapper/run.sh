#!/bin/bash

#set -e

wrapdocker
cd /source/server
docker rm -fv $(docker ps -qa)
docker build -t nodeserver .
docker run  -d --net=host --name=nodeserver -d nodeserver
while sleep 10
do
    docker logs -f nodeserver
done
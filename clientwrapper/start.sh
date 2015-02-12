#!/bin/bash

wrapdocker
cd /source/client/
docker rm -fv $(docker ps -qa)
docker build -t client .
docker rm -fv client
docker run -d --net=host --name=client client
#docker run -d -v /var/run/docker.sock:/var/run/docker.sock --name=client client

while sleep 10
do
    docker logs -f client
done
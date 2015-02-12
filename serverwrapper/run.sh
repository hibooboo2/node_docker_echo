#!/bin/bash

#set -e

wrapdocker
cd $(dirname $0)/
ls
cd ./server
docker build -t nodeserver .
docker run  -d --net=host --name=nodeserver -d nodeserver
while sleep 10
do
    docker logs -f nodeserver
done
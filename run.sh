#!/bin/bash

#set -e

wrapdocker
cd $(dirname $0)/
ls
cd ./Server
docker build -t nodeserver .
docker run  -d --net=host --name=nodeserver -p 8000:8000 -d nodeserver
docker images
count=0
while sleep 10
do
    echo $count
    count=$(($count + 1))
done
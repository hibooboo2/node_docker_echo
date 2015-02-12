#!/bin/bash

wrapdocker
cd /source/client/
docker build -t client .
docker rm -fv client
docker run -it --rm --net=host -p 8000:8000 --name=client client
#docker run -d -v /var/run/docker.sock:/var/run/docker.sock --name=client client

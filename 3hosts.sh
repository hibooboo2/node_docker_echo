#!/bin/bash

set -e

CMDS="jq docker"

for i in $CMDS
do
        # command -v will return >0 when the $i is not found
	which $i >/dev/null && continue || { echo "$i command not found."; exit 1; }
done

function node_server(){
#the magic to determine if cattle server needs to be run restarted or rebuilt.
    if [[ $(docker inspect nodeserver | jq -r .[0].Name) != "/nodeserver" ]]; then
        docker rm -fv nodeserver | echo > /dev/null
        docker create --privileged -v /var/lib/docker:/var/lib/docker -p 8000:8000 --name=nodeserver nodeserver
    else
        docker rm -fv nodeserver | echo > /dev/null
        docker create --privileged -v /var/lib/docker:/var/lib/docker -p 8000:8000 --name=nodeserver nodeserver
    fi
}

function create_clients(){
    for i in {1..3}
    do
        docker rm -vf nodeclient$i  | echo > /dev/null
        docker create -e HOSTNAME=nodeclient$i --link=nodeserver:server --name=nodeclient$i nodeclient
    done
}

function start_stuff(){
    docker restart nodeserver
    docker restart nodeclient1 nodeclient2 nodeclient3
    
}

cd $(dirname $0)
docker build -t nodeserver .
cd client/
docker build -t nodeclient .
node_server
create_clients
start_stuff
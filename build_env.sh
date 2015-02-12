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
    if [[ $(docker inspect nodeservercont | jq -r .[0].Name) != "/nodeservercont" ]]; then
        docker rm -fv nodeservercont | echo > /dev/null
        docker create -v ~/sandbox/nodeservercont:/var/lib/docker --privileged -p 8000:8000 --name=nodeservercont nodeservercont
    else
        docker rm -fv nodeservercont | echo > /dev/null
        docker create -v ~/sandbox/nodeservercont:/var/lib/docker --privileged -p 8000:8000 --name=nodeservercont nodeservercont
    fi
}

function create_clients(){
    for i in {1..3}
    do
        docker rm -vf clientwrapper$i  | echo > /dev/null
        docker create -e HOSTNAME=clientwrapper$i --privileged -v ~/sandbox/clientwrapper$i:/var/lib/docker --link=nodeservercont:server --name=clientwrapper$i clientwrapper
    done
}

function start_stuff(){
    docker restart nodeservercont
    docker restart clientwrapper1 clientwrapper2 clientwrapper3
    
}

cd $(dirname $0)
cd serverwrapper/
docker build -t nodeservercont .
cd ..
cd wrapper/
docker build -t clientwrapper .
cd ..
node_server
create_clients
start_stuff

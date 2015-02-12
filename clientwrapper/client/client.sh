#!/bin/bash

while sleep 1
do 
    curl server:8000/$HOSTNAME
done

#!/bin/bash

count=0
while sleep 1
do
    echo $count
    count=$(($count + 1))
done
#!/bin/bash

#Home Directory of Dockerfile for slave container
SlaveHome=$1

#Home Directory of Dockerfile for slave container
MasterHome=$2

cd $SlaveHome
docker build -t jmeterslave .

cd $MasterHome
docker build -t jmetermaster .



#Run docker slave container1
docker run --name jmeterslave1 -d jmeterslave

#Run docker container2
docker run --name jmeterslave2 -d jmeterslave

export a=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave1 )
export b=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave2 )

docker run --name jmetermasternew -d -v /reports:/reports -e IP=$a,$b jmetermaster

#cp /reports/reportnew.xml  $WORKSPACE





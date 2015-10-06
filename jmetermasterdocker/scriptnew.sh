#!/bin/bash


#export host=$2
export workspace=$1
#export users=$3
#export count=$4
#export hostip=$5

docker pull www.cybage-docker-registry.com:9080/jmeterslave
docker pull www.cybage-docker-registry.com:9080/jmetermaster


#Run docker slave container1
docker run --name jmeterslave1 -d www.cybage-docker-registry.com:9080/jmeterslave

#Run docker container2
docker run --name jmeterslave2 -d www.cybage-docker-registry.com:9080/jmeterslave



export a=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave1 )
export b=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave2 )
export host=dev.alm-task-manager.com
#docker build -t jmetergenericmaster .
#docker build -t jmetergenericmaster .
docker run --name jmetermaster -d -v /reports:/reports -e IP=$a,$b  www.cybage-docker-registry.com:9080/jmetermaster

ls /reports

cp /reports/reportnew.xml  $1





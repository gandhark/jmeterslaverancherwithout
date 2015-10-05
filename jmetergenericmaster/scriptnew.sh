#!/bin/bash

docker pull www.cybage-docker-registry.com:9080/jmeterslave
#docker pull www.cybage-docker-registry.com:9080/jmetergenericmaster


#Run docker slave container1
docker run --name jmeterslave1 -d www.cybage-docker-registry.com:9080/jmeterslave

#Run docker container2
docker run --name jmeterslave2 -d www.cybage-docker-registry.com:9080/jmeterslave



export a=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave1 )
export b=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave2 )
#export host=dev.alm-task-manager.com
export host=$2
#docker build -t jmetergenericmaster .
docker build -t jmetergenericmaster .
docker run --name jmetergenericmaster -d -v /reportsgeneric:/reportsgeneric -e IP=$a,$b -e host=$host jmetergenericmaster
ls /reportsgeneric

cp /reports/reportnew.xml  $1





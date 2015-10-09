#!/bin/bash

export workspace=$1

docker pull www.cybage-docker-registry.com:9080/jmeterslave
docker pull www.cybage-docker-registry.com:9080/jmetermaster



for(i=0;i<$2;i++)
do

#Run docker slave container$i
docker run --name jmeterslave$i -d www.cybage-docker-registry.com:9080/jmeterslave


echo "fetching slave containers IP and storing it into variable a and variable b";
export ip$i=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave1 )
export host=dev.alm-task-manager.com

done;


#docker run --name jmetermaster -d -v $workspace:/reports -e IP=$a,$b  www.cybage-docker-registry.com:9080/jmetermaster






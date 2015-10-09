#!/bin/bash

export workspace=$1
export number=$2
docker pull www.cybage-docker-registry.com:9080/jmeterslave
docker pull www.cybage-docker-registry.com:9080/jmetermaster

echo $2;




#echo "fetching slave containers IP and storing it into variable a and variable b";
#export ip$i=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave1 )
#export host=dev.alm-task-manager.com

#done;



a=0

while [ $a -lt $2 ]
do
  echo $a
  docker run --name jmeterslave$a -d www.cybage-docker-registry.com:9080/jmeterslave

   a=`expr $a + 1`


#echo "fetching slave containers IP and storing it into variable a and variable b";
#export ip$i=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave1 )
#export host=dev.alm-task-manager.com

done







#docker run --name jmetermaster -d -v $workspace:/reports -e IP=$a,$b  www.cybage-docker-registry.com:9080/jmetermaster






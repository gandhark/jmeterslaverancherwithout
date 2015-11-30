#!/usr/bin/env bash

export workspace=$1
export baseURL=$2

echo Building test container image

#docker build -t selenium/test:local ./Test
#pulling latest image of selenium test local


docker pull www.cybage-docker-registry.com:9080/selenium_test


echo '\n\n*****Starting Selenium Hub Container...*****\n'
HUB=$(docker run -d selenium/hub:2.47.1)
HubURL=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $HUB )


HUB_NAME=$(docker inspect -f '{{ .Name  }}' $HUB | sed s:/::)
echo '\n\n*****Waiting for Hub to come online...*****\n'
docker logs -f $HUB &
sleep 2


echo '\n*****Starting Selenium Chrome node...*****\n'
NODE_CHROME=$(docker run -d --link $HUB_NAME:hub  selenium/node-chrome$DEBUG:2.47.1)
ipCHROME_NODE=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $NODE_CHROME )


echo '\n\n*****Starting Selenium Firefox node...*****\n'
NODE_FIREFOX=$(docker run -d --link $HUB_NAME:hub selenium/node-firefox$DEBUG:2.47.1)
ipFIREFOX_NODE=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $NODE_FIREFOX )


docker logs -f $NODE_CHROME &
docker logs -f $NODE_FIREFOX &
echo '\n******Waiting for nodes to register and come online...******'
sleep 3s


echo "\n\n\n*************************************calling function firefox*****************************************\n"
echo 'Calling function test_node_firefox'

 test_node_firefox
 {
  BROWSER=firefox
  echo Running $BROWSER test...

SEARCH1="172.27.59.27"
REPLACE1="$HubURL"
sed -i "s%${SEARCH1}%${REPLACE1}%g"  ../selenium_javaTests/src/com/test/TitleCheck_FireFox.java
sed -i "s%${SEARCH1}%${REPLACE1}%g"  ../selenium_javaTests/src/com/test/TitleCheck_Chrome.java


SEARCH2="127.0.0.1"
REPLACE2="$baseURL"
sed -i "s%${SEARCH2}%${REPLACE2}%g"  ../selenium_javaTests/src/com/test/TitleCheck_FireFox.java
sed -i "s%${SEARCH2}%${REPLACE2}%g"  ../selenium_javaTests/src/com/test/TitleCheck_Chrome.java

cd ./../selenium_javaTests/

echo "***********************************************"



docker run --name seleniumlocal -d -e CONT=FireFoxDriver --link $HUB_NAME:hub -v $workspace/selenium_grid/selenium_javaTests:/opt www.cybage-docker-registry.com:9080/selenium_test


STATUS=$?
  TEST_CONTAINER_firefox=$(docker ps -aq | head -1)

  if [ ! $STATUS = 0 ]; then

   echo Failed
    exit 1
  fi


    echo "\n\n**************logs of TEST_CONTAINER_FIREFOX**************"
    docker logs -f $TEST_CONTAINER_firefox | tee test_local_firefox.log
    echo "**********************************************************"


     echo Removing the test container firefox
     docker stop $TEST_CONTAINER_firefox
     docker rm $TEST_CONTAINER_firefox

}

echo '**************************************end of function Firefox****************************************'


echo '\n\n\n***********************************calling function Chrome*****************************************\n'
echo 'calling function test_node_chrome'



test_node_chrome
 {
 BROWSER=chrome
  echo Running $BROWSER test...



docker run --name seleniumlocal -d -e CONT=ChromeDriver --link $HUB_NAME:hub -v $workspace/selenium_grid/selenium_javaTests:/opt www.cybage-docker-registry.com:9080/selenium_test

  STATUS=$?
  TEST_CONTAINER_chrome=$(docker ps -aq | head -1)

  if [ ! $STATUS = 0 ]; then
    echo Failed
    echo '*****************'
    exit 1
  fi


    echo "\n\n**************logs of TEST_CONTAINER_CHROME**************"
    docker logs -f $TEST_CONTAINER_chrome | tee test_local_chrome.log
    echo "**********************************************************"

    echo Removing the test container chrome
    docker stop $TEST_CONTAINER_chrome
    docker rm $TEST_CONTAINER_chrome

        }
echo "*******************************end of function Chrome*******************************************\n"



#echo '*************************************** Stopping and removing  node containers *******************************************'


echo '\n\n*************************************** logs of CHROME node container *******************************************'
  docker logs $NODE_CHROME | tee node_chrome.log
  echo '\nTearing down Selenium Chrome Node container *** Chrome node down ***\n'
  docker stop $NODE_CHROME
  docker rm $NODE_CHROME


echo '\n\n*************************************** logs of FIREFOX node container *******************************************'
  docker logs $NODE_FIREFOX | tee node_firefox.log
  echo '\nTearing down Selenium Firefox Node container *** FireFox node down ***\n'
  docker stop $NODE_FIREFOX
  docker rm $NODE_FIREFOX


echo '\n\n*************************************** logs of HUB container *******************************************'
  docker logs $HUB | tee hub.log
  echo '\n***  At last removing hub  ***'
 docker stop $HUB
  docker rm $HUB


echo '\nDone'
echo '\n\n\n*******************************************end of script******************************************'


#!/bin/bash


echo $IPADDRESS;
cd $WORKSPACE


echo "\n Application hosted on ";
echo $IPADDRESS;
echo "\n starting Selenium Test cases using Selenium Grid on Docker "
cd $WORKSPACE/selenium_grid

sudo cp TitleCheck_Chrome.java selenium_javaTests/src/com/test
sudo cp TitleCheck_FireFox.java selenium_javaTests/src/com/test


cd $WORKSPACE/selenium_grid/docker_selenium


echo "providing permissions"
sudo chmod +x test.sh


sudo sh test.sh $WORKSPACE $IPADDRESS

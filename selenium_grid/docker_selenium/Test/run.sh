#!/bin/sh

echo $TEST_CMD
#mkdir $TEST_CMD
cd /opt
ls
ant -version


echo "**********************Running FIREFOX Test  cases using ANT inside test:local container*************************"
ant FireFoxDriver
echo "**********************************************************************************************************"


	echo "**********************Running Chrome Test  cases using ANT inside test:local container*************************"
ant ChromeDriver
echo "**********************************************************************************************************"




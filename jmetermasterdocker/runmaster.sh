#!/bin/sh
service apache2 restart
 cd /usr/share/jmeter/bin

rm jmeter.properties

cp /jmeter.properties .


SEARCH="remote_hosts=172.17.0.140"
REPLACE="remote_hosts=$IP,127.0.0.1"
mkdir $REPLACE
mkdir $IP
sed -i "s/$SEARCH/$REPLACE/g" ./jmeter.properties
 pwd
echo "172.27.59.35 dev.alm-task-manager.com" >> /etc/hosts

cd /
echo "executing jmeter test cases";
jmeter -n -t url-benchmarknew.jmx -l /reports/reportnew.xml -r

sleep 400s;
cd /usr/share/jmeter/bin
cp jmeter-server jmeter-server.sh
 chmod +x jmeter jmeter-server *.sh
 sh jmeter-server.sh


#!/bin/sh
service apache2 restart
cd /usr/share/jmeter/bin
rm jmeter.properties
cp /jmeter.properties .


SEARCH="remote_hosts=172.17.0.140"
REPLACE="remote_hosts=$IP"

#ost=dev.alm-task-manager.com

echo  $REPLACE
echo $IP
echo $host


sed -i "s/$SEARCH/$REPLACE/g" ./jmeter.properties
 pwd
echo "172.27.59.35 dev.alm-task-manager.com" >> /etc/hosts

cd /
#rm -rf reports
#mkdir $IP1
#echo "remote_hosts=16.10.0.13,16.10.13.14">>/usr/share/bin/

jmeter -n -t url-benchmarknew.jmx -Jusers=50 -Jcount=10 -Jhost=$host -l /reportsgeneric/reportgeneric.xml


cd /usr/share/jmeter/bin
cp jmeter-server jmeter-server.sh
 chmod +x jmeter jmeter-server *.sh
 sh jmeter-server.sh


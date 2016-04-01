#!/bin/bash

#2016-03-31 10:11
service mysqld status > /home/sh/temp_1
cat /home/sh/temp_1
if [ -z "`grep -w "running" /home/sh/temp_1`" ];then
	echo "---start sql--- " 
	service mysqld start 
else
	echo -e "\e[1;31m ---keep sql running---\e[0m"
fi

#service mysqld status >/home/sh/result.txt
echo 
echo

echo -e "\e[1;31m----ready to start hadoop---\e[0m"
kdestroy
/home/sh/hadoop_start.sh

kdestroy
#only gateway start Sentry
if [ "`hostname`" = "gateway.bdsm.cmcc" ];then
	echo "---ready to start Sentry---"
	/opt/apache-bdsmsentry-0.8-bin/bin/sentry --log4jConf /opt/apache-bdsmsentry-0.8-bin/conf/sentry-log4j.properties --command service --conffile /opt/apache-bdsmsentry-0.8-bin/conf/sentry-site.xml& 

#	cat /home/sh/temp_2 >>/home/sh/result.txt
#	if [ -z "`grep -w "Commit Succeeded" /home/sh/temp_2`" ];then
#		echo -e "\e[1;31m ---Failed to start Sentry---\e[0m"
#	else
#		echo -e "\e[1;31m ---keep Sentry running---\e[0m"
#	fi
fi

echo "---start hive:---"
hive --service hiveserver2&
echo -e "\e[1;31m ---hive is running---\e[0m"

ps aux |grep sentry >/home/sh/temp_3
#cat /home/sh/temp_3>>/home/sh/result.txt


rm -f /home/sh/temp_1
rm -f /home/sh/result.txt
rm -f /home/sh/temp_3

#echo -e "\e[1;31m---sleep 30s---\e[0m"
#sleep 30

if [ "`hostname`" = "gateway.bdsm.cmcc" ];then

	echo -e "\e[1;31m---sleep 30s---\e[0m"
	sleep 30
	ps aux | grep hive >/home/sh/temp_4
	ps aux | grep sentry >/home/sh/temp_5
	
	if [ -z "`grep -w "org.apache.hive.service.server.HiveServer2" /home/sh/temp_4`" ] || [ -z "`grep -w "/opt/apache-bdsmsentry-0.8-bin/conf/sentry-site.xml" /home/sh/temp_5`" ];then
		echo -e "\e[1;31m---Failed to start sentry or hive---\e[0m"	
	fi

	rm -f /home/sh/temp_4
	rm -f /home/sh/temp_5

	login.sh
fi

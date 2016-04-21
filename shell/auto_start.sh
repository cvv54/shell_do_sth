#!/bin/bash

service mysqld status > ./temp_1
cat ./temp_1
if [ -z "`grep -w "running" ./temp_1`" ];then
	echo "---start sql--- " 
	service mysqld start 
else
	echo -e "\e[1;31m ---keep sql running---\e[0m"
fi

#service mysqld status >./result.txt
echo 
echo

echo -e "\e[1;31m----ready to start hadoop---\e[0m"
kdestroy
function start_dfs()
{
	for((i=1;i<3;i++))
	{
		echo "!!!!!!!!!!------------Try to start dfs '$i'th time(s)-----------"
		/opt/hadoop-2.6.0/sbin/start-dfs.sh

		jps >./123.txx

		#"grep -w" means that exactly match
		if [ -z "`grep -w "NameNode" ./123.txx`" ] || [ -z "`grep -w "SecondaryNameNode" ./123.txx`" ] || [ -z "` grep -w "Jps" ./123.txx`" ]; then
        		echo -e "\e[1;31m !!!!!!!!!!-----------some process start failed----------------\e[0m"
       			/opt/hadoop-2.6.0/sbin/stop-dfs.sh
        		echo "!!!!!!!!!!-----------------restart dfs-----------------------"
        		/opt/hadoop-2.6.0/sbin/start-dfs.sh
		else
			echo "!!!!!!!!!!----out of loop--------"
			break
		fi
	}
	
	if [ $i -eq 3 ] ;then
		echo -e "\e[1;31m !!!!!!!!!!----Failed more then 3 times,script stop \e[0m"
                exit -1
	else
		echo -e "\e[1;31m !!!!!!!!!!-----------start-dfs success----------------- \e[0m"
            	jps
	fi
}

#try to start yarn
function start_yarn()
{
        for((j=1;j<3;j++))
        {
                echo "!!!!!!!!!!------------Try to start yarn '$j'th time(s)-----------"
                /opt/hadoop-2.6.0/sbin/start-yarn.sh

                jps >./123.txx

                #"grep -w" means that exactly match
                if [ -z "`grep -w "ResourceManager" ./123.txx`" ] || [ -z "`grep -w "NodeManager" ./123.txx`" ] ; then
                       	echo -e "\e[1;31m !!!!!!!!!!-----------some process start failed----------------\e[0m"
                        /opt/hadoop-2.6.0/sbin/stop-yarn.sh
                        echo "!!!!!!!!!!-----------------restart yarn-----------------------"
                        /opt/hadoop-2.6.0/sbin/start-yarn.sh
                else
			echo "!!!!!!!!!!---out of loop--------"
			break
                fi
        }

        if [ $j -eq 3 ] ;then
                echo "!!!!!!!!!!---------Failed more then 3 times,script stop";
                exit -1
	else
		 echo -e "\e[1;31m !!!!!!!!!!-----------start-yarn success----------------- \e[0m"
                jps
        fi
}

#try to start secure_dns
function start_secure_dns()
{
	echo "!!!!!!!!!!---------in the function start_secure_dns--------------"
        for((k=1;k<3;k++))
        {
		jps >./xxx.txt
                echo "!!!!!!!!!!------------Try to start secure_dns '$k'th time(s)-----------"
                /opt/hadoop-2.6.0/sbin/start-secure-dns.sh

                jps >./123.txx
                #"grep -w" means that exactly match
                if [ -z "`awk '{ print $0 }'  ./xxx.txt ./123.txx |sort|uniq -u`" ]; then
                       	echo -e "\e[1;31m !!!!!!!!!!-----------some process start failed----------------\e[0m"
                        /opt/hadoop-2.6.0/sbin/stop-secure-dns.sh
                        echo "!!!!!!!!!!-----------------restart secure-dns-----------------------"
                        /opt/hadoop-2.6.0/sbin/start-secure-dns.sh
                else
			echo "!!!!!!!!!!----out of loop--------"
               		break
		fi
       }

        if [ $k -eq 3 ] ;then
		echo "!!!!!!!!!!Failed more then 3 times,script stop";
                exit -1
	else
		echo -e "\e[1;31m !!!!!!!!!!-----------start-decure-dns success----------------\e[0m"
                jps
        fi
}


echo "!!!!!!!!!!-----------------------"
#echo "input 1 to start dfs ,input 2 to start secure-dns ,input 3 to start yarn ,and input x to start all .(default start all) :"

#read -n1 choose
#choose=x
echo "!!!!!!!!!!-------you choice is : $choose"

        echo "!!!!!!!!!!!-----------try to start all process-------------"
	start_dfs;
	start_yarn;
	start_secure_dns;
echo 
echo
echo
echo "!!!!!!!!!!!-----------finished----------"
jps
echo
rm -f ./123.txx
rm -f ./xxx.txt
echo "!!!!!!!!!!--------delete temp file--------"
echo
echo "!!!!!!!!!!----------over-----------------"
echo


kdestroy
#only gateway start Sentry
if [ "`hostname`" = "gateway.bdsm.cmcc" ];then
	echo "---ready to start Sentry---"
	/opt/apache-bdsmsentry-0.8-bin/bin/sentry --log4jConf /opt/apache-bdsmsentry-0.8-bin/conf/sentry-log4j.properties --command service --conffile /opt/apache-bdsmsentry-0.8-bin/conf/sentry-site.xml& 

#	cat ./temp_2 >>./result.txt
#	if [ -z "`grep -w "Commit Succeeded" ./temp_2`" ];then
#		echo -e "\e[1;31m ---Failed to start Sentry---\e[0m"
#	else
#		echo -e "\e[1;31m ---keep Sentry running---\e[0m"
#	fi
fi

echo "---start hive:---"
hive --service hiveserver2&
echo -e "\e[1;31m ---hive is running---\e[0m"

ps aux |grep sentry >./temp_3
#cat ./temp_3>>./result.txt


rm -f ./temp_1
rm -f ./result.txt
rm -f ./temp_3

#echo -e "\e[1;31m---sleep 30s---\e[0m"
#sleep 30

if [ "`hostname`" = "gateway.bdsm.cmcc" ];then

	echo -e "\e[1;31m---sleep 30s---\e[0m"
	sleep 30
	ps aux | grep hive >./temp_4
	ps aux | grep sentry >./temp_5
	
	if [ -z "`grep -w "org.apache.hive.service.server.HiveServer2" ./temp_4`" ] || [ -z "`grep -w "/opt/apache-bdsmsentry-0.8-bin/conf/sentry-site.xml" ./temp_5`" ];then
		echo -e "\e[1;31m---Failed to start sentry or hive---\e[0m"	
	fi

	rm -f ./temp_4
	rm -f ./temp_5

fi

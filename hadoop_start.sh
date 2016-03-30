#!/bin/bash

#Please let me know ,if you find something wrong here.Thanks.
#By Luozhihui 
#Email: cvv54@hotmail.com
#version1.0  2016/03/23
#complete the function of starting hadoop

#version1.1  2016/03/25 
#use 'break' to quit the loop instead of judging the var's value
#instead 'comm' with 'awk' to compare two unsorted files

#if starting dfs is failed ,try again ,at most 3 times 
function start_dfs()
{
	for((i=1;i<3;i++))
	{
		echo "!!!!!!!!!!------------Try to start dfs '$i'th time(s)-----------"
		/opt/hadoop-2.6.0/sbin/start-dfs.sh

		jps >/home/sh/123.txx

		#"grep -w" means that exactly match
		if [ -z "`grep -w "NameNode" /home/sh/123.txx`" ] || [ -z "`grep -w "SecondaryNameNode" /home/sh/123.txx`" ] || [ -z "` grep -w "Jps" /home/sh/123.txx`" ]; then
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

                jps >/home/sh/123.txx

                #"grep -w" means that exactly match
                if [ -z "`grep -w "ResourceManager" /home/sh/123.txx`" ] || [ -z "`grep -w "NodeManager" /home/sh/123.txx`" ] ; then
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
		jps >/home/sh/xxx.txt
                echo "!!!!!!!!!!------------Try to start secure_dns '$k'th time(s)-----------"
                /opt/hadoop-2.6.0/sbin/start-secure-dns.sh

                jps >/home/sh/123.txx
                #"grep -w" means that exactly match
                if [ -z "`awk '{ print $0 }'  /home/sh/xxx.txt /home/sh/123.txx |sort|uniq -u`" ]; then
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
echo "input 1 to start dfs ,input 2 to start secure-dns ,input 3 to start yarn ,and input x to start all .(default start all) :"

#read -n1 choose
choose=x
echo "!!!!!!!!!!-------you choice is : $choose"
if [ $choose = "1" ];then
        echo "!!!!!!!!!!------start-dfs.sh will be execute-----------"
       start_dfs;
elif [ $choose = "2" ];then
        echo "!!!!!!!!!!-----start-yarn.sh will be execute------------"
       start_yarn;
elif [ $choose = "3" ];then
        echo "!!!!!!!!!!-----start-secure-dns.sh will be execute------------"
       start_secure_dns;
else
        echo "!!!!!!!!!!!-----------try to start all process-------------"
	start_dfs;
	start_yarn;
	start_secure_dns;
fi
echo 
echo
echo
echo "!!!!!!!!!!!-----------finished----------"
jps
echo
rm -f /home/sh/123.txx
rm -f /home/sh/xxx.txt
echo "!!!!!!!!!!--------delete temp file--------"
echo
echo "!!!!!!!!!!----------over-----------------"
echo

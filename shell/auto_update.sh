#!/bin/bash

#login to remote host and get filepath

auto_login_ssh(){

expect -c "set timeout -1;
spawn  ssh -o StrictHostKeyChecking=no $2 ${@:3};
expect *assword:*;
send -- $1\r;
expect "]#"
send {cd /root/daily_build/apache-hive-1.1.0-bin}
send \n
expect "]#"
send {ls -rt|tail -1 >/root/daily_build/hivepath.txt}
send \n

expect "]#"
send {cd /root/daily_build/apache-bdsmsentry-0.8-bin}
send \n
expect "]#"
send {ls -rt|tail -1 >/root/daily_build/bdsmpath.txt}
send \n

expect "]#"
send exit\n
expect eof
";}


eval $(/bin/grep remote_ip myconf.conf)
eval $(/bin/grep login_user myconf.conf)
eval $(/bin/grep login_passwd myconf.conf)
auto_login_ssh "$login_passwd" "$login_user"@"$remote_ip"

eval $(/bin/grep local_path myconf.conf)

batch_scp(){
#refference : http://www.jb51.net/article/34005.htm
#	list_file=$1
#	src_file=$2
#	dest_file=$3
#	cat $list_file | while read line
#	do
#  	host_ip=`echo $line | awk '{print $1}'`
#   	username=`echo $line | awk '{print $2}'`
#   	password=`echo $line | awk '{print $3}'`
#   	echo "$host_ip"
	src_file=$1
	dest_file=$2
	./expect_scp $remote_ip $login_user $login_passwd $src_file $dest_file
#	./expect_scp $host_ip $username $password $src_file $dest_file
   	echo -e "\e[1;31m download...\e[0m"
#	done 
}


echo -e "\e[1;31m mkdir...\e[0m"
mkdir -p $local_path
rm
#download
echo -e "\e[1;31m download hivepath&bdsmpath...\e[0m"
batch_scp "/root/daily_build/hivepath.txt" "$local_path"
batch_scp "/root/daily_build/bdsmpath.txt" "$local_path"
#./batch_scp.sh ./hosts.list /root/daily_build/hivepath.txt $local_path
#./batch_scp.sh ./hosts.list /root/daily_build/bdsmpath.txt $local_path
 
echo -e "\e[1;31m download jar...\e[0m"
hivepath=`cat "$local_path""/hivepath.txt" `
bdsmpath=`cat "$local_path""/bdsmpath.txt"`
hivehead="/root/daily_build/apache-hive-1.1.0-bin/"
bdsmhead="/root/daily_build/apache-bdsmsentry-0.8-bin/"
hivetail="/apache-hive-1.1.0-bin.tar.gz"
bdsmtail="/apache-bdsmsentry-0.8-bin.tar.gz"
hivefile=${hivehead}${hivepath}${hivetail}
bdsmfile=${bdsmhead}${bdsmpath}${bdsmtail}
echo -e "\e[1;31m $hivefile\e[0m" 
echo -e "\e[1;31m $bdsmfile\e[0m"

rm -f "$local_path""/apache-hive-1.1.0-bin.tar.gz" 
rm -f "$local_path""/apache-bdsmsentry-0.8-bin.tar.gz"

batch_scp "$hivefile" "$local_path"
batch_scp "$bdsmfile" "$local_path"

#untar
echo -e "\e[1;31m untar...\e[0m"
cd $local_path
tar xvf .$hivetail
tar xvf .$bdsmtail

#backup
mkdir /opt/apache-bdsmsentry-0.8-bin/lib_old/
mkdir /opt/apache-hive-1.1.0-bin/lib_old/
echo y |cp -rf /opt/apache-bdsmsentry-0.8-bin/lib/* /opt/apache-bdsmsentry-0.8-bin/lib_old/
echo y |cp -rf /opt/apache-hive-1.1.0-bin/lib/* /opt/apache-hive-1.1.0-bin/lib_old/

#update
echo y|cp -rf apache-bdsmsentry-0.8-bin/lib/* /opt/apache-bdsmsentry-0.8-bin/lib
echo y|cp -rf apache-hive-1.1.0-bin/lib/* /opt/apache-hive-1.1.0-bin/lib
echo y|cp apache-bdsmsentry-0.8-bin/lib/bdsmsentry-*.jar /opt/apache-hive-1.1.0-bin/lib




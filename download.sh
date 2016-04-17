#!/bin/bash


ls

echo "print var from remote host"
echo $a
echo "-----------------"

auto_copy(){

	eval $(/bin/grep remote_ip myconf.conf)
	eval $(/bin/grep login_user myconf.conf)
	eval $(/bin/grep login_passwd myconf.conf)

	eval $(/bin/grep remote_path myconf.conf)
	eval $(/bin/grep local_path myconf.conf)

	expect -c "set timeout -1;

	spawn scp "$login_user"@"$remote_ip":"$remote_path" "$local_path"
	expect *assword:*;
	send -- $login_passwd\r;
	expect eof";
}


auto_copy $login_passwd


cd "$local_path"
echo `pwd`
echo `hostname` 


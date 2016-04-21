#!/bin/bash

echo -e "\e[1;31m ------------stop-------------\e[0m"
./auto_stop.sh


if [ "`hostname`" = "gateway.bdsm.cmcc" ];then
	echo -e "\e[1;31m ------------update-------------\e[0m"
	./auto_update.sh
	fi

echo -e "\e[1;31m ------------start-------------\e[0m"
./auto_start.sh

if [ "`hostname`" = "gateway.bdsm.cmcc" ];then
	sleep 30
	echo -e "\e[1;31m ------------login-------------\e[0m"
	./kinit_login.sh
	fi


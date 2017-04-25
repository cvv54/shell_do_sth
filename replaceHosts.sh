#/bin/bash

#get hostname
hostname
#get short hostname
sht=`hostname`
sht=`echo ${sht%%.*}`
echo $sht

#get ip
lcl_ip=`ifconfig -a|grep inet|grep -v 127.0.0.1 |grep -v 192.168 |grep -v inet6 | awk '{print $2}'|tr -d "addr:"`
echo $lcl_ip

#get the line include message about this PC
old_ip=`grep -r ${sht%%.*} /etc/hosts`
echo "old_ip"$old_ip

#create a string covers current IP and hostname
new_ip=$lcl_ip" "$sht" "`hostname`
echo "new_ip"$new_ip
#sed -n "/`grep -r ${sht%%.*} /etc/hosts`/p " /etc/hosts

#delete it
sed -i -e /`hostname`/d /etc/hosts

#insert new row
echo $new_ip >>/etc/hosts

scp /etc/hosts root@two1:/etc/
scp /etc/hosts root@two3:/etc/
scp /etc/hosts root@two:/etc/
echo "Finished!"

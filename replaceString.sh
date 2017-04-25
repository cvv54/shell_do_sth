#/bin/bash
function rpStr()
{
	for i in `find /opt/ -name $1`
	do
		echo 
		echo '******************************************'
		echo $i
		echo	`grep -rn $2 $i`
		sed -i "s#$2#$3#g" `grep -rn $2 -rl $i`
	done
}

#echo "Usage: rpStr 'filenam' 'oldString' 'newString'"

#read -t 15 -p "Input argument please:" filename
#read -t 15 -p "Input oldString:" oldString
#read -t 15 -p "Input newString:" newString

#echo "We will search all files under /opt named " $filename " and replace " $oldString " with " $newString 

#rpStr $filename $oldString $newString

rpStr "ranger-admin-site.xml" "localhost" "two.bdsm.cmcc"
rpStr "ranger-admin-site.xml" "mj1" "two.bdsm.cmcc"

#Use 'sed -i "s#oldString#newString#g" filename' instead of 'sed -i "s/oldString/newString/g" filename'
#Because there is / in oldString and newString
rpStr "ranger-admin-site.xml" "/opt/keytabs/hive.keytab" "/etc/security/keytabs/hbase.keytab"
rpStr "ranger-admin-site.xml" "hive/two.bdsm.cmcc@BDSM.CMCC" "hbase/two.bdsm.cmcc@BDSM.CMCC"

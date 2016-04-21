#!/bin/bash

	kdestroy

	echo "---init Kerberos:---"
	
	kinit -kt /etc/security/keytabs/single.keytab single/host@REALM

	echo "---login---"
	
	beeline -u "jdbc:hive2://host:10000/;principal=single/host@REALM"


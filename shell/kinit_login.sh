#!/bin/bash

	kdestroy

	echo "---init Kerberos:---"
	
	kinit -kt /etc/security/keytabs/single.keytab single/gateway.bdsm.cmcc@BDSM.CMCC

	echo "---login---"
	
	beeline -u "jdbc:hive2://gateway.bdsm.cmcc:10000/;principal=single/gateway.bdsm.cmcc@BDSM.CMCC"


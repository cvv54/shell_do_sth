#!/bin/bash

/opt/hadoop-2.6.0/sbin/stop-dfs.sh
/opt/hadoop-2.6.0/sbin/stop-secure-dns.sh
/opt/hadoop-2.6.0/sbin/stop-yarn.sh

echo
echo
echo jps:
jps
echo
echo
echo

#!/bin/bash

ps -aux | grep hive | awk '{print $2}' |xargs kill -9
ps -aux | grep sentry | awk '{print $2}' |xargs kill -9

/opt/hadoop-2.6.0/sbin/stop-dfs.sh
/opt/hadoop-2.6.0/sbin/stop-secure-dns.sh
/opt/hadoop-2.6.0/sbin/stop-yarn.sh

echo
echo
echo jps:
jps
echo
ps aux | grep hive
ps aux | grep sentry
echo


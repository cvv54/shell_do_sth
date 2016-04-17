#!/bin/bash

auto_login_ssh(){

expect -c "set timeout -1;
spawn -noecho ssh -o StrictHostKeyChecking=no $2 ${@:3};
expect *assword:*;
send -- $1\r;
expect "]#"
send ls\n
expect "]#"
send ps\n
expect "]#"
send who\n
expect "]#"
send exit\n
expect eof
#send exit\n
#interact;
";}


eval $(/bin/grep remote_ip myconf.conf)
eval $(/bin/grep login_user myconf.conf)
eval $(/bin/grep login_passwd myconf.conf)
auto_login_ssh "$login_passwd" "$login_user"@"$remote_ip"

#!/bin/bash

./auto_stop.sh
./auto_update.sh
./auto_start.sh
sleep 30
./kinit_login.sh


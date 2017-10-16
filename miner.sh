#!/bin/bash
# First, kill miner if exists
MINER_NAME="minerd"
MINER_PID=$(/bin/ps -ef | /bin/grep $MINER_NAME | /bin/grep -v grep | awk '{ print $2 }')

if [ -z $MINER_PID ]
then
        echo "Miner process $MINER_NAME not running previously"
else
        echo "Previous Miner process $MINER_NAME running with PID $MINER_PID"
        /bin/kill -9 $MINER_PID
        echo "Miner process $MINER_PID killed"
fi

cd TEST
./m-minerd_A53 -c ../cfg.json -B > /tmp/log.miner 2>&1
cd ..

MINER_PID=$(/bin/ps -ef | /bin/grep $MINER_NAME | /bin/grep -v grep | awk '{ print $2 }')
echo "new $MINER_NAME instance running with PID $MINER_PID"
exit 0

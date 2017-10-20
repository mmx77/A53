#!/bin/bash
# GLOBAL VARIABLES ----------------
source ./config.control

# Activate debugging
#set -x

# MINER_NAME is kept in config file
MINER_PID=$(/bin/ps -ef | /bin/grep $MINER_NAME | /bin/grep -v grep | awk '{ print $2 }')

if [ -z $MINER_PID ]
then
        echo "No Process $MINER_NAME running. Nothing to be killed"
else
        echo "$MINER_NAME with PID $MINER_PID"
        /bin/kill -9 $MINER_PID
        echo "Killed"
fi

# Stop debugging
#set +x

exit 0

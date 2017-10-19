#!/bin/bash
# GLOBAL VARIABLES ----------------
source ./config.control

# FUNCTIONS -----------------------
function get_PID_by_name {
	/bin/ps -ef | /bin/grep $1 | /bin/grep -v grep | awk '{ print $2 }'
}

function kill_process_by_PID {
	if [ -z $1 ]
	then
        	echo "Miner process $MINER_NAME not running previously"
		return 1
	else
        	echo "Previous Miner process $MINER_NAME running with PID $1"
	        /bin/kill -9 $1
        	echo "Miner process $1 killed"
	fi
	return 0
}

# MAIN CODE -----------------------
set -x

if (($CPU_TYPE==$CPU_A7));
then
        MINER_NAME=$(echo "$MINER_A7")
elif (($CPU_TYPE==$CPU_A53));
then
        MINER_NAME=$(echo "$MINER_A53")
fi

# Kill miner if exists
#MINER_NAME="minerd"
MINER_PID=$(get_PID_by_name $MINER_NAME)
kill_process_by_PID $MINER_PID

cd TEST
./$MINER_NAME -c ../cfg.json -B > $LOG_FILE 2>&1
cd ..

MINER_PID=$(/bin/ps -ef | /bin/grep $MINER_NAME | /bin/grep -v grep | awk '{ print $2 }')
echo "new $MINER_NAME instance running with PID $MINER_PID"
exit 0

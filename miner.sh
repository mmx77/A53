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

function retrieve_compiled_name {
	if (($CPU_TYPE==$CPU_A7));
	then
        	echo "$MINER_A7"
	elif (($CPU_TYPE==$CPU_A53));
	then
        	echo "$MINER_A53"
	fi
}

function update_config_file {
	#local NEW_CONFIG_LINE=$(echo '"'"$1"'"="'"$2"'"' )
	local NEW_CONFIG_LINE=$(echo "$1="'"'"$2"'"' )
	sed -i "/$1/c\\$NEW_CONFIG_LINE" "$CONFIG_FILE_SCRIPTS"
}

# MAIN CODE -----------------------
#set -x

MNR_NAME=$(retrieve_compiled_name)
# Update config file for the rest of scripts
update_config_file $MNR_LABEL_NAME_OF_MINER $MNR_NAME

# Kill miner if exists
#MINER_NAME="minerd"
MNR_PID=$(get_PID_by_name $MNR_NAME)
kill_process_by_PID $MNR_PID

cd TEST
./$MNR_NAME -c ../cfg.json -B > $MNR_LOG_FILE 2>&1
cd ..

MINER_PID=$(get_PID_by_name $MNR_NAME)
echo "new $MNR_NAME instance running with PID $MNR_PID"
exit 0


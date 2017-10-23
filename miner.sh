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

function retrieve_HW_processor {
	local PROCESSOR=$(cat /proc/cpuinfo | grep Processor | head -n 1 | awk '{ print $3 }')
	echo "$PROCESSOR"
}

function retrieve_compiled_name {
	case $(retrieve_HW_processor) in
		"$MNR_CPU_HW_A7")
			echo "$MNR_COMPILED_A7"
			;;
		"$MNR_CPU_HW_A53")
        		echo "$MNR_COMPILED_A53"
			;;
	esac
}

function update_config_file {
	local OLD_CONFIG_LINE=$(echo "$1=")
	local NEW_CONFIG_LINE=$(echo "$1="'"'"$2"'"' )
	CUR_CONFIG_LINE=$(grep "$OLD_CONFIG_LINE" "$CONFIG_FILE_SCRIPTS" )

	# Update config file, if not updated yet
	if [[ "$CUR_CONFIG_LINE" != "$NEW_CONFIG_LINE" ]];
	then
		sed -i "/$OLD_CONFIG_LINE/c\\$NEW_CONFIG_LINE" "$CONFIG_FILE_SCRIPTS"
	fi
}

# MAIN CODE -----------------------
#set -x

MNR_NAME=$(retrieve_compiled_name)
# Update config file for the rest of scripts, if necessary
update_config_file $MNR_LABEL_NAME_OF_MINER $MNR_NAME

# Kill miner if exists
MNR_PID=$(get_PID_by_name $MNR_NAME)
kill_process_by_PID $MNR_PID

cd TEST
./$MNR_NAME -c ../cfg.json -B > $MNR_LOG_FILE 2>&1
cd ..

MNR_PID=$(get_PID_by_name $MNR_NAME)
echo "new $MNR_NAME instance running with PID $MNR_PID"
exit 0

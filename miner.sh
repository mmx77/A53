#!/bin/bash
# GLOBAL VARIABLES ----------------
source ./config.control

# FUNCTIONS -----------------------

# External functions to kill a process
source ./functions_kill

function retrieve_HW_processor {
	local PROCESSOR=$(cat /proc/cpuinfo | grep Processor | head -n 1 | awk '{ print $3 }')
	echo "$PROCESSOR"
}

function retrieve_compiled_name {
	PROCESSOR=$(retrieve_HW_processor)
	if [ "$PROCESSOR" == "$MNR_CPU_HW_A7" ];
	then
        	echo "$MNR_COMPILED_A7"
	elif [ "$PROCESSOR" == "$MNR_CPU_HW_A53" ];
	then
        	echo "$MNR_COMPILED_A53"
	fi
}

function update_config_file {
	#local NEW_CONFIG_LINE=$(echo '"'"$1"'"="'"$2"'"' )
	local OLD_CONFIG_LINE=$(echo "$1=")
	local NEW_CONFIG_LINE=$(echo "$1="'"'"$2"'"' )
	sed -i "/$OLD_CONFIG_LINE/c\\$NEW_CONFIG_LINE" "$CONFIG_FILE_SCRIPTS"
}

# MAIN CODE -----------------------
set -x

MNR_NAME=$(retrieve_compiled_name)
# Update config file for the rest of scripts
update_config_file $MNR_LABEL_NAME_OF_MINER $MNR_NAME

kill_process_by_name $MNR_NAME

cd TEST
./$MNR_NAME -c ../cfg.json -B > $MNR_LOG_FILE 2>&1
cd ..

echo "new $MNR_NAME instance running with PID $(get_PID_by_name $MNR_NAME)"

exit 0

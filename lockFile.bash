#!/bin/bash

edit_this_file="$1"

# Lock file in the /tmp directory
lock_file="/tmp/lock_file"


# Get this processes PID
MYPID=$$

# Get a timestamp
time_stamp=$(date +%Y%m%d)

function verify_lock {
    locked_by=( $(head -1 $lock_file) )
    locking_user=${locked_by[0]}
    locking_pid=${locked_by[1]}
    locked_since=${locked_by[2]}
    if [ "$locking_pid" != "$MYPID" ]; then
        echo -e "File is locked by \"${locking_user}\" with process \"${locking_pid}\" since \"${locked_since}\"."
        got_lock="false"
        return 1
    else
        echo -e "Acquired successful lock on \"${edit_this_file}\""
        got_lock="true"
        return 0
    fi
}

function create_lock {
    echo -e "Attempting to lock \"${edit_this_file}\" for edit..."
    touch $lock_file
    echo "${USER} ${MYPID} ${time_stamp}" >> $lock_file  #Append rather than overwirite, because other process can blow away a sucessful lock in a race condition.
}

function lock_check {
    echo "Checking for lock file..."
    COUNT=0
    TIMEOUT=""
    while [ -f $lock_file ]
        do
            if [ $COUNT -gt 1800 ]; then
                TIMEOUT=1
                break
            fi

            verify_lock
            if [ $? == "0" ]; then
                break
            else
                sleep 2
                COUNT=$(( COUNT + 1 ))
                continue
            fi
        done

    if [ "$TIMEOUT" != "1" ]; then
        if [ "$got_lock" != "true" ]; then
            if [ -f $lock_file ]; then
                lock_check
            else
                create_lock
                lock_check
            fi
        else
            return 0
        fi
    else
        echo "Lock file check took longer than 1 hour, exiting"
        exit 2
    fi
}

lock_check

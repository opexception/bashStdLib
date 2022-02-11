#!/bin/bash

FILE_TO_EDIT="$1"

# Lock file in the /tmp directory, also remove and path to get only file name.
LOCK_FILE="/tmp/${FILE_TO_EDIT##*/}.lck"

# Get this process' PID
MYPID=$$

# Clean up lock file on script exit
tidy ()
    {
        if [ -f ${LOCK_FILE} ] && [ "$(head -1 ${LOCK_FILE}| awk '{print $2}')" == "${MYPID}" ]
            then
                rm -f ${LOCK_FILE}
        fi
    }
trap "tidy" EXIT

# Get a timestamp
tstamp=$(date +%Y%m%d)

verify_lock ()
    { # Used by lock_check() to validate the successful creation of a lock file while avoiding race conditions from competing processes.
        local locked_by

        # locked_by has 3 ordered elements: 0-User who locked it, 1-PID of locking process, and 2-Timestamp of the lock
        locked_by=( $(head -1 ${LOCK_FILE}) )

        if [ "${locked_by[1]}" != "${MYPID}" ]
            then
                if [ "${GOT_LOCK}" == "false" ]
                    then
                        echo -n "."
                    else
                        echo -e "File is locked by \"${locked_by[0]}\" with process \"${locked_by[1]}\" since \"${locked_by[2]}\"."
                        GOT_LOCK="false"
                fi
                return 1
            else
                echo -e "Acquired successful lock"
                GOT_LOCK="true"
                return 0
        fi
    }


create_lock ()
    { # Create a lock file
        echo -e "Attempting to lock '${FILE_TO_EDIT}' for edit"
        if touch ${LOCK_FILE}
            then
                echo "${USER} ${MYPID} ${tstamp}" >> ${LOCK_FILE}  #Append rather than overwirite, because other process can blow away a sucessful lock in a race condition.
            else
                echo "Unable to create or write lock file '${LOCK_FILE}'"
                exit 1
        fi
    }


lock_check ()
    { # Check if we have a lock file, and if not, create one. 
      # timeout=n can be used to wait for a lock file to become available for "n" seconds
        echo "Checking for lock file..."

        local count
        local timeout
        local timed_out
        count=0
        timeout=60
        timed_out=""
        while [ -f ${LOCK_FILE} ]
            do
                if [ $count -gt ${timeout} ]
                    then
                        timed_out=1
                        break
                fi

                if verify_lock
                    then
                        break
                    else
                        sleep 1
                        (( count++ ))
                        continue
                fi
            done

        if [ "${timed_out}" != "1" ]
            then
                if [ "${GOT_LOCK}" != "true" ]
                    then
                        if [ -f ${LOCK_FILE} ]
                            then
                                lock_check
                            else
                                create_lock
                                lock_check
                        fi
                    else
                        return 0
                fi
            else
                echo -e " :(\nLock file unavailable for more than ${timeout} seconds, exiting"
                exit 2
        fi
    }


lock_check

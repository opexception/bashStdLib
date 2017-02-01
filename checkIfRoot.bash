#!/bin/bash

# checkIfRoot.bash
#
# Make sure user has Root privileges before allowing to continue.

Check_Root()
  { # Check if running as root.
  echo -n "Checking user permissions..."
  if (( $(id -u) != 0 ))
    then
      echo -e "\nSorry, only root can do that"
      exit
  fi
  echo " OK"
  }

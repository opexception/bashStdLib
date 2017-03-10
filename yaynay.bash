#!/bin/bash

# yaynay.bash
#
# Ask a Yes/No question

read -p "Would you like to continue? (answering 'no' will exit) [y/n]" yaynay
yaynay=$(echo ${yaynay:0:1} | tr "[a-z]" "[A-Z]")
case ${yaynay} in
  Y)
    continue
    ;;
  N)
    exit 1
    ;;
  *)
    echo "Reply hazy... please try again later."
    echo "Exiting."
    exit 1
esac

# As a function:
yay_nay()
    { # A yes/no prompt
    if [ $# > 0 ]
        then
            MSG="$@"
        else
            MSG="Would you like to continue?"
    fi
    read -p "${MSG} [y/N]" yaynay
    yaynay=$(echo ${yaynay:0:1} | tr "[a-z]" "[A-Z]")
    case ${yaynay} in
        Y)
            return 0
        ;;
        N)
            return 1
        ;;
        "")
            return 1 # Default to No
            #return 0 # Default to Yes
        ;;
        *)
            yay_nay $@
            return $?
        ;;
    esac
    }

# To-do:
# Add empty string to case to allow for default answers. It took longer to type this than it would to just do that.

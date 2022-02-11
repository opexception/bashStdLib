#!/bin/bash

fecho()
    { # Fancy echo -- Print in different fonts.
    # Font init takes time. Only do it once. Check if we've done this already
    if [ -z ${font_init+x} ]
        then
        # Are we in an interactive terminal?
        if test -t 1
            then
                # Does this terminal support color?
                ncolors=$(tput colors)
                if test -n "$ncolors" && test $ncolors -ge 8
                    then
                        # Setup build font list, This may be SLOW!, but only once.
                        NORM_f=$(tput sgr0) # Set terminal output back to NORMal
                        BOLD_f=$(tput bold) # Set terminal output to BOLD
                        INV_f=$(tput smso) # Set terminal output to INVert foreground/background
                        UL_f=$(tput smul) # Set terminal output to UnderLine
                        NOUL_f=$(tput rmul) # Remove UnderLine
                        BLACK_f="$(tput setaf 0)"
                        RED_f="$(tput setaf 1)"
                        GREEN_f="$(tput setaf 2)"
                        YELLOW_f="$(tput setaf 3)"
                        BLUE_f="$(tput setaf 4)"
                        MAGENTA_f="$(tput setaf 5)"
                        CYAN_f="$(tput setaf 6)"
                        WHITE_f="$(tput setaf 7)"
                        # Setting $font_init prevents having to set all these fonts again
                        font_init=1
                    else
                        no_font=1
                fi
        else
            no_font=1
        fi
    fi
    if [ -z ${no_font+x} ] # If terminal is not interactive, or doesn't have color
        then
            for (( c=1; c<=$#; c++ ))
                do
                    arg_key=${!c}
                    case "${arg_key}" in
                        -x|--silent)  # A switch!
                            echo "Turning on silent mode"
                            ;;
                        -b) # Print arg in bold
                            (( c++ ))
                            echo -en "${BOLD_f}${!c}${NORM_f}"
                            ;;
                        -n) # Print arg in normal font
                            (( c++ ))
                            echo -en "${!c}"
                            ;;
                        -i) # Print arg in inverse font
                            (( c++ ))
                            echo -en "${INV_f}${!c}${NORM_f}"
                            ;;
                        -u) # Print arg in underlined font
                            (( c++ ))
                            echo -en "${UL_f}${!c}${NOUL_f}"
                            ;;
                        -bi|--bi|-ib|--ib)
                            (( c++ ))
                            echo -en "${BOLD_f}${INV_f}${!c}${NORM_f}"
                            ;;
                        -bu|--bu|-ub|--ub)
                            (( c++ ))
                            echo -en "${BOLD_f}${UL_f}${!c}${NORM_f}${NOUL_f}"
                            ;;
                        -iu|--iu|-ui|--ui)
                            (( c++ ))
                            echo -en "${INV_f}${UL_f}${!c}${NORM_f}${NOUL_f}"
                            ;;
                        -bui|-biu|-ubi|-uib|-ibu|-iub|--bui|--biu|--ubi|--uib|--ibu|--iub)
                            #All three attributes. Maintains bakward compatibility while fixin single dash issues.
                            (( c++ ))
                            echo -en "${BOLD_f}${INV_f}${UL_f}${!c}${NORM_f}${NOUL_f}"
                            ;;
                        *)
                            echo -en " ${arg_key}"
                            ;;
                    esac
                done
        else # If terminal doesn't support color, or isn't interactive, strip all coding
            for (( c=1; c<=$#; c++ ))
                do
                    arg_key=${!c}
                    case "${arg_key}" in
                        -x|--silent)
                            echo "Turning on silent mode"
                            ;;
                        -b) # Print arg in bold
                            (( c++ ))
                            echo -en "${!c}"
                            ;;
                        -n) # Print arg in normal font
                            (( c++ ))
                            echo -en "${!c}"
                            ;;
                        -i) # Print arg in inverse font
                            (( c++ ))
                            echo -en "${!c}"
                            ;;
                        -u) # Print arg in underlined font
                            (( c++ ))
                            echo -en "${!c}"
                            ;;
                        -bi|--bi|-ib|--ib)
                            (( c++ ))
                            echo -en "${!c}"
                            ;;
                        -bu|--bu|-ub|--ub)
                            (( c++ ))
                            echo -en "${!c}"
                            ;;
                        -iu|--iu|-ui|--ui)
                            (( c++ ))
                            echo -en "${!c}"
                            ;;
                        -bui|-biu|-ubi|-uib|-ibu|-iub|--bui|--biu|--ubi|--uib|--ibu|--iub)
                            #All three attributes. Maintains bakward compatibility while fixing single dash issues.
                            (( c++ ))
                            echo -en "${!c}"
                            ;;
                        *)
                            echo -en " ${arg_key}"
                            ;;
                    esac
                done
        fi
    echo
    }


help()
    { # Show help
    fecho -n "fecho = " -u "f" -n "ancy " -u "echo"
    echo
    echo "Use fecho to print things in various text styles"
    echo
    echo "There are 4 styles currently supported:"
    fecho -n "\t-b\t" -b "Bold"
    fecho -n "\t-u\t" -u "Underlined"
    fecho -n "\t-i\t" -i "Inverted"
    echo -e "\t-n\tNormal"
    echo
    fecho -n "You can also combine any of the three styles any way you wish by using a doubledash. For example:"
    fecho -n "\t--bu\t" --bu "Bold Underlined" -n " or\n\t--iub\t" --ubi "Inverted Underlined Bold"
    echo
    fecho -n "Read the " -u "source" -n " to this " --bui "help function" -n " for some " --ub "examples" -n "!"
    }

# Known issues:
# - Slow to run on some systems (Cygwin, Darwin)
#
# To-Do:
# - fuzz the fecho()! Need *some* error handling
#
# - Implement colors
#
# - Simplify formatted string building. Need less case statement?



debugit()
    { # Output debug messages depending on how $debug_level is set.
      # first argument is the type of message. Must be one of the following:
      #    ERROR
      #    WARNING
      #    INFO
      #    DEBUG
      # Example: 
      #   debugit INFO "This is how you use the debug feature."
      # Example output:
      #   INFO: This is how you use the debug feature.

    case ${debug_level} in
        0) return 0 ;; # Silent mode
        1) # ERRORs only
            case ${1} in
                ERROR) shift; >&2 echo -e "ERROR: $@"; return 0 ;;
                WARNING) return 0 ;;
                INFO) return 0 ;;
                DEBUG) return 0 ;;
                *) >&2 echo -e "INTERNAL ERROR - Debug message type '$1' is invalid."; return 1 ;;
            esac
        ;;
        2) # ERRORs and WARNINGs
            case ${1} in
                ERROR) shift; >&2 echo -e "ERROR: $@"; return 0 ;;
                WARNING) shift; echo -e "WARNING: $@"; return 0 ;;
                INFO) return 0 ;;
                DEBUG) return 0 ;;
                *) >&2 echo -e "INTERNAL ERROR - Debug message type '$1' is invalid."; return 1 ;;
            esac
        ;;
        3) # ERRORs, WARNINGs and INFOs
            case ${1} in
                ERROR) shift; >&2 echo -e "ERROR: $@"; return 0 ;;
                WARNING) shift; echo -e "WARNING: $@"; return 0 ;;
                INFO) shift; echo -e "INFO: $@"; return 0 ;;
                DEBUG) return 0 ;;
                *) >&2 echo -e "INTERNAL ERROR - Debug message type '$1' is invalid."; return 1 ;;
            esac
        ;;
        4) # ERRORs, WARNINGs, INFOs and DEBUGs
            case ${1} in
                ERROR) shift; >&2 echo -e "ERROR: $@"; return 0 ;;
                WARNING) shift; echo -e "WARNING: $@"; return 0 ;;
                INFO) shift; echo -e "INFO: $@"; return 0 ;;
                DEBUG) shift; echo -e "DEBUG: $@"; return 0 ;;
                *) >&2 echo -e "INTERNAL ERROR - Debug message type '$1' is invalid."; return 1 ;;
            esac
        ;;
        *) # Someone set $debug_level wrong.
            echo "INTERNAL ERROR - Invalid debug level '${debug_level}'"
            echo "Setting debug level to default of 3"
            debug_level=3
        ;;
    esac
    }
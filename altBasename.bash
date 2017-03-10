BASENAME=$(which basename 2>/dev/null)
if [ "${BASENAME}" == "" ]; then
    mybasename()
        {
        echo $1 | awk -F\/ '{print $NF}'
        }
        BASENAME=mybasename
fi

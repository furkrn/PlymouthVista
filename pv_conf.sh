#!/bin/bash

SCRIPT_LOCATION=""
PRIMARY_SCRIPT_LOCATION="$(pwd)/PlymouthVista.script"
SECONDARY_SCRIPT_LOCATION="$(pwd)/PlymouthVista.script"
START_SECTION="#USED_BY_PV_CONF"
END_SECTION="#END_USED_BY_PV_CONF"

declare -A config_values

readScript() {
    # This was used before on gen_blur.sh, modified slightly to include quotes.

    config_lines=$(sed -n "/$START_SECTION/,/$END_SECTION/p" "$SCRIPT_LOCATION")
    
    if [[ -z $config_lines ]]; then
        echo "Cannot find configuration section. Stopping!"
        exit 1
    fi

    clean_lines=$(echo "$config_lines" | \
    sed -e 's|//.*||' -e 's|#.*||' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d')

    while IFS= read -r line; do
        if [[ "$line" =~ ^global\.([[:alnum:]_]+)[[:space:]]*=[[:space:]]*(\"([^\"]*)\"|([^[:space:];]+))[[:space:]]*\;?$ ]]; then
            key="${BASH_REMATCH[1]}"
            if [[ -n "${BASH_REMATCH[2]}" && "${BASH_REMATCH[2]}" == \"*\" ]]; then
                value="${BASH_REMATCH[2]}" 
            else
                value="${BASH_REMATCH[4]}"
            fi
            config_values["$key"]="$value"
        fi
    done <<< "$clean_lines"
}


writeToScript() {
    local key=$1
    local value=$2
    local isString=$3

    config_lines=$(sed -n "/$START_SECTION/,/$END_SECTION/p" "$SCRIPT_LOCATION")

    clean_lines=$(echo "$config_lines" | \
    sed -e 's|//.*||' -e 's|#.*||' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d')

    lineToReplace=$(echo "$clean_lines" | \
    grep "global.$key")

    newLine="global.$key = "

    if [[ $isString == 1 ]]; then
        newLine+='"'
        newLine+=$value
        newLine+='"'
    else
        newLine+=$value
    fi

    newLine+=';'

    tmp=$(mktemp) || { echo "Failed to create tmp file"; exit 2; }
    sed -e "s/$lineToReplace/$newLine/g" "$SCRIPT_LOCATION" > $tmp || exit 1
    mv "$tmp" "$SCRIPT_LOCATION"
}

listConfiguration() {
    for key in "${!config_values[@]}"; do
        value=${config_values[$key]}
        printf "  %-30s = %s \n" "$key" "$value"
    done
}

updateConfiguration() {
    local key=$1
    local newValue=$2

    if [[ $(hasKey "$key") == 0 ]]; then
        echo "Key named '$key' doesn't exist!"
        return
    fi

    isString=0
    if echo ${config_values[$key]} | grep -Eq '^"|"$'; then
        isString=1
    fi

    supportsMultiline=0
    if [[ "$isString" == 1 ]] && echo $key | grep -Eq 'MTL$'; then
        supportsMultiline=1
    fi

    if [ "$supportsMultiline" == 0 ]; then
        if [[ $newValue == *$'\n'* ]]; then
            echo "Provided key doesn't support multiline texts"
            return
        fi
    else
        newValue="${newValue//$'\n'/\\n}"
    fi

    writeToScript "$key" "$newValue" "$isString"
}

readConfiguration() {
    local key=$1

    if [[ $(hasKey "$key") == 0 ]]; then
        echo "Key named '$key' doesn't exist!"
        return
    fi

    echo ${config_values[$key]} | sed -e 's/^"//' -e 's/"$//'
}

hasKey() {
    local key=$1

    if [[ -z $key ]]; then
        echo 0
        return
    fi

    value=${config_values[$key]}

    if [[ -z $value ]]; then
        echo 0
        return
    fi

    echo 1
}

usage() {
    echo "  Shows this message : pv_conf -h"
    echo "  Set value          : pv_conf -s [key] -v [value] -i [optional_config_file]"
    echo "  Get value          : pv_conf -g [key] -i [optional_config_file]"
    echo "  List all values    : pv_conf -l -i [optional_config_file]"
}

findScript() {
    local userDefinedLocation=$1

    if [[ -z $userDefinedLocation ]]; then
        if [[ ! -f $PRIMARY_SCRIPT_LOCATION ]]; then
            if [[ ! -f $SECONDARY_SCRIPT_LOCATION ]]; then
                echo "Specify the file by either using the -i option or compiling the theme or installing the theme."
                exit 2
            fi

            SCRIPT_LOCATION=$SECONDARY_SCRIPT_LOCATION
        fi

        SCRIPT_LOCATION=$PRIMARY_SCRIPT_LOCATION
    else
        if [[ ! -f $userDefinedLocation ]]; then
            echo "Specified file does not exist!"
            exit 2
        fi

        SCRIPT_LOCATION=$userDefinedLocation
    fi
}

while getopts :i:s::g:h:v:l op; do
    case $op in
        i)
            DEFINED_USER_SCRIPT_LOCATION=${OPTARG}
            ;;
        l)
            task="list"
            ;;
        s)
            task="set"
            keyArg=${OPTARG}
            ;;
        v)
            valueToChangeArg=${OPTARG}
            ;;
        g)
            task="get"
            keyArg=${OPTARG}
            ;;
        h | *)
            usage
            exit 0
            ;;
        esac
done

if [[ $task == "get" ]] && [[ -z $keyArg ]]; then
    echo "Key is required for get operation."
    usage
    exit 1
fi

if [[ "$task" == "set" && (-z "$keyArg" || -z "$valueToChangeArg") ]]; then
    echo "Key and value is required for set operation."
    usage
    exit 1
fi

findScript $DEFINED_USER_SCRIPT_LOCATION
readScript

case $task in
    list)
        listConfiguration
        ;;
    get)
        readConfiguration $keyArg
        ;;
    set)
        updateConfiguration $keyArg $valueToChangeArg
        ;;
    *)
        usage
        ;;
esac

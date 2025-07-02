#!/bin/bash

CONF_LOCATION="/etc/plymouth/plymouthd.conf"

if [[ -z $1 ]]; then
    echo "You must specify a key to recieve."
    exit 2
fi

if [[ ! -f $CONF_LOCATION ]]; then
    echo "Cannot find plymouthd.conf, exitting..."
    exit 2
fi

declare -A values

configLines=$(cat $CONF_LOCATION)

cleanLines=$(echo "$configLines" | \
sed -e 's|\[.*||' -e 's|#.*||' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d')

while read -r line; do
    if [[ $line =~ (.*)=(.*) ]]; then
        key=${BASH_REMATCH[1]}
        value=${BASH_REMATCH[2]}
        values["$key"]="$value"
    fi
done <<< "$cleanLines"

echo "${values[$1]}"
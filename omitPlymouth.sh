#!/bin/bash

DRACUT_CONF_LOCATION='/etc/dracut.conf.d/omit_plymouth.conf'
DRACUT_CONF='\nomit_dracutmodules+=" plymouth "'

if [[ -z $(command -v dracut) ]]; then
    echo "This system does not use dracut, exitting"
    exit 1
fi

if [[ "$EUID" != 0 ]]; then
    echo "Insufficent permissions, please run this as root."
    exit 1
fi

printf "$DRACUT_CONF" > "$DRACUT_CONF_LOCATION"

sudo dracut --force --regenerate-all --verbose
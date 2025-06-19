#!/bin/bash

SCRIPT_DIR="/usr/share/plymouth/themes/PlymouthVista"
OS_STATE=""
HIBERNATE_STAT=""
USE_SESSION_CHECK=0
ASSUME_NO_SHUTDOWN=0

usage() {
    echo "  plymouth_state_updater -H <0|1>          : Turns on/off the ReturnFromHibernation"
    echo "  plymouth_state_updater -h                : Displays this message"
    echo "  plymouth_state_updater -n                : Assumes no shutdown"
    echo "  plymouth_state_updater -c                : Changes OsState by determining if sddm is running."
    echo "  plymouth_state_updater -s <sddm|desktop> : Changes OsState to either 'sddm' or 'desktop'."
}

if [[ ! -d $SCRIPT_DIR ]]; then
    echo "$SCRIPT_DIR does not exist, Stopping!"
    exit 2
fi

cd $SCRIPT_DIR

if [[ ! -f "./pv_conf.sh" ]]; then
    echo "pv_conf.sh is required. Stopping!"
    exit 2
fi

if [[ ! -f "./PlymouthVista.script" ]]; then
    echo "PlymouthVista theme must be installed before running this script!"
    exit 2
fi

while getopts ":s:H:nch" opt; do
    case $opt in
    s)
        OS_STATE=${OPTARG}
        ;;
    H)
        HIBERNATE_STAT=${OPTARG}
        ;;
    c)
        USE_SESSION_CHECK=1
        ;;
    n)
        ASSUME_NO_SHUTDOWN=1
        ;;
    h | *)
        usage
        exit 0
        ;;
    esac
done

if [[ -z $OS_STATE ]] && [[ -z $HIBERNATE_STAT ]] && [[ $USE_SESSION_CHECK == 0 ]]; then
    usage
    exit 0
fi
 
if [[ -n $HIBERNATE_STAT ]]; then
    if [[ $HIBERNATE_STAT != [0,1] ]]; then
        echo "Only provide '0' or '1' to the -H option."
        exit 2
    fi

    if [[ $USE_SESSION_CHECK == 1 ]]; then
        echo "You can only use session check with -n option."
        exit 2
    fi
fi

if [[ -n $OS_STATE ]]; then
    if [[ $OS_STATE != "sddm" ]] && [[ $OS_STATE != "desktop" ]]; then
        echo "Only provide 'sddm' and 'desktop' to the -s option."
        exit 2
    fi

    if [[ -n $HIBERNATE_STAT ]]; then
        echo "Either change hibernation status or os_state."
        exit 2
    fi

    if [[ $USE_SESSION_CHECK == 1 ]]; then
        echo "You can only use session check with -n option."
        exit 2
    fi
fi

if [[ $ASSUME_NO_SHUTDOWN == 1 ]] && [ "$(busctl get-property org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager PreparingForShutdown | awk '{print $2}')" = "true" ]; then
    echo "Shutdown signal was available, value will not be changed!"
    exit 0
fi

if [[ -n $HIBERNATE_STAT ]]; then
    ./pv_conf.sh -s ReturnFromHibernation -v $HIBERNATE_STAT
fi

if [[ $USE_SESSION_CHECK == 1 ]]; then
    if `loginctl list-sessions | awk '{print $3}' | grep -q 'sddm'`; then
        OS_STATE="sddm"
    else
        OS_STATE="desktop"
    fi
fi

if [[ -n $OS_STATE ]]; then
    if [[ $(./pv_conf.sh -g Pref) != 1 ]]; then
        echo "WARNING: Pref isn't set to '1', changing OsState won't make any changes."
    fi

    ./pv_conf.sh -s OsState -v $OS_STATE
fi
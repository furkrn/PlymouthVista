#!/bin/bash

USER_SYSTEMD_SERVICES="$(pwd)/systemd/user"
SYSTEM_SYSTEMD_SERVICES="$(pwd)/systemd/system"
HIBERNATE_SYSTEMD_SERVICES="$(pwd)/systemd/hibernation"
INSTALL_DIR="/usr/share/plymouth/themes/PlymouthVista"
HAS_SYSTEMD=1
COMPILED_SCRIPT="$(pwd)/PlymouthVista.script"
SKIP_CONF=0
SKIP_FINAL_QUESTION=0
NO_APPLY=0
COPY_OLD_CONF=0
OVERWRITE=0
RUN_USER="$SUDO_USER"

installSystemdServices() {
    local serviceInstallDirectory=$1
    local asUserService=$2

    if [[ ! -d $serviceInstallDirectory ]]; then
        echo "$serviceDirectory does not exist, ignoring it."
        return
    fi

    [[ $asUserService == 1 ]] && installDir="/etc/systemd/user" || installDir="/etc/systemd/system" 

    cp $serviceInstallDirectory/* $installDir

    for f in $serviceInstallDirectory/*.service; do
        serviceName=$(basename $f)
        if [[ $asUserService == 1 ]]; then
            systemctl enable --user -M $RUN_USER@ $serviceName
        else
            systemctl enable $serviceName
        fi
    done
}

tryUninstallSystemdServices() {
    local serviceInstallDirectory=$1
    local asUserService=$2

    if [[ ! -d $serviceInstallDirectory ]]; then
        echo "$serviceInstallDirectory does not exist, ignoring it."
        return
    fi

    for f in $serviceInstallDirectory/*.service; do
        serviceName=$(basename $f)
        if [[ $asUserService == 1 ]]; then
            if [[ $(systemctl --user -M $RUN_USER@ is-enabled $serviceName) == "enabled" ]]; then
                systemctl disable --user -M $RUN_USER@ $serviceName
            fi

            fullServicePath=/etc/systemd/user/$serviceName
        else
            if [[ $(systemctl is-enabled $serviceName) == "enabled" ]]; then
                systemctl disable $serviceName
            fi

            fullServicePath=/etc/systemd/system/$serviceName
        fi  

        if [[ -f $fullServicePath ]]; then
            rm $fullServicePath
        fi
    done
}

copyOldConfiguration() {
    echo "Copying old configuration..."
    lines=$(./pv_conf.sh -l -i $INSTALL_DIR/PlymouthVista.script || return)
    while read -r line; do
        key=$(echo $line | awk '{print $1}')
        value=$(./pv_conf.sh -g $key)
        ./pv_conf.sh -s $key -v "$value" -i $COMPILED_SCRIPT
    done <<< "$lines"
    echo "Done."
}

usage() {
    echo "  Collection of available arguments:"
    echo "  -h : Displays this message."
    echo "  -s : Skips configuration-related questions, such as switching to Windows 7 mode."
    echo "  -u : Copies your older configuration."
    echo "  -n : Keeps your current Plymouth configuration by not applying PlymouthVista as the default Plymouth theme."
    echo "  -o : Overwrites if an existing installation exits. Only skips the overwrite question!"
    echo "  -q : Skips the final question, which asks about whether you should use that configuration or not."
}

if [[ -z $RUN_USER ]]; then
    RUN_USER=$(logname)
fi

if [[ -z "$(command -v systemctl)" ]]; then
    HAS_SYSTEMD=0
fi

while getopts suqnoh op; do
    case $op in
        s)
            SKIP_CONF=1
            ;;
        u)
            COPY_OLD_CONF=1
            ;;
        q)
            SKIP_FINAL_QUESTION=1
            ;;
        n)
            NO_APPLY=1
            ;;
        o)
            OVERWRITE=1
            ;;
        h | *)
            usage
            exit 0
            ;;
    esac
done

if [[ "$EUID" != 0 ]]; then
    echo "You need to run this script as root."
    exit 2
fi

if [[ ! -f "./pv_conf.sh" ]]; then
    echo "./pv_conf.sh is not found! Stopping."
    exit 2
else
    chmod +x ./pv_conf.sh
fi

if [[ -z "$(command -v plymouth-set-default-theme)" ]]; then
    echo "Plymouth-scripts package is not installed! Stopping."
    exit 2
fi

if [[ ! -f $COMPILED_SCRIPT ]]; then
    echo "PlymouthVista.script isn't compiled, please run ./compile.sh first!"
    exit 1
fi

if plymouth-set-default-theme --list | grep -qe "PlymouthVista" || [ -d $INSTALL_DIR ]; then
    if [[ $OVERWRITE == 0 ]]; then
        read -p "PlymouthVista is already installed, Do you want to overwrite it? (y/N): " ANSWER
        if [[ $ANSWER == "${ANSWER#[Yy]}" ]]; then
            exit 2;
        fi
    fi

    if [[ $COPY_OLD_CONF == 1 ]]; then
        copyOldConfiguration
    fi

    rm -rf $INSTALL_DIR
fi

if ! fc-list | grep -qe "Segoe UI"; then    
    echo "WARNING: Segoe UI isn't installed. Everything except the Vista boot screen and password screen may look weird without Segoe UI."
fi

if ! fc-list | grep -qe "Lucida Console"; then
    echo "WARNING: Lucida Console isn't installed. Password screen may look weird without Lucida Console."
fi

if [[ $SKIP_CONF == 0 ]]; then
    read -p "Would you like to use the Windows 7 mode instead of the Windows Vista mode (y/N): " THEMESETTING
    if [[ $THEMESETTING != "${THEMESETTING#[Yy]}" ]]; then
        ./pv_conf.sh -s UseLegacyBootScreen -v 0 -i $COMPILED_SCRIPT
        ./pv_conf.sh -s UseShadow -v 1 -i $COMPILED_SCRIPT
        ./pv_conf.sh -s AuthuiStyle -v 7 -i $COMPILED_SCRIPT
    else
        ./pv_conf.sh -s UseLegacyBootScreen -v 1 -i $COMPILED_SCRIPT
        ./pv_conf.sh -s UseShadow -v 0 -i $COMPILED_SCRIPT
        ./pv_conf.sh -s AuthuiStyle -v vista -i $COMPILED_SCRIPT
    fi

    echo "Do you want fade in effects in shutdown?"

    if [ "$HAS_SYSTEMD" == 1 ]; then
        echo "1 - Automatic (Fade when shutdown is called from your desktop, don't fade when shutdown is called from SDDM)"
    else
        echo "Only 2 and 3 can be used. First option relies on Systemd."
    fi

    echo "2 - Always (Fade when shutdown is called from your desktop, fade when shutdown is called from SDDM)"
    echo "3 - Never (Don't fade when shutdown is called from your desktop, don't fade when shutdown is called from SDDM)"
    read -p "Your choice (1/2/3): " INPUT

    if [[ $INPUT != 1 ]] && [[ $INPUT != 2 ]] then
        INPUT=0;
    fi

    ./pv_conf.sh -s Pref -v $INPUT -i $COMPILED_SCRIPT

    if [ "$HAS_SYSTEMD" == 1 ]; then
        read -p "Do you want to enable hibernation features? (y/N): " ANSWER
        if [[ $ANSWER != "${ANSWER#[Yy]}" ]]; then
            ./pv_conf.sh -s UseHibernation -v 1 -i $COMPILED_SCRIPT
        fi
    else
        echo "Skipping hibernation question. This feature relies on Systemd."
    fi
fi

if [[ $SKIP_FINAL_QUESTION == 0 ]]; then
    ./pv_conf.sh -l -i $COMPILED_SCRIPT
    read -p "Do you want to continue with this configuration? (Y/n): " ANSWER
    if [[ $ANSWER != "${ANSWER#[Nn]}" ]]; then
        echo "Your answers is saved into the PlymouthVista.script."
        echo "To configure your PlymouthVista.script, use the ./pv_conf.sh script to configure it.,"
        echo "Then, start this script back with the -s option to skip questions to prevent overwriting back to your configuration."
        exit 0
    fi
fi

if [[ -z $(./pv_conf.sh -g OldPlymouthTheme) ]]; then
    echo "Retrieving the old Plymouth theme, because 'OldPlymouthTheme' wasn't set"
    oldTheme="bgrt"
    if [[ -f ."/readplyconf.sh" ]]; then
        chmod +x ./readplyconf.sh
        oldTheme=$(./readplyconf.sh Theme)
    fi

    ./pv_conf.sh -s OldPlymouthTheme -v "$oldTheme" -i ./PlymouthVista.script
fi

cp ./lucon_disable_anti_aliasing.conf /etc/fonts/conf.d/10-lucon_disable_anti_aliasing.conf
echo "Installed Font configuration."

if [[ $(./pv_conf.sh -g UseShadow) == 1 ]]; then
    if [[ ! -f "./gen_blur.sh" ]]; then
        echo "WARNING: Windows 7 blur effect cannot be generated because ./gen_blur.sh does not exist!"
    else
        chmod +x ./gen_blur.sh
        ./gen_blur.sh
    fi
fi

cp -r $(pwd) $INSTALL_DIR
echo "The theme is copied to $INSTALL_DIR"

if [[ "$HAS_SYSTEMD" == 1 ]]; then
    if [[ $(./pv_conf.sh -g Pref) == 1 ]]; then
        chmod 777 $INSTALL_DIR/PlymouthVista.script
        echo "Installing fade services..."
        installSystemdServices $SYSTEM_SYSTEMD_SERVICES 0
        installSystemdServices $USER_SYSTEMD_SERVICES 1
    else
        echo "Uninstalling fade services if they are still present..."
        tryUninstallSystemdServices $SYSTEM_SYSTEMD_SERVICES 0
        tryUninstallSystemdServices $USER_SYSTEMD_SERVICES 1
    fi

    if [[ $(./pv_conf.sh -g UseHibernation) == 1 ]]; then
        chmod 777 $INSTALL_DIR/PlymouthVista.script
        echo "Installing hibernation services..."
        installSystemdServices $HIBERNATE_SYSTEMD_SERVICES 0
    else
        echo "Uninstalling hibernation services if they are still present..."
        tryUninstallSystemdServices $HIBERNATE_SYSTEMD_SERVICES 0
    fi

fi

if [[ $NO_APPLY == 0 ]]; then
    echo "Setting plymouth theme as default..."
    plymouth-set-default-theme -R PlymouthVista
fi
echo "Done."
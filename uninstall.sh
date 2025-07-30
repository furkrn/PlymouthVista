#!/bin/bash
INSTALL_DIR="/usr/share/plymouth/themes/PlymouthVista"
CURRENT_DIR=$(pwd)
OLD_THEME="bgrt"
USER_SYSTEMD_SERVICES=("update-plymouth-vista-state-logon.service")
SYSTEM_SYSTEMD_SERVICES=("update-plymouth-vista-state-boot.service" "update-plymouth-vista-state-quit.service" "plymouth-vista-hibernate.service" "plymouth-vista-resume-from-hibernation.service" "plymouth-vista-slow-boot-animation.service")
SKIP_QUESTION=0
OLD_THEME_NOT_FOUND=0

if [[ $1 == "-y" ]]; then
    SKIP_QUESTION=1
fi

if [[ $EUID != 0 ]]; then
    echo "You need to run this script as root"
    exit 2
fi

if [[ -z $(command -v plymouth-set-default-theme) ]]; then
    echo "plymouth-set-default-theme isn't installed, exitting..."s
    exit 2
fi

if [[ ! -d $INSTALL_DIR ]]; then
    echo "PlymouthVista isn't installed, exitting..."
    exit 1
fi

if [[ -f "$INSTALL_DIR/pv_conf.sh" ]]; then
    cd $INSTALL_DIR
    chmod +x ./pv_conf.sh
    if ./pv_conf.sh -l | grep -qe OldPlymouthTheme; then
        configValue=$(./pv_conf.sh -g OldPlymouthTheme)
        if [[ -n $configValue ]]; then
            OLD_THEME="$configValue"
        else
            echo "WARNING: 'OldPlymouthTheme' was empty. Your Plymouth theme will set to '$OLD_THEME' instead."
        fi
    else
        echo "WARNING: Cannot find a key called 'OldPlymouthTheme' in your configuration, your Plymouth theme will set to '$OLD_THEME' instead."
    fi

    cd $CURRENT_DIR
else
    echo "WARNING: pv_conf.sh isn't found, your Plymouth theme will set to '$OLD_THEME' instead"
fi

if ! plymouth-set-default-theme --list | grep -qe "$OLD_THEME"; then
    echo "WARNING: '$OLD_THEME' isn't a valid Plymouth theme. Your Plymouth theme configuration will reset to default instead."
    OLD_THEME_NOT_FOUND=1
fi

if [[ $OLD_THEME == "PlymouthVista" ]]; then
    echo "WARNING: 'OldPlymouthTheme' was set to 'PlymouthVista', your Plymouth theme configuration will reset."
    OLD_THEME_NOT_FOUND=1
fi

if [[ $SKIP_QUESTION == 0 ]]; then
    read -p "Are you sure you want to uninstall PlymouthVista? (y/N): " ANSWER
    if [[ $ANSWER != "${ANSWER#[Nn]}" ]]; then
        exit 0
    fi
fi

if [[ ! -f "./readplyconf.sh" ]]; then
    echo "echo PlymouthVista" >> readplyconf.sh
fi

chmod +x ./readplyconf.sh

if [[ $(./readplyconf.sh "Theme") == "PlymouthVista" ]]; then
    if [[ $OLD_THEME_NOT_FOUND == 1 ]]; then
        echo "Resetting Plymouth theme configuration ..."
        plymouth-set-default-theme -Rr
    else
        echo "Changing Plymouth theme to $OLD_THEME."
        plymouth-set-default-theme -R $OLD_THEME
    fi
fi

if [[ -n $(command -v systemctl) ]]; then
    echo "Removing systemd services..."
    for userService in "${USER_SYSTEMD_SERVICES[@]}"; do
        if [[ $(systemctl --user -M $SUDO_USER@ is-enabled "$userService") == "enabled" ]]; then
            systemctl --user -M $SUDO_USER@ disable $userService
        fi
        serviceLocation="/etc/systemd/user/$userService"
        if [[ -f $serviceLocation ]]; then
            rm $serviceLocation
        fi
    done

    for systemService in "${SYSTEM_SYSTEMD_SERVICES[@]}"; do
        if [[ $(systemctl is-enabled "$systemService") == "enabled" ]]; then
            systemctl disable $systemService
        fi
        serviceLocation="/etc/systemd/system/$systemService"
        if [[ -f $serviceLocation ]]; then
            rm $serviceLocation
        fi
    done
fi

echo "Removing font configuration..."
rm /etc/fonts/conf.d/10-lucon_disable_anti_aliasing.conf

echo "Removing PlymouthVista files..."
rm -rf $INSTALL_DIR
echo "Uninstallation is completed."
echo "Thank you for trying out PlymouthVista."

#!/bin/bash

# IMPORTANT: This install script has only been tested on Fedora Linux.
# Installation procedure may vary from distribution-to-distribution.


if [[ "$EUID" != 0 ]]
then
    echo "You need to run this script as root."
    exit 2
fi

if [[ -z "$(command -v plymouth-set-default-theme)" ]]; then
    echo "Plymouth-scripts package is not installed! Stopping."
    exit 2
fi

if [[ ! -f "PlymouthVista.script" ]]; then
    echo "Please compile PlymouthVista by running ./compile.sh first."
    exit 2
fi

read -p "Would you like to use the Windows 7 variant instead of the Windows Vista variant (y/N): " THEMESETTING
if [[ $THEMESETTING != "${THEMESETTING#[Yy]}" ]]; then
    chmod +x ./gen_blur.sh
    ./gen_blur.sh

    # I won't bother with a proper better way, this just works :\
    sed -i '/# START_WIN7_CONFIG/,/# END_WIN7_CONFIG/{ 
    /# START_WIN7_CONFIG/!{ 
        /# END_WIN7_CONFIG/!d 
    } 
    r /dev/stdin
}' PlymouthVista.script <<EOF
// Use Vista boot which is available even on Windows 11.
// 1 - Use Vista boot screen
// 0 - Use 7 boot screen
global.UseLegacyBootScreen = 0;

// Add shadow effect to shutdown screen text.
// 0 - Windows Vista style, no text shadow.
// 1 - Windows 7 style, show text shadow. 
global.UseShadow = 1;

// Change the background of the shutdown screen.
// vista - Use Vista background and branding.
// 7 - Use 7 background and branding.
global.AuthuiStyle = "7";
EOF
fi

echo "Do you want fade in effects in shutdown?"
echo "1 - Automatic (Fade when shutdown is called from your desktop, don't fade when shutdown is called from SDDM)"
echo "2 - Always (Fade when shutdown is called from your desktop, fade when shutdown is called from SDDM)"
echo "3 - Never (Don't fade when shutdown is called from your desktop, don't fade when shutdown is called from SDDM)"
read -p "Your choice (1/2/3): " INPUT

if [[ $INPUT != 1 ]] && [[ $INPUT != 2 ]] then
    INPUT=0;
fi

sed -i '/# START_USED_BY_INSTALL_SCRIPT_PREF/,/# END_USED_BY_INSTALL_SCRIPT_PREF/{ 
    /# START_USED_BY_INSTALL_SCRIPT_PREF/!{ 
        /# END_USED_BY_INSTALL_SCRIPT_PREF/!d 
    } 
    r /dev/stdin
}' PlymouthVista.script <<EOF
global.Pref = $INPUT;
EOF

cp ./lucon_disable_anti_aliasing.conf /etc/fonts/conf.d/10-lucon_disable_anti_aliasing.conf
echo "Installed Font configuration"

if [ -d "/usr/share/plymouth/themes/PlymouthVista" ]; then
    rm -rf /usr/share/plymouth/themes/PlymouthVista
fi

cp -r $(pwd) /usr/share/plymouth/themes/PlymouthVista
echo "Copied theme."

if [[ $INPUT = 1 ]] then
    echo "Creating automatic services"
    chmod -R 777 /usr/share/plymouth/themes/PlymouthVista/

    cp $(pwd)/systemd/system/* /etc/systemd/system
    for f in $(pwd)/systemd/system/*.service; do
        systemctl enable $(basename $f)
    done

    cp $(pwd)/systemd/user/* /etc/systemd/user
        for f in $(pwd)/systemd/user/*.service; do
        systemctl --user -M $SUDO_USER@ enable update-plymouth-vista-state-logon.service
    done

fi

echo "Setting plymouth theme as default..."
plymouth-set-default-theme -R PlymouthVista
echo "Rebuilt initramfs while changing the Plymouth theme"
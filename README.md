## Note on copyrighted assets
## All of the resources belong to Microsoft Corporation.
## "Windows Vista" is a registered trademark of Microsoft Corporation. The author(s) of this project are in no way affiliated with Microsoft, and are not endorsed by Microsoft in any way.

# PlymouthVista
Re-creation of Windows Vista boot screen from its original assets. Designed to be used with themes like [VistaThemePlasma](https://gitgud.io/catpswin56/vistathemeplasma). If you use VTP you don't need to clone this repository because this theme is merged to the VTP repository.

Special thanks to [blacklightpy](https://github.com/blacklightpy) for literally everything.

Special thanks to [catpswin56](https://gitgud.io/catpswin56/vistathemeplasma) for VTP and accepting my merge request that merges this theme to their repository.

This project is a fan-made labor of love that sees absolutely no profit whatsoever, donations or otherwise.

# Installation

You will be needing `plymouth` and `plymouth-script` packages to install this theme.

You will be need `Segoe UI` and `Lucida Console` from a Windows installation. These fonts must be installed as system-wide fonts.

> [!WARNING]
> This theme is only tested on Fedora Linux and Arch Linux.

- Clone this repository.
- Compile script using `compile.sh`.
- Use `install.sh` for installation.

You might need to update initramfs again, if you persist flickering systemd messages at boot. Simply use `dracut --force --omit plymouth --regenerate-all --verbose`.

# Features

1- Vista boot:
![boot](screenshots/boot.gif)

2- Shutdown screen:
![shutdown](screenshots/shutdown.gif)

3- Windows boot manager (Password):
![password](screenshots/password.gif)

4- Windows Boot Manager (Question):
![question](screenshots/question.gif)
# Configuration:
For keys, refer to [this section of this documentation.](#keys)

## Configuring with pv_conf.sh:
`pv_conf.sh` is a script that helps to configure the theme. This script is already used for the fading effect, showing the hibernation screen and installing the theme.

- Compile the theme,
> [!WARNING]
> If you have an existing PlymouthVista installation, you also need to pass option `-i`, which accepts the `/path/of/the/new/PlymouthVista.script` file for the commands below. By passing the `-i` option, you won't be overwriting your existing installation.
- Run `./pv_conf.sh -l` to verify if it shows anything. This command displays every key and value pair from your compiled script.
- To get the value of a key, use `./pv_conf.sh -g {key}` to display the value of the key.
- To modify the value of a key, use `./pv_conf.sh -g {key} -v {value}`, which will modify the value of the key.
- After you've finished the configuration and want to install the theme, you may want to pass the `-s` option to skip questions that are related to basic configuration.


## Configuring by modifying the source:
You can also modify `/path/of/the/PlymouthVista/src/plymouth_config.sp`. 

> [!WARNING]
> You are directly modifying the PlymouthVista's source code. Please be careful about the syntax!

> [!WARNING]
> Do not remove the `global.` prefix. It's mandatory!

- Modify the `plymouth_config.sp` for your own taste. Only modify the parts like these:
- - `global.KeepTheKey = "modify here";` 
- - `global.KeepTheKeyAndModifyTheIntegerOnly = 1;`
- Then, run `./compile.sh`.
- After that, install the theme with `install.sh`. You may also want to pass the `-s` option to skip questions that are related to basic configuration.

# Keys:

### OsState:
**This key is reserved for fading service. Please don't modify it, especially when you set `Pref` to `1`.**

##### Accepted values:
- `sddm`: Won't show the fade that is applied to the shutdown and reboot screen.
- `desktop`: Will show the fade that is applied to the shutdown and reboot screen.

### SpawnFakeLogoff:
**This is reserved for the fake logoff screen service,** *which isn't available yet, lol.*

##### Accepted values:
- `1`: Show the logoff screen instead of the shutdown screen.
- `0`: Show the shutdown screen instead of the logoff screen.

### ReturnFromHibernation:
Used for whether the hibernation resume screen should be shown or not. **Please don't modify it if you use hibernation services.**

##### Accepted values:
- `1`: Show hibernation resume screen.
- `0`: Show normal boot screen.

### OldPlymouthTheme
This key is reserved for the uninstallation script, which will revert to the previous Plymouth theme.

##### Default value:
`""`

### Pref:
Fading preference for the shutdown and reboot screens.

##### Accepted values:
- `1`: Use `OsState` value to determine whether fade should be shown or not on the shutdown and reboot screen.
- `2`: Always show the fade.
- `3` - Never show the fade.

### UseHibernation:
Defines whether hibernation should be used or not.
**This value is only read by `install.sh` to add/remove hibernation services.**

##### Accepted values:
- `1`: Install hibernation services,
- `2`: Uninstall hibernation services, if they are present.

### DisableWall:
Defined whether annoying wall messages should be disabled or not.
**This value is only read by `install.sh` to add/remove no-wall services.**

##### Accepted values:
- `0`: Keep wall messages.
- `1`:  Disable wall messages.

### PasswordTitle:
Title of the password screen
##### Prerequisites:
- Must be a single line of text,
- Allowed up to 74 characters.
##### Default value:
`"Windows Boot Manager"`

### OverriddenPasswordMessage:
Overrides the message of the password screen with its value.

##### Prerequisites:
- Must be a single line of text,
- Allowed up to 74 characters.
##### Default value:
`""`

### PasswordText:
Text that is shown above the textbox.
##### Default value:
`"Password"`

### AnswerTitle:
Title of the password screen
##### Prerequisites:
- Must be a single line of text,
- Allowed up to 74 characters.
##### Default value:
`"Windows Boot Manager"`

### OverriddenAnswerMessage:
Overrides the message of the password screen with its value.

##### Prerequisites:
- Must be a single line of text,
- Allowed up to 74 characters.
##### Default value:
`""`

### AnswerText:
Text that is shown above the textbox.
##### Default value:
`"Password"`

### ScaleBootManager:
Defines whether elements in the Boot Manager screen *(password and answer screen)*, such as rectangles and texts, should be scaled or not.
Default is set to `0` because the screen may look weird.

##### Accepted values:
- `1`: Scale elements.
- `0`: Don't scale elements.

### ShutdownText:
Text that is shown when the system is shutting down.

##### Prerequisites:
- Only a single line of text is allowed. Don't use `/n`.
- If you set `UseShadow` to `1` and modified this key after installation, please consider regenerating the blur effect after modifying.

##### Default value:
`"Shutting down..."`

### RebootText:
Text that is shown when the system is rebooting.
- Both Windows 7 and Windows Vista use `Shutting Down...` instead of `Rebooting...` but to make this screen make more sense, you will see `Rebooting...` as the default value.

##### Prerequisites:
- Only a single line of text is allowed. Don't use `/n`.
- If you set `UseShadow` to `1` and modified this key after installation, please consider regenerating the blur effect after modifying.

##### Default value:
`"Rebooting..."`

### LogoffText:
Text that is shown when the fake logoff will be shown.

##### Prerequisites:
- Only a single line of text is allowed. Don't use `/n`.
- If you set `UseShadow` to `1` and modified this key after installation, please consider regenerating the blur effect after modifying.

##### Default value:
`"Logging off..."`

### UpdateTextMTL:
Text that is shown when the system is updating.
- This text supports formatting. Use `%i` for number.
- You can also use newline, unlike other screens. Simply use `\n` for newlines.

##### Prerequisites
- If you set `UseShadow` to `1` and modified this key after installation, please consider regenerating the blur effect after modifying.

##### Default Value:
`"Configuring Windows Updates\n%i% complete\nDo not turn off your computer.`

### UseLegacyBootScreen:
Defines whether the Vista boot screen should be used or not:

##### Accepted values:
- `1` - Use the Vista boot screen.
- `0` - Use the 7 boot screen.

### UseShadow:
Defines whether the shadow effect should be applied or not.
Modifying this value after installation requires the blur effects to be regenerated. Simply use the `./gen_blur.sh` script for it.

##### Accepted values:
- `1`: Windows Vista style, don't show text shadow.
- `0`: Windows 7 style, show text shadow.

### AuthuiStyle:
Sets the background and branding image of the shutdown, reboot, and update screen.

##### Accepted values:
- `"7"`: Use Windows 7 background and branding.
- `"vista"`: Use Windows Vista background and branding.

### StartingText:
The text that is displayed on Windows 7 boot screen when the system is starting normally.
##### Default value:
`"Starting Windows"`

### ResumingText:
The text that is displayed on Windows 7 boot screen when the system is returning from hibernation.
##### Default value:
`"Resuming Windows"`

### CopyrightText:
Copyright text of the Windows 7 boot screen that is displayed on bottom center of the screen. 
##### Default value:
`"© Microsoft Corporation"`

### UseNoGuiResume:
Defines whether Windows Vista's no GUI resume screen will be used or not.
This only applies when `UseLegacyBootScreen` is set to `1`.

##### Accepted values:
- `1` - Use Windows Vista's no GUI resume screen.
- `0` - Don't use Windows Vista's no GUI resume screen.

### NoGuiResumeText:
Text that is shown below of the progress bar on the Windows Vista hibernation resume screen.
##### Default value:
`"Resuming Windows..."`

### BootSlowdown
Slows down your boot in seconds.
Works when the plymouth-vista-slow-boot-animation.service is enabled.
If you don't want to slow down your boot time, keep this value as 0.
##### Default value:
`0`
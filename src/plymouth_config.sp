// plymouth_config.sp
// Plymouth theme configuration

// DO NOT MODIFY THIS SECTION ESPECIALLY IF YOU ARE USING "global.Pref = 1".
// AVAILABLE VALUES ARE EITHER "sddm" AND "desktop"
// ssdm - No fade
// desktop - Fade
# START_USED_BY_SERVICE
global.OsState = "desktop";
# END_USED_BY_SERVICE

// !START OF THE MODIFIABLE SECTION

// 1 - use service
// 2 - always fade
// anything else - never fade

# START_USED_BY_INSTALL_SCRIPT
global.Pref = 1;
# END_USED_BY_INSTALL_SCRIPT

// Title of the password screen, must be a single line and maximum 74 lengths is allowed!
// Defaults to "Windows Boot Manager"
global.PasswordTitle = "Windows Boot Manager";

// Message of the password screen. 
// Default is "" which will write boot messages instead.
global.OverriddenPasswordMessage = "";

// Password text of the password screen. must be a single line text.
global.PasswordText = "Password";

// Title of the answer screen, must be a single line and maximum 74 lengths is allowed!
global.AnswerTitle = "Windows Boot Manager";

// Message of the question screen. 
// Default is "" which will write boot messages instead.
global.OverriddenAnswerMessage = "";

// Password text of the answer screen. must be a single line text.
// Default is "Password"
global.AnswerText = "Password";

// Shutdown screen text
// Defaults to "Shutting Down..."
global.ShutdownText = "Shutting down...";

// Reboot screen text
// Default to "Rebooting..."
// Windows 7 & Vista displays "Shutting Down..." instead but I think it would be better if it says "Rebooting..." instead.
global.RebootText = "Rebooting...";

// !END OF THE MODIFIABLE SECTION

fun ReadOsState() {
    if (global.Pref == 1) {
        return global.OsState;
    }
    else if (global.Pref == 2) {
        return "desktop";
    }
    else {
        return "sddm";
    }
}
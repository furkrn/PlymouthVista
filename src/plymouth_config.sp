// plymouth_config.sp
// Plymouth theme configuration

// DO NOT MODIFY THIS SECTION ESPECIALLY IF YOU ARE USING "global.Pref = 1".
// AVAILABLE VALUES ARE EITHER "sddm" AND "desktop"
// ssdm - No fade
// desktop - Fade
# START_USED_BY_SERVICE
global.OsState = "desktop";
# END_USED_BY_SERVICE

// DO NOT MODIFY THIS SECTION,
// THIS SECTION IS MANAGED BY A SYSTEMD SERVICE (which will be available soon...)
# START_USED_BY_LOGOFF
global.SpawnFakeLogoff = 0;
# END_USED_BY_LOGOFF

// !START OF THE MODIFIABLE SECTION

// 1 - use service
// 2 - always fade
// anything else - never fade

# START_USED_BY_INSTALL_SCRIPT_PREF
global.Pref = 1;
# END_USED_BY_INSTALL_SCRIPT_PREF

// You can configure Fake logon screen by managing that systemd service!
// Any value for using that fake logoff screen here won't make sense.

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

// Defines boot manager screen should be scaled or not
// Default is "0" because will look weird when scaled
// 1 - Scale Boot manager screen
// 0 - Don't scale boot manager screen
global.ScaleBootManager = 0;

# START_GEN_BLUR
// Shutdown screen text
// Defaults to "Shutting down..."
// If you are using Windows 7 variant ("global.UseShadow = 1"), make sure to run gen_blur.sh after modifying this value
// Do not use multiline texts
global.ShutdownText = "Shutting down...";

// Reboot screen text
// Default to "Rebooting..."
// Windows 7 & Vista displays "Shutting down..." instead but I think it would be better if it says "Rebooting..." instead.
// If you are using Windows 7 variant ("global.UseShadow = 1"), make sure to run gen_blur.sh after modifying this value
// Do not use multiline texts
global.RebootText = "Rebooting...";

// Fake logoff screen text
// Defaults to "Logging off..."
// If you are using Windows 7 variant ("global.UseShadow = 1"), make sure to run gen_blur.sh after modifying this value
// Do not use multiline texts
global.LogoffText = "Logging off...";

// Update screen text
// Defaults to "Configuring Windows Updates\n%i% complete\nDo not turn off your computer."
// Use '\n' for newline
// Use $i for numbers
// Multiline texts are allowed.
global.UpdateText = "Configuring Windows Updates\n%i% complete\nDo not turn off your computer.";

# END_GEN_BLUR

# START_WIN7_CONFIG
// Use Vista boot which is available even on Windows 11.
// 1 - Use Vista boot screen
// 0 - Use 7 boot screen
global.UseLegacyBootScreen = 1;

// Add shadow effect to shutdown screen text.
// 0 - Windows Vista style, no text shadow.
// 1 - Windows 7 style, show text shadow. 
global.UseShadow = 0;

// Change the background of the shutdown screen.
// vista - Use Vista background and branding.
// 7 - Use 7 background and branding.
global.AuthuiStyle = "vista";
# END_WIN7_CONFIG

// Displayed text screen when system is booting using Windows 7 boot screen.
// Defaults to "Starting Windows"
global.StartingText = "Starting Windows";

// Displayed text screen when system is resuming using Windows 7 boot screen.
// Defaults to "Resuming Windows";
global.ResumingText = "Resuming Windows";

// Copyright text of Windows 7 boot screen
// Defaults to "© Microsoft Corporation"
global.CopyrightText = "© Microsoft Corporation";

// You can modify Windows 7 boot screen values if you want to do something like Free Ware Sys Starting Windows 9 or something like that...
// https://crustywindo.ws/w/images/2/2a/Dilshad9-Boot.png

// !END OF THE MODIFIABLE SECTION

fun ReadOsState() {
    if (global.Pref == 1) {
        if (global.SpawnFakeLogoff) {
            // Logoff screen will spawn only when user is logging off, 
            // We can safely ignore this because it will return to value 'sddm' when we logoff.
            // Use global.Pref to configure this.
            return "desktop";
        }
        
        return global.OsState;
    }
    else if (global.Pref == 2) {
        return "desktop";
    }
    else {
        return "sddm";
    }
}
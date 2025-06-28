// plymouth_config.sp
// Plymouth theme configuration

// You are free to modify this file for configuring the theme.
// But, I'd recommend keeping the original integrity of this file and using pv_conf.sh instead.
// Simply, compile the theme and run pv_conf.sh to configure.
#USED_BY_PV_CONF

// DO NOT MODIFY THIS SECTION ESPECIALLY IF YOU ARE USING "global.Pref = 1".
// AVAILABLE VALUES ARE EITHER "sddm" AND "desktop"
// sddm - No fade
// desktop - Fade
global.OsState = "desktop";

// DO NOT MODIFY THIS SECTION,
// THIS SECTION IS MANAGED BY A SYSTEMD SERVICE (which will be available soon...)
global.SpawnFakeLogoff = 0;

// DO NOT MODIFY THIS SECTION yet,
// THIS LINE will be MANAGED BY A SYSTEMD SERVICE
global.ReturnFromHibernation = 0;

// !START OF THE MODIFIABLE SECTION

// 1 - use service
// 2 - always fade
// anything else - never fade
global.Pref = 1;

// Sets whether hibernation should be used or not.
// This value is only read by install.sh to add/remove hibernation services.
// 1 - Use hibernation
// 0 - Don't use hibernation
global.UseHibernation = 0;

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
global.UpdateTextMTL = "Configuring Windows Updates\n%i% complete\nDo not turn off your computer.";

// Use Vista boot screen
// 1 - Use Vista boot screen
// 0 - Use 7 boot screen
global.UseLegacyBootScreen = 1;

// Adds shadow effect to the shutdown screen text.
// 0 - Windows Vista style, no text shadow.
// 1 - Windows 7 style, show text shadow. 
global.UseShadow = 0;

// Style of the Shutdown screen.
// vista - Use Vista background and branding.
// 7 - Use 7 background and branding.
global.AuthuiStyle = "vista";

// Sets the Windows 7 boot screen's starting text
// Defaults to "Starting Windows"
global.StartingText = "Starting Windows";

// Sets the Windows 7 boot screen's resuming text
// Defaults to "Resuming Windows";
global.ResumingText = "Resuming Windows";

// Copyright text of Windows 7 boot screen
// Defaults to "© Microsoft Corporation"
global.CopyrightText = "© Microsoft Corporation";

// Sets whether Windows Vista's no GUI resume screen will be used,
// This only applies when `global.UseLegacyBootScreen` is set to "1".
// 1 - Use Windows Vista's no GUI resume screen.
// 0 - Don't use Windows Vista's no GUI resume screen.
global.UseNoGuiResume = 1;

// Sets Windows Vista's no GUI resume screen's text.
// Defaults to "Resuming Windows..."
global.NoGuiResumeText = "Resuming Windows...";

// Want to make your own Windows 9, see this:
// https://crustywindo.ws/w/images/2/2a/Dilshad9-Boot.png

// !END OF THE MODIFIABLE SECTION
#END_USED_BY_PV_CONF

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
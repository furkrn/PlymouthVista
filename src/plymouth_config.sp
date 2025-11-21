// plymouth_config.sp
// Plymouth theme configuration

// You are free to modify this file for configuring the theme.
// But, I'd recommend keeping the original integrity of this file and using pv_conf.sh instead.
// Simply, compile the theme and run pv_conf.sh to configure.
#USED_BY_PV_CONF

//This key is reserved for fading service. Please don't modify it, especially when you set Pref to 1.
//Accepted values:
//sddm: Won't show the fade that is applied to the shutdown and reboot screen.
//desktop: Will show the fade that is applied to the shutdown and reboot screen.
global.OsState = "desktop";

//This is reserved for the fake logoff screen service, which isn't available yet, lol.
//Accepted Values:
//1: Show the logoff screen instead of the shutdown screen.
//0: Show the shutdown screen instead of the logoff screen.
global.SpawnFakeLogoff = 0;

//Used for whether the hibernation resume screen should be shown or not. Please don't modify it if you use hibernation services.
//Accepted Values:
//1: Show hibernation resume screen.
//0: Show normal boot screen.
global.ReturnFromHibernation = 0;

//This key is reserved for the uninstallation script, which will revert to the previous Plymouth theme.
global.OldPlymouthTheme = "";

//Pref:
//Fading preference for the shutdown and reboot screens.
//Accepted values:
//1: Use OsState value to determine whether fade should be shown or not on the shutdown and reboot screen.
//2: Always show the fade.
//3 - Never show the fade.
global.Pref = 1;

//Defines whether hibernation should be used or not.
//This value is only read by install.sh to add/remove hibernation services.
//Accepted values:
//1: Install hibernation services,
//2: Uninstall hibernation services, if they are present.
global.UseHibernation = 0;

//Defined whether annoying wall messages should be disabled or not.
//This value is only read by `install.sh` to add/remove no-wall services.
//Accepted values:
//0: Keep wall messages.
//1: Disable wall messages.
global.DisableWall = 1;

//Title of the password screen
//Prerequisites:
//Must be a single line of text,
//Allowed up to 74 characters.
//Default value:
//"Windows Boot Manager"
global.PasswordTitle = "Windows Boot Manager";

//Overrides the message of the password screen with its value.
//Prerequisites:
//Must be a single line of text,
//Allowed up to 74 characters.
//Default value:
//""
global.OverriddenPasswordMessage = "";

//Text that is shown above the textbox.
//
//Default value:
//"Password"
global.PasswordText = "Password";

//Title of the password screen
//Prerequisites:
//Must be a single line of text,
//Allowed up to 74 characters.
//Default value:
//"Windows Boot Manager"
global.AnswerTitle = "Windows Boot Manager";

//Overrides the message of the password screen with its value.
//Prerequisites:
//Must be a single line of text,
//Allowed up to 74 characters.
//Default value:
//""
global.OverriddenAnswerMessage = "";

//Text that is shown above the textbox.
//Default value:
//"Password"
global.AnswerText = "Password";

//Defines whether elements in the Boot Manager screen (password and answer screen), such as rectangles and texts, should be scaled or not.
//Default is set to 0 because the screen may look weird.
//Accepted values:
//1: Scale elements.
//0: Don't scale elements.
global.ScaleBootManager = 0;

//Text that is shown when the system is shutting down.
//Prerequisites:
//Only a single line of text is allowed. Don't use /n.
//If you set UseShadow to 1 and modified this key after installation, please consider regenerating the blur effect after modifying.
//Default value:
//"Shutting down..."
global.ShutdownText = "Shutting down...";

//Text that is shown when the system is rebooting.
//Both Windows 7 and Windows Vista use Shutting Down... instead of Rebooting... but to make this screen make more sense, you will see Rebooting... as the default value.
//Prerequisites:
//Only a single line of text is allowed. Don't use /n.
//If you set UseShadow to 1 and modified this key after installation, please consider regenerating the blur effect after modifying.
//Default value:
//"Rebooting..."
global.RebootText = "Rebooting...";

//Text that is shown when the fake logoff will be shown.
//Prerequisites:
//Only a single line of text is allowed. Don't use /n.
//If you set UseShadow to 1 and modified this key after installation, please consider regenerating the blur effect after modifying.
//Default value:
//"Logging off..."
global.LogoffText = "Logging off...";

//Text that is shown when the system is updating.
//This text supports formatting. Use %i for number.
//You can also use newline, unlike other screens. Simply use \n for newlines.
//Prerequisites
//If you set UseShadow to 1 and modified this key after installation, please consider regenerating the blur effect after modifying.
//Default Value:
//"Configuring Windows Updates\n%i% complete\nDo not turn off your computer.
global.UpdateTextMTL = "Configuring Windows Updates\n%i% complete\nDo not turn off your computer.";

//Defines whether the Vista boot screen should be used or not:
//Accepted values:
//1 - Use the Vista boot screen.
//0 - Use the 7 boot screen.
global.UseLegacyBootScreen = 1;

//Defines whether the shadow effect should be applied or not.
//Modifying this value after installation requires the blur effects to be regenerated. Simply use the `./gen_blur.sh` script for it.
//Accepted values:
//1: Windows Vista style, don't show text shadow.
//0: Windows 7 style, show text shadow.
global.UseShadow = 0;

//Sets the background and branding image of the shutdown, reboot, and update screen.
//Accepted values:
//"7": Use Windows 7 background and branding.
//"vista": Use Windows Vista background and branding.
global.AuthuiStyle = "vista";

//The text that is displayed on Windows 7 boot screen when the system is starting normally.
//Default value:
//"Starting Windows"
global.StartingText = "Starting Windows";

//The text that is displayed on Windows 7 boot screen when the system is returning from hibernation.
//Default value:
//"Resuming Windows"
global.ResumingText = "Resuming Windows";

//Copyright text of the Windows 7 boot screen that is displayed on bottom center of the screen.
//Default value:
//"© Microsoft Corporation"
global.CopyrightText = "© Microsoft Corporation";

//Defines whether Windows Vista's no GUI resume screen will be used or not.
//This only applies when UseLegacyBootScreen is set to 1.
//Accepted values:
//1 - Use Windows Vista's no GUI resume screen.
//0 - Don't use Windows Vista's no GUI resume screen.
global.UseNoGuiResume = 1;

//Text that is shown below of the progress bar on the Windows Vista hibernation resume screen.
//Default value:
//"Resuming Windows..."
global.NoGuiResumeText = "Resuming Windows...";

//Slows down your boot in seconds.
//Works when the plymouth-vista-slow-boot-animation.service is enabled.
//If you don't want to slow down your boot, keep this value as 0.
//Default value:
//0
global.BootSlowdown = 0;

// Want to make your own Windows 9, see this:
// https://crustywindo.ws/w/images/2/2a/Dilshad9-Boot.png

#END_USED_BY_PV_CONF

// Do not modify this!
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
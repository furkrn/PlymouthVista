// PlymouthVista
// Plymouth theme to emulate the Windows Vista boot sequences.
// 
// No copyrighted assets are distributed with this project.
// You must prepare the required assets yourself.
// This project includes a Python script to automate this process for you.
// See prepare_assets/README for details.
// 
// "Windows Vista" is a registered trademark of Microsoft Corporation.
// The author(s) of this software are in no way affiliated with or endorsed by Microsoft Corporation,
// in any capacity. This project is a fan-made labor of love that sees NO PROFITS WHATSOEVER, donations or otherwise.

Window.SetBackgroundColor(0, 0, 0);

global.GlobalWidth = Window.GetWidth();
global.GlobalHeight = Window.GetHeight();

global.ScaleFactorX = Window.GetWidth() / 640;
global.ScaleFactorY = Window.GetHeight() / 480;

global.ScaleFactorXAuthui = Window.GetWidth() / 1900;
global.ScaleFactorYAuthui = Window.GetHeight() / 1200;

BootManager = 0;
BootScreen = 0;
ShutdownScreen = 0;

fun RefreshCallback() {
	if (BootManager == 0) {
		if (Plymouth.GetMode() == "boot" || Plymouth.GetMode() == "resume") {
			BootScreen.Update(BootScreen);
		}
		else if (Plymouth.GetMode() == "shutdown" || Plymouth.GetMode() == "reboot") {
			ShutdownScreen.UpdateFade(ShutdownScreen);
		}
	}
}

fun ShowQuestionDialog(prompt, contents) {
	if (BootManager == 0) {
		BootManager = BootManagerNew("Windows Boot Manager", prompt, "Answer");
	}
	else {
		BootManager.UpdateAnswer(BootManager, contents);
	}
}

fun ShowPasswordDialog(prompt, bulletCount) {
	if (BootManager == 0) {
		BootManager = BootManagerNew("Windows Boot Manager", prompt, "Password");
	}
	else {
		BootManager.UpdateBullets(BootManager, bulletCount);
	}

}

fun ReturnNormal() {
    if (Plymouth.GetMode() == "boot" || Plymouth.GetMode() == "resume") {
		BootScreen = BootScreenNew();
		Plymouth.SetRefreshRate(12);
    }
    else if (Plymouth.GetMode() == "shutdown") {
	    ShutdownScreen = ShutdownScreenNew("Shutting down...");
	    Plymouth.SetRefreshRate(30);
    }
    else if (Plymouth.GetMode() == "reboot") {
	    ShutdownScreen = ShutdownScreenNew("Rebooting...");
	    Plymouth.SetRefreshRate(30);
    }

	if (BootManager != 0) {
		BootManager = 0;
	}

	Plymouth.SetRefreshFunction(RefreshCallback);
}

Plymouth.SetDisplayNormalFunction(ReturnNormal);
Plymouth.SetDisplayQuestionFunction(ShowQuestionDialog);
Plymouth.SetDisplayPasswordFunction(ShowPasswordDialog);

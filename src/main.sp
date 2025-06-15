// PlymouthVista
// Plymouth theme to emulate the Windows Vista and 7 boot sequences and shutdown sequences.
// 
// Distributed images are owned by Microsoft Corporation!
// 
// "Windows Vista" is a registered trademark of Microsoft Corporation.
// The author(s) of this software are in no way affiliated with or endorsed by Microsoft Corporation,
// in any capacity. This project is a fan-made labor of love that sees NO PROFITS WHATSOEVER, donations or otherwise.
//
// "Windows 7" is a registered trademark of Microsoft Corporation.
// The author(s) of this software are in no way affiliated with or endorsed by Microsoft Corporation,
// in any capacity. This project is a fan-made labor of love that sees NO PROFITS WHATSOEVER, donations or otherwise.

Window.SetBackgroundColor(0, 0, 0);

global.GlobalWidth = Window.GetWidth();
global.GlobalHeight = Window.GetHeight();

global.ScaleFactorX = Window.GetWidth() / 640;
global.ScaleFactorY = Window.GetHeight() / 480;

global.ScaleFactorXAuthui = Window.GetWidth() / 1920;
global.ScaleFactorYAuthui = Window.GetHeight() / 1200;

BootManager = 0;
BootScreen = 0;
ShutdownScreen = 0;
UpdateScreen = 0;

fun RefreshCallback() {
	if (BootManager == 0) {
		mode = Plymouth.GetMode();
		if (mode == "boot" || mode == "firmware_upgrade" || mode == "update") {
			BootScreen.Update(BootScreen);
		}
		else if (mode == "shutdown" || mode == "reboot") {
			if (ReadOsState() == "sddm") {
				ShutdownScreen.UpdateDelayed(ShutdownScreen);
			}
			else {
				ShutdownScreen.UpdateFade(ShutdownScreen);
			}
		}
		else if (mode == "system-upgrade") {
			UpdateScreen.ShowScreen(UpdateScreen);
		}
	}
}

fun ShowQuestionDialog(prompt, contents) {
	if (BootManager == 0) {
		val = 0;
		if (global.OverriddenAnswerMessage != "") {
			val = global.OverriddenAnswerMessage;
		}
		else {
			val = prompt;
		}
		BootManager = BootManagerNew(global.AnswerTitle, prompt, global.AnswerText);
	}
	else {
		BootManager.UpdateAnswer(BootManager, contents);
	}
}

fun ShowPasswordDialog(prompt, bulletCount) {
	if (BootManager == 0) {
		val = 0;
		if (global.OverriddenPasswordMessage != "") {
			val = global.OverriddenPasswordMessage;
		}
		else {
			val = prompt;
		}
		BootManager = BootManagerNew(global.PasswordTitle, val, global.PasswordText);
	}
	else {
		BootManager.UpdateBullets(BootManager, bulletCount);
	}

}

fun ShowSystemUpdate(progress)
{
	UpdateScreen.ShowScreen(UpdateScreen);
	UpdateScreen.UpdateText(UpdateScreen, progress);
}

fun ReturnNormal() {
	mode = Plymouth.GetMode();
	// Why are "update" and "firmware_upgrade" modes here? Because,
	// - Fedora's BGRT theme shows spinner on "firmware_upgrade"
	// - Fedora's BGRT theme shows spinner on "update"
    if (mode == "boot" || mode == "update" || mode == "firmware_upgrade") {
		if (global.UseLegacyBootScreen) {
			if (global.ReturnFromHibernation && global.UseNoGuiResume) {
				BootScreen = NewNoGUIBoot();
			}
			else {
				BootScreen = LegacyBootScreenNew();
			}

		}
		else {
			if (global.ReturnFromHibernation) {
				BootScreen = SevenBootScreenNew("resume");
			}
			else {
				BootScreen = SevenBootScreenNew("boot");
			}
		}
		
		Plymouth.SetRefreshRate(12);

    }
    else if (mode == "shutdown") {
		text = "";
		blur = "";
		if (global.SpawnFakeLogoff) {
			text = global.LogoffText;
			blur = "blurLogoffText.png";
		}
		else {
			text = global.ShutdownText;
			blur = "blurShutdownText.png";
		}

	    ShutdownScreen = ShutdownScreenNew(text, blur);
	    Plymouth.SetRefreshRate(30);
    }
    else if (mode == "reboot") {
	    ShutdownScreen = ShutdownScreenNew(global.RebootText, "blurRebootText.png");
	    Plymouth.SetRefreshRate(30);
    }
	else if (mode == "system-upgrade")
	{
		UpdateScreen = UpdateScreenNew(global.UpdateText);
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
Plymouth.SetSystemUpdateFunction(ShowSystemUpdate);

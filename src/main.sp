// PlymouthXP
// Plymouth theme to emulate the Windows XP boot sequences.
// 
// No copyrighted assets are distributed with this project.
// You must prepare the required assets yourself.
// This project includes a Python script to automate this process for you.
// See prepare_assets/README for details.
// 
// "Windows XP" is a registered trademark of Microsoft Corporation.
// The author(s) of this software are in no way affiliated with or endorsed by Microsoft Corporation,
// in any capacity. This project is a fan-made labor of love that sees NO PROFITS WHATSOEVER, donations or otherwise.

Window.SetBackgroundColor(0, 0, 0);

ScaleFactorX = Window.GetWidth() / 640;
ScaleFactorY = Window.GetHeight() / 480;

BootScreen = BootScreenNew();

fun RefreshCallback() {
	if (Plymouth.GetMode() == "boot" || Plymouth.GetMode() == "resume") {
		BootScreen.Update(BootScreen);
	}
}

Plymouth.SetRefreshRate(12);
Plymouth.SetRefreshFunction(RefreshCallback);

// PlymouthVista
// boot7.sp
// Defines Windows 7 style boot screen class

fun SevenBootScreenNew(status) {
    local.self = [];

    scaleX = global.GlobalWidth / 1024;
    scaleY = global.GlobalHeight / 768;

    self.CopyrightText = Image.Text(global.CopyrightText, 0.5, 0.5, 0.5, 1, "Segoe UI 11");
    self.ScaledCopyright = self.CopyrightText.Scale(self.CopyrightText.GetWidth() * scaleX, self.CopyrightText.GetHeight() * scaleY);
    self.CopyrightSprite = Sprite();
    self.CopyrightSprite.SetImage(self.ScaledCopyright);
    self.CopyrightSprite.SetOpacity(0);

    self.CopyrightTextX = (global.GlobalWidth - self.ScaledCopyright.GetWidth()) / 2;
    self.CopyrightTextY = 718 * scaleY;
    
    self.CopyrightSprite.SetX(self.CopyrightTextX);
    self.CopyrightSprite.SetY(self.CopyrightTextY);

    text = "";
    if (status == "resume") {
        text = global.ResumingText;
    }
    else {
        text = global.StartingText;
    }

    self.MainText = Image.Text(text, 1, 1, 1, 1, "Segoe UI 18");
    self.ScaledMainText = self.MainText.Scale(self.MainText.GetWidth() * scaleX, self.MainText.GetHeight() * scaleY);
    self.MainTextSprite = Sprite();
    self.MainTextSprite.SetImage(self.ScaledMainText);
    self.MainTextSprite.SetOpacity(0);

    self.MainTextX = (global.GlobalWidth - self.ScaledMainText.GetWidth()) / 2;
    self.MainTextY = 523 * scaleY;

    self.MainTextSprite.SetX(self.MainTextX);
    self.MainTextSprite.SetY(self.MainTextY);

    for (i = 0; i < 105; i++) {
        flagImage = Image("flag" + i + ".png");
        flagImageScaled = flagImage.Scale(flagImage.GetWidth() * scaleX, flagImage.GetHeight() * scaleY);
        flagSprite = Sprite();
        flagSprite.SetImage(flagImageScaled);
        flagSprite.SetOpacity(0);
        flagSprite.SetX(self.MainTextX);
        flagSprite.SetY(self.MainTextY - self.ScaledMainText.GetHeight() - flagImageScaled.GetHeight());
        self.Flags[i] = flagSprite;
    }

    self.Current = 0;
    self.LastStep = 0;

    fun Update(self) {
        if (self.Current == 0) {
            self.CopyrightSprite.SetOpacity(1);
            self.MainTextSprite.SetOpacity(1);
            self.Flags[0].SetOpacity(1);
        }
        else {
            self.Flags[self.LastStep].SetOpacity(0);
            self.Flags[self.Current].SetOpacity(1);
        }

        self.LastStep = self.Current;
        if (self.Current == 104) {
            self.Current = 60;
        }
        else {
            self.Current++;
        }

    }

    self.Update = Update;

    return self;
}
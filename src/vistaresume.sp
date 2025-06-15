// vistaresume.sp
// Windows Vista resume screen.

fun NewNoGUIBoot(text) {
    local.self = [];

    scaleFactorX = GlobalWidth / 1024;
    scaleFactorY = GlobalHeight / 768;

    self.NoGuiImage = Image("resumevista.png");
    self.NoGuiScaledX = self.NoGuiImage.GetWidth() * scaleFactorX;
    self.NoGuiScaledY = self.NoGuiImage.GetHeight() * scaleFactorY;
    self.NoGuiScaled = self.NoGuiImage.Scale(self.NoGuiScaledX, self.NoGuiScaledY);

    self.NoGuiSprite = Sprite(self.NoGuiScaled);
    self.NoGuiSprite.SetZ(0);
    self.NoGuiSprite.SetOpacity(1);

    fontSize = 18 * (GlobalHeight / 768);
    self.ResumeText = Image.Text(global.NoGuiResumeText, 0.5, 0.5, 0.5, 1, "Lucida Console " + fontSize);
    textY = GlobalHeight - fontSize - 20;
    
    self.ResumeTextSprite = Sprite(self.ResumeText);
    self.ResumeTextSprite.SetZ(1);
    self.ResumeTextSprite.SetX((GlobalWidth - self.ResumeText.GetWidth()) / 2);
    self.ResumeTextSprite.SetY(textY);

    for (i = 1; i < 11; i++) {
        resumeBarImage = Image("resumebar" + i + ".png");
        resumeBarScaleX = resumeBarImage.GetWidth() * scaleFactorX;
        resumeBarScaleY = resumeBarImage.GetHeight() * scaleFactorY;
        resumeBarImageScaled = resumeBarImage.Scale(resumeBarScaleX, resumeBarScaleY);

        resumeBarSprite = Sprite(resumeBarImageScaled);
        resumeBarSprite.SetOpacity(0);
        resumeBarSprite.SetX((GlobalWidth - resumeBarImageScaled.GetWidth()) / 2);
        resumeBarSprite.SetY(textY - fontSize * 2);
        resumeBarSprite.SetZ(1);

        self.ResumeBars[i - 1] = resumeBarSprite;
    }

    self.CurrentStep = 0;
    self.LastStep = 9;

    fun Update(self) {
        self.ResumeBars[self.CurrentStep].SetOpacity(1);
        self.ResumeBars[self.LastStep].SetOpacity(0);
        self.LastStep = self.CurrentStep;
        if (self.CurrentStep >= 9) {
            self.CurrentStep = 0;
        }
        else {
            self.CurrentStep++;
        }
    }

    self.Update = Update;

    return self;
}
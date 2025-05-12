// PlymouthVista
// Windows Update screen
// wupdate.sp

fun UpdateScreenNew(baseText) {
    local.self = [];

    self.BaseText = baseText;

    self.BaseSprite = Sprite();
    self.BaseImage = Image("authui_" + global.AuthuiStyle + ".png");

    self.ScaledX = self.BaseImage.GetWidth() * ScaleFactorXAuthui;
    self.ScaledY = self.BaseImage.GetHeight() * ScaleFactorYAuthui;

    self.BaseImageScaled = self.BaseImage.Scale(self.ScaledX, self.ScaledY);

    self.BaseSprite.SetImage(self.BaseImageScaled);
    self.BaseSprite.SetOpacity(0);
    self.BaseSprite.SetZ(1);

    self.BrandingSprite = Sprite();
    self.BrandingImage = Image("branding_" + global.AuthuiStyle + ".png");
    self.BrandingSprite.SetImage(self.BrandingImage);

    // does scaling matter? simply no! 
    self.BrandingSprite.SetOpacity(0.0);
    self.BrandingSprite.SetZ(2);

    self.BrandingSprite.SetX((GlobalWidth - self.BrandingImage.GetWidth()) / 2);
    self.BrandingSprite.SetY(GlobalHeight - self.BrandingImage.GetHeight() - 23);

    baseTextString = Format(baseText, 0);
    baseTextLine = CountLines(baseTextString);
    baseText = Image.Text(baseTextString, 1, 1, 1, 1, "Segoe UI 18", "center");

    self.TextX = (GlobalWidth - baseText.GetWidth()) / 2 + 36;
    self.TextY = (GlobalHeight - baseText.GetHeight()) / 2;

    self.CurrentTextSprite = Sprite();
    self.CurrentTextSprite.SetImage(baseText);
    self.CurrentTextSprite.SetOpacity(0);
    self.CurrentTextSprite.SetX(self.TextX);
    self.CurrentTextSprite.SetY(self.TextY);
    self.CurrentTextSprite.SetZ(4);

    if (global.UseShadow) {
        shadow = Image("blurUpdate0.png");

        self.CurrentShadowSprite = Sprite();
        self.CurrentShadowSprite.SetImage(shadow);
        self.CurrentShadowSprite.SetOpacity(0);
        self.CurrentShadowSprite.SetZ(3);
        self.CurrentShadowSprite.SetX(self.TextX - 4.5);
        self.CurrentShadowSprite.SetY(self.TextY + 1.7);

    }

    for (i = 0; i < 18; i++) {
        imageSpinner = Image("spinner_" + i + ".png");
        self.SpinnerWidth = imageSpinner.GetWidth();

        sprite = Sprite();
        sprite.SetImage(imageSpinner);
        sprite.SetOpacity(0);
        sprite.SetZ(10);

        sprite.SetX(self.TextX - 8 - imageSpinner.GetWidth());
        if (baseTextLine == 1) {
            sprite.SetY(self.TextY + imageSpinner.GetHeight() / 3);
        }
        else {
            sprite.SetY(self.TextY + baseTextLine * 2 * imageSpinner.GetHeight() / 3);
        }

        self.Spinners[i] = sprite;
    }

    self.SpinnerStep = 0;
    self.LastSpinner = 17;

    self.CurrentDot = 0;

    fun ShowScreen(self) {
        self.BaseSprite.SetOpacity(1);
        self.BrandingSprite.SetOpacity(1);
        self.CurrentTextSprite.SetOpacity(1);
        self.DotSprite.SetOpacity(1);
        if (global.UseShadow) {
            self.CurrentShadowSprite.SetOpacity(1);
            self.DotShadowSprite.SetOpacity(1);
        }
        
        self.DrawSpinners(self);
    }

    fun UpdateText(self, progress) {
        text = Image.Text(Format(self.BaseText, progress), 1, 1, 1, 1, "Segoe UI 18", "center");
        self.CurrentTextSprite.SetImage(text);
        if (global.UseShadow) {
            shadow = Image("blurUpdate" + progress + ".png");
            self.CurrentShadowSprite.SetImage(shadow);
        }
    }

    fun DrawSpinners(self) {
        currentStep = self.Spinners[self.SpinnerStep];
        currentStep.SetOpacity(1);
        
        lastStep = self.Spinners[self.LastSpinnerStep];
        lastStep.SetOpacity(0);

        self.LastSpinnerStep = self.SpinnerStep;

        if (self.SpinnerStep >= 17) {
            self.SpinnerStep = 0;
        }
        else {
            self.SpinnerStep += 1;
        }
    }

    self.ShowScreen = ShowScreen;
    self.UpdateText = UpdateText;
    self.DrawSpinners = DrawSpinners;
    self.DrawDots = DrawDots;

    return self;
}
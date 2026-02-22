// PlymouthVista
// Windows Updates screen
// wupdate.sp

fun UpdateScreenNew() {
    local.self = [];

    self.BaseSprite = Sprite();
    self.BaseImage = Image("authui_" + global.AuthuiStyle + ".png").Scale(Window.GetWidth(), Window.GetHeight());
    self.BaseSprite.SetImage(self.BaseImage);
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

    baseText = Image("textUpdate0.png");

    self.TextX = (GlobalWidth - baseText.GetWidth()) / 2;
    self.TextY = (GlobalHeight - baseText.GetHeight()) / 2 - 36;

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
        // The shadows have a 2px padding, and we want to offset it by
        // (0.5, 1), so we use (TextX - 1.5, TextY - 1) to account for both.
        self.CurrentShadowSprite.SetX(self.TextX - 1.5);
        self.CurrentShadowSprite.SetY(self.TextY - 1);
    }

    for (i = 0; i < 18; i++) {
        imageSpinner = Image("spinner_" + i + ".png");
        self.SpinnerWidth = imageSpinner.GetWidth();

        sprite = Sprite();
        sprite.SetImage(imageSpinner);
        sprite.SetOpacity(0);
        sprite.SetZ(10);

        sprite.SetX(self.TextX - 8 - imageSpinner.GetWidth());
        sprite.SetY((GlobalHeight - imageSpinner.GetHeight()) / 2 - 36);

        self.Spinners[i] = sprite;
    }

    self.SpinnerStep = 0;
    self.LastSpinner = 17;

    self.CurrentDot = 0;

    fun ShowScreen(self) {
        self.BaseSprite.SetOpacity(1);
        self.BrandingSprite.SetOpacity(1);
        self.CurrentTextSprite.SetOpacity(1);
        if (global.UseShadow) {
            self.CurrentShadowSprite.SetOpacity(1);
        }

        self.DrawSpinners(self);
    }

    fun UpdateText(self, progress) {
        text = Image("textUpdate" + progress + ".png");
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
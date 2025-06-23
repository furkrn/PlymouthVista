// PlymouthVista
// Shutdown screen.
// shutdown.sp

fun ShutdownScreenNew(text, blurLocation) {
    local.self = [];

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

    // does scaling matter?
    self.BrandingSprite.SetOpacity(0.0);
    self.BrandingSprite.SetZ(2);

    self.BrandingSprite.SetX((GlobalWidth - self.BrandingImage.GetWidth()) / 2);
    self.BrandingSprite.SetY(GlobalHeight - self.BrandingImage.GetHeight() - 23);

    self.Text = Image.Text(text, 1, 1, 1, 1, "Segoe UI 18");
    self.TextSprite = Sprite();
	self.TextSprite.SetImage(self.Text);

    self.TextX = (GlobalWidth - self.Text.GetWidth()) / 2;
    self.TextY = (GlobalHeight - self.Text.GetHeight()) / 2 - 36;

	self.TextSprite.SetOpacity(0);
	self.TextSprite.SetZ(4);
    self.TextSprite.SetX(self.TextX);
    self.TextSprite.SetY(self.TextY);

    if (global.UseShadow) {
        self.ShadowImage = Image(blurLocation);
        self.ShadowSprite = Sprite();
        self.ShadowSprite.SetImage(self.ShadowImage);
        self.ShadowSprite.SetOpacity(0);
        self.ShadowSprite.SetZ(3);
        self.ShadowSprite.SetX(self.TextX);
        self.ShadowSprite.SetY(self.TextY + 1);
    }

    for (i = 0; i < 18; i++) {
        imageSpinner = Image("spinner_" + i + ".png");
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

    self.FadedOpacity = 0;
    self.Updating = true;
    self.DelaySteps = 10000;
    self.CurrentDelayStep = 0;
    self.FadeSteps = 18;

    fun UpdateFade(self) {
        if (self.Updating == true) {
            self.FadedOpacity += (1 / self.FadeSteps);
        }

        if (self.FadedOpacity >= 1) {
            self.Updating = false;
            self.FadedOpacity = 1;
        }

        self.SetBackgroundOpacity(self, self.FadedOpacity);
        self.SetTextOpacity(self, self.FadedOpacity);
        self.DrawSpinners(self, self.FadedOpacity);
    }

    fun UpdateDelayed(self) {
        self.SetBackgroundOpacity(self, 1);
        self.CurrentDelayStep++;

        if (self.CurrentDelayStep >= self.DelaySteps) {
            self.Updating = false;
        }

        if (self.Updating == false) {
            self.SetTextOpacity(self, 1);
            self.DrawSpinners(self, 1);
        }
    }

    fun SetBackgroundOpacity(self, opaque) {
        self.BaseSprite.SetOpacity(opaque);
        self.BrandingSprite.SetOpacity(opaque);
    }

    fun SetTextOpacity(self, opaque) {
        self.TextSprite.SetOpacity(opaque);
        if (global.UseShadow) {
            self.ShadowSprite.SetOpacity(opaque);
        }
    }

    fun DrawSpinners(self, opaque) {
        currentStep = self.Spinners[self.SpinnerStep];
        currentStep.SetOpacity(opaque);
        
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

    self.UpdateFade = UpdateFade;
    self.UpdateDelayed = UpdateDelayed;
    self.SetBackgroundOpacity = SetBackgroundOpacity;
    self.SetTextOpacity = SetTextOpacity;
    self.DrawSpinners = DrawSpinners;

    return self;
}
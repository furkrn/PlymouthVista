// PlymouthXP
// boot.sp
// Defines the standard boot screen class

fun BootScreenNew() {
	local.self = [];
	
	self.BaseSprite = Sprite();
	self.ProgressSprite = Sprite();

	self.BaseImage = Image("base.png");
	self.ProgressImage = Image("progress.png");

	self.State = "fadein";
	self.Opacity = 0;
	self.FadeSteps = 15;

	// I could directly use the screen width & height here, but
	// I want to follow the pattern of using the scale factors.
	self.BaseScaledWidth = self.BaseImage.GetWidth() * ScaleFactorX;
	self.BaseScaledHeight = self.BaseImage.GetHeight() * ScaleFactorY;

	self.ProgressScaledWidth = self.ProgressImage.GetWidth() * ScaleFactorX;
	self.ProgressScaledHeight = self.ProgressImage.GetHeight() * ScaleFactorY;

	self.BaseImageScaled = self.BaseImage.Scale(self.BaseScaledWidth, self.BaseScaledHeight);
	self.ProgressImageScaled = self.ProgressImage.Scale(self.ProgressScaledWidth, self.ProgressScaledHeight);

	self.BaseSprite.SetImage(self.BaseImageScaled);
	self.BaseSprite.SetOpacity(0);
	self.BaseSprite.SetZ(1);

	// Progress co-ordinate stuff
	self.ProgressOriginX = 234 * ScaleFactorX;
	self.ProgressReturnX = (234 + (18 * 8)) * ScaleFactorX;
	self.ProgressCurrentX = self.ProgressOriginX;
	self.ProgressStepX = 8 * ScaleFactorX;
	self.ProgressY = 354 * ScaleFactorY;

	self.ProgressSprite.SetImage(self.ProgressImageScaled);
	self.ProgressSprite.SetOpacity(0);
	self.ProgressSprite.SetZ(0);
	self.ProgressSprite.SetX(self.ProgressCurrentX);
	self.ProgressSprite.SetY(self.ProgressY);
	
	fun Update(self) {
		// What state are we in?
		if (self.State == "fadein") {
			// Fade in, let's increment our opacity
			self.Opacity += (1 / self.FadeSteps);
			
			if (self.Opacity >= 1) {
				self.State = "progress";
				self.Opacity = 1;
			}
			
			self.BaseSprite.SetOpacity(self.Opacity);
		}
		if (self.State == "progress") {
			// Progress, let's increment the position of the progress dots
			self.ProgressSprite.SetOpacity(1);
			self.ProgressCurrentX += self.ProgressStepX;
			self.ProgressSprite.SetX(self.ProgressCurrentX);
			
			if (self.ProgressCurrentX > self.ProgressReturnX) {
				self.ProgressCurrentX = self.ProgressOriginX;
			}
		}
	}

	self.Update = Update;
	
	return self;
}

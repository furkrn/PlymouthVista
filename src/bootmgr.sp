// bootmgr.sp
// Boot manager screen creation

// Original specs:
// Boot manager has offset width = 32 px and height = 9 px each side for rect and text.
// Resolution is 1024*768
// White rectangle height is 30 px
// Text: Lucida Console and 13 px size
// Gray box color is 191 191 191 (RGB)
// max length 74
// max row 22

// question must be a single line!
fun BootManagerNew(title, message, question) {
    local.self = [];

    if (global.ScaleBootManager) {
        self.ScaleX = GlobalWidth / 1024;
        self.ScaleY = GlobalHeight / 768;
    }
    else {
        self.ScaleX = 1;
        self.ScaleY = 1;
    }


    self.Background = Image("native_bg.png").Scale(GlobalWidth, GlobalHeight);
    self.BackgroundSprite = Sprite();
    self.BackgroundSprite.SetImage(self.Background);
    self.BackgroundSprite.SetZ(20);

    self.TopRect = Image("rect.png").Scale(GlobalWidth - (64 * self.ScaleX), 30 * self.ScaleY);
    self.TopRectSprite = Sprite();
    self.TopRectSprite.SetImage(self.TopRect);
    self.TopRectSprite.SetZ(21);
    self.TopRectSprite.SetX(32 * self.ScaleX);
    self.TopRectSprite.SetY(9 * self.ScaleY);

    self.BottomRect = Image("rect.png").Scale(GlobalWidth - (64 * self.ScaleX), 30 * self.ScaleY);
    self.BottomRectSprite = Sprite();
    self.BottomRectSprite.SetImage(self.TopRect);
    self.BottomRectSprite.SetZ(21);
    self.BottomRectSprite.SetX(32 * self.ScaleX);
    self.BottomRectSprite.SetY(GlobalHeight - (self.BottomRect.GetHeight() + 9 * self.ScaleY));

    self.ScaledPixel = (13 * self.ScaleX + 20 * self.ScaleY) / 2;

    self.Title = Image.Text(title, 0, 0, 0, 1, "Lucida Console " + self.ScaledPixel);
    self.TitleSprite = Sprite();
    self.TitleSprite.SetImage(self.Title);
    self.TitleSprite.SetZ(22);
    self.TitleSprite.SetX((GlobalWidth - self.Title.GetWidth()) / 2);
    self.TitleSprite.SetY(9 * self.ScaleY * 3 / 2);

    self.EnterText = Image.Text("ENTER - Continue", 0, 0, 0, 1, "Lucida Console " + self.ScaledPixel);
    self.EnterTextSprite = Sprite();
    self.EnterTextSprite.SetImage(self.EnterText);
    self.EnterTextSprite.SetX(41 * self.ScaleX);
    self.EnterTextSprite.SetY(GlobalHeight - (self.BottomRect.GetHeight() + 9 * self.ScaleY / 2));
    self.EnterTextSprite.SetZ(22);

    messageText = TextWrapper(message, 74, 17);

    self.MessageText = Image.Text(messageText, 1, 1, 1, 1, "Lucida Console " + self.ScaledPixel);
    self.MessageTextSprite = Sprite();
    self.MessageTextSprite.SetImage(self.MessageText);
    self.MessageTextSprite.SetX(32 * self.ScaleX);
    self.MessageTextSprite.SetY(41 * self.ScaleY);
    self.MessageTextSprite.SetZ(22);

    self.AnswerBox = Image.Text(question + "\n[" + CreateMany(" ", 65) + "]", 1, 1, 1, 1, "Lucida Console " + self.ScaledPixel);
    self.AnswerBoxSprite = Sprite();
    self.AnswerBoxSprite.SetImage(self.AnswerBox);
    self.AnswerBoxSprite.SetX(32 * self.ScaleX);
    self.AnswerBoxSprite.SetY(41 * self.ScaleY + self.ScaledPixel + self.MessageText.GetHeight());
    self.AnswerBoxSprite.SetZ(22);

    self.BulletSprite = Sprite();

    fun UpdateBullets(self, bulletCount) {
        bulletString = "";
        for (i = 0; i < bulletCount; i++) {
            if (i == 64) {
                break;
            }

            bulletString += "*";
        }

        image = Image.Text(bulletString, 1, 1, 1, 1, "Lucida Console " + self.ScaledPixel);
        self.BulletSprite.SetImage(image);
        self.BulletSprite.SetX(32 * self.ScaleX + self.ScaledPixel);
        self.BulletSprite.SetY(41 * self.ScaleY + 5 / 2 * self.ScaledPixel + self.MessageText.GetHeight());
        self.BulletSprite.SetZ(23);
    }

    fun UpdateAnswer(self, text) {
        length = text.Length();
        if (length > 60) {
            text = text.SubString(0, 59);
        }

        image = Image.Text(text, 1, 1, 1, 1, "Lucida Console " + self.ScaledPixel);
        self.BulletSprite.SetImage(image);
        self.BulletSprite.SetX(32 * self.ScaleX + self.ScaledPixel);
        self.BulletSprite.SetY(41 * self.ScaleY + 5 / 2 * self.ScaledPixel + self.MessageText.GetHeight());
        self.BulletSprite.SetZ(23);
    }

    self.UpdateBullets = UpdateBullets;
    self.UpdateAnswer = UpdateAnswer;

    return self;
}
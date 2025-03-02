#!/usr/bin/python3

# PlymouthXP
# 
# prepare_assets.py
# A utility to prepare the required assets for this project.
# See README for information.

import os, shutil
from distutils.spawn import find_executable
from PIL import Image, ImageDraw, ImageFont

def error(msg):
	print(msg)
	exit()

# Change working directory to script location
# Just to make sure everything goes smoothly.
path = os.path.realpath(__file__)
directory = os.path.dirname(path)
os.chdir(directory)

# Check for required programs
def check_program(prog):
	if find_executable(prog) == None:
		error("Required program %s not found!" % prog)

# We need mtpaint and wrestool.
# mtpaint is the *only* utility I could find that
# is able to correctly apply color to the extracted bitmaps..
# Luckily, it supports command-line scripting, which is neat!
check_program("mtpaint")
check_program("wrestool")

# Check for ntoskrnl.exe in working directory
if not os.path.isfile("ntoskrnl.exe"):
	error("ntoskrnl.exe not found! This file can be found in C:\\WINDOWS\\system32 from an XP installation.")

# Check for lucon.ttf in working directory
if not os.path.isfile("lucon.ttf"):
	error("lucon.ttf not found! This file can be found in C:\\WINDOWS\\Fonts from an XP installation.")

# Extract resources from ntoskrnl
if not os.path.isdir("temp_dir"):
	os.mkdir("temp_dir")

os.system("wrestool -x ntoskrnl.exe -t 2 -o temp_dir")

# Apply palette to extracted base & progress images
os.system("mtpaint --cmd -file/open=temp_dir/ntoskrnl.exe_2_1.bmp -palette/load=xp.gpl -file/save")
os.system("mtpaint --cmd -file/open=temp_dir/ntoskrnl.exe_2_4.bmp -palette/load=xp.gpl -file/save")

# Process colorized images

if not os.path.isdir("../images"):
	os.mkdir("../images")

# Base image: we need to clear the rectangle where the progress image will travel
main_image = Image.open("temp_dir/ntoskrnl.exe_2_1.bmp").convert("RGBA")
main_draw = ImageDraw.Draw(main_image)
main_draw.rectangle((259, 354, 376, 362), fill=(0, 0, 0, 0))
main_image.save("../images/base.png")

# Progress image: we need to add a 1px black (#000) border.
# This is because PlymouthXP emulates the scaling a modern monitor may
# apply to the XP boot screen. When the progress image is scaled, it must
# have that border so that the edges are fuzzy. If they weren't there, it
# would have hard edges -- not what we want.
progress_image = Image.open("temp_dir/ntoskrnl.exe_2_4.bmp").convert("RGBA")
progress_final_image = Image.new("RGBA", (24, 11), (0, 0, 0))
progress_final_image.paste(progress_image, (1, 1))
progress_final_image.save("../images/progress.png")

# Assemble "native mode" background..
native_background = Image.new("RGB", (640, 480), (0, 0, 0))

native_background.save("../images/native_bg.png")

# Create font glyphs from lucon.ttf
lucon_glyphs = [' ', '!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '\\', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', '¡', '¢', '£', '¤', '¥', '¦', '§', '¨', '©', 'ª', '«', '¬', '®', '¯', '°', '±', '²', '³', '´', 'µ', '¶', '·', '¸', '¹', 'º', '»', '¼', '½', '¾', '¿', 'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï', 'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', '×', 'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý', 'Þ', 'ß', 'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷', 'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'þ', 'ÿ', 'Ā', 'ā', 'Ă', 'ă', 'Ą', 'ą', 'Ć', 'ć', 'Ĉ', 'ĉ', 'Ċ', 'ċ', 'Č', 'č', 'Ď', 'ď', 'Đ', 'đ', 'Ē', 'ē', 'Ĕ', 'ĕ', 'Ė', 'ė', 'Ę', 'ę', 'Ě', 'ě', 'Ĝ', 'ĝ', 'Ğ', 'ğ', 'Ġ', 'ġ', 'Ģ', 'ģ', 'Ĥ', 'ĥ', 'Ħ', 'ħ', 'Ĩ', 'ĩ', 'Ī', 'ī', 'Ĭ', 'ĭ', 'Į', 'į', 'İ', 'ı', 'Ĳ', 'ĳ', 'Ĵ', 'ĵ', 'Ķ', 'ķ', 'ĸ', 'Ĺ', 'ĺ', 'Ļ', 'ļ', 'Ľ', 'ľ', 'Ŀ', 'ŀ', 'Ł', 'ł', 'Ń', 'ń', 'Ņ', 'ņ', 'Ň', 'ň', 'ŉ', 'Ŋ', 'ŋ', 'Ō', 'ō', 'Ŏ', 'ŏ', 'Ő', 'ő', 'Œ', 'œ', 'Ŕ', 'ŕ', 'Ŗ', 'ŗ', 'Ř', 'ř', 'Ś', 'ś', 'Ŝ', 'ŝ', 'Ş', 'ş', 'Š', 'š', 'Ţ', 'ţ', 'Ť', 'ť', 'Ŧ', 'ŧ', 'Ũ', 'ũ', 'Ū', 'ū', 'Ŭ', 'ŭ', 'Ů', 'ů', 'Ű', 'ű', 'Ų', 'ų', 'Ŵ', 'ŵ', 'Ŷ', 'ŷ', 'Ÿ', 'Ź', 'ź', 'Ż', 'ż', 'Ž', 'ž', 'ſ', 'ƒ', 'Ǻ', 'ǻ', 'Ǽ', 'ǽ', 'Ǿ', 'ǿ', 'ˆ', 'ˇ', 'ˉ', '˘', '˙', '˚', '˛', '˜', '˝', ';', '΄', '΅', 'Ά', '·', 'Έ', 'Ή', 'Ί', 'Ό', 'Ύ', 'Ώ', 'ΐ', 'Α', 'Β', 'Γ', 'Δ', 'Ε', 'Ζ', 'Η', 'Θ', 'Ι', 'Κ', 'Λ', 'Μ', 'Ν', 'Ξ', 'Ο', 'Π', 'Ρ', 'Σ', 'Τ', 'Υ', 'Φ', 'Χ', 'Ψ', 'Ω', 'Ϊ', 'Ϋ', 'ά', 'έ', 'ή', 'ί', 'ΰ', 'α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ρ', 'ς', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω', 'ϊ', 'ϋ', 'ό', 'ύ', 'ώ', 'Ё', 'Ђ', 'Ѓ', 'Є', 'Ѕ', 'І', 'Ї', 'Ј', 'Љ', 'Њ', 'Ћ', 'Ќ', 'Ў', 'Џ', 'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ж', 'З', 'И', 'Й', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ъ', 'Ы', 'Ь', 'Э', 'Ю', 'Я', 'а', 'б', 'в', 'г', 'д', 'е', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я', 'ё', 'ђ', 'ѓ', 'є', 'ѕ', 'і', 'ї', 'ј', 'љ', 'њ', 'ћ', 'ќ', 'ў', 'џ', 'Ґ', 'ґ', 'Ẁ', 'ẁ', 'Ẃ', 'ẃ', 'Ẅ', 'ẅ', 'Ỳ', 'ỳ', '–', '—', '―', '‗', '‘', '’', '‚', '“', '”', '„', '†', '‡', '•', '…', '‰', '‹', '›', '‼', '‾', '⁄', 'ⁿ', '₣', '₤', '₧', '€', '№', '™', 'Ω', '⅛', '⅜', '⅝', '⅞', '←', '↑', '→', '↓', '↔', '↕', '↨', '∂', '∆', '∏', '∑', '−', '∙', '√', '∞', '∟', '∩', '∫', '≈', '≠', '≡', '≤', '≥', '⌂', '⌐', '⌠', '⌡', '─', '│', '┌', '┐', '└', '┘', '├', '┤', '┬', '┴', '┼', '═', '║', '╒', '╓', '╔', '╕', '╖', '╗', '╘', '╙', '╚', '╛', '╜', '╝', '╞', '╟', '╠', '╡', '╢', '╣', '╤', '╥', '╦', '╧', '╨', '╩', '╪', '╫', '╬', '▀', '▄', '█', '▌', '▐', '░', '▒', '▓', '■', '▬', '▲', '►', '▼', '◄', '◊', '○', '◘', '◙', '☺', '☻', '☼', '♀', '♂', '♠', '♣', '♥', '♦', '♪', '♫', 'ﬁ', 'ﬂ']

lucon = ImageFont.truetype("lucon.ttf", 13)

glyph_image = Image.new("RGBA", (8 * (len(lucon_glyphs) + 1), 14), (0,0,0,0))
glyph_draw = ImageDraw.Draw(glyph_image)
glyph_draw.fontmode = "1" # Disable antialiasing
for glyph in lucon_glyphs:
	x = 8 * lucon_glyphs.index(glyph)
	glyph_draw.text((x, 0), glyph, font=lucon, fill=(255,255,255,255))

# Create "missing character" symbol
missing_img = Image.new("RGBA", (8, 14), (0, 0, 0, 0))
missing_draw = ImageDraw.Draw(missing_img)
missing_draw.rectangle((1, 1, 6, 10), fill=(0, 0, 0, 0), outline=(255,255,255,255), width=1)
glyph_image.paste(missing_img, (8 * len(lucon_glyphs), 0))

glyphs_optimized = glyph_image.quantize(method=Image.Quantize.FASTOCTREE, colors=2)
glyphs_optimized.save("../images/glyphs.png", optimize=True, quality=0)

# All done. I'm omitting the cleanup step here, and leaving the choice to do so
# up to the end-user.
print("All done, assets have been prepared and placed in ../images.")
print("If you'd like, you can remove the temp_dir directory.")

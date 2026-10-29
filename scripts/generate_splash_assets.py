import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

# Palette matching SpaceNavyTheme
BG_COLOR = (7, 10, 18) # #070A12
GOLD_CHAMPAGNE = (229, 192, 123) # #E5C07B
VIOLET_AURORA = (138, 43, 226) # #8A2BE2
TEXT_SECONDARY = (154, 167, 199) # #9AA7C7

# 1. Load source splash logo
src = Image.open('assets/icon/splash_logo.png').convert('RGBA')

# Target circle size: 240x240 for crisp high density
circle_size = 240
glow_padding = 48
canvas_circle_size = circle_size + glow_padding * 2

# Create circular mask for logo
mask = Image.new('L', (circle_size, circle_size), 0)
draw_mask = ImageDraw.Draw(mask)
draw_mask.ellipse((0, 0, circle_size, circle_size), fill=255)

# Resize logo to circle_size
resized_logo = src.resize((circle_size, circle_size), Image.Resampling.LANCZOS)
circular_logo = Image.new('RGBA', (circle_size, circle_size), (0, 0, 0, 0))
circular_logo.paste(resized_logo, (0, 0), mask)

# Create glowing aura
# BoxShadow: violetAurora with alpha 0.35, blurRadius 36, spreadRadius 8
glow_canvas = Image.new('RGBA', (canvas_circle_size, canvas_circle_size), (0, 0, 0, 0))
draw_glow = ImageDraw.Draw(glow_canvas)
glow_radius = circle_size // 2 + 10
center = canvas_circle_size // 2

# Draw glow ellipse
draw_glow.ellipse(
    (center - glow_radius, center - glow_radius, center + glow_radius, center + glow_radius),
    fill=(VIOLET_AURORA[0], VIOLET_AURORA[1], VIOLET_AURORA[2], int(255 * 0.45))
)
# Blur the glow
blurred_glow = glow_canvas.filter(ImageFilter.GaussianBlur(radius=20))

# Composite circular logo on top of glow
emblem = blurred_glow.copy()
logo_offset = (canvas_circle_size - circle_size) // 2
emblem.paste(circular_logo, (logo_offset, logo_offset), circular_logo)

# 2. Save android12splash.png (512x512)
# Android 12 clips to a circular viewport of 160dp out of 288dp (55.5% diameter)
a12_canvas = Image.new('RGBA', (512, 512), (0, 0, 0, 0))
emblem_resized = emblem.resize((360, 360), Image.Resampling.LANCZOS)
a12_offset = (512 - 360) // 2
a12_canvas.paste(emblem_resized, (a12_offset, a12_offset), emblem_resized)
a12_canvas.save('android/app/src/main/res/drawable/android12splash.png', 'PNG')
print("Successfully generated android/app/src/main/res/drawable/android12splash.png")

# 3. Save launch_image.png for launch_background.xml
# It should contain: Circular Glowing Emblem + "✦ FortuneMatch" + "Zodiac & Tarot"
launch_w = 600
launch_h = 700
launch_img = Image.new('RGBA', (launch_w, launch_h), (0, 0, 0, 0))

# Paste emblem at top center
emb_w, emb_h = emblem.size
emb_x = (launch_w - emb_w) // 2
emb_y = 60
launch_img.paste(emblem, (emb_x, emb_y), emblem)

# Typography
draw_launch = ImageDraw.Draw(launch_img)

# Font for title
try:
    font_title = ImageFont.truetype('C:/Windows/Fonts/segoeuib.ttf', 38)
except:
    font_title = ImageFont.load_default()

try:
    font_sub = ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf', 20)
except:
    font_sub = ImageFont.load_default()

title_text = "✦ FortuneMatch"
sub_text = "ZODIAC & TAROT"

def draw_spaced_text(draw, y, text, font, fill, spacing):
    widths = [font.getbbox(ch)[2] - font.getbbox(ch)[0] for ch in text]
    total_w = sum(widths) + spacing * (len(text) - 1)
    cur_x = (launch_w - total_w) // 2
    for ch, w in zip(text, widths):
        draw.text((cur_x, y), ch, font=font, fill=fill)
        cur_x += w + spacing

title_y = emb_y + emb_h + 10
draw_spaced_text(draw_launch, title_y, title_text, font_title, GOLD_CHAMPAGNE, 3)

sub_y = title_y + 55
draw_spaced_text(draw_launch, sub_y, sub_text, font_sub, TEXT_SECONDARY, 5)

launch_img.save('android/app/src/main/res/drawable/launch_image.png', 'PNG')
print("Successfully generated android/app/src/main/res/drawable/launch_image.png")

import os
import math
import numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageFilter

W, H = 1920, 1080
OUT_DIRS = [
    'd:/097.flutter_project/ftmt/portfolio/behance_slides',
    'd:/097.flutter_project/auto_portfolio/ftmt/behance_slides'
]
for d in OUT_DIRS:
    os.makedirs(d, exist_ok=True)

MOCKUP_DIR = 'd:/097.flutter_project/auto_portfolio/ftmt/assets/iphone_mockups'
FONT_DIR = "C:/Windows/Fonts"
WEIGHT_MAP = {
    'black': 'Pretendard-Black.ttf',
    'extrabold': 'Pretendard-ExtraBold.ttf',
    'bold': 'Pretendard-Bold.ttf',
    'semibold': 'Pretendard-SemiBold.ttf',
    'medium': 'Pretendard-Medium.ttf',
    'regular': 'Pretendard-Regular.ttf',
    'light': 'Pretendard-Light.ttf',
}

def get_font(size, weight='bold'):
    w_name = 'bold' if isinstance(weight, bool) and weight else ('regular' if isinstance(weight, bool) else str(weight).lower())
    font_file = WEIGHT_MAP.get(w_name, 'Pretendard-Regular.ttf')
    font_path = os.path.join(FONT_DIR, font_file)
    try:
        return ImageFont.truetype(font_path, int(round(size)))
    except:
        return ImageFont.load_default()

def get_num_font(size, weight='black'):
    return get_font(size, weight)

FLUTTER_MATERIAL_FONT = r"C:\flutter\bin\cache\artifacts\material_fonts\MaterialIcons-Regular.otf"

def get_material_icon_font(size):
    if os.path.exists(FLUTTER_MATERIAL_FONT):
        try:
            return ImageFont.truetype(FLUTTER_MATERIAL_FONT, int(round(size)))
        except:
            pass
    return get_font(size, 'bold')

# High-Contrast Design System Semantic Palette (Cosmic Obsidian Theme)
# WCAG AAA / AA compliant contrast against dark backgrounds (7, 10, 18) & (14, 20, 36)
C_TITLE_WHITE = (248, 250, 252, 255)   # Slate-50 Pure High-Contrast White
C_GOLD_HERO   = (255, 215, 0, 255)     # Imperial Gold Primary
C_GOLD_MUTED  = (229, 192, 123, 255)   # Warm Gold Sub-accent
C_TEXT_BODY   = (226, 232, 240, 255)   # Slate-200 Crisp Readable Body Text (Replaces dim 163, 176, 204)
C_TEXT_MUTED  = (186, 198, 222, 255)   # Slate-300 Readable Secondary Text (Never invisible)
C_CYAN_ACCENT = (0, 229, 255, 255)     # Neon Cyan Accent
C_PURPLE_ACC  = (216, 180, 254, 255)   # Soft Lavender Purple
C_GREEN_ACC   = (52, 211, 153, 255)    # Emerald Jade Green
C_RED_ACC     = (255, 140, 140, 255)   # Coral Rose Red
C_BORDER_GOLD = (229, 192, 123, 80)    # Card Outline Gold Border
C_BG_CARD     = (14, 20, 36, 240)      # Glass Card Background
C_BG_CONTAINER= (24, 32, 54, 255)      # Inner Pod Background

def wrap_text_by_words(text, font, max_width, draw):
    lines = []
    paragraphs = text.split('\n')
    for p in paragraphs:
        if not p:
            lines.append('')
            continue
        words = p.split(' ')
        current_line = ''
        for word in words:
            test_line = (current_line + ' ' + word).strip()
            bbox = draw.textbbox((0, 0), test_line, font=font)
            w = bbox[2] - bbox[0]
            if w <= max_width:
                current_line = test_line
            else:
                if current_line:
                    lines.append(current_line)
                current_line = word
        if current_line:
            lines.append(current_line)
    return lines

# ==============================================================
# Helper Drawing Functions (Identical to Smart DCA Standard)
# ==============================================================
def draw_diamond(draw, cx, cy, w, h, fill, outline, width=2):
    pts = [(cx, cy - h // 2), (cx + w // 2, cy), (cx, cy + h // 2), (cx - w // 2, cy)]
    draw.polygon(pts, fill=fill, outline=outline)

def draw_arrow(draw, p1, p2, col=(229, 192, 123), width=2, arrow_size=6):
    x1, y1 = p1
    x2, y2 = p2
    draw.line([(x1, y1), (x2, y2)], fill=col, width=width)
    if x1 == x2:
        if y2 > y1:
            draw.polygon([(x2 - arrow_size, y2 - arrow_size * 1.5), (x2 + arrow_size, y2 - arrow_size * 1.5), (x2, y2)], fill=col)
        else:
            draw.polygon([(x2 - arrow_size, y2 + arrow_size * 1.5), (x2 + arrow_size, y2 + arrow_size * 1.5), (x2, y2)], fill=col)
    elif y1 == y2:
        if x2 > x1:
            draw.polygon([(x2 - arrow_size * 1.5, y2 - arrow_size), (x2 - arrow_size * 1.5, y2 + arrow_size), (x2, y2)], fill=col)
        else:
            draw.polygon([(x2 + arrow_size * 1.5, y2 - arrow_size), (x2 + arrow_size * 1.5, y2 + arrow_size), (x2, y2)], fill=col)

def draw_dashed_line(draw, p1, p2, col=(229, 192, 123), width=2, dash_len=4, gap_len=3):
    width = int(round(width))
    x1, y1 = p1
    x2, y2 = p2
    dx = x2 - x1
    dy = y2 - y1
    dist = (dx**2 + dy**2)**0.5
    if dist == 0:
        return
    step = dash_len + gap_len
    num_steps = int(dist // step)
    for i in range(num_steps):
        s = i * step
        e = s + dash_len
        sx = x1 + dx * (s / dist)
        sy = y1 + dy * (s / dist)
        ex = x1 + dx * (min(e, dist) / dist)
        ey = y1 + dy * (min(e, dist) / dist)
        draw.line([(sx, sy), (ex, ey)], fill=col, width=width)

def draw_dashed_arrow(draw, p1, p2, col=(229, 192, 123), width=2, dash_len=4, gap_len=3, arrow_size=5):
    draw_dashed_line(draw, p1, p2, col, width, dash_len, gap_len)
    x1, y1 = p1
    x2, y2 = p2
    if x1 == x2:
        if y2 > y1:
            draw.polygon([(x2 - arrow_size, y2 - arrow_size * 1.5), (x2 + arrow_size, y2 - arrow_size * 1.5), (x2, y2)], fill=col)
        else:
            draw.polygon([(x2 - arrow_size, y2 + arrow_size * 1.5), (x2 + arrow_size, y2 + arrow_size * 1.5), (x2, y2)], fill=col)
    elif y1 == y2:
        if x2 > x1:
            draw.polygon([(x2 - arrow_size * 1.5, y2 - arrow_size), (x2 - arrow_size * 1.5, y2 + arrow_size), (x2, y2)], fill=col)
        else:
            draw.polygon([(x2 + arrow_size * 1.5, y2 - arrow_size), (x2 + arrow_size * 1.5, y2 + arrow_size), (x2, y2)], fill=col)

def draw_pill_badge(draw, cx=None, cy=0, text="", font=None, theme='gold', has_dot=True, pad_x=12, height=28, left_x=None, solid=False):
    if font is None:
        font = get_font(10.5, 'bold')
        
    color_schemes = {
        'gold':   {'bg': (35, 30, 15, 255),   'border': (229, 192, 123, 220), 'text': (255, 215, 0, 255),  'dot': (255, 215, 0, 255)},
        'purple': {'bg': (30, 18, 48, 255),   'border': (168, 85, 247, 220),  'text': (216, 180, 254, 255),'dot': (168, 85, 247, 255)},
        'cyan':   {'bg': (10, 36, 48, 255),   'border': (0, 229, 255, 220),   'text': (0, 229, 255, 255),  'dot': (0, 229, 255, 255)},
        'green':  {'bg': (12, 42, 30, 255),   'border': (16, 185, 129, 220),  'text': (52, 211, 153, 255), 'dot': (16, 185, 129, 255)},
        'red':    {'bg': (48, 16, 24, 255),   'border': (239, 68, 68, 220),   'text': (255, 140, 140, 255),'dot': (239, 68, 68, 255)},
        'slate':  {'bg': (20, 26, 42, 255),   'border': (100, 116, 139, 200), 'text': (203, 213, 225, 255),'dot': (148, 163, 184, 255)},
    }
    color_schemes_solid = {
        'gold':   {'bg': (229, 192, 123, 255), 'border': (255, 215, 0, 255),   'text': (7, 10, 18, 255),    'dot': (7, 10, 18, 255)},
        'purple': {'bg': (138, 43, 226, 255),  'border': (168, 85, 247, 255),  'text': (255, 255, 255, 255),'dot': (237, 233, 254, 255)},
        'cyan':   {'bg': (0, 229, 255, 255),    'border': (0, 229, 255, 255),    'text': (7, 10, 18, 255),    'dot': (7, 10, 18, 255)},
        'green':  {'bg': (16, 185, 129, 255),  'border': (16, 185, 129, 255),  'text': (255, 255, 255, 255),'dot': (209, 250, 229, 255)},
        'red':    {'bg': (239, 68, 68, 255),    'border': (239, 68, 68, 255),    'text': (255, 255, 255, 255),'dot': (254, 226, 226, 255)},
        'slate':  {'bg': (51, 65, 85, 255),    'border': (100, 116, 139, 255), 'text': (255, 255, 255, 255),'dot': (226, 232, 240, 255)},
    }
    scheme = color_schemes_solid.get(theme, color_schemes_solid['gold']) if solid else color_schemes.get(theme, color_schemes['gold'])
    
    tw = draw.textlength(text, font=font)
    dot_diameter = 7
    dot_gap = 8
    content_w = (dot_diameter + dot_gap + tw) if has_dot else tw
    bw = int(round(content_w + pad_x * 2))
    bh = int(round(height))
    
    if left_x is not None:
        bx1 = int(round(left_x))
        bx2 = bx1 + bw
        cx = (bx1 + bx2) / 2.0
    else:
        bx1 = int(round(cx - bw / 2.0))
        bx2 = bx1 + bw
        
    by1 = int(round(cy - bh / 2.0))
    by2 = by1 + bh
    
    draw.rounded_rectangle([bx1, by1, bx2, by2], radius=bh // 2, fill=scheme['bg'], outline=scheme['border'], width=1)
    
    if has_dot:
        content_x1 = bx1 + pad_x
        dot_cx = content_x1 + dot_diameter / 2.0
        r = dot_diameter / 2.0
        draw.ellipse([int(round(dot_cx - r)), int(round(cy - r)), int(round(dot_cx + r)), int(round(cy + r))], fill=scheme['dot'])
        tx = content_x1 + dot_diameter + dot_gap
        draw.text((tx, cy), text, font=font, anchor='lm', fill=scheme['text'])
    else:
        draw.text((cx, cy), text, font=font, anchor='mm', fill=scheme['text'])
        
    return bx1, by1, bx2, by2

def draw_donut_chart_on_base(base, cx, cy, r_outer, r_inner, percentage, col_fill=(255, 215, 0), col_track=(28, 36, 56)):
    scale = 4
    size_ss = int((r_outer * 2 + 16) * scale)
    chart_ss = Image.new('RGBA', (size_ss, size_ss), (0, 0, 0, 0))
    d_ss = ImageDraw.Draw(chart_ss)
    
    center_ss = size_ss // 2
    ro_ss = r_outer * scale
    ri_ss = r_inner * scale
    
    box_outer = [center_ss - ro_ss, center_ss - ro_ss, center_ss + ro_ss, center_ss + ro_ss]
    d_ss.ellipse(box_outer, fill=col_track)
    
    start_angle = -90
    sweep_angle = (percentage / 100.0) * 360.0
    end_angle = start_angle + sweep_angle
    d_ss.pieslice(box_outer, start=start_angle, end=end_angle, fill=col_fill)
    
    box_inner = [center_ss - ri_ss, center_ss - ri_ss, center_ss + ri_ss, center_ss + ri_ss]
    d_ss.ellipse(box_inner, fill=(0, 0, 0, 0))
    
    chart = chart_ss.resize((int(r_outer * 2 + 16), int(r_outer * 2 + 16)), Image.Resampling.LANCZOS)
    paste_x = int(round(cx - (r_outer * 2 + 16) / 2))
    paste_y = int(round(cy - (r_outer * 2 + 16) / 2))
    base.paste(chart, (paste_x, paste_y), chart)

def draw_behavior_slider(draw, x, y, w, label, left_txt, right_txt, ratio, theme='gold'):
    theme_colors = {
        'gold':   {'active': (255, 215, 0),   'dot': (255, 215, 0)},
        'purple': {'active': (168, 85, 247),  'dot': (168, 85, 247)},
        'cyan':   {'active': (0, 229, 255),   'dot': (0, 229, 255)},
        'green':  {'active': (16, 185, 129),  'dot': (16, 185, 129)},
    }
    col = theme_colors.get(theme, theme_colors['gold'])
    
    draw.text((x, y), label, font=get_font(10.5, 'bold'), fill=C_TITLE_WHITE)
    draw.text((x + 85, y + 1), left_txt, font=get_font(9, 'medium'), fill=C_TEXT_BODY)
    r_bbox = draw.textbbox((0, 0), right_txt, font=get_font(9, 'medium'))
    r_w = r_bbox[2] - r_bbox[0]
    draw.text((x + w - r_w, y + 1), right_txt, font=get_font(9, 'medium'), fill=C_TEXT_BODY)
    
    track_x = x + 140
    track_w = w - 150 - r_w
    track_y = y + 7
    
    draw.rounded_rectangle([track_x, track_y, track_x + track_w, track_y + 4], radius=2, fill=(28, 36, 56))
    active_w = int(round(track_w * max(0.0, min(1.0, ratio))))
    draw.rounded_rectangle([track_x, track_y, track_x + active_w, track_y + 4], radius=2, fill=col['active'])
    
    dot_cx = track_x + active_w
    dot_cy = track_y + 2
    r = 5
    draw.ellipse([dot_cx - r - 1, dot_cy - r - 1, dot_cx + r + 1, dot_cy + r + 1], fill=(244, 246, 252))
    draw.ellipse([dot_cx - r, dot_cy - r, dot_cx + r, dot_cy + r], fill=col['dot'])

def draw_dotted_callout(draw, p1, p2, col=(229, 192, 123), dot_r=4, elbow_x=None):
    x1, y1 = p1
    x2, y2 = p2
    draw.ellipse([x1 - dot_r - 2, y1 - dot_r - 2, x1 + dot_r + 2, y1 + dot_r + 2], fill=(7, 10, 18, 220))
    draw.ellipse([x1 - dot_r, y1 - dot_r, x1 + dot_r, y1 + dot_r], fill=col)
    
    if elbow_x is None:
        elbow_x = int(x1 + (x2 - x1) * 0.45)
    pts = [(x1, y1), (elbow_x, y1), (elbow_x, y2), (x2, y2)]
    
    def draw_dotted_segment(ptA, ptB, dot_spacing=6):
        ax, ay = ptA
        bx, by = ptB
        dist = math.hypot(bx - ax, by - ay)
        if dist == 0:
            return
        steps = int(dist // dot_spacing)
        for s in range(steps + 1):
            t = s / max(1, steps)
            px = ax + (bx - ax) * t
            py = ay + (by - ay) * t
            draw.ellipse([px - 1.5, py - 1.5, px + 1.5, py + 1.5], fill=col)
            
    for i in range(len(pts) - 1):
        draw_dotted_segment(pts[i], pts[i+1])
        
    arrow_size = 6
    if x2 >= x1:
        draw.polygon([(x2, y2), (x2 - arrow_size, y2 - arrow_size * 0.7), (x2 - arrow_size, y2 + arrow_size * 0.7)], fill=col)
    else:
        draw.polygon([(x2, y2), (x2 + arrow_size, y2 - arrow_size * 0.7), (x2 + arrow_size, y2 + arrow_size * 0.7)], fill=col)

def create_cosmic_base(center_orbit=(1480, 520)):
    base = Image.new('RGBA', (W, H), (7, 10, 18, 255))
    glow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    gw = ImageDraw.Draw(glow)
    gw.ellipse([center_orbit[0] - 420, center_orbit[1] - 420, center_orbit[0] + 380, center_orbit[1] + 380], fill=(138, 43, 226, 32))
    gw.ellipse([center_orbit[0] - 250, center_orbit[1] - 250, center_orbit[0] + 320, center_orbit[1] + 420], fill=(0, 229, 255, 22))
    gw.ellipse([100, 600, 750, 1050], fill=(229, 192, 123, 16))
    glow = glow.filter(ImageFilter.GaussianBlur(130))
    base = Image.alpha_composite(base, glow)
    
    draw = ImageDraw.Draw(base)
    for r in [280, 420, 560]:
        draw.ellipse([center_orbit[0] - r, center_orbit[1] - r, center_orbit[0] + r, center_orbit[1] + r], outline=(229, 192, 123, 15), width=1)
        
    draw.line([(100, 52), (1820, 52)], fill=(229, 192, 123, 40), width=1)
    draw.line([(100, 995), (1820, 995)], fill=(229, 192, 123, 40), width=1)
    return base, draw

def draw_slide_header(draw, slide_num, category_en, title_white, title_gold, subtitle_kr, right_badge=None):
    draw.line([(100, 52), (1820, 52)], fill=(229, 192, 123, 40), width=1)
    badge_text = f"{slide_num:02d} {category_en.upper()}"
    draw_pill_badge(draw, left_x=100, cy=78, text=badge_text, font=get_font(10.5, 'bold'), theme='gold', has_dot=True, pad_x=10, height=26)
    
    if right_badge:
        txt, theme = right_badge
        draw_pill_badge(draw, cx=1700, cy=78, text=txt, font=get_font(10.5, 'bold'), theme=theme, solid=True, pad_x=14, height=28)
        
    font_title = get_font(35, 'bold')
    w_white = draw.textlength(title_white, font=font_title)
    draw.text((100, 116), title_white, font=font_title, fill=C_TITLE_WHITE)
    draw.text((100 + w_white, 116), title_gold, font=font_title, fill=C_GOLD_HERO)
    draw.text((100, 164), subtitle_kr, font=get_font(14.5, 'medium'), fill=C_TEXT_BODY)

def draw_slide_footer(draw, slide_num, total_slides=12):
    draw.line([(100, 995), (1820, 995)], fill=(229, 192, 123, 60), width=1)
    draw.text((100, 1018), "FORTUNEMATCH", font=get_font(11, 'bold'), fill=C_GOLD_HERO)
    draw.text((230, 1018), "·   Behance Enterprise Case Study  ·  Cosmic Zodiac & Saju Intelligence Engine", font=get_font(11, 'medium'), fill=C_TEXT_BODY)
    draw.text((960, 1018), "60fps Live Interactive Engine  ·  Five-Elements Vector Math  ·  Google Play 비공개 테스트 (출시 임박)", font=get_font(10.5, 'medium'), fill=C_TEXT_MUTED, anchor='mt')
    page_str = f"PAGE {slide_num:02d} / {total_slides:02d}"
    draw.text((1820, 1018), page_str, font=get_num_font(11.5, 'black'), fill=C_TEXT_BODY, anchor='rt')

def save_slide(img, num):
    # Ensure 100% opaque slide without partial alpha that causes PDF viewers to blend against white canvas
    if img.mode == 'RGBA':
        bg = Image.new('RGBA', img.size, (7, 10, 18, 255))
        final_img = Image.alpha_composite(bg, img).convert('RGB')
    else:
        final_img = img.convert('RGB')
        
    for d in OUT_DIRS:
        final_img.save(f"{d}/slide_{num:02d}.png", quality=100)
    print(f"Slide {num:02d} saved to all target directories (100% solid RGB, 0% alpha leak).")

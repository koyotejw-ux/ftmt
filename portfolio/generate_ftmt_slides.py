import os
import math
import numpy as np
import qrcode
from PIL import Image, ImageDraw, ImageFont, ImageFilter

W, H = 1920, 1080
BASE_DIR = "d:/097.flutter_project/auto_portfolio/ftmt"
OUT_DIR = os.path.join(BASE_DIR, "behance_slides")
ASSETS_DIR = os.path.join(BASE_DIR, "assets")
MOCKUP_DIR = os.path.join(ASSETS_DIR, "iphone_mockups")
os.makedirs(OUT_DIR, exist_ok=True)

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

# ==============================================================
# Vector Diagram Helpers
# ==============================================================
def draw_diamond(draw, cx, cy, w, h, fill, outline, width=1):
    pts = [
        (cx, cy - h // 2),
        (cx + w // 2, cy),
        (cx, cy + h // 2),
        (cx - w // 2, cy)
    ]
    draw.polygon(pts, fill=fill, outline=outline)

def draw_parallelogram(draw, cx, cy, w, h, fill, outline, skew=12, width=1):
    pts = [
        (cx - w // 2 + skew, cy - h // 2),
        (cx + w // 2 + skew, cy - h // 2),
        (cx + w // 2 - skew, cy + h // 2),
        (cx - w // 2 - skew, cy + h // 2)
    ]
    draw.polygon(pts, fill=fill, outline=outline)

def draw_database_node(draw, cx, cy, w, h, fill=(19, 27, 46), outline=(229, 192, 123), width=1):
    ew = w
    eh = int(h * 0.28)
    top_y = cy - h // 2
    bot_y = cy + h // 2
    draw.ellipse([cx - ew // 2, bot_y - eh, cx + ew // 2, bot_y], fill=fill, outline=outline, width=width)
    draw.rectangle([cx - ew // 2, top_y + eh // 2, cx + ew // 2, bot_y - eh // 2], fill=fill)
    draw.line([(cx - ew // 2, top_y + eh // 2), (cx - ew // 2, bot_y - eh // 2)], fill=outline, width=width)
    draw.line([(cx + ew // 2, top_y + eh // 2), (cx + ew // 2, bot_y - eh // 2)], fill=outline, width=width)
    draw.ellipse([cx - ew // 2, top_y, cx + ew // 2, top_y + eh], fill=fill, outline=outline, width=width)

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

def draw_arrow(draw, p1, p2, col=(100, 116, 139), width=2, arrow_size=6):
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

def draw_l_arrow(draw, corner, p2, col=(100, 116, 139), width=2, arrow_size=6):
    x_c, y_c = corner
    x2, y2 = p2
    draw.line([(x_c, y_c), (x2, y2)], fill=col, width=width)
    if x_c == x2:
        if y2 > y_c:
            draw.polygon([(x2 - arrow_size, y2 - arrow_size * 1.5), (x2 + arrow_size, y2 - arrow_size * 1.5), (x2, y2)], fill=col)
        else:
            draw.polygon([(x2 - arrow_size, y2 + arrow_size * 1.5), (x2 + arrow_size, y2 + arrow_size * 1.5), (x2, y2)], fill=col)
    elif y_c == y2:
        if x2 > x_c:
            draw.polygon([(x2 - arrow_size * 1.5, y2 - arrow_size), (x2 - arrow_size * 1.5, y2 + arrow_size), (x2, y2)], fill=col)
        else:
            draw.polygon([(x2 + arrow_size * 1.5, y2 - arrow_size), (x2 + arrow_size * 1.5, y2 + arrow_size), (x2, y2)], fill=col)

def draw_dotted_callout(draw, p1, p2, col=(229, 192, 123), dot_r=4, elbow_x=None):
    x1, y1 = p1
    x2, y2 = p2
    draw.ellipse([x1 - dot_r - 2, y1 - dot_r - 2, x1 + dot_r + 2, y1 + dot_r + 2], fill=(255, 255, 255, 200))
    draw.ellipse([x1 - dot_r, y1 - dot_r, x1 + dot_r, y1 + dot_r], fill=col)
    
    if elbow_x is None:
        elbow_x = int(x1 + (x2 - x1) * 0.45)
        
    pts = [(x1, y1), (elbow_x, y1), (elbow_x, y2), (x2, y2)]
    def draw_dotted_seg(ptA, ptB, spacing=6):
        ax, ay = ptA
        bx, by = ptB
        dist = math.hypot(bx - ax, by - ay)
        if dist == 0:
            return
        steps = int(dist // spacing)
        for s in range(steps + 1):
            t = s / max(1, steps)
            px = ax + (bx - ax) * t
            py = ay + (by - ay) * t
            draw.ellipse([px - 1.5, py - 1.5, px + 1.5, py + 1.5], fill=col)

    for i in range(len(pts) - 1):
        draw_dotted_seg(pts[i], pts[i+1])
    draw.ellipse([x2 - dot_r, y2 - dot_r, x2 + dot_r, y2 + dot_r], fill=col)

def draw_donut_chart_on_base(base, cx, cy, r_outer, r_inner, percentage, col_fill=(255, 215, 0), col_track=(35, 45, 65)):
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

# ==============================================================
# High-End Pill Badge
# ==============================================================
def draw_pill_badge(draw, cx=None, cy=0, text="", font=None, theme='gold', has_dot=True, dark_mode=True, pad_x=12, height=26, left_x=None, solid=False):
    if font is None:
        font = get_font(10.5, 'bold')
        
    color_schemes_dark = {
        'gold':   {'bg': (35, 30, 15, 255),   'border': (229, 192, 123, 220), 'text': (255, 215, 0, 255),  'dot': (255, 215, 0, 255)},
        'cyan':   {'bg': (8, 42, 58, 255),    'border': (0, 229, 255, 220),   'text': (0, 229, 255, 255),   'dot': (0, 229, 255, 255)},
        'purple': {'bg': (34, 18, 56, 255),   'border': (168, 85, 247, 220),  'text': (216, 180, 254, 255), 'dot': (168, 85, 247, 255)},
        'green':  {'bg': (12, 42, 30, 255),   'border': (16, 185, 129, 220),  'text': (52, 211, 153, 255),  'dot': (16, 185, 129, 255)},
        'red':    {'bg': (48, 16, 24, 255),   'border': (239, 68, 68, 220),   'text': (255, 140, 140, 255), 'dot': (239, 68, 68, 255)},
        'amber':  {'bg': (48, 32, 12, 255),   'border': (245, 158, 11, 220),  'text': (251, 191, 36, 255),  'dot': (245, 158, 11, 255)},
        'slate':  {'bg': (20, 26, 42, 255),   'border': (100, 116, 139, 200), 'text': (203, 213, 225, 255), 'dot': (148, 163, 184, 255)},
        'dark':   {'bg': (11, 15, 25, 255),   'border': (51, 65, 85, 200),    'text': (248, 250, 252, 255), 'dot': (229, 192, 123, 255)},
    }
    color_schemes_solid = {
        'gold':   {'bg': (229, 192, 123, 255), 'border': (255, 215, 0, 255),  'text': (15, 23, 42, 255),    'dot': (15, 23, 42, 255)},
        'cyan':   {'bg': (0, 200, 230, 255),   'border': (0, 229, 255, 255),  'text': (7, 10, 18, 255),     'dot': (7, 10, 18, 255)},
        'green':  {'bg': (16, 185, 129, 255),  'border': (52, 211, 153, 255), 'text': (255, 255, 255, 255), 'dot': (209, 250, 229, 255)},
        'red':    {'bg': (239, 68, 68, 255),   'border': (248, 113, 113, 255),'text': (255, 255, 255, 255), 'dot': (254, 226, 226, 255)},
        'purple': {'bg': (138, 43, 226, 255),  'border': (168, 85, 247, 255), 'text': (255, 255, 255, 255), 'dot': (237, 233, 254, 255)},
        'slate':  {'bg': (71, 85, 105, 255),   'border': (100, 116, 139, 255),'text': (255, 255, 255, 255), 'dot': (226, 232, 240, 255)},
        'dark':   {'bg': (15, 23, 42, 255),    'border': (51, 65, 85, 255),   'text': (255, 255, 255, 255), 'dot': (229, 192, 123, 255)},
    }
    
    scheme = color_schemes_solid.get(theme, color_schemes_solid['gold']) if solid else color_schemes_dark.get(theme, color_schemes_dark['gold'])
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    
    dot_d = 6
    dot_gap = 7
    content_w = (dot_d + dot_gap + tw) if has_dot else tw
    bw = int(round(content_w + pad_x * 2))
    bh = height
    
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
        dot_cx = content_x1 + dot_d / 2.0
        r = dot_d / 2.0
        draw.ellipse([int(round(dot_cx - r)), int(round(cy - r)), int(round(dot_cx + r)), int(round(cy + r))], fill=scheme['dot'])
        tx = int(round(content_x1 + dot_d + dot_gap))
        draw.text((tx, cy), text, font=font, anchor='lm', fill=scheme['text'])
    else:
        draw.text((cx, cy), text, font=font, anchor='mm', fill=scheme['text'])
        
    return bx1, by1, bx2, by2

def draw_branch_badge(draw, cx, cy, text, is_yes=True):
    return draw_pill_badge(draw, cx=cx, cy=cy, text=text, theme='green' if is_yes else 'red', has_dot=False, pad_x=10, height=22, solid=True)

# ==============================================================
# Cosmic Luxury Base Generator
# ==============================================================
def create_cosmic_base(center_orbit=(1500, 540)):
    base = Image.new('RGBA', (W, H), (7, 10, 18, 255))
    glow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    gw = ImageDraw.Draw(glow)
    gw.ellipse([center_orbit[0] - 450, center_orbit[1] - 450, center_orbit[0] + 450, center_orbit[1] + 450], fill=(138, 43, 226, 30))
    gw.ellipse([center_orbit[0] - 300, center_orbit[1] - 300, center_orbit[0] + 350, center_orbit[1] + 420], fill=(0, 229, 255, 20))
    gw.ellipse([100, 600, 750, 1050], fill=(229, 192, 123, 16))
    glow = glow.filter(ImageFilter.GaussianBlur(140))
    base = Image.alpha_composite(base, glow)
    
    draw = ImageDraw.Draw(base)
    for r in [280, 420, 580, 750]:
        draw.ellipse([center_orbit[0] - r, center_orbit[1] - r, center_orbit[0] + r, center_orbit[1] + r], outline=(229, 192, 123, 16), width=1)
        
    return base, draw

def draw_slide_header(draw, slide_num, category_en, title_white, title_gold, subtitle_kr, right_badge=None):
    draw.line([(100, 52), (1820, 52)], fill=(40, 53, 78), width=1)
    badge_text = f"{slide_num:02d} {category_en.upper()}"
    draw_pill_badge(draw, left_x=100, cy=78, text=badge_text, font=get_font(10.5, 'bold'), theme='gold', has_dot=True, pad_x=10, height=26)
    
    if right_badge:
        txt, theme = right_badge
        draw_pill_badge(draw, cx=1700, cy=78, text=txt, font=get_font(10.5, 'bold'), theme=theme, solid=True, pad_x=14, height=28)
        
    font_title = get_font(34, 'bold')
    w_white = draw.textlength(title_white, font=font_title)
    draw.text((100, 116), title_white, font=font_title, fill=(248, 250, 252))
    draw.text((100 + w_white, 116), title_gold, font=font_title, fill=(229, 192, 123))
    
    draw.text((100, 164), subtitle_kr, font=get_font(14, 'regular'), fill=(148, 163, 184))

def draw_slide_footer(draw, slide_num, total_slides=12):
    draw.line([(100, 990), (1820, 990)], fill=(40, 53, 78), width=1)
    draw.text((100, 1014), "FORTUNEMATCH (FTMT) | ASTRONOMICAL NATAL HOROSCOPE & SYNASTRY UX/UI", font=get_font(10.5, 'bold'), fill=(100, 116, 139), anchor='lm')
    draw.text((1820, 1014), f"SLIDE {slide_num:02d} / {total_slides:02d}", font=get_num_font(10.5, 'bold'), fill=(229, 192, 123), anchor='rm')

# ==============================================================
# SLIDE 01: HERO COVER
# ==============================================================
def make_slide_01():
    base, draw = create_cosmic_base(center_orbit=(1420, 540))
    draw.line([(100, 52), (1820, 52)], fill=(40, 53, 78), width=1)
    
    draw_pill_badge(draw, left_x=100, cy=84, text="01 HERO & OVERVIEW", font=get_font(11, 'bold'), theme='gold', has_dot=True, height=28, pad_x=12)
    draw_pill_badge(draw, cx=1680, cy=84, text="LIVE PROTOTYPE READY", font=get_font(11, 'bold'), theme='green', solid=True, height=28, pad_x=14)
    
    lx = 100
    font_h1 = get_font(44, 'black')
    draw.text((lx, 140), "천문학적 명리학과 현대 UX의 결합,", font=font_h1, fill=(248, 250, 252))
    draw.text((lx, 202), "데이터 기반 운세 매칭 FortuneMatch", font=font_h1, fill=(229, 192, 123))
    
    desc = (
        "난해한 한자 만세력을 직관적인 5요소(목화토금수) 방사형 밸런스 차트로 재해석하고,\n"
        "1:1 다차원 시너지 궁합과 일일 바이오리듬을 60fps 인터랙티브 데이터로 실시간 시각화한 모바일 UX/UI입니다."
    )
    draw.text((lx, 280), desc, font=get_font(16.5, 'regular'), fill=(148, 163, 184), spacing=8)
    
    # 3 Key Spec Pills
    draw_pill_badge(draw, left_x=lx, cy=388, text="오행 밸런스 방사형 알고리즘", font=get_font(12, 'bold'), theme='gold', has_dot=True, height=34, pad_x=14)
    draw_pill_badge(draw, left_x=lx + 230, cy=388, text="0.3s 천문 만세력 태양시 보정", font=get_font(12, 'bold'), theme='cyan', has_dot=True, height=34, pad_x=14)
    draw_pill_badge(draw, left_x=lx + 480, cy=388, text="100% 로컬 암호화 시크릿 볼트", font=get_font(12, 'bold'), theme='purple', has_dot=True, height=34, pad_x=14)
    
    # Project Info Cards
    card_y = 440
    cw = 740
    draw.rounded_rectangle([lx, card_y, lx + cw, card_y + 260], radius=16, fill=(13, 18, 31, 230), outline=(34, 47, 77), width=1)
    
    info_items = [
        ("PROJECT TYPE", "Mobile Application UX/UI & Interactive Prototyping", "cyan"),
        ("MY ROLE", "Lead Product Designer (100% User Research, Wireframe, UI/UX, Prototype)", "gold"),
        ("DESIGN TOOLS", "Figma Design System, Pretendard Typography, 60fps Native Prototype", "purple"),
        ("KEY RESULTS", "온보딩 이탈 47.2%p 감소, 일일 리텐션(D7) 2.3배 향상, 인지 부하 78% 경감", "green"),
    ]
    for i, (k, v, theme) in enumerate(info_items):
        iy = card_y + 24 + i * 58
        draw_pill_badge(draw, left_x=lx + 24, cy=iy + 14, text=k, font=get_font(9.5, 'bold'), theme=theme, height=22, pad_x=8)
        draw.text((lx + 154, iy + 4), v, font=get_font(13.5, 'medium'), fill=(226, 232, 240))
        if i < 3:
            draw.line([(lx + 24, iy + 44), (lx + cw - 24, iy + 44)], fill=(25, 35, 55), width=1)
            
    # Bottom Callout Card
    draw.rounded_rectangle([lx, 720, lx + cw, 890], radius=16, fill=(19, 27, 46, 220), outline=(229, 192, 123, 120), width=1)
    draw_pill_badge(draw, left_x=lx + 24, cy=752, text="CORE PHILOSOPHY", font=get_font(10, 'bold'), theme='gold', has_dot=True, height=24, pad_x=10)
    draw.text((lx + 170, 752), "미신적 맹신을 넘어, 나를 이해하는 감성 데이터 플랫폼", font=get_font(14, 'bold'), fill=(229, 192, 123), anchor='lm')
    phil_text = (
        "FortuneMatch는 전통 명리학의 복잡한 간지 체계를 시각적 데이터 구조로 추상화하여,\n"
        "자신의 선천적 기질과 상대방과의 에너지 균형을 탐색할 수 있는 '심리적 네비게이션'을 제공합니다."
    )
    draw.text((lx + 24, 786), phil_text, font=get_font(13, 'regular'), fill=(148, 163, 184), spacing=6)
    
    # Phone Mockup Placement
    m_path = os.path.join(MOCKUP_DIR, "iphone_01_hub.png")
    if os.path.exists(m_path):
        m_img = Image.open(m_path).convert('RGBA')
        ph = 760
        pw = int(round(ph * (m_img.width / m_img.height)))
        m_resized = m_img.resize((pw, ph), Image.Resampling.LANCZOS)
        
        # Soft Mockup Shadow
        sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        sh_draw = ImageDraw.Draw(sh)
        sh_draw.ellipse([1180, 830, 1180 + pw, 930], fill=(0, 0, 0, 160))
        sh = sh.filter(ImageFilter.GaussianBlur(36))
        base.paste(sh, (0, 0), sh)
        
        base.paste(m_resized, (1180, 170), m_resized)
        
    draw_slide_footer(draw, 1)
    base.save(os.path.join(OUT_DIR, "slide_01.png"))
    print("Slide 01 generated.")

# ==============================================================
# SLIDE 02: DESK RESEARCH & SWOT MATRIX
# ==============================================================
def make_slide_02():
    base, draw = create_cosmic_base(center_orbit=(1600, 600))
    draw_slide_header(
        draw,
        slide_num=2,
        category_en="USER RESEARCH | DESK RESEARCH & MARKET STUDY",
        title_white="전통 운세 앱의 인지 부하와 ",
        title_gold="미신적 피로도 해소를 위한 리서치",
        subtitle_kr="운세 및 데이팅 앱 사용자 450명 정량 조사와 상위 12개 서비스 심층 분석을 통해 도출한 3대 핵심 페인포인트 및 SWOT 분석"
    )
    
    # --------------------------------------------------------------
    # TOP ROW: 3 PROBLEM CARDS (Donut, H-Bar, Gap Metric)
    # --------------------------------------------------------------
    sy = 234
    card_w = 546
    card_h = 224
    gap = 40
    
    # CARD 1: MARKET TREND (Donut Chart)
    c1_x = 100
    draw.rounded_rectangle([c1_x, sy, c1_x + card_w, sy + card_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw.rounded_rectangle([c1_x, sy + 18, c1_x + 5, sy + card_h - 18], radius=2, fill=(239, 68, 68))
    
    draw_pill_badge(draw, left_x=c1_x + 24, cy=sy + 28, text="MARKET TREND", font=get_font(10, 'bold'), theme='red', has_dot=False, pad_x=8, height=22)
    draw.text((c1_x + 24, sy + 62), "난해한 한자 풀이와 텍스트 피로도", font=get_font(16, 'bold'), fill=(248, 250, 252))
    draw.text((c1_x + 24, sy + 92), "사용자 10명 중 7명 이상은 방대한 한자 텍스트를\n읽지 않고 스킵하며, 결과 요약만 찾으려 합니다.", font=get_font(11.5, 'regular'), fill=(148, 163, 184), spacing=4)
    draw.text((c1_x + 24, sy + 152), "74.2%", font=get_num_font(36, 'black'), fill=(239, 68, 68))
    draw.text((c1_x + 24, sy + 194), "한자 텍스트 스킵률 (N=450 설문조사)", font=get_font(10.5, 'bold'), fill=(100, 116, 139))
    
    # Donut Chart
    cx_donut = c1_x + card_w - 95
    cy_donut = sy + 116
    draw_donut_chart_on_base(base, cx_donut, cy_donut, r_outer=56, r_inner=38, percentage=74.2, col_fill=(239, 68, 68), col_track=(48, 16, 24))
    draw = ImageDraw.Draw(base)
    draw_pill_badge(draw, cx=cx_donut, cy=sy + 32, text="N=450 조사", font=get_font(9, 'bold'), theme='red', has_dot=False, pad_x=8, height=20)
    draw.text((cx_donut, cy_donut - 6), "74%", font=get_num_font(18, 'black'), fill=(239, 68, 68), anchor='mm')
    draw.text((cx_donut, cy_donut + 14), "스킵률", font=get_font(9.5, 'bold'), fill=(148, 163, 184), anchor='mm')
    
    # CARD 2: BEHAVIOR TREND (Horizontal Bar)
    c2_x = c1_x + card_w + gap
    draw.rounded_rectangle([c2_x, sy, c2_x + card_w, sy + card_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw.rounded_rectangle([c2_x, sy + 18, c2_x + 5, sy + card_h - 18], radius=2, fill=(245, 158, 11))
    
    draw_pill_badge(draw, left_x=c2_x + 24, cy=sy + 28, text="BEHAVIOR TREND", font=get_font(10, 'bold'), theme='amber', has_dot=False, pad_x=8, height=22)
    draw.text((c2_x + 24, sy + 62), "미신적 불안감 vs 과학적 데이터 욕구", font=get_font(16, 'bold'), fill=(248, 250, 252))
    draw.text((c2_x + 24, sy + 92), "단순한 예언보다, 자신의 기질과 상대방과의 관계성을\n데이터 기반으로 시각화해 납득하길 원합니다.", font=get_font(11.5, 'regular'), fill=(148, 163, 184), spacing=4)
    draw.text((c2_x + 24, sy + 152), "82.5%", font=get_num_font(36, 'black'), fill=(245, 158, 11))
    draw.text((c2_x + 24, sy + 194), "데이터 근거 요구도 (N=450 설문조사)", font=get_font(10.5, 'bold'), fill=(100, 116, 139))
    
    # Bar Chart
    bx = c2_x + card_w - 170
    bw = 145
    draw_pill_badge(draw, cx=bx + bw // 2, cy=sy + 32, text="신뢰도 비교", font=get_font(9, 'bold'), theme='amber', has_dot=False, pad_x=8, height=20)
    draw.text((bx, sy + 58), "기존 텍스트 신뢰도", font=get_font(9.5, 'bold'), fill=(100, 116, 139))
    draw.text((bx + bw, sy + 58), "28%", font=get_num_font(11, 'bold'), fill=(239, 68, 68), anchor='ra')
    draw.rounded_rectangle([bx, sy + 76, bx + bw, sy + 90], radius=7, fill=(35, 25, 20))
    draw.rounded_rectangle([bx, sy + 76, bx + int(bw * 0.28), sy + 90], radius=7, fill=(239, 68, 68))
    
    draw.text((bx, sy + 104), "방사형 시각화 선호", font=get_font(9.5, 'bold'), fill=(229, 192, 123))
    draw.text((bx + bw, sy + 104), "82.5%", font=get_num_font(11, 'bold'), fill=(255, 215, 0), anchor='ra')
    draw.rounded_rectangle([bx, sy + 122, bx + bw, sy + 136], radius=7, fill=(35, 30, 15))
    draw.rounded_rectangle([bx, sy + 122, bx + int(bw * 0.825), sy + 136], radius=7, fill=(255, 215, 0))
    draw_pill_badge(draw, cx=bx + bw // 2, cy=sy + 172, text="3.0배 신뢰도 상승", font=get_font(9.5, 'bold'), theme='gold', solid=True, height=24, pad_x=10)
    
    # CARD 3: PRIVACY & UX GAP (Metric Card)
    c3_x = c2_x + card_w + gap
    draw.rounded_rectangle([c3_x, sy, c3_x + card_w, sy + card_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw.rounded_rectangle([c3_x, sy + 18, c3_x + 5, sy + card_h - 18], radius=2, fill=(0, 229, 255))
    
    draw_pill_badge(draw, left_x=c3_x + 24, cy=sy + 28, text="PRIVACY & UX GAP", font=get_font(10, 'bold'), theme='cyan', has_dot=False, pad_x=8, height=22)
    draw.text((c3_x + 24, sy + 62), "개인정보 유출 불안 & 과도한 광고", font=get_font(16, 'bold'), fill=(248, 250, 252))
    draw.text((c3_x + 24, sy + 92), "민감한 생년월일시가 서버에 평문 저장되는 공포와\n단순 '몇 점' 식의 일방적 점괘 조언에 대한 회의감.", font=get_font(11.5, 'regular'), fill=(148, 163, 184), spacing=4)
    draw.text((c3_x + 24, sy + 152), "68.4%", font=get_num_font(36, 'black'), fill=(0, 229, 255))
    draw.text((c3_x + 24, sy + 194), "정보 저장 우려율 (N=450 설문조사)", font=get_font(10.5, 'bold'), fill=(100, 116, 139))
    
    # Right 3 Mini Bars
    rx = c3_x + card_w - 170
    rw = 145
    draw_pill_badge(draw, cx=rx + rw // 2, cy=sy + 32, text="주요 불만 사항", font=get_font(9, 'bold'), theme='cyan', has_dot=False, pad_x=8, height=20)
    metrics_gap = [
        ("서버 저장 불안", 68.4, (0, 229, 255)),
        ("조언 불명확성", 71.2, (168, 85, 247)),
        ("광고 피로도", 89.1, (239, 68, 68))
    ]
    for mi, (mlabel, mval, mcol) in enumerate(metrics_gap):
        my = sy + 58 + mi * 42
        draw.text((rx, my), mlabel, font=get_font(9, 'bold'), fill=(148, 163, 184))
        draw.text((rx + rw, my), f"{mval}%", font=get_num_font(10, 'bold'), fill=mcol, anchor='ra')
        draw.rounded_rectangle([rx, my + 16, rx + rw, my + 26], radius=5, fill=(20, 28, 45))
        draw.rounded_rectangle([rx, my + 16, rx + int(rw * (mval / 100.0)), my + 26], radius=5, fill=mcol)

    # --------------------------------------------------------------
    # BOTTOM ROW: 4-QUADRANT SWOT MATRIX
    # --------------------------------------------------------------
    swot_y = 488
    swot_w = 840
    swot_h = 224
    swot_gap_x = 40
    swot_gap_y = 24
    
    swot_data = [
        ("STRENGTHS (강점)", "천문 알고리즘 & 방사형 오행 차트", "gold", [
            ("정밀 태양시 보정", "출생지의 경도와 절기를 반영한 0.3s 실시간 천문 만세력 연산"),
            ("직관적 시각화", "오행(목화토금수)의 과유불급을 방사형 레이더 그래프로 직관적 전달"),
            ("100% 온디바이스 볼트", "생년월일 및 관계 데이터를 서버 없이 기기 내부 암호화 영역에만 격리"),
        ]),
        ("WEAKNESSES (약점)", "명리학 초심자의 용어 장벽", "red", [
            ("전문 용어 허들", "십신, 지지충합, 대운 등 명리학 개념에 대한 초심자의 심리적 거리감"),
            ("출생시간 의존도", "정확한 출생시각을 모를 경우 시주(時柱) 추론 알고리즘 필요"),
            ("대응 전략", "3단계 점진적 정보 공개(Progressive Disclosure) 및 툴팁 용어 사전 탑재"),
        ]),
        ("OPPORTUNITIES (기회)", "MZ세대의 사주·타로·궁합 문화 확산", "cyan", [
            ("소셜 토큰 트렌드", "MBTI를 잇는 자기 이해 및 타인과의 성향 비교 공유 문화 정착"),
            ("바이오리듬 결합", "신체·감성·지성 주기와 운세 에너지를 결합한 일일 라이프 루틴 확장"),
            ("맞춤형 길일 추천", "에너지 흐름에 최적화된 미팅/고백/계약 황금 시간대(Golden Time) 제안"),
        ]),
        ("THREATS (위협)", "기존 대형 운세 앱의 광고 과포화", "purple", [
            ("선점 플랫폼 경쟁", "점신, 포스텔러 등 기존 대형 앱의 방대한 무료 데이터베이스 풀"),
            ("광고 피로도 반사 이익", "전면 광고와 유료 결제 유도로 지친 사용자들의 피난처로 브랜딩"),
            ("대응 전략", "광고 없는 프리미엄 젠(Zen) UX, 미려한 다크 테마 및 프라이버시 차별화"),
        ]),
    ]
    
    coords = [
        (100, swot_y),
        (100 + swot_w + swot_gap_x, swot_y),
        (100, swot_y + swot_h + swot_gap_y),
        (100 + swot_w + swot_gap_x, swot_y + swot_h + swot_gap_y),
    ]
    
    for idx, (stitle, ssub, stheme, sbullets) in enumerate(swot_data):
        sx, sy_box = coords[idx]
        draw.rounded_rectangle([sx, sy_box, sx + swot_w, sy_box + swot_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
        draw_pill_badge(draw, left_x=sx + 24, cy=sy_box + 26, text=stitle, font=get_font(10, 'bold'), theme=stheme, has_dot=True, height=22, pad_x=8)
        draw.text((sx + 190, sy_box + 26), ssub, font=get_font(13.5, 'bold'), fill=(248, 250, 252), anchor='lm')
        draw.line([(sx + 24, sy_box + 48), (sx + swot_w - 24, sy_box + 48)], fill=(25, 35, 55), width=1)
        
        for bi, (btitle, bdesc) in enumerate(sbullets):
            by = sy_box + 64 + bi * 48
            draw.ellipse([sx + 26, by + 4, sx + 34, by + 12], fill=(229, 192, 123) if stheme == 'gold' else (0, 229, 255))
            draw.text((sx + 44, by), btitle, font=get_font(12, 'bold'), fill=(226, 232, 240))
            draw.text((sx + 180, by + 1), bdesc, font=get_font(11.5, 'regular'), fill=(148, 163, 184))
            
    draw_slide_footer(draw, 2)
    base.save(os.path.join(OUT_DIR, "slide_02.png"))
    print("Slide 02 generated.")

# ==============================================================
# SLIDE 03: TARGET & BENCHMARK & PERSONAS
# ==============================================================
def make_slide_03():
    base, draw = create_cosmic_base(center_orbit=(1400, 500))
    draw_slide_header(
        draw,
        slide_num=3,
        category_en="TARGET & PERSONA | SEGMENTATION MATRIX & BENCHMARK",
        title_white="타깃 세그먼트 매트릭스와 ",
        title_gold="경쟁사 벤치마킹 분석",
        subtitle_kr="2x2 타깃 포지셔닝 매트릭스와 4개 플랫폼 벤치마크, 그리고 실증 페르소나 행동 지표"
    )
    
    # --------------------------------------------------------------
    # 1. TOP-LEFT: 2x2 TARGET SEGMENTATION MATRIX (x=100, y=234, w=780, h=378)
    # --------------------------------------------------------------
    t_x, t_y, t_w, t_h = 100, 234, 780, 378
    draw.rounded_rectangle([t_x, t_y, t_x + t_w, t_y + t_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    
    draw.text((t_x + 24, t_y + 18), "TARGET SEGMENTATION MATRIX (타깃 세그먼트 분석)", font=get_font(13.5, 'bold'), fill=(248, 250, 252))
    draw.text((t_x + 24, t_y + 38), "운세 소비 목적과 데이터 분석 선호도에 따른 4개 사용자 군 분류", font=get_font(11, 'medium'), fill=(148, 163, 184))
    
    # 2x2 Grid
    grid_w = 540
    grid_h = 260
    grid_x = t_x + (t_w - grid_w) // 2
    grid_y = t_y + 76
    qw = (grid_w - 16) // 2
    qh = (grid_h - 16) // 2
    
    axis_x = grid_x + qw + 8
    axis_y = grid_y + qh + 8
    draw.line([(axis_x, grid_y), (axis_x, grid_y + grid_h)], fill=(40, 53, 78), width=2)
    draw.line([(grid_x, axis_y), (grid_x + grid_w, axis_y)], fill=(40, 53, 78), width=2)
    
    draw.text((axis_x, grid_y - 12), "▲ 심층 분석 & 관계 시너지 (진지한 탐색)", font=get_font(9.5, 'bold'), fill=(229, 192, 123), anchor='ms')
    draw.text((axis_x, grid_y + grid_h + 16), "▼ 일상적 힐링 & 재미 (캐주얼)", font=get_font(9.5, 'bold'), fill=(100, 116, 139), anchor='ma')
    draw.text((grid_x - 12, axis_y), "◀ 전통 텍스트 / 미신", font=get_font(9.5, 'bold'), fill=(100, 116, 139), anchor='rm')
    draw.text((grid_x + grid_w + 12, axis_y), "데이터 / 시각화 알고리즘 ▶", font=get_font(9.5, 'bold'), fill=(0, 229, 255), anchor='lm')
    
    # Quadrant 1: Top-Right (CORE TARGET)
    q1_x = grid_x + qw + 16
    q1_y = grid_y
    draw.rounded_rectangle([q1_x, q1_y, q1_x + qw, q1_y + qh], radius=8, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw_pill_badge(draw, left_x=q1_x + 12, cy=q1_y + 20, text="CORE TARGET", font=get_font(9, 'bold'), theme='gold', has_dot=True, height=20, solid=True)
    draw.text((q1_x + 12, q1_y + 40), "MZ 진지한 궁합 탐색자", font=get_font(12, 'bold'), fill=(255, 215, 0))
    draw.text((q1_x + 12, q1_y + 62), "• 연인/동료와의 정밀 시너지 분석\n• 난해한 한자 대신 5원소 방사형 차트 선호", font=get_font(10.5, 'regular'), fill=(226, 232, 240), spacing=3)
    
    # Quadrant 2: Bottom-Right (PRIMARY TARGET)
    q2_x = q1_x
    q2_y = grid_y + qh + 16
    draw.rounded_rectangle([q2_x, q2_y, q2_x + qw, q2_y + qh], radius=8, fill=(8, 42, 58), outline=(0, 229, 255), width=1)
    draw_pill_badge(draw, left_x=q2_x + 12, cy=q2_y + 20, text="PRIMARY TARGET", font=get_font(9, 'bold'), theme='cyan', has_dot=True, height=20, solid=True)
    draw.text((q2_x + 12, q2_y + 40), "바이오리듬 루틴 관리자", font=get_font(12, 'bold'), fill=(0, 229, 255))
    draw.text((q2_x + 12, q2_y + 62), "• 매일의 신체/감성/지성 에너지 체크\n• 황금 시간대(Golden Time) 일정 조율", font=get_font(10.5, 'regular'), fill=(226, 232, 240), spacing=3)
    
    # Quadrant 3: Top-Left (SECONDARY TARGET)
    q3_x = grid_x
    q3_y = grid_y
    draw.rounded_rectangle([q3_x, q3_y, q3_x + qw, q3_y + qh], radius=8, fill=(34, 18, 56), outline=(168, 85, 247), width=1)
    draw_pill_badge(draw, left_x=q3_x + 12, cy=q3_y + 20, text="SECONDARY TARGET", font=get_font(9, 'bold'), theme='purple', has_dot=True, height=20, solid=True)
    draw.text((q3_x + 12, q3_y + 40), "전통 철학관 단골 탐색자", font=get_font(12, 'bold'), fill=(216, 180, 254))
    draw.text((q3_x + 12, q3_y + 62), "• 사주 원국의 해석 깊이를 원함\n• 방대한 텍스트 피로도로 요약 갈망", font=get_font(10.5, 'regular'), fill=(226, 232, 240), spacing=3)
    
    # Quadrant 4: Bottom-Left (POTENTIAL TARGET)
    q4_x = grid_x
    q4_y = grid_y + qh + 16
    draw.rounded_rectangle([q4_x, q4_y, q4_x + qw, q4_y + qh], radius=8, fill=(20, 26, 42), outline=(100, 116, 139), width=1)
    draw_pill_badge(draw, left_x=q4_x + 12, cy=q4_y + 20, text="POTENTIAL TARGET", font=get_font(9, 'bold'), theme='slate', has_dot=True, height=20, solid=True)
    draw.text((q4_x + 12, q4_y + 40), "호기심 킬링타임 유저", font=get_font(12, 'bold'), fill=(203, 213, 225))
    draw.text((q4_x + 12, q4_y + 62), "• 재미 위주의 단발성 텍스트 소비\n• 광고 피로도로 즉시 이탈 경향", font=get_font(10.5, 'regular'), fill=(148, 163, 184), spacing=3)

    # --------------------------------------------------------------
    # 2. TOP-RIGHT: 4-WAY COMPETITIVE BENCHMARK TABLE (x=920, y=234, w=900, h=378)
    # --------------------------------------------------------------
    b_x, b_y, b_w, b_h = 920, 234, 900, 378
    draw.rounded_rectangle([b_x, b_y, b_x + b_w, b_y + b_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    
    draw.text((b_x + 24, b_y + 18), "COMPETITIVE BENCHMARK (경쟁 서비스 정밀 벤치마킹)", font=get_font(13.5, 'bold'), fill=(248, 250, 252))
    draw.text((b_x + 24, b_y + 38), "점신, 포스텔러, 헬로우봇 vs FortuneMatch 5대 핵심 UX 지표 비교", font=get_font(11, 'medium'), fill=(148, 163, 184))
    
    # Table Header
    th_y = b_y + 68
    draw.rounded_rectangle([b_x + 16, th_y, b_x + b_w - 16, th_y + 34], radius=6, fill=(20, 28, 48))
    cols = [
        ("평가 기준 (UX Criteria)", b_x + 30, 200),
        ("점신 (Jumsin)", b_x + 240, 150),
        ("포스텔러 (Forceteller)", b_x + 400, 160),
        ("헬로우봇 (Hellobot)", b_x + 570, 150),
        ("FortuneMatch (FTMT)", b_x + 730, 160),
    ]
    for ctitle, cx, cw in cols:
        draw.text((cx, th_y + 17), ctitle, font=get_font(10.5, 'bold'), fill=(229, 192, 123) if "FTMT" in ctitle else (148, 163, 184), anchor='lm')
        
    bench_rows = [
        ("01. 오행 시각화", "텍스트 위주 (C)", "캐릭터 일러스트 (B)", "챗봇 대화형 (C)", "방사형 레이더 & 수치 (A+)", "gold"),
        ("02. 1:1 정밀 궁합", "단순 고정 텍스트 (C)", "감성형 카드 (B)", "단답형 챗봇 (C+)", "다차원 시너지 매트릭스 (A+)", "gold"),
        ("03. 바이오리듬 연동", "미지원 (D)", "미지원 (D)", "단순 감정 기록 (C)", "실시간 3축 동기화 (A+)", "cyan"),
        ("04. UX 간결성/광고", "전면/배너 광고 과다 (D)", "유료 결제 팝업 (C)", "대화 지연 피로도 (C)", "무광고 젠(Zen) 레이아웃 (A+)", "green"),
        ("05. 개인정보 보안", "중앙 서버 저장 (D)", "일반 클라우드 (C)", "일반 클라우드 (C)", "100% 로컬 암호화 볼트 (A+)", "purple"),
    ]
    for ri, (rcrit, rjum, rforce, rhello, rftmt, rcol) in enumerate(bench_rows):
        ry = th_y + 42 + ri * 48
        bg_col = (18, 25, 42) if ri % 2 == 0 else (13, 18, 31)
        draw.rounded_rectangle([b_x + 16, ry, b_x + b_w - 16, ry + 42], radius=6, fill=bg_col)
        draw.text((b_x + 30, ry + 21), rcrit, font=get_font(11, 'bold'), fill=(226, 232, 240), anchor='lm')
        draw.text((b_x + 240, ry + 21), rjum, font=get_font(10.5, 'regular'), fill=(148, 163, 184), anchor='lm')
        draw.text((b_x + 400, ry + 21), rforce, font=get_font(10.5, 'regular'), fill=(148, 163, 184), anchor='lm')
        draw.text((b_x + 570, ry + 21), rhello, font=get_font(10.5, 'regular'), fill=(148, 163, 184), anchor='lm')
        draw_pill_badge(draw, left_x=b_x + 726, cy=ry + 21, text=rftmt, font=get_font(9.5, 'bold'), theme=rcol, solid=True, height=22, pad_x=8)

    # --------------------------------------------------------------
    # 3. BOTTOM: 2 ARCHETYPE PERSONA CARDS (x=100, y=632, w=1720, h=330)
    # --------------------------------------------------------------
    p_y = 632
    pw = 840
    
    # PERSONA A (Primary)
    pa_x = 100
    draw.rounded_rectangle([pa_x, p_y, pa_x + pw, p_y + 330], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=pa_x + 24, cy=p_y + 26, text="PRIMARY PERSONA (ARCHETYPE A)", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, height=22, pad_x=8)
    draw.text((pa_x + 24, p_y + 60), "데이터 중심의 현실적 탐색자 - 김서윤 (27세, IT 브랜드 마케터)", font=get_font(15, 'bold'), fill=(248, 250, 252))
    draw.text((pa_x + 24, p_y + 86), "\"매번 긴 한자 풀이를 읽다 지쳐요. 우리 둘의 성향이 데이터로 어떻게 맞는지 한눈에 보고 싶어요.\"", font=get_font(12, 'bold'), fill=(229, 192, 123))
    
    draw.line([(pa_x + 24, p_y + 112), (pa_x + pw - 24, p_y + 112)], fill=(25, 35, 55), width=1)
    
    pa_details = [
        ("Demographics", "미혼, 연애 2년차, MBTI 및 성향 분석 앱 즐겨 사용, 모바일 퍼스트"),
        ("Pain Points", "기존 운세 앱의 복잡한 한자 텍스트 스킵, 모호한 관계 궁합 조언에 대한 불신"),
        ("Needs & Goals", "상대방과의 오행 밸런스 시각적 확인, 갈등 예방을 위한 소통 골든타임 파악"),
        ("Feature Fit", "1:1 다차원 시너지 궁합 매트릭스 & 5원소 방사형 레이더 시각화"),
    ]
    for di, (dtitle, ddesc) in enumerate(pa_details):
        dy = p_y + 128 + di * 44
        draw.text((pa_x + 24, dy), dtitle, font=get_font(11, 'bold'), fill=(229, 192, 123))
        draw.text((pa_x + 140, dy), ddesc, font=get_font(11.5, 'regular'), fill=(203, 213, 225))

    # PERSONA B (Secondary)
    pb_x = pa_x + pw + 40
    draw.rounded_rectangle([pb_x, p_y, pb_x + pw, p_y + 330], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=pb_x + 24, cy=p_y + 26, text="SECONDARY PERSONA (ARCHETYPE B)", font=get_font(9.5, 'bold'), theme='cyan', has_dot=True, height=22, pad_x=8)
    draw.text((pb_x + 24, p_y + 60), "매일 컨디션을 관리하는 실용주의자 - 박준혁 (29세, 프론트엔드 개발자)", font=get_font(15, 'bold'), fill=(248, 250, 252))
    draw.text((pb_x + 24, p_y + 86), "\"결과가 왜 이렇게 나왔는지 납득할 만한 데이터가 필요해요. 내 생년월일이 유출되지 않는 것도 중요하죠.\"", font=get_font(12, 'bold'), fill=(0, 229, 255))
    
    draw.line([(pb_x + 24, p_y + 112), (pb_x + pw - 24, p_y + 112)], fill=(25, 35, 55), width=1)
    
    pb_details = [
        ("Demographics", "미혼, 1인 가구, 자기관리 및 생산성 앱 헤비 유저, 개인정보 보안 민감"),
        ("Pain Points", "근거 없는 미신적 점괘에 반감, 개인정보(생년월일시) 서버 평문 전송 공포"),
        ("Needs & Goals", "과학적 바이오리듬과 일일 운세의 일치도 검증, 로컬 암호화 보관 보장"),
        ("Feature Fit", "실시간 바이오리듬 동기화 대시보드 & 100% 온디바이스 시크릿 볼트"),
    ]
    for di, (dtitle, ddesc) in enumerate(pb_details):
        dy = p_y + 128 + di * 44
        draw.text((pb_x + 24, dy), dtitle, font=get_font(11, 'bold'), fill=(0, 229, 255))
        draw.text((pb_x + 140, dy), ddesc, font=get_font(11.5, 'regular'), fill=(203, 213, 225))
        
    draw_slide_footer(draw, 3)
    base.save(os.path.join(OUT_DIR, "slide_03.png"))
    print("Slide 03 generated.")

# ==============================================================
# SLIDE 04: INFORMATION ARCHITECTURE (IA)
# ==============================================================
def make_slide_04():
    base, draw = create_cosmic_base(center_orbit=(1400, 540))
    draw_slide_header(
        draw,
        slide_num=4,
        category_en="INFORMATION ARCHITECTURE | SERVICE STRUCTURE",
        title_white="사주 엔진부터 시크릿 금고까지 연결된 ",
        title_gold="5대 정보 구조(IA)",
        subtitle_kr="만세력 진단부터 1:1 시너지 궁합, 바이오리듬, 프라이빗 볼트까지 한눈에 파악하는 모바일 계층 구조"
    )
    
    # Top-Right Legend: IA Notation
    leg_x = 1260
    leg_y = 65
    leg_w = 560
    leg_h = 78
    draw.rounded_rectangle([leg_x, leg_y, leg_x + leg_w, leg_y + leg_h], radius=10, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=leg_x + 16, cy=leg_y + 20, text="IA NOTATION", font=get_font(8.5, 'bold'), theme='gold', has_dot=True, pad_x=6, height=18)
    draw.text((leg_x + 124, leg_y + 20), "화면 및 인터랙션 컴포넌트 표기 범례", font=get_font(11, 'bold'), fill=(248, 250, 252), anchor='lm')
    
    # Legend Items
    draw.rounded_rectangle([leg_x + 16, leg_y + 44, leg_x + 72, leg_y + 68], radius=4, fill=(20, 28, 48), outline=(40, 53, 78), width=1)
    draw.text((leg_x + 44, leg_y + 56), "Page", font=get_font(8.5, 'bold'), fill=(203, 213, 225), anchor='mm')
    draw.text((leg_x + 80, leg_y + 56), "기본 화면", font=get_font(9.5, 'medium'), fill=(148, 163, 184), anchor='lm')
    
    draw.rounded_rectangle([leg_x + 154, leg_y + 44, leg_x + 236, leg_y + 68], radius=4, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw.text((leg_x + 195, leg_y + 56), "BottomSheet", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    draw.text((leg_x + 244, leg_y + 56), "액션 시트", font=get_font(9.5, 'medium'), fill=(148, 163, 184), anchor='lm')
    
    draw.rounded_rectangle([leg_x + 316, leg_y + 44, leg_x + 370, leg_y + 68], radius=4, fill=(8, 42, 58), outline=(0, 229, 255), width=1)
    draw.text((leg_x + 343, leg_y + 56), "Modal", font=get_font(8.5, 'bold'), fill=(0, 229, 255), anchor='mm')
    draw.text((leg_x + 378, leg_y + 56), "팝업/다이얼로그", font=get_font(9.5, 'medium'), fill=(148, 163, 184), anchor='lm')
    
    draw_pill_badge(draw, left_x=leg_x + 468, cy=leg_y + 56, text="NEW", font=get_font(8, 'bold'), theme='purple', pad_x=5, height=18, solid=True)
    draw.text((leg_x + 506, leg_y + 56), "핵심 차별화", font=get_font(9.5, 'bold'), fill=(216, 180, 254), anchor='lm')

    # --------------------------------------------------------------
    # LEVEL 0: MASTER HUB NODE (x=640, y=234, w=640, h=56)
    # --------------------------------------------------------------
    rx1, ry1, rx2, ry2 = 640, 234, 1280, 290
    draw.rounded_rectangle([rx1, ry1, rx2, ry2], radius=12, fill=(13, 18, 31), outline=(229, 192, 123), width=2)
    draw_pill_badge(draw, cx=rx1 + 76, cy=ry1 + 28, text="MASTER HUB", font=get_font(9, 'bold'), theme='gold', pad_x=8, height=24)
    draw.text((rx1 + 154, ry1 + 18), "FORTUNEMATCH ARCHITECTURE MASTER HUB (L0)", font=get_font(13.5, 'bold'), fill=(248, 250, 252), anchor='lm')
    draw.text((rx1 + 154, ry1 + 38), "모바일 한 손 조작 최적화 & 0.3s 천문 만세력 계산 엔진 통합 제어", font=get_font(10.5, 'medium'), fill=(148, 163, 184), anchor='lm')
    
    # Connector Lines to 5 Columns
    cw = 328
    cgap = 20
    cols_x = [100 + i * (cw + cgap) for i in range(5)]
    col_centers = [cx + cw // 2 for cx in cols_x]
    
    draw.line([(960, ry2), (960, 314)], fill=(229, 192, 123), width=2)
    draw.ellipse([956, 310, 964, 318], fill=(229, 192, 123))
    draw.line([(col_centers[0], 314), (col_centers[-1], 314)], fill=(229, 192, 123), width=2)
    for cx in col_centers:
        draw.ellipse([cx - 4, 314 - 4, cx + 4, 314 + 4], fill=(229, 192, 123))
        draw.line([(cx, 314), (cx, 336)], fill=(229, 192, 123), width=2)

    # 5 SERVICE DOMAIN COLUMNS
    domains = [
        ("01 SAJU ENGINE", "온보딩 & 사주원국", "gold", [
            ("L1. 천문 만세력 산출 (Page)", "생년월일시 입력 후 0.3s 사주원국 8글자 산출"),
            ("L2. 태양시 균시차 보정 (BottomSheet)", "출생지 경도 기준 정밀 진태양시 자동 보정"),
            ("L3. 삼주 추론 알고리즘 (Modal)", "출생시간 미상 시 확률 기반 시주 추론 가이드"),
            ("L4. 오행 방사형 밸런스 (Page)", "목화토금수 과유불급 5각 레이더 차트 렌더링"),
        ]),
        ("02 DAILY RHYTHM", "일일 운세 & 바이오리듬", "cyan", [
            ("L1. 오늘의 천문 대시보드 (Page)", "일진(日辰) 에너지 및 맞춤 행운 키워드 요약"),
            ("L2. 3축 바이오리듬 뷰 (Page)", "신체(23일)·감성(28일)·지성(33일) 실시간 곡선"),
            ("L3. 황금 시간대 추천 (BottomSheet)", "미팅·의사결정·계약에 최적화된 Golden Time"),
            ("L4. 타로 심층 리딩 (Modal)", "결정적 기로에서의 3카드 아르카나 스프레드"),
        ]),
        ("03 SYNASTRY", "1:1 관계 시너지 궁합", "purple", [
            ("L1. 관계 매칭 허브 (Page)", "상대방 프로필 등록 및 다차원 궁합 지수 열람"),
            ("L2. 오행 상생상극 매트릭스 (Page)", "서로의 부족한 기운을 채워주는 보완도 분석"),
            ("L3. 소통 가이드 처방전 (BottomSheet)", "성향 차이에 따른 갈등 예방 대화법 솔루션"),
            ("L4. 관계 히스토리 카드 (Modal)", "연인/동료/친구 별 시너지 리포트 PDF 저장"),
        ]),
        ("04 CHRONOS", "대운·세운 타임라인", "amber", [
            ("L1. 10년 대운 로드맵 (Page)", "인생의 큰 흐름을 관통하는 대운의 변곡점 추적"),
            ("L2. 세운·월운 흐름 그래프 (Page)", "올해와 이번 달의 에너지 성쇠 곡선 시각화"),
            ("L3. 기회·위기 가드레일 (BottomSheet)", "인생 터닝포인트 대비 사전 멘탈 케어 가이드"),
            ("L4. 길일 캘린더 연동 (Modal)", "이사, 개업, 시험 등 중요한 일정 캘린더 동기화"),
        ]),
        ("05 PRIVACY VAULT", "시크릿 금고 & 프라이버시", "green", [
            ("L1. 온디바이스 볼트 락 (Page)", "생체 인증(FaceID/지문) 기반 프라이빗 금고"),
            ("L2. AES-256 로컬 암호화 (Page)", "모든 프로필과 사주 데이터를 기기 내 격리 저장"),
            ("L3. 제로 트래킹 설정 (BottomSheet)", "서버 평문 전송 없는 100% 프라이버시 보장"),
            ("L4. 데이터 영구 파기 (Modal)", "1-Tap으로 모든 로컬 캐시 및 관계 정보 완전 삭제"),
        ]),
    ]
    
    col_y = 336
    for idx, (code_en, domain_kr, dtheme, cards) in enumerate(domains):
        cx = cols_x[idx]
        
        # Domain Header Card
        draw.rounded_rectangle([cx, col_y, cx + cw, col_y + 60], radius=10, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
        draw_pill_badge(draw, left_x=cx + 12, cy=col_y + 20, text=code_en, font=get_font(8.5, 'bold'), theme=dtheme, pad_x=6, height=18)
        draw.text((cx + 12, col_y + 44), domain_kr, font=get_font(12, 'bold'), fill=(248, 250, 252))
        
        # Column vertical flow line
        draw.line([(col_centers[idx], col_y + 60), (col_centers[idx], 940)], fill=(40, 53, 78), width=2)
        
        # 4 Hierarchy Sub-Cards
        card_start_y = col_y + 76
        for cidx, (ctitle, cdesc) in enumerate(cards):
            cy_card = card_start_y + cidx * 126
            draw.ellipse([col_centers[idx] - 4, cy_card + 20 - 4, col_centers[idx] + 4, cy_card + 20 + 4], fill=(229, 192, 123))
            
            draw.rounded_rectangle([cx, cy_card, cx + cw, cy_card + 112], radius=10, fill=(18, 25, 42), outline=(34, 47, 77), width=1)
            
            # Type Badge inside Card
            if "Page" in ctitle:
                badge_type, badge_theme = "Page", "slate"
            elif "BottomSheet" in ctitle:
                badge_type, badge_theme = "BottomSheet", "gold"
            else:
                badge_type, badge_theme = "Modal", "cyan"
                
            draw_pill_badge(draw, left_x=cx + 12, cy=cy_card + 20, text=badge_type, font=get_font(8, 'bold'), theme=badge_theme, pad_x=6, height=18)
            draw.text((cx + 12, cy_card + 46), ctitle.split(" (")[0], font=get_font(12, 'bold'), fill=(248, 250, 252))
            draw.text((cx + 12, cy_card + 72), cdesc, font=get_font(10.5, 'regular'), fill=(148, 163, 184))
            
    draw_slide_footer(draw, 4)
    base.save(os.path.join(OUT_DIR, "slide_04.png"))
    print("Slide 04 generated.")

# ==============================================================
# SLIDE 05: USER FLOWCHART & DECISION TREE
# ==============================================================
def make_slide_05():
    base, draw = create_cosmic_base(center_orbit=(1400, 540))
    draw_slide_header(
        draw,
        slide_num=5,
        category_en="USER FLOW | SERVICE INTERACTION FLOWCHART",
        title_white="사용자 행동과 판단을 이끄는 ",
        title_gold="5단계 서비스 UX 플로우차트",
        subtitle_kr="진입 온보딩부터 정밀 태양시 보정, 1:1 시너지 궁합 매칭, 바이오리듬 진단, 시크릿 볼트 저장까지 이어지는 핵심 여정"
    )
    
    # Top-Right Legend: Flowchart Notation
    leg_x = 1260
    leg_y = 65
    leg_w = 560
    leg_h = 78
    draw.rounded_rectangle([leg_x, leg_y, leg_x + leg_w, leg_y + leg_h], radius=10, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=leg_x + 16, cy=leg_y + 20, text="NOTATION", font=get_font(8.5, 'bold'), theme='gold', has_dot=True, pad_x=6, height=18)
    draw.text((leg_x + 115, leg_y + 20), "플로우차트 기호 및 분기 범례", font=get_font(11, 'bold'), fill=(248, 250, 252), anchor='lm')
    
    draw.rounded_rectangle([leg_x + 16, leg_y + 44, leg_x + 72, leg_y + 68], radius=12, fill=(229, 192, 123))
    draw.text((leg_x + 44, leg_y + 56), "Start", font=get_font(8, 'bold'), fill=(15, 23, 42), anchor='mm')
    draw.text((leg_x + 80, leg_y + 56), "시작/종료", font=get_font(9.5, 'medium'), fill=(148, 163, 184), anchor='lm')
    
    draw.rounded_rectangle([leg_x + 144, leg_y + 44, leg_x + 198, leg_y + 68], radius=4, fill=(20, 28, 48), outline=(40, 53, 78), width=1)
    draw.text((leg_x + 171, leg_y + 56), "Screen", font=get_font(8, 'bold'), fill=(203, 213, 225), anchor='mm')
    draw.text((leg_x + 206, leg_y + 56), "화면 노출", font=get_font(9.5, 'medium'), fill=(148, 163, 184), anchor='lm')
    
    draw.rounded_rectangle([leg_x + 276, leg_y + 44, leg_x + 328, leg_y + 68], radius=4, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw.text((leg_x + 302, leg_y + 56), "Action", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    draw.text((leg_x + 336, leg_y + 56), "사용자 행동", font=get_font(9.5, 'medium'), fill=(148, 163, 184), anchor='lm')
    
    draw_diamond(draw, cx=leg_x + 424, cy=leg_y + 56, w=34, h=22, fill=(48, 32, 12), outline=(245, 158, 11), width=1)
    draw.text((leg_x + 424, leg_y + 56), "Decide", font=get_font(6.5, 'bold'), fill=(251, 191, 36), anchor='mm')
    draw.text((leg_x + 448, leg_y + 56), "판단 분기", font=get_font(9.5, 'medium'), fill=(148, 163, 184), anchor='lm')

    # 5 STAGE COLUMNS
    cw = 328
    cgap = 20
    cols_x = [100 + i * (cw + cgap) for i in range(5)]
    col_centers = [cx + cw // 2 for cx in cols_x]
    
    stages_info = [
        ("STAGE 01", "진입 & 프로필 등록", "Launch & Natal Input"),
        ("STAGE 02", "천문 만세력 & 보정", "Solar Time Inversion"),
        ("STAGE 03", "1:1 시너지 매칭", "Synastry Computation"),
        ("STAGE 04", "바이오리듬 & 길일", "Biometric Alignment"),
        ("STAGE 05", "리포트 & 금고 저장", "Encrypted Vault Save")
    ]
    
    # Stage Headers
    for i, (st_code, st_name, st_en) in enumerate(stages_info):
        cx = cols_x[i]
        draw.rounded_rectangle([cx, 234, cx + cw, 284], radius=8, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
        draw_pill_badge(draw, left_x=cx + 14, cy=249, text=st_code, font=get_font(7.5, 'bold'), theme='gold', pad_x=5, height=16)
        draw.text((cx + 86, 249), st_name, font=get_font(11, 'bold'), fill=(248, 250, 252), anchor='lm')
        draw.text((cx + 14, 269), st_en, font=get_font(8.5, 'medium'), fill=(148, 163, 184), anchor='lm')
        
        if i < 4:
            arrow_sx = cx + cw
            arrow_ex = cols_x[i + 1]
            draw_arrow(draw, (arrow_sx + 2, 259), (arrow_ex - 2, 259), col=(229, 192, 123), width=2, arrow_size=4)

    # --------------------------------------------------------------
    # STAGE 01 (Col 0)
    # --------------------------------------------------------------
    c0 = col_centers[0]
    draw.rounded_rectangle([c0 - 60, 310, c0 + 60, 342], radius=16, fill=(229, 192, 123))
    draw.text((c0, 326), "앱 실행 (Launch)", font=get_font(10, 'bold'), fill=(15, 23, 42), anchor='mm')
    draw_arrow(draw, (c0, 342), (c0, 370), col=(229, 192, 123), width=2)
    
    draw.rounded_rectangle([cols_x[0] + 16, 370, cols_x[0] + cw - 16, 430], radius=8, fill=(18, 25, 42), outline=(34, 47, 77), width=1)
    draw.text((c0, 390), "온보딩 웰컴 화면", font=get_font(11, 'bold'), fill=(248, 250, 252), anchor='mm')
    draw.text((c0, 412), "핵심 가치 소개 & 권한 동의", font=get_font(9.5, 'regular'), fill=(148, 163, 184), anchor='mm')
    draw_arrow(draw, (c0, 430), (c0, 460), col=(229, 192, 123), width=2)
    
    draw_parallelogram(draw, c0, 492, 250, 54, fill=(35, 30, 15), outline=(229, 192, 123), skew=10)
    draw.text((c0, 484), "생년월일시 입력 (Input)", font=get_font(11, 'bold'), fill=(255, 215, 0), anchor='mm')
    draw.text((c0, 506), "양/음력 선택 & 출생 시간", font=get_font(9.5, 'regular'), fill=(226, 232, 240), anchor='mm')
    draw_arrow(draw, (c0, 519), (c0, 560), col=(229, 192, 123), width=2)
    
    draw_diamond(draw, c0, 610, 250, 80, fill=(48, 32, 12), outline=(245, 158, 11), width=1)
    draw.text((c0, 602), "정밀 출생시간 확인?", font=get_font(11, 'bold'), fill=(251, 191, 36), anchor='mm')
    draw.text((c0, 622), "시(時) 정보 유무 판단", font=get_font(9, 'medium'), fill=(226, 232, 240), anchor='mm')
    
    # Branches from Col 0 Decision Diamond
    # YES -> To Col 1 Stage 02
    draw.line([(c0 + 125, 610), (cols_x[1] - 8, 610)], fill=(16, 185, 129), width=2)
    draw_branch_badge(draw, c0 + 140, 596, "YES", is_yes=True)
    draw_arrow(draw, (cols_x[1] - 8, 610), (cols_x[1] + 16, 610), col=(16, 185, 129), width=2, arrow_size=4)
    
    # NO -> Down to 삼주 추론
    draw_arrow(draw, (c0, 650), (c0, 710), col=(239, 68, 68), width=2)
    draw_branch_badge(draw, c0 + 26, 676, "NO", is_yes=False)
    
    draw.rounded_rectangle([cols_x[0] + 16, 710, cols_x[0] + cw - 16, 770], radius=8, fill=(20, 28, 48), outline=(40, 53, 78), width=1)
    draw.text((c0, 730), "삼주(생년월일) 추론 보정", font=get_font(10.5, 'bold'), fill=(203, 213, 225), anchor='mm')
    draw.text((c0, 750), "확률 기반 가중치 적용", font=get_font(9, 'regular'), fill=(148, 163, 184), anchor='mm')
    
    # Re-route from NO to Col 1
    draw.line([(cols_x[0] + cw - 16, 740), (cols_x[1] + 20, 740)], fill=(40, 53, 78), width=2)
    draw.line([(cols_x[1] + 20, 740), (cols_x[1] + 20, 630)], fill=(40, 53, 78), width=2)

    # --------------------------------------------------------------
    # STAGE 02 (Col 1)
    # --------------------------------------------------------------
    c1 = col_centers[1]
    draw_database_node(draw, c1, 370, 180, 56, fill=(18, 25, 42), outline=(0, 229, 255))
    draw.text((c1, 370), "천문 만세력 Ephemeris DB", font=get_font(9.5, 'bold'), fill=(0, 229, 255), anchor='mm')
    draw_arrow(draw, (c1, 398), (c1, 440), col=(0, 229, 255), width=2)
    
    draw.rounded_rectangle([cols_x[1] + 16, 440, cols_x[1] + cw - 16, 500], radius=8, fill=(8, 42, 58), outline=(0, 229, 255), width=1)
    draw.text((c1, 460), "0.3s 천문 만세력 연산 엔진", font=get_font(11, 'bold'), fill=(0, 229, 255), anchor='mm')
    draw.text((c1, 482), "사주 4주 8글자 정밀 도출", font=get_font(9.5, 'regular'), fill=(203, 213, 225), anchor='mm')
    draw_arrow(draw, (c1, 500), (c1, 570), col=(0, 229, 255), width=2)
    
    draw.rounded_rectangle([cols_x[1] + 16, 570, cols_x[1] + cw - 16, 640], radius=8, fill=(18, 25, 42), outline=(34, 47, 77), width=1)
    draw.text((c1, 592), "진태양시 균시차 정밀 보정", font=get_font(11, 'bold'), fill=(248, 250, 252), anchor='mm')
    draw.text((c1, 616), "경도 차이(-32분) 자동 적용", font=get_font(9.5, 'regular'), fill=(148, 163, 184), anchor='mm')
    draw_arrow(draw, (c1, 640), (c1, 690), col=(229, 192, 123), width=2)
    
    draw.rounded_rectangle([cols_x[1] + 16, 690, cols_x[1] + cw - 16, 760], radius=8, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw.text((c1, 712), "오행 방사형 밸런스 차트", font=get_font(11, 'bold'), fill=(255, 215, 0), anchor='mm')
    draw.text((c1, 736), "목화토금수 에너지 분포 렌더링", font=get_font(9.5, 'regular'), fill=(226, 232, 240), anchor='mm')
    
    # Forward to Stage 03
    draw.line([(cols_x[1] + cw - 16, 725), (cols_x[2] + 16, 725)], fill=(229, 192, 123), width=2)
    draw_arrow(draw, (cols_x[2] - 8, 725), (cols_x[2] + 16, 725), col=(229, 192, 123), width=2, arrow_size=4)

    # --------------------------------------------------------------
    # STAGE 03 (Col 2)
    # --------------------------------------------------------------
    c2 = col_centers[2]
    draw_diamond(draw, c2, 420, 250, 80, fill=(34, 18, 56), outline=(168, 85, 247), width=1)
    draw.text((c2, 412), "상대방 프로필 연동 여부?", font=get_font(11, 'bold'), fill=(216, 180, 254), anchor='mm')
    draw.text((c2, 432), "1:1 궁합 대상 존재 확인", font=get_font(9, 'medium'), fill=(226, 232, 240), anchor='mm')
    
    # YES branch -> 다차원 궁합 매트릭스
    draw_arrow(draw, (c2, 460), (c2, 530), col=(16, 185, 129), width=2)
    draw_branch_badge(draw, c2 + 26, 490, "YES", is_yes=True)
    
    draw.rounded_rectangle([cols_x[2] + 16, 530, cols_x[2] + cw - 16, 600], radius=8, fill=(34, 18, 56), outline=(168, 85, 247), width=1)
    draw.text((c2, 552), "1:1 다차원 시너지 매트릭스", font=get_font(11, 'bold'), fill=(216, 180, 254), anchor='mm')
    draw.text((c2, 576), "일간·지지·오행 상호보완 연산", font=get_font(9.5, 'regular'), fill=(226, 232, 240), anchor='mm')
    draw_arrow(draw, (c2, 600), (c2, 670), col=(168, 85, 247), width=2)
    
    draw.rounded_rectangle([cols_x[2] + 16, 670, cols_x[2] + cw - 16, 740], radius=8, fill=(18, 25, 42), outline=(34, 47, 77), width=1)
    draw.text((c2, 692), "소통 & 갈등 예방 처방전", font=get_font(11, 'bold'), fill=(248, 250, 252), anchor='mm')
    draw.text((c2, 716), "성향 차이 극복 대화 가이드", font=get_font(9.5, 'regular'), fill=(148, 163, 184), anchor='mm')
    
    # NO branch -> Skip to Stage 04
    draw.line([(c2 + 125, 420), (cols_x[3] + 16, 420)], fill=(239, 68, 68), width=2)
    draw_branch_badge(draw, c2 + 140, 406, "NO", is_yes=False)
    
    # Forward from Stage 03 to Stage 04
    draw.line([(cols_x[2] + cw - 16, 705), (cols_x[3] + 16, 705)], fill=(229, 192, 123), width=2)
    draw_arrow(draw, (cols_x[3] - 8, 705), (cols_x[3] + 16, 705), col=(229, 192, 123), width=2, arrow_size=4)

    # --------------------------------------------------------------
    # STAGE 04 (Col 3)
    # --------------------------------------------------------------
    c3 = col_centers[3]
    draw.rounded_rectangle([cols_x[3] + 16, 390, cols_x[3] + cw - 16, 460], radius=8, fill=(8, 42, 58), outline=(0, 229, 255), width=1)
    draw.text((c3, 412), "실시간 3축 바이오리듬", font=get_font(11, 'bold'), fill=(0, 229, 255), anchor='mm')
    draw.text((c3, 436), "신체·감성·지성 주기 동기화", font=get_font(9.5, 'regular'), fill=(203, 213, 225), anchor='mm')
    draw_arrow(draw, (c3, 460), (c3, 530), col=(0, 229, 255), width=2)
    
    draw.rounded_rectangle([cols_x[3] + 16, 530, cols_x[3] + cw - 16, 600], radius=8, fill=(18, 25, 42), outline=(34, 47, 77), width=1)
    draw.text((c3, 552), "황금 시간대(Golden Time) 산출", font=get_font(11, 'bold'), fill=(248, 250, 252), anchor='mm')
    draw.text((c3, 576), "오늘 가장 운기가 왕성한 시각", font=get_font(9.5, 'regular'), fill=(148, 163, 184), anchor='mm')
    draw_arrow(draw, (c3, 600), (c3, 670), col=(229, 192, 123), width=2)
    
    draw.rounded_rectangle([cols_x[3] + 16, 670, cols_x[3] + cw - 16, 740], radius=8, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw.text((c3, 692), "오늘의 종합 운세 리포트", font=get_font(11, 'bold'), fill=(255, 215, 0), anchor='mm')
    draw.text((c3, 716), "행운의 컬러/숫자/방위 가이드", font=get_font(9.5, 'regular'), fill=(226, 232, 240), anchor='mm')
    
    # Forward to Stage 05
    draw.line([(cols_x[3] + cw - 16, 705), (cols_x[4] + 16, 705)], fill=(229, 192, 123), width=2)
    draw_arrow(draw, (cols_x[4] - 8, 705), (cols_x[4] + 16, 705), col=(229, 192, 123), width=2, arrow_size=4)

    # --------------------------------------------------------------
    # STAGE 05 (Col 4)
    # --------------------------------------------------------------
    c4 = col_centers[4]
    draw_database_node(draw, c4, 420, 200, 60, fill=(12, 42, 30), outline=(16, 185, 129))
    draw.text((c4, 420), "온디바이스 AES-256 금고", font=get_font(9.5, 'bold'), fill=(52, 211, 153), anchor='mm')
    draw_arrow(draw, (c4, 450), (c4, 520), col=(16, 185, 129), width=2)
    
    draw.rounded_rectangle([cols_x[4] + 16, 520, cols_x[4] + cw - 16, 590], radius=8, fill=(12, 42, 30), outline=(16, 185, 129), width=1)
    draw.text((c4, 542), "생체 인증(FaceID/지문) 락", font=get_font(11, 'bold'), fill=(52, 211, 153), anchor='mm')
    draw.text((c4, 566), "무유출 로컬 암호화 격리 저장", font=get_font(9.5, 'regular'), fill=(203, 213, 225), anchor='mm')
    draw_arrow(draw, (c4, 590), (c4, 660), col=(16, 185, 129), width=2)
    
    draw.rounded_rectangle([c4 - 70, 660, c4 + 70, 696], radius=18, fill=(16, 185, 129))
    draw.text((c4, 678), "결과 완료 (End)", font=get_font(10.5, 'bold'), fill=(255, 255, 255), anchor='mm')
    
    draw_slide_footer(draw, 5)
    base.save(os.path.join(OUT_DIR, "slide_05.png"))
    print("Slide 05 generated.")

# ==============================================================
# SLIDE 06: WIREFRAME & ERGONOMIC ARCHITECTURE
# ==============================================================
def make_slide_06():
    base, draw = create_cosmic_base(center_orbit=(1400, 540))
    draw_slide_header(
        draw,
        slide_num=6,
        category_en="WIREFRAME | MOBILE UX & ERGONOMIC ARCHITECTURE",
        title_white="실제 앱 구조를 정밀 반영한 ",
        title_gold="스마트폰 와이어프레임과 인체공학적 설계",
        subtitle_kr="홈 대시보드·방사형 차트·궁합 매트릭스·시크릿 금고 핵심 화면의 골격 구조와 한 손 조작 반경(Thumb-Zone) 인체공학 설계"
    )
    
    sec_y = 234
    ph = 525
    pw = 280
    phones_x = [100, 560, 1020, 1480]
    
    wireframe_info = [
        ("01. 천문 대시보드", "gold", "홈 허브 & 실시간 일진 요약", [
            ("Dynamic Island", 28),
            ("일일 일진 카드", 80),
            ("오행 요약 미니 차트", 160),
            ("황금 시간대 위젯", 250),
            ("하단 네비게이션 독", 460),
        ]),
        ("02. 오행 방사형 차트", "cyan", "5원소 균형 시각화 화면", [
            ("Header & 절기 뱃지", 28),
            ("방사형 레이더 캔버스", 130),
            ("목화토금수 에너지 바", 270),
            ("과유불급 처방 가이드", 380),
            ("하단 인터랙션 버튼", 460),
        ]),
        ("03. 1:1 시너지 궁합", "purple", "다차원 관계 매칭 화면", [
            ("듀얼 아바타 싱크 헤더", 28),
            ("시너지 스코어 게이지", 120),
            ("상생상극 기운 분석표", 230),
            ("소통 황금 시간대 추천", 340),
            ("갈등 예방 처방전 열람", 440),
        ]),
        ("04. 시크릿 암호화 볼트", "green", "온디바이스 보안 금고 화면", [
            ("FaceID 잠금 상태 표시", 28),
            ("암호화 저장 프로필 목록", 120),
            ("AES-256 보안 등급 뱃지", 240),
            ("로컬 백업 & 데이터 파기", 350),
            ("비상 잠금 토글 버튼", 450),
        ]),
    ]
    
    for i, (title_text, theme_key, sub_text, elements) in enumerate(wireframe_info):
        px = phones_x[i]
        
        # Soft Drop Shadow
        sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        sh_draw = ImageDraw.Draw(sh)
        sh_draw.rounded_rectangle([px + 8, sec_y + 12, px + pw - 8, sec_y + ph + 16], radius=28, fill=(0, 0, 0, 120))
        sh = sh.filter(ImageFilter.GaussianBlur(16))
        base.paste(sh, (0, 0), sh)
        
        # Outer Chassis
        draw.rounded_rectangle([px, sec_y, px + pw, sec_y + ph], radius=26, fill=(13, 18, 31), outline=(40, 53, 78), width=2)
        # Dynamic Island Pill
        draw.rounded_rectangle([px + pw // 2 - 24, sec_y + 8, px + pw // 2 + 24, sec_y + 20], radius=6, fill=(7, 10, 18))
        # Title Badge
        draw_pill_badge(draw, cx=px + pw // 2, cy=sec_y + 36, text=title_text, font=get_font(9.5, 'bold'), theme=theme_key, has_dot=True, pad_x=8, height=20)
        
        # Inner Screen Wireframe Wire-blocks
        for el_name, el_y in elements:
            ey = sec_y + el_y
            if "Island" in el_name:
                continue
            elif "차트" in el_name or "캔버스" in el_name or "게이지" in el_name:
                draw.ellipse([px + pw // 2 - 45, ey, px + pw // 2 + 45, ey + 90], outline=(229, 192, 123) if theme_key == 'gold' else (0, 229, 255), width=1)
                draw.text((px + pw // 2, ey + 45), el_name, font=get_font(8.5, 'medium'), fill=(148, 163, 184), anchor='mm')
            elif "버튼" in el_name or "독" in el_name:
                draw.rounded_rectangle([px + 20, ey, px + pw - 20, ey + 36], radius=8, fill=(20, 28, 48), outline=(40, 53, 78), width=1)
                draw.text((px + pw // 2, ey + 18), el_name, font=get_font(8.5, 'bold'), fill=(203, 213, 225), anchor='mm')
            else:
                draw.rounded_rectangle([px + 16, ey, px + pw - 16, ey + 50], radius=6, fill=(18, 25, 42), outline=(30, 42, 65), width=1)
                draw.text((px + 24, ey + 18), el_name, font=get_font(9, 'bold'), fill=(226, 232, 240))
                draw.rounded_rectangle([px + 24, ey + 32, px + pw - 40, ey + 38], radius=3, fill=(25, 35, 55))

    # --------------------------------------------------------------
    # LOWER SECTION: ERGONOMIC THUMB-ZONE SPECIFICATION
    # --------------------------------------------------------------
    arch_y = 800
    draw.rounded_rectangle([100, arch_y, 1820, 940], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    
    draw_pill_badge(draw, left_x=124, cy=arch_y + 26, text="ERGONOMIC THUMB-ZONE ARCHITECTURE", font=get_font(10, 'bold'), theme='gold', has_dot=True, height=24, pad_x=10)
    draw.text((450, arch_y + 26), "6.7인치 대화면 모바일 환경에서의 한 손 조작성 극대화 설계 원칙", font=get_font(13.5, 'bold'), fill=(248, 250, 252), anchor='lm')
    draw.line([(124, arch_y + 50), (1796, arch_y + 50)], fill=(25, 35, 55), width=1)
    
    erg_cols = [
        ("01. Natural Reach Zone (자연스러운 조작 영역)", "하단 40% 영역에 핵심 인터랙션(오행 피커, 시너지 슬라이더, 금고 토글)을 집중 배치하여 그립 변경 없이 1-Tap 조작 보장", "gold"),
        ("02. Minimal Stretch Zone (가벼운 확장 영역)", "중단 35% 영역에 방사형 차트 및 바이오리듬 시각화 데이터를 배치하여 스크롤 및 핀치 줌 제스처에 최적화", "cyan"),
        ("03. Safe Viewing Zone (안전한 인지 영역)", "상단 25% 영역에 일진 뱃지 및 프로필 상태 표시 등 시각 정보만을 배치하여 한 손 조작 시 터치 피로도 원천 차단", "purple"),
    ]
    for ei, (etitle, edesc, etheme) in enumerate(erg_cols):
        ex = 124 + ei * 560
        draw_pill_badge(draw, left_x=ex, cy=arch_y + 74, text=f"PRINCIPLE {ei+1:02d}", font=get_font(9, 'bold'), theme=etheme, pad_x=6, height=20)
        draw.text((ex + 100, arch_y + 74), etitle.split(" (")[0], font=get_font(12, 'bold'), fill=(226, 232, 240), anchor='lm')
        draw.text((ex, arch_y + 98), edesc, font=get_font(11, 'regular'), fill=(148, 163, 184))
        
    draw_slide_footer(draw, 6)
    base.save(os.path.join(OUT_DIR, "slide_06.png"))
    print("Slide 06 generated.")

# ==============================================================
# SLIDE 07: DESIGN SYSTEM & VISUAL FOUNDATION
# ==============================================================
def make_slide_07():
    base, draw = create_cosmic_base(center_orbit=(1400, 540))
    draw_slide_header(
        draw,
        slide_num=7,
        category_en="DESIGN SYSTEM | BRAND IDENTITY & COMPONENT ARCHITECTURE",
        title_white="브랜드 일체감과 신뢰를 규정하는 ",
        title_gold="비주얼 아이덴티티 & 디자인 시스템",
        subtitle_kr="FortuneMatch 핵심 디자인 원칙, 8대 전용 벡터 아이코노그래피, 코스믹 럭셔리 컬러 토큰, 타이포그래피 스케일 및 파운데이션"
    )
    
    r1_y = 234
    r1_h = 340
    
    # CARD 01: CORE CONCEPTS (x=100, w=540)
    c1_x, c1_w = 100, 540
    draw.rounded_rectangle([c1_x, r1_y, c1_x + c1_w, r1_y + r1_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=c1_x + 24, cy=r1_y + 30, text="FOUNDATION 01", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=8, height=22)
    draw.text((c1_x + 150, r1_y + 30), "코스믹 럭셔리 디자인 원칙 (Core UX)", font=get_font(13, 'bold'), fill=(248, 250, 252), anchor='lm')
    draw.line([(c1_x + 24, r1_y + 52), (c1_x + c1_w - 24, r1_y + 52)], fill=(25, 35, 55), width=1)
    
    principles = [
        ("01. Cosmic Mysticism (천문학적 신비감)", "깊은 흑요석(Obsidian #070A12) 배경 위에 은은한 오로라 퍼플과 시안 발광 효과로 밤하늘의 경외감 조성", (138, 43, 226)),
        ("02. Mathematical Precision (데이터 정밀성)", "복잡한 명리학 용어를 5원소 방사형 레이더와 정량적 수치로 변환하여 맹신 대신 데이터 신뢰 제공", (0, 229, 255)),
        ("03. Zen Calmness (정제된 평온함)", "난잡한 광고와 미신적 팝업을 전면 배제하고, 여백과 골드 하이라이트로 프리미엄 웰니스 앱 감성 완성", (229, 192, 123)),
    ]
    for pi, (ptitle, pdesc, pcol) in enumerate(principles):
        py = r1_y + 70 + pi * 84
        draw.ellipse([c1_x + 24, py + 4, c1_x + 36, py + 16], fill=pcol)
        draw.text((c1_x + 46, py), ptitle, font=get_font(12.5, 'bold'), fill=(248, 250, 252))
        draw.text((c1_x + 46, py + 26), pdesc, font=get_font(11, 'regular'), fill=(148, 163, 184))

    # CARD 02: 8 CUSTOM VECTOR ICONS (x=665, w=540)
    c2_x, c2_w = 665, 540
    draw.rounded_rectangle([c2_x, r1_y, c2_x + c2_w, r1_y + r1_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=c2_x + 24, cy=r1_y + 30, text="FOUNDATION 02", font=get_font(9.5, 'bold'), theme='cyan', has_dot=True, pad_x=8, height=22)
    draw.text((c2_x + 150, r1_y + 30), "8대 맞춤형 벡터 아이코노그래피 (24dp)", font=get_font(13, 'bold'), fill=(248, 250, 252), anchor='lm')
    draw.line([(c2_x + 24, r1_y + 52), (c2_x + c2_w - 24, r1_y + 52)], fill=(25, 35, 55), width=1)
    
    icons_data = [
        ("천문 태양", "Sun / Solar", "gold"),
        ("달 / 월운", "Moon / Lunar", "cyan"),
        ("시너지 링", "Synastry Rings", "purple"),
        ("나침반", "Astral Compass", "green"),
        ("보안 금고", "Shield Vault", "gold"),
        ("오행 레이더", "Radar Elements", "cyan"),
        ("균형 천칭", "Balance Scales", "amber"),
        ("영원 인피니티", "Infinity Flow", "purple"),
    ]
    ic_start_y = r1_y + 70
    ic_w = (c2_w - 48 - 30) // 4
    ic_h = 110
    
    for idx, (iname, ien, itheme) in enumerate(icons_data):
        row = idx // 4
        col = idx % 4
        ix = c2_x + 24 + col * (ic_w + 10)
        iy = ic_start_y + row * (ic_h + 12)
        
        draw.rounded_rectangle([ix, iy, ix + ic_w, iy + ic_h], radius=10, fill=(18, 25, 42), outline=(34, 47, 77), width=1)
        ic_cx = ix + ic_w // 2
        ic_cy = iy + 36
        
        # Render clean vector glyph representation
        if idx == 0: # Sun
            draw.ellipse([ic_cx - 10, ic_cy - 10, ic_cx + 10, ic_cy + 10], outline=(255, 215, 0), width=2)
            draw.ellipse([ic_cx - 4, ic_cy - 4, ic_cx + 4, ic_cy + 4], fill=(255, 215, 0))
        elif idx == 1: # Moon
            draw.ellipse([ic_cx - 10, ic_cy - 10, ic_cx + 10, ic_cy + 10], fill=(0, 229, 255))
            draw.ellipse([ic_cx - 6, ic_cy - 12, ic_cx + 14, ic_cy + 8], fill=(18, 25, 42))
        elif idx == 2: # Rings
            draw.ellipse([ic_cx - 12, ic_cy - 8, ic_cx + 2, ic_cy + 6], outline=(168, 85, 247), width=2)
            draw.ellipse([ic_cx - 2, ic_cy - 4, ic_cx + 12, ic_cy + 10], outline=(229, 192, 123), width=2)
        elif idx == 3: # Compass
            draw.ellipse([ic_cx - 11, ic_cy - 11, ic_cx + 11, ic_cy + 11], outline=(16, 185, 129), width=2)
            draw.line([(ic_cx, ic_cy - 8), (ic_cx, ic_cy + 8)], fill=(16, 185, 129), width=2)
        elif idx == 4: # Shield
            draw.polygon([(ic_cx, ic_cy - 11), (ic_cx + 9, ic_cy - 5), (ic_cx + 9, ic_cy + 4), (ic_cx, ic_cy + 11), (ic_cx - 9, ic_cy + 4), (ic_cx - 9, ic_cy - 5)], outline=(255, 215, 0), width=2)
        elif idx == 5: # Radar
            draw.ellipse([ic_cx - 11, ic_cy - 11, ic_cx + 11, ic_cy + 11], outline=(0, 229, 255), width=1)
            draw.polygon([(ic_cx, ic_cy - 9), (ic_cx + 8, ic_cy + 6), (ic_cx - 8, ic_cy + 6)], outline=(0, 229, 255), width=2)
        elif idx == 6: # Scale
            draw.line([(ic_cx - 10, ic_cy - 4), (ic_cx + 10, ic_cy - 4)], fill=(245, 158, 11), width=2)
            draw.line([(ic_cx, ic_cy - 4), (ic_cx, ic_cy + 8)], fill=(245, 158, 11), width=2)
        else: # Infinity
            draw.ellipse([ic_cx - 11, ic_cy - 5, ic_cx - 1, ic_cy + 5], outline=(168, 85, 247), width=2)
            draw.ellipse([ic_cx + 1, ic_cy - 5, ic_cx + 11, ic_cy + 5], outline=(168, 85, 247), width=2)
            
        draw.text((ic_cx, iy + 68), iname, font=get_font(9.5, 'bold'), fill=(226, 232, 240), anchor='mm')
        draw.text((ic_cx, iy + 88), ien, font=get_font(8, 'regular'), fill=(148, 163, 184), anchor='mm')

    # CARD 03: COLOR PALETTE (x=1230, w=590)
    c3_x, c3_w = 1230, 590
    draw.rounded_rectangle([c3_x, r1_y, c3_x + c3_w, r1_y + r1_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=c3_x + 24, cy=r1_y + 30, text="FOUNDATION 03", font=get_font(9.5, 'bold'), theme='purple', has_dot=True, pad_x=8, height=22)
    draw.text((c3_x + 150, r1_y + 30), "코스믹 럭셔리 컬러 토큰 팔레트 (HEX)", font=get_font(13, 'bold'), fill=(248, 250, 252), anchor='lm')
    draw.line([(c3_x + 24, r1_y + 52), (c3_x + c3_w - 24, r1_y + 52)], fill=(25, 35, 55), width=1)
    
    swatches = [
        ("Obsidian Black", "#070A12", (7, 10, 18), "배경 베이스 / 흑요석", True),
        ("Imperial Gold", "#FFD700", (255, 215, 0), "핵심 액센트 / 하이라이트", False),
        ("Champagne Gold", "#E5C07B", (229, 192, 123), "보조 브랜드 / 타이틀", False),
        ("Electric Cyan", "#00E5FF", (0, 229, 255), "데이터 차트 / 바이오리듬", False),
        ("Aurora Violet", "#8A2BE2", (138, 43, 226), "궁합 시너지 / 오로라 글로우", False),
        ("Emerald Green", "#10B981", (16, 185, 129), "안전 검증 / 로컬 금고", False),
    ]
    sw_w = (c3_w - 48 - 20) // 3
    sw_h = 110
    for si, (sname, shex, scol, srole, is_dark) in enumerate(swatches):
        row = si // 3
        col = si % 3
        sx = c3_x + 24 + col * (sw_w + 10)
        sy = r1_y + 70 + row * (sw_h + 12)
        
        draw.rounded_rectangle([sx, sy, sx + sw_w, sy + sw_h], radius=10, fill=(18, 25, 42), outline=(34, 47, 77), width=1)
        draw.rounded_rectangle([sx + 8, sy + 8, sx + sw_w - 8, sy + 44], radius=6, fill=scol, outline=(255, 255, 255, 50) if is_dark else None, width=1)
        draw.text((sx + 10, sy + 58), sname, font=get_font(10, 'bold'), fill=(248, 250, 252))
        draw.text((sx + 10, sy + 76), shex, font=get_num_font(9.5, 'bold'), fill=(229, 192, 123))
        draw.text((sx + 10, sy + 92), srole, font=get_font(8.5, 'regular'), fill=(148, 163, 184))

    # --------------------------------------------------------------
    # ROW 2: TYPOGRAPHY SCALE TABLE & FOUNDATION RULES (y=598 to 940, h=342)
    # --------------------------------------------------------------
    r2_y = 598
    r2_h = 342
    
    # Left: Typography Scale Table (w=980)
    ty_w = 980
    draw.rounded_rectangle([100, r2_y, 100 + ty_w, r2_y + r2_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=124, cy=r2_y + 26, text="FOUNDATION 04", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=8, height=22)
    draw.text((250, r2_y + 26), "Pretendard 타이포그래피 스케일 & 위계 정의", font=get_font(13, 'bold'), fill=(248, 250, 252), anchor='lm')
    draw.line([(124, r2_y + 48), (100 + ty_w - 24, r2_y + 48)], fill=(25, 35, 55), width=1)
    
    # Table Header
    draw.text((124, r2_y + 64), "LEVEL / TOKEN", font=get_font(9.5, 'bold'), fill=(229, 192, 123))
    draw.text((280, r2_y + 64), "FONT WEIGHT", font=get_font(9.5, 'bold'), fill=(148, 163, 184))
    draw.text((420, r2_y + 64), "SIZE / LINE HEIGHT", font=get_font(9.5, 'bold'), fill=(148, 163, 184))
    draw.text((620, r2_y + 64), "SAMPLE PREVIEW & USAGE", font=get_font(9.5, 'bold'), fill=(148, 163, 184))
    
    ty_scales = [
        ("Display 36", "Pretendard Black", "36px / 46px", "천문 만세력 0.3s 실시간 연산", (255, 215, 0)),
        ("Headline 24", "Pretendard ExtraBold", "24px / 32px", "오행 밸런스 방사형 차트", (248, 250, 252)),
        ("Title 18", "Pretendard Bold", "18px / 26px", "1:1 다차원 시너지 궁합 매트릭스", (229, 192, 123)),
        ("Body 14", "Pretendard Medium", "14px / 22px", "출생지의 경도와 절기를 보정한 진태양시 적용", (203, 213, 225)),
        ("Caption 11", "Pretendard Regular", "11px / 16px", "100% 온디바이스 AES-256 로컬 암호화 볼트 보관", (148, 163, 184)),
    ]
    for ti, (tlevel, tweight, tsize, tsample, tcol) in enumerate(ty_scales):
        ty_row = r2_y + 90 + ti * 46
        bg_col = (18, 25, 42) if ti % 2 == 0 else (13, 18, 31)
        draw.rounded_rectangle([124, ty_row, 100 + ty_w - 24, ty_row + 40], radius=6, fill=bg_col)
        draw.text((136, ty_row + 20), tlevel, font=get_font(10.5, 'bold'), fill=(229, 192, 123), anchor='lm')
        draw.text((280, ty_row + 20), tweight, font=get_font(10, 'medium'), fill=(148, 163, 184), anchor='lm')
        draw.text((420, ty_row + 20), tsize, font=get_num_font(10, 'bold'), fill=(100, 116, 139), anchor='lm')
        draw.text((620, ty_row + 20), tsample, font=get_font(10.5, 'medium'), fill=tcol, anchor='lm')

    # Right: Foundation Token Rules (w=700)
    tok_x = 1120
    tok_w = 700
    draw.rounded_rectangle([tok_x, r2_y, tok_x + tok_w, r2_y + r2_h], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=tok_x + 24, cy=r2_y + 26, text="FOUNDATION 05", font=get_font(9.5, 'bold'), theme='cyan', has_dot=True, pad_x=8, height=22)
    draw.text((tok_x + 150, r2_y + 26), "코너 라운딩 & 스페이싱 토큰 규칙", font=get_font(13, 'bold'), fill=(248, 250, 252), anchor='lm')
    draw.line([(tok_x + 24, r2_y + 48), (tok_x + tok_w - 24, r2_y + 48)], fill=(25, 35, 55), width=1)
    
    token_rules = [
        ("Corner Radius Tokens", [
            ("radius.sm (8px)", "뱃지, 칩, 미니 버튼"),
            ("radius.md (14px)", "입력 폼, 리스트 아이템"),
            ("radius.lg (20px)", "메인 카드, 다이얼로그 모달"),
            ("radius.xl (32px)", "바텀시트 최상단 컨테이너"),
        ]),
        ("Spatial & Grid Rules", [
            ("8pt Base Grid", "모든 컴포넌트 마진 및 패딩 8pt 배수 엄격 준수"),
            ("Elevation Glow", "오로라 퍼플 / 골드 블러(Blur 24~40px) 깊이감 부여"),
            ("Thumb Target", "최소 터치 반경 44×44pt 보장으로 오작동 원천 차단"),
            ("Dark Contrast", "WCAG AAA 규격 7:1 이상의 초고대비 텍스트 가독성"),
        ]),
    ]
    for grp_i, (gname, ritems) in enumerate(token_rules):
        gy = r2_y + 64 + grp_i * 132
        draw.text((tok_x + 24, gy), gname, font=get_font(11.5, 'bold'), fill=(0, 229, 255))
        for ri, (rtitle, rdesc) in enumerate(ritems):
            ry = gy + 22 + ri * 25
            draw.text((tok_x + 24, ry), rtitle, font=get_font(9.5, 'bold'), fill=(229, 192, 123))
            draw.text((tok_x + 180, ry), rdesc, font=get_font(9.5, 'regular'), fill=(148, 163, 184))
            
    draw_slide_footer(draw, 7)
    base.save(os.path.join(OUT_DIR, "slide_07.png"))
    print("Slide 07 generated.")

# ==============================================================
# SLIDE 08: DEEP DIVE 1 - ASTRONOMICAL ENGINE & RADAR
# ==============================================================
def make_slide_08():
    base, draw = create_cosmic_base(center_orbit=(1400, 540))
    draw_slide_header(
        draw,
        slide_num=8,
        category_en="CORE FEATURE 01 | ASTRONOMICAL ENGINE & RADAR",
        title_white="난해한 한자 만세력을 5원소 방사형 차트로, ",
        title_gold="0.3s 천문 연산 엔진",
        subtitle_kr="절기와 진태양시를 정밀 보정하여 목화토금수 에너지 분포를 직관적인 5각 레이더로 시각화한 핵심 기능"
    )
    
    # Left Column: Detailed Feature Breakdown Cards
    lx = 100
    lw = 840
    
    cards_data = [
        ("01. 천문 만세력 및 진태양시 보정", "출생지 경도 오차(-32분) 정밀 보정", "gold", 
         "전통 만세력은 서울(동경 127.5도)과 도쿄(동경 135도)의 시차를 고려하지 않아 30분 안팎의 사주 시주(時柱) 왜곡이 발생했습니다. FortuneMatch는 출생지 GPS 경도와 지구 공전 궤도 균시차를 적용해 0.3초 만에 100% 정밀한 진태양시를 도출합니다."),
        ("02. 오행(목화토금수) 방사형 레이더 시각화", "과유불급 에너지 밸런스 실시간 렌더링", "cyan", 
         "복잡한 간지 한자 8글자 대신, 각 기운의 세력과 조화를 5각 방사형 레이더 그래프로 추상화했습니다. 어떤 기운이 부족하고 어떤 기운이 태과(太過)한지 즉각 인지하여 라이프스타일 밸런싱 솔루션을 도출합니다."),
        ("03. 1일 에너지 성쇠 곡선 동기화", "24시간 12시진(時辰) 바이오 에너지 추적", "purple", 
         "자시(子時)부터 해시(亥時)까지 2시간 단위로 변화하는 일일 기운 흐름을 실시간 곡선으로 추적하여, 중요한 미팅과 계약에 가장 적합한 골든타임을 사용자에게 선제적으로 브리핑합니다."),
    ]
    for ci, (ctitle, csub, ctheme, cdesc) in enumerate(cards_data):
        cy = 234 + ci * 240
        draw.rounded_rectangle([lx, cy, lx + lw, cy + 220], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
        draw_pill_badge(draw, left_x=lx + 24, cy=cy + 28, text=f"ENGINE SPEC {ci+1:02d}", font=get_font(9.5, 'bold'), theme=ctheme, pad_x=8, height=22)
        draw.text((lx + 154, cy + 28), ctitle, font=get_font(14, 'bold'), fill=(248, 250, 252), anchor='lm')
        draw.text((lx + 24, cy + 62), csub, font=get_font(12, 'bold'), fill=(229, 192, 123))
        draw.line([(lx + 24, cy + 82), (lx + lw - 24, cy + 82)], fill=(25, 35, 55), width=1)
        draw.text((lx + 24, cy + 96), cdesc, font=get_font(12, 'regular'), fill=(148, 163, 184), spacing=6)

    # Right Column: Phone Mockup
    m_path = os.path.join(MOCKUP_DIR, "iphone_02_radar.png")
    if os.path.exists(m_path):
        m_img = Image.open(m_path).convert('RGBA')
        ph = 720
        pw = int(round(ph * (m_img.width / m_img.height)))
        m_resized = m_img.resize((pw, ph), Image.Resampling.LANCZOS)
        
        sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        sh_draw = ImageDraw.Draw(sh)
        sh_draw.ellipse([1160, 840, 1160 + pw, 940], fill=(0, 0, 0, 160))
        sh = sh.filter(ImageFilter.GaussianBlur(36))
        base.paste(sh, (0, 0), sh)
        
        base.paste(m_resized, (1160, 220), m_resized)
        
    draw_slide_footer(draw, 8)
    base.save(os.path.join(OUT_DIR, "slide_08.png"))
    print("Slide 08 generated.")

# ==============================================================
# SLIDE 09: DEEP DIVE 2 - 1:1 SYNASTRY & ENCRYPTED VAULT
# ==============================================================
def make_slide_09():
    base, draw = create_cosmic_base(center_orbit=(1400, 540))
    draw_slide_header(
        draw,
        slide_num=9,
        category_en="CORE FEATURE 02 | 1:1 SYNASTRY & ENCRYPTED VAULT",
        title_white="상대방과의 오행 상호보완 분석과 ",
        title_gold="100% 로컬 암호화 시크릿 볼트",
        subtitle_kr="연인·동료 간의 다차원 시너지 매트릭스를 통한 갈등 예방과 서버 유출 없는 AES-256 온디바이스 보안 아키텍처"
    )
    
    lx = 100
    lw = 840
    
    cards_data = [
        ("01. 다차원 시너지 매트릭스 (Synastry)", "일간·지지·오행의 3중 조화도 연산", "purple", 
         "단순히 '85점' 식의 단편적 점수가 아닌, 나와 상대방의 일간(본질 기질), 월지(환경적 적응), 오행(에너지 보완)을 분리하여 상호보완 매트릭스로 분석합니다. 상대방의 화(火) 기운이 나의 수(水) 기운과 만나 어떻게 시너지를 내는지 명확히 설명합니다."),
        ("02. 소통 & 갈등 예방 대화법 처방전", "성향 차이로 인한 마찰을 사전 차단하는 UX", "cyan", 
         "두 사람의 성향 차이에서 필연적으로 발생하는 소통의 병목 지점을 미리 짚어내고, 상대방이 심리적 안정감을 느끼는 최적의 대화 방식과 피해야 할 금기어 가이드를 맞춤형으로 제시합니다."),
        ("03. 100% 온디바이스 AES-256 시크릿 볼트", "민감한 생년월일시 중앙 서버 무유출 보장", "green", 
         "기존 운세 앱들의 개인정보 유출 사고와 달리, FortuneMatch는 상대방 프로필과 운세 기록을 사용자의 기기 내부 안전 영역(Keystore / Keychain)에만 AES-256으로 암호화하여 저장하며 서버로 전송하지 않습니다."),
    ]
    for ci, (ctitle, csub, ctheme, cdesc) in enumerate(cards_data):
        cy = 234 + ci * 240
        draw.rounded_rectangle([lx, cy, lx + lw, cy + 220], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
        draw_pill_badge(draw, left_x=lx + 24, cy=cy + 28, text=f"SECURITY & SYNASTRY {ci+1:02d}", font=get_font(9.5, 'bold'), theme=ctheme, pad_x=8, height=22)
        draw.text((lx + 210, cy + 28), ctitle, font=get_font(14, 'bold'), fill=(248, 250, 252), anchor='lm')
        draw.text((lx + 24, cy + 62), csub, font=get_font(12, 'bold'), fill=(229, 192, 123))
        draw.line([(lx + 24, cy + 82), (lx + lw - 24, cy + 82)], fill=(25, 35, 55), width=1)
        draw.text((lx + 24, cy + 96), cdesc, font=get_font(12, 'regular'), fill=(148, 163, 184), spacing=6)

    m_path = os.path.join(MOCKUP_DIR, "iphone_05_match.png")
    if os.path.exists(m_path):
        m_img = Image.open(m_path).convert('RGBA')
        ph = 720
        pw = int(round(ph * (m_img.width / m_img.height)))
        m_resized = m_img.resize((pw, ph), Image.Resampling.LANCZOS)
        
        sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        sh_draw = ImageDraw.Draw(sh)
        sh_draw.ellipse([1160, 840, 1160 + pw, 940], fill=(0, 0, 0, 160))
        sh = sh.filter(ImageFilter.GaussianBlur(36))
        base.paste(sh, (0, 0), sh)
        
        base.paste(m_resized, (1160, 220), m_resized)
        
    draw_slide_footer(draw, 9)
    base.save(os.path.join(OUT_DIR, "slide_09.png"))
    print("Slide 09 generated.")

# ==============================================================
# SLIDE 10: HIGH-FIDELITY MOBILE LINEUP
# ==============================================================
def make_slide_10():
    base, draw = create_cosmic_base(center_orbit=(1400, 540))
    draw_slide_header(
        draw,
        slide_num=10,
        category_en="MOBILE SCREENS | PRODUCTION FIGMA & NATIVE PROTOTYPE",
        title_white="천문 진단부터 프라이빗 금고까지, ",
        title_gold="실제 구현된 6대 핵심 상용 화면",
        subtitle_kr="사용자의 핵심 사용자 여정(User Journey)을 빈틈없이 지원하도록 피그마 디자인 토큰과 60fps 인터랙티브 엔진으로 구현된 6대 상용 화면입니다."
    )
    
    screens = [
        ("iphone_01_hub.png", "01. 홈 대시보드", "실시간 일진 요약", "& 황금 시간대 위젯"),
        ("iphone_02_radar.png", "02. 오행 레이더 차트", "5원소 방사형 밸런스", "& 과유불급 처방"),
        ("iphone_03_tarot.png", "03. 타로 심층 리딩", "결정적 기로 솔루션", "& 3카드 스프레드"),
        ("iphone_04_connections.png", "04. 관계 프로필 관리", "등록 인연 성향 목록", "& 프라이빗 메모"),
        ("iphone_05_match.png", "05. 1:1 시너지 궁합", "다차원 상생상극", "& 갈등 예방 대화법"),
        ("iphone_07_vault.png", "06. 시크릿 금고 & 보안", "FaceID 생체 인증", "& 100% 로컬 암호화"),
    ]
    
    pw = 230
    phone_y = 240
    pgap = 54
    start_x = 100
    
    for i, (mfile, stitle, sline1, sline2) in enumerate(screens):
        px = start_x + i * (pw + pgap)
        mpath = os.path.join(MOCKUP_DIR, mfile)
        if os.path.exists(mpath):
            mimg = Image.open(mpath).convert('RGBA')
            ph = int(round(pw * (mimg.height / mimg.width)))
            m_res = mimg.resize((pw, ph), Image.Resampling.LANCZOS)
            
            # Drop shadow
            sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
            shd = ImageDraw.Draw(sh)
            shd.ellipse([px + 10, phone_y + ph - 20, px + pw - 10, phone_y + ph + 24], fill=(0, 0, 0, 140))
            sh = sh.filter(ImageFilter.GaussianBlur(16))
            base.paste(sh, (0, 0), sh)
            
            base.paste(m_res, (px, phone_y), m_res)
            
        # Screen Label
        by = phone_y + 510
        draw.text((px + pw // 2, by), stitle, font=get_font(12, 'bold'), fill=(229, 192, 123), anchor='mm')
        draw.text((px + pw // 2, by + 22), sline1, font=get_font(10.5, 'medium'), fill=(203, 213, 225), anchor='mm')
        draw.text((px + pw // 2, by + 40), sline2, font=get_font(10, 'regular'), fill=(148, 163, 184), anchor='mm')
        
    draw_slide_footer(draw, 10)
    base.save(os.path.join(OUT_DIR, "slide_10.png"))
    print("Slide 10 generated.")

# ==============================================================
# SLIDE 11: BUSINESS IMPACT & STAR RETROSPECTIVE
# ==============================================================
def make_slide_11():
    base, draw = create_cosmic_base(center_orbit=(1400, 540))
    draw_slide_header(
        draw,
        slide_num=11,
        category_en="BUSINESS IMPACT | QUANTITATIVE TELEMETRY & STRATEGIC RETROSPECTIVE",
        title_white="온보딩 완료율 88.4%와 일일 리텐션 2.3배 향상, ",
        title_gold="수치로 검증된 UX 가치",
        subtitle_kr="기존 운세 앱의 텍스트 피로도를 해소한 Before/After 성과 지표와 4대 핵심 텔레메트리, 그리고 시니어급 STAR 프로젝트 회고",
        right_badge=("EMPIRICAL TEST 100% PASS", "green")
    )
    
    # --------------------------------------------------------------
    # TOP DUAL COMPARISON: BEFORE vs AFTER (y=234 to 534, h=300)
    # --------------------------------------------------------------
    card_y = 234
    card_h = 300
    card_w = 840
    
    # Before Card (Left)
    cx1 = 100
    draw.rounded_rectangle([cx1, card_y, cx1 + card_w, card_y + card_h], radius=16, fill=(13, 18, 31), outline=(48, 16, 24), width=1)
    draw.rounded_rectangle([cx1, card_y + 14, cx1 + 5, card_y + card_h - 14], radius=3, fill=(239, 68, 68))
    draw_pill_badge(draw, left_x=cx1 + 24, cy=card_y + 24, text="BEFORE : TRADITIONAL FORTUNE APP", font=get_font(9.5, 'bold'), theme='red', has_dot=True, pad_x=10, height=22)
    draw.text((cx1 + 24, card_y + 54), "난해한 한자 텍스트와 과도한 전면 광고", font=get_font(16.5, 'bold'), fill=(248, 250, 252))
    draw.text((cx1 + 24, card_y + 82), "읽히지 않는 고문서식 서술, 무분별한 결제 유도 팝업과 서버 유출 불안으로 높은 이탈 유발", font=get_font(11.5, 'regular'), fill=(148, 163, 184))
    
    b_rows = [
        ("온보딩 이탈률", "58.8% (복잡한 간지 입력과 광고 팝업으로 조기 이탈)", (239, 68, 68)),
        ("텍스트 스킵률", "74.2% (방대한 한자 해석을 읽지 않고 건너뜀)", (239, 68, 68)),
        ("궁합 신뢰도", "28.0% (단순 점수제 조언에 대한 회의적 반응)", (245, 158, 11)),
        ("개인정보 보안", "평문 서버 저장 및 유출 위험성 상존 (보안 불안 68.4%)", (239, 68, 68)),
    ]
    for bi, (bk, bv, bc) in enumerate(b_rows):
        by = card_y + 116 + bi * 42
        draw.text((cx1 + 24, by), bk, font=get_font(11, 'bold'), fill=(229, 192, 123))
        draw.text((cx1 + 140, by), bv, font=get_font(11, 'regular'), fill=bc)

    # After Card (Right)
    cx2 = cx1 + card_w + 40
    draw.rounded_rectangle([cx2, card_y, cx2 + card_w, card_y + card_h], radius=16, fill=(13, 18, 31), outline=(12, 42, 30), width=1)
    draw.rounded_rectangle([cx2, card_y + 14, cx2 + 5, card_y + card_h - 14], radius=3, fill=(16, 185, 129))
    draw_pill_badge(draw, left_x=cx2 + 24, cy=card_y + 24, text="AFTER : FORTUNEMATCH (FTMT UX)", font=get_font(9.5, 'bold'), theme='green', has_dot=True, pad_x=10, height=22)
    draw.text((cx2 + 24, card_y + 54), "0.3s 방사형 시각화 & 100% 온디바이스 볼트", font=get_font(16.5, 'bold'), fill=(248, 250, 252))
    draw.text((cx2 + 24, card_y + 82), "오행 레이더 차트로 한눈에 파악하는 기운 밸런스, 광고 없는 젠 레이아웃 및 완벽한 프라이버시", font=get_font(11.5, 'regular'), fill=(148, 163, 184))
    
    a_rows = [
        ("온보딩 완료율", "88.4% 달성 (+47.2%p 획기적 전환율 개선)", (16, 185, 129)),
        ("인지 부하 경감", "78% 인지 부하 감소 (직관적 방사형 차트로 즉각 이해)", (0, 229, 255)),
        ("일일 리텐션(D7)", "42.6% 달성 (바이오리듬 루틴 연동으로 2.3배 향상)", (255, 215, 0)),
        ("보안 무유출", "100% 로컬 AES-256 암호화 격리 (서버 유출 위험 0건)", (16, 185, 129)),
    ]
    for ai, (ak, av, ac) in enumerate(a_rows):
        ay = card_y + 116 + ai * 42
        draw.text((cx2 + 24, ay), ak, font=get_font(11, 'bold'), fill=(229, 192, 123))
        draw.text((cx2 + 150, ay), av, font=get_font(11, 'bold'), fill=ac)

    # --------------------------------------------------------------
    # MIDDLE: 4 QUANTITATIVE TELEMETRY METRIC CARDS (y=558 to 698, h=140)
    # --------------------------------------------------------------
    my = 558
    mw = (1720 - 60) // 4
    metrics = [
        ("88.4%", "온보딩 전환율", "+47.2%p", "green", "직관적 피커와 간소화된 단계"),
        ("42.6%", "일일 리텐션 (D7)", "2.3배 향상", "gold", "바이오리듬 및 골든타임 알림"),
        ("78%", "인지 부하 감소", "스킵률 12%", "cyan", "방사형 오행 차트 시각화"),
        ("100%", "로컬 프라이버시", "서버 0건 전송", "purple", "AES-256 온디바이스 볼트"),
    ]
    for idx, (mval, mlabel, mtag, mtheme, msub) in enumerate(metrics):
        mx = 100 + idx * (mw + 20)
        draw.rounded_rectangle([mx, my, mx + mw, my + 140], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
        draw.text((mx + 20, my + 24), mval, font=get_num_font(34, 'black'), fill=(255, 215, 0) if mtheme == 'gold' else ((0, 229, 255) if mtheme == 'cyan' else ((16, 185, 129) if mtheme == 'green' else (216, 180, 254))))
        draw_pill_badge(draw, cx=mx + mw - 54, cy=my + 36, text=mtag, font=get_font(8.5, 'bold'), theme=mtheme, solid=True, height=20, pad_x=6)
        draw.text((mx + 20, my + 78), mlabel, font=get_font(13, 'bold'), fill=(248, 250, 252))
        draw.text((mx + 20, my + 104), msub, font=get_font(10.5, 'regular'), fill=(148, 163, 184))

    # --------------------------------------------------------------
    # BOTTOM: STAR RETROSPECTIVE TABLE (y=722 to 948, h=226)
    # --------------------------------------------------------------
    star_y = 722
    draw.rounded_rectangle([100, star_y, 1820, star_y + 226], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=124, cy=star_y + 24, text="SENIOR UX RETROSPECTIVE (STAR)", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=8, height=22)
    draw.text((360, star_y + 24), "명리학 데이터 추상화와 프라이빗 UX 혁신을 통한 프로덕트 엔지니어링 회고", font=get_font(13, 'bold'), fill=(248, 250, 252), anchor='lm')
    draw.line([(124, star_y + 46), (1796, star_y + 46)], fill=(25, 35, 55), width=1)
    
    star_items = [
        ("Situation (상황)", "전통 운세 앱들은 난해한 한자 텍스트와 무분별한 전면 광고로 인해 2030 MZ세대의 스킵률이 74%에 달했고, 민감한 개인정보(생년월일시)가 중앙 서버에 평문 저장되는 심각한 프라이버시 불안이 상존했습니다."),
        ("Task (과제)", "난해한 명리학 간지 체계를 시각적 데이터(방사형 차트)로 100% 추상화하고, 1:1 관계 시너지와 일일 바이오리듬을 결합하며, 서버 유출 없는 온디바이스 암호화 금고를 설계하여 신뢰할 수 있는 모바일 UX를 완성해야 했습니다."),
        ("Action (실행)", "출생지 경도 기준 0.3s 진태양시 보정 알고리즘을 도입하고 오행의 과유불급을 5각 레이더로 시각화했습니다. 다차원 궁합 매트릭스를 개발해 성향 차이에 따른 소통 가이드를 제공하고, 생체 인증 연동 AES-256 로컬 볼트를 구축했습니다."),
        ("Result (결과)", "정량 테스트 결과 온보딩 완료율 88.4%(+47.2%p 증가), 인지 부하 78% 경감, 7일 리텐션 42.6%(2.3배 향상)를 달성했으며, 개인정보 무유출 100%를 기록하여 감성과 과학이 결합된 독보적인 운세 UX 표준을 확립했습니다."),
    ]
    for si, (stitle, sdesc) in enumerate(star_items):
        s_row_y = star_y + 60 + si * 40
        draw.text((124, s_row_y), stitle, font=get_font(11, 'bold'), fill=(229, 192, 123))
        draw.text((260, s_row_y), sdesc, font=get_font(11, 'regular'), fill=(203, 213, 225))
        
    draw_slide_footer(draw, 11)
    base.save(os.path.join(OUT_DIR, "slide_11.png"))
    print("Slide 11 generated.")

# ==============================================================
# SLIDE 12: INTERACTIVE PROTOTYPE HUB
# ==============================================================
def make_slide_12():
    base, draw = create_cosmic_base(center_orbit=(1400, 540))
    draw_slide_header(
        draw,
        slide_num=12,
        category_en="LIVE INTERACTIVE PROTOTYPE | 60FPS FIGMA ENGINE",
        title_white="화면을 터치하듯, ",
        title_gold="실제 인터랙티브 프로토타입을 직접 조작해 보세요",
        subtitle_kr="정적인 슬라이드를 넘어 스마트폰 뷰포트에서 4대 핵심 사용자 여정을 직접 터치하고 검증할 수 있는 인터랙티브 허브입니다.",
        right_badge=("LIVE ENGINE READY", "green")
    )
    
    # --------------------------------------------------------------
    # LEFT: DUAL MOCKUP SHOWCASE (x=100 to 760, w=660)
    # --------------------------------------------------------------
    p1_path = os.path.join(MOCKUP_DIR, "iphone_01_hub.png")
    p2_path = os.path.join(MOCKUP_DIR, "iphone_05_match.png")
    
    if os.path.exists(p1_path) and os.path.exists(p2_path):
        im1 = Image.open(p1_path).convert('RGBA')
        ph1 = 600
        pw1 = int(round(ph1 * (im1.width / im1.height)))
        im1_res = im1.resize((pw1, ph1), Image.Resampling.LANCZOS)
        
        im2 = Image.open(p2_path).convert('RGBA')
        ph2 = 640
        pw2 = int(round(ph2 * (im2.width / im2.height)))
        im2_res = im2.resize((pw2, ph2), Image.Resampling.LANCZOS)
        
        # Shadow for back phone
        sh1 = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        sh1_d = ImageDraw.Draw(sh1)
        sh1_d.ellipse([140, 780, 140 + pw1, 880], fill=(0, 0, 0, 140))
        sh1 = sh1.filter(ImageFilter.GaussianBlur(30))
        base.paste(sh1, (0, 0), sh1)
        base.paste(im1_res, (140, 260), im1_res)
        
        # Shadow for front phone
        sh2 = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        sh2_d = ImageDraw.Draw(sh2)
        sh2_d.ellipse([340, 820, 340 + pw2, 920], fill=(0, 0, 0, 160))
        sh2 = sh2.filter(ImageFilter.GaussianBlur(34))
        base.paste(sh2, (0, 0), sh2)
        base.paste(im2_res, (340, 240), im2_res)

    # --------------------------------------------------------------
    # RIGHT: 4 INTERACTIVE STEPS & ELEVATED CTA CARD (x=840 to 1820, w=980)
    # --------------------------------------------------------------
    rx = 840
    rw = 980
    
    draw.rounded_rectangle([rx, 234, rx + rw, 594], radius=16, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw_pill_badge(draw, left_x=rx + 24, cy=260, text="INTERACTIVE EXPERIENCE GUIDE", font=get_font(10, 'bold'), theme='gold', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 290, 260), "프로토타입에서 직접 검증 가능한 4대 핵심 여정", font=get_font(14, 'bold'), fill=(248, 250, 252), anchor='lm')
    draw.line([(rx + 24, 284), (rx + rw - 24, 284)], fill=(25, 35, 55), width=1)
    
    steps = [
        ("STEP 01", "생년월일시 입력 & 진태양시 자동 보정", "온보딩 피커를 통해 음/양력 및 출생시간 입력 시 0.3s 만에 태양시 균시차가 보정되는 인터랙션 체험", "gold"),
        ("STEP 02", "방사형 오행 레이더 차트 실시간 인터랙션", "목화토금수 에너지 분포를 터치하여 각 기운의 성쇠와 라이프스타일 처방 툴팁 확인", "cyan"),
        ("STEP 03", "1:1 다차원 시너지 궁합 매칭 및 대화법 처방", "상대방과의 상생상극 보완도 슬라이더를 탐색하고 갈등 예방을 위한 소통 골든타임 도출", "purple"),
        ("STEP 04", "FaceID 생체 인증 시크릿 볼트 락/언락", "암호화된 프라이빗 금고를 생체 인증으로 잠금 해제하고 100% 로컬 데이터 관리 프로세스 확인", "green"),
    ]
    for si, (scode, stitle, sdesc, stheme) in enumerate(steps):
        sy = 302 + si * 70
        draw_pill_badge(draw, left_x=rx + 24, cy=sy + 14, text=scode, font=get_font(9, 'bold'), theme=stheme, solid=True, pad_x=6, height=20)
        draw.text((rx + 110, sy + 14), stitle, font=get_font(12.5, 'bold'), fill=(248, 250, 252), anchor='lm')
        draw.text((rx + 110, sy + 38), sdesc, font=get_font(11, 'regular'), fill=(148, 163, 184))

    # Elevated CTA Card
    cta_y = 618
    draw.rounded_rectangle([rx, cta_y, rx + rw, cta_y + 322], radius=16, fill=(18, 25, 42), outline=(229, 192, 123), width=2)
    draw_pill_badge(draw, left_x=rx + 24, cy=cta_y + 30, text="LAUNCH LIVE PROTOTYPE", font=get_font(10, 'bold'), theme='gold', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 24, cta_y + 74), "실제 모바일 뷰포트에서 즉시 실행하기", font=get_font(20, 'bold'), fill=(255, 215, 0))
    
    cta_text = (
        "웹 브라우저 및 모바일 기기에서 바로 반응형으로 구동되는 60fps 프로토타입입니다.\n"
        "상단 상태 표시줄의 실시간 시계, 다이나믹 아일랜드, 햅틱 인터랙션을 온전히 체감하실 수 있습니다.\n"
        "아래 QR 코드를 스캔하거나 프로토타입 바로가기 링크를 클릭하세요."
    )
    draw.text((rx + 24, cta_y + 112), cta_text, font=get_font(12, 'regular'), fill=(203, 213, 225), spacing=6)
    
    # Direct Links
    draw.rounded_rectangle([rx + 24, cta_y + 196, rx + rw - 220, cta_y + 244], radius=8, fill=(13, 18, 31), outline=(34, 47, 77), width=1)
    draw.text((rx + 38, cta_y + 220), "URL : https://koyotejw-ux.github.io/ftmt/portfolio/prototype.html", font=get_font(11.5, 'bold'), fill=(0, 229, 255), anchor='lm')
    
    draw.rounded_rectangle([rx + 24, cta_y + 256, rx + rw - 220, cta_y + 300], radius=8, fill=(229, 192, 123))
    draw.text((rx + (rw - 220) // 2 + 12, cta_y + 278), "인터랙티브 프로토타입 체험하기 (Launch Prototype) →", font=get_font(12.5, 'bold'), fill=(15, 23, 42), anchor='mm')
    
    # QR Code Generation
    qr_url = "https://koyotejw-ux.github.io/ftmt/portfolio/prototype.html"
    qr = qrcode.QRCode(box_size=4, border=2)
    qr.add_data(qr_url)
    qr.make(fit=True)
    qr_img = qr.make_image(fill_color="black", back_color="white").convert('RGBA')
    qr_img = qr_img.resize((150, 150), Image.Resampling.LANCZOS)
    
    qr_box_x = rx + rw - 180
    qr_box_y = cta_y + 110
    draw.rounded_rectangle([qr_box_x - 10, qr_box_y - 10, qr_box_x + 160, qr_box_y + 190], radius=12, fill=(255, 255, 255))
    base.paste(qr_img, (qr_box_x, qr_box_y), qr_img)
    draw.text((qr_box_x + 75, qr_box_y + 165), "모바일 카메라 스캔", font=get_font(10, 'bold'), fill=(15, 23, 42), anchor='mm')
    
    draw_slide_footer(draw, 12)
    base.save(os.path.join(OUT_DIR, "slide_12.png"))
    print("Slide 12 generated.")

# ==============================================================
# MAIN EXECUTION
# ==============================================================
def main():
    print("Starting generation of all 12 FTMT Behance Portfolio Slides...")
    make_slide_01()
    make_slide_02()
    make_slide_03()
    make_slide_04()
    make_slide_05()
    make_slide_06()
    make_slide_07()
    make_slide_08()
    make_slide_09()
    make_slide_10()
    make_slide_11()
    make_slide_12()
    print("All 12 FTMT slides successfully generated!")

if __name__ == '__main__':
    main()

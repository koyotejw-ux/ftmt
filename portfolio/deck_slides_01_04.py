import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter
from build_executive_ftmt_deck import (
    W, H, MOCKUP_DIR, get_font, get_num_font, wrap_text_by_words,
    draw_diamond, draw_arrow, draw_dashed_line, draw_dashed_arrow,
    draw_pill_badge, draw_donut_chart_on_base, draw_behavior_slider,
    create_cosmic_base, draw_slide_header, draw_slide_footer, save_slide,
    C_TITLE_WHITE, C_GOLD_HERO, C_GOLD_MUTED, C_TEXT_BODY, C_TEXT_MUTED,
    C_CYAN_ACCENT, C_PURPLE_ACC, C_GREEN_ACC, C_RED_ACC, C_BORDER_GOLD
)

# ==============================================================
# SLIDE 01: HERO COVER (Matching Smart DCA Slide 01 Layout & Typography)
# ==============================================================
def make_slide_01():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    # Hairline Top Boundary
    draw.line([(100, 52), (1820, 52)], fill=(229, 192, 123, 40), width=1)
    
    # Top Kicker & Metadata
    draw_pill_badge(draw, left_x=100, cy=76, text="COSMIC ASTRO LAB · 2026 CASE STUDY", font=get_font(11.5, 'bold'), theme='gold', has_dot=True, pad_x=12, height=28)
    
    meta_txt = "서비스 기획 · UI/UX 디자인 · Android Live · Cosmic Design System"
    w_meta = draw.textlength(meta_txt, font=get_font(13.5, 'medium'))
    draw.text((1820 - w_meta, 68), meta_txt, font=get_font(13.5, 'medium'), fill=C_TEXT_BODY)
    
    # Category Label
    draw.text((100, 146), "FORTUNEMATCH · UX/UI CASE STUDY", font=get_font(14, 'bold'), fill=C_GOLD_HERO)
    
    # Big Clean Headline (56pt Black)
    title_p1 = "우주의 주파수를 잇다, "
    title_p2 = "운명의 인연을 찾다."
    w_p1 = draw.textlength(title_p1, font=get_font(56, 'black'))
    draw.text((100, 178), title_p1, font=get_font(56, 'black'), fill=C_TITLE_WHITE)
    draw.text((100 + w_p1, 178), title_p2, font=get_font(56, 'black'), fill=C_GOLD_HERO)
    
        # Clean UX Subtitle (2 balanced lines)
    sub1 = "낡은 한자와 미신적 이미지를 걷어내고 현대적인 인터랙션으로 재해석한 사주 솔루션,"
    sub2 = "우주 좌표 메타포와 5각형 오행 시각화로 관계의 본질을 푸는 감성 프로덕트 UX 설계"
    draw.text((100, 260), sub1, font=get_font(16.5, 'medium'), fill=C_TEXT_BODY)
    draw.text((100, 288), sub2, font=get_font(16.5, 'semibold'), fill=C_GOLD_MUTED)
    
    # OPEN STORYLINE: Key Strengths (Open layout with zero enclosing boxes as requested)
    strengths = [
        ("01", "비주얼 메타포", "우주 좌표 메타포 전환", "Cosmic Data Metaphor",
         "난해한 한자와 미신적 그래픽을 배제하고 생년월일시 4주 8글자를 현대적인 우주 좌표와 고유 주파수로 시각화하여 진입 장벽을 해소했습니다."),
        ("02", "오행 데이터 시각화", "5각형 실시간 레이더 차트", "5-Elements Interactive Radar",
         "목·화·토·금·수 에너지 밸런스를 5각형 실시간 레이더 차트로 직관화하여 텍스트 의존도를 낮추고 정보 인지 속도를 대폭 개선했습니다."),
        ("03", "관계 케미스트리", "감성 관계 시너지 설계", "Relationship Chemistry Flow",
         "단순 길흉화복 점괘가 아닌 두 사람의 상생상극 알고리즘을 감성적인 조화도 점수와 대화형 관계 가이드로 전환한 인터랙티브 UX를 구축했습니다."),
        ("04", "마이크로 인터랙션", "오감 만족 데일리 리추얼", "Tactile Micro-Interactions",
         "물리 엔진 기반의 3D 타로 셔플과 기분 좋은 햅틱 진동 피드백을 결합하여 매일 부담 없이 즐길 수 있는 심리적 안정감의 리추얼을 완성했습니다.")
    ]
    
    # Calculate maximum badge width to ensure unified title alignment with clean margin
    max_badge_w = max(draw.textlength(tag, font=get_font(10, 'bold')) + 16 for _, tag, _, _, _ in strengths)
    title_x = int(round(144 + max_badge_w + 24)) # 24px clean margin after the longest badge
    
    k_y = 358
    for idx, (num, tag, title_ko, sub_en, desc) in enumerate(strengths):
        # Open number pill
        draw.rounded_rectangle([100, k_y + 2, 136, k_y + 28], radius=6, fill=(24, 32, 54, 255), outline=(229, 192, 123, 70), width=1)
        draw.text((118, k_y + 15), num, font=get_font(11, 'bold'), fill=C_GOLD_HERO, anchor='mm')
        
        # Tag & Title & EN Subtitle
        draw_pill_badge(draw, left_x=144, cy=k_y + 15, text=tag, font=get_font(10, 'bold'), theme='gold', has_dot=False, pad_x=8, height=22)
        
        draw.text((title_x, k_y + 4), title_ko, font=get_font(15.5, 'bold'), fill=C_TITLE_WHITE)
        
        w_title = draw.textlength(title_ko, font=get_font(15.5, 'bold'))
        draw.text((title_x + w_title + 12, k_y + 6), f"·  {sub_en}", font=get_font(12, 'medium'), fill=(148, 163, 184))
        
        # 2-line description with comfortable width (up to 780px)
        words = desc.split(' ')
        lines = []
        cur_l = ""
        for w in words:
            test = (cur_l + ' ' + w).strip()
            if draw.textlength(test, font=get_font(12, 'regular')) <= 780:
                cur_l = test
            else:
                lines.append(cur_l)
                cur_l = w
        if cur_l:
            lines.append(cur_l)
            
        desc_y = k_y + 36
        for l in lines[:2]:
            draw.text((144, desc_y), l, font=get_font(12, 'regular'), fill=C_TEXT_BODY)
            desc_y += 20
            
        # Subtle hairline divider between items
        if idx < 3:
            draw.line([(100, k_y + 92), (900, k_y + 92)], fill=(229, 192, 123, 30), width=1)
            
        k_y += 114
        
    # Right Side: Dual Smartphone Mockups (Sleek Flagship Positioning)
    phone_hub_path = f"{MOCKUP_DIR}/iphone_01_hub.png"
    phone_match_path = f"{MOCKUP_DIR}/iphone_05_match.png"
    
    if os.path.exists(phone_hub_path) and os.path.exists(phone_match_path):
        phone_hub = Image.open(phone_hub_path).convert('RGBA')
        phone_match = Image.open(phone_match_path).convert('RGBA')
        
        target_h = 670
        target_w = int(round(target_h * (phone_hub.width / phone_hub.height)))
        p_front = phone_hub.resize((target_w, target_h), Image.Resampling.LANCZOS)
        p_back = phone_match.resize((target_w, target_h), Image.Resampling.LANCZOS)
        
        angle = -11.0
        rot_front = p_front.rotate(angle, expand=True, resample=Image.Resampling.BICUBIC)
        rot_back = p_back.rotate(angle, expand=True, resample=Image.Resampling.BICUBIC)
        
        def make_shadow(img, blur=46, offset=(22, 42), alpha=85):
            mask = img.split()[3]
            sh_img = Image.new('RGBA', (img.width + 120, img.height + 120), (0, 0, 0, 0))
            black = Image.new('RGBA', img.size, (0, 0, 0, alpha))
            sh_img.paste(black, (60 + offset[0], 60 + offset[1]), mask)
            return sh_img.filter(ImageFilter.GaussianBlur(blur)), (60, 60)
            
        sh_back, pad_b = make_shadow(rot_back, blur=40, offset=(18, 34), alpha=70)
        sh_front, pad_f = make_shadow(rot_front, blur=48, offset=(24, 44), alpha=90)
        
        p_back_x, p_back_y = 1270, 115
        p_front_x, p_front_y = 970, 170
        
        base.paste(sh_back, (p_back_x - pad_b[0], p_back_y - pad_b[1]), sh_back)
        base.paste(rot_back, (p_back_x, p_back_y), rot_back)
        
        base.paste(sh_front, (p_front_x - pad_f[0], p_front_y - pad_f[1]), sh_front)
        base.paste(rot_front, (p_front_x, p_front_y), rot_front)
        
        draw = ImageDraw.Draw(base)
        draw_pill_badge(draw, left_x=1340, cy=94, text="SCREEN 02 · 오행 레이더 & 케미스트리", font=get_font(10, 'bold'), theme='gold', has_dot=True, pad_x=10, height=22, solid=True)
        draw_pill_badge(draw, left_x=1040, cy=148, text="SCREEN 01 · 감성 온보딩 & 우주 좌표 허브", font=get_font(10, 'bold'), theme='cyan', has_dot=True, pad_x=10, height=22, solid=True)
        
    # Bottom 4-Column Specification Strip (Spanning x=100 to 1820, y=840 to 956)
    bar_y = 840
    bar_h = 116
    draw.rounded_rectangle([100, bar_y, 1820, bar_y + bar_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 80), width=1)
    
    col_w = 1720 // 4
    specs = [
        ("PROJECT ROLE", "서비스 기획 100% · UI/UX 디자인 100%", "페르소나 리서치 · 문제 정의 · IA 정보 설계 · 와이어프레임 · UI 디자인 총괄"),
        ("PERIOD & TIMELINE", "2026.06 - 2026.10 (5개월 완결)", "사용자 인터뷰 -> 오행 UX 인터랙션 설계 -> 디자인 시스템 구축 -> 실기기 검증"),
        ("DESIGN SYSTEM", "Cosmic Luxury 토큰 · 컴포넌트 규격", "R8/R12/R16 라운딩 체계 · 8pt 베이스라인 · 다크 옵시디언 감성 테마 구축"),
        ("DELIVERY & RELEASE", "Google Play 비공개 테스트 & 프로토타입", "Android 실기기 인터랙션 검증 완료 · Web 60fps 인터랙티브 시뮬레이터 완성")
    ]
    
    for i, (cat, val_bold, val_desc) in enumerate(specs):
        cx = 100 + i * col_w
        if i > 0:
            draw.line([(cx, bar_y + 18), (cx, bar_y + bar_h - 18)], fill=(229, 192, 123, 50), width=1)
        draw.text((cx + 28, bar_y + 18), cat, font=get_font(11, 'bold'), fill=C_GOLD_HERO)
        draw.text((cx + 28, bar_y + 42), val_bold, font=get_font(14.5, 'bold'), fill=C_TITLE_WHITE)
        draw.text((cx + 28, bar_y + 70), val_desc, font=get_font(11, 'medium'), fill=C_TEXT_BODY)
        
    draw_slide_footer(draw, 1)
    save_slide(base, 1)
def make_slide_02():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=2,
        category_en="USER RESEARCH | DESK RESEARCH & MARKET STUDY",
        title_white="낡은 한자와 미신을 걷어낸 ",
        title_gold="새로운 시장 기회",
        subtitle_kr="AI 기반 시장 데이터 마이닝과 2030 타깃 N=520 불만 패턴 분석을 통해 도출한 3대 혁신 전략"
    )
    
    card_w = 546
    card_h = 224
    gap = 40
    sy = 234
    
    # CARD 1: MARKET TREND (Large Donut Chart - 74.2%)
    c1_x = 100
    draw.rounded_rectangle([c1_x, sy, c1_x + card_w, sy + card_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    
    draw_pill_badge(draw, left_x=c1_x + 24, cy=sy + 26, text="UX FRICTION TREND", font=get_font(10, 'bold'), theme='red', has_dot=False, pad_x=8, height=22)
    draw.text((c1_x + 24, sy + 58), "한자 나열과 텍스트 인지 부하", font=get_font(16.5, 'bold'), fill=C_TITLE_WHITE)
    draw.text((c1_x + 24, sy + 88), "사용자 10명 중 7명 이상이 난해한 고전 한자 설명에 지쳐\n핵심 관계 요약을 파악하지 못하고 첫 화면에서 이탈합니다.", font=get_font(11.5, 'medium'), fill=C_TEXT_BODY, spacing=4)
    draw.text((c1_x + 24, sy + 144), "74.2%", font=get_num_font(38, 'black'), fill=(239, 68, 68))
    draw.text((c1_x + 24, sy + 188), "UI 텍스트 이탈률 (AI 패턴 분석 2030 N=520)", font=get_font(11, 'bold'), fill=C_TEXT_MUTED)
    
    cx_donut = c1_x + card_w - 95
    cy_donut = sy + 116
    draw_donut_chart_on_base(base, cx_donut, cy_donut, r_outer=56, r_inner=38, percentage=74.2, col_fill=(239, 68, 68), col_track=(38, 20, 28))
    draw = ImageDraw.Draw(base)
    draw_pill_badge(draw, cx=cx_donut, cy=sy + 32, text="AI 마이닝 N=520", font=get_font(9, 'bold'), theme='red', has_dot=False, pad_x=8, height=20)
    
    draw.text((cx_donut, cy_donut - 6), "74%", font=get_num_font(18, 'black'), fill=(239, 68, 68), anchor='mm')
    draw.text((cx_donut, cy_donut + 14), "이탈률", font=get_font(9.5, 'bold'), fill=C_TEXT_MUTED, anchor='mm')
    
    # CARD 2: BEHAVIOR TREND (Horizontal Bar Chart)
    c2_x = c1_x + card_w + gap
    draw.rounded_rectangle([c2_x, sy, c2_x + card_w, sy + card_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    
    draw_pill_badge(draw, left_x=c2_x + 24, cy=sy + 26, text="EMOTIONAL UX TREND", font=get_font(10, 'bold'), theme='gold', has_dot=False, pad_x=8, height=22)
    draw.text((c2_x + 24, sy + 58), "미신적 공포 마케팅의 피로감", font=get_font(16.5, 'bold'), fill=C_TITLE_WHITE)
    draw.text((c2_x + 24, sy + 88), "액운이나 살을 강조하는 불안 마케팅으로 인해\n친구들과 공유하거나 일상적 힐링으로 소비하기 꺼려집니다.", font=get_font(11.5, 'medium'), fill=C_TEXT_BODY, spacing=4)
    draw.text((c2_x + 24, sy + 144), "85% -> 12%", font=get_num_font(30, 'black'), fill=C_GOLD_HERO)
    draw.text((c2_x + 24, sy + 188), "부정 감정 86% 감소 (AI 감성 분석 모델)", font=get_font(11, 'bold'), fill=C_GREEN_ACC)
    
    bx = c2_x + card_w - 170
    b_w = 145
    draw_pill_badge(draw, cx=bx + b_w // 2, cy=sy + 32, text="감정 피로도 비교", font=get_font(9, 'bold'), theme='gold', has_dot=False, pad_x=8, height=20)
    
    draw.text((bx, sy + 57), "기존 사주 앱", font=get_font(10, 'bold'), fill=C_TEXT_MUTED)
    w_85 = draw.textlength("85%", font=get_num_font(11.5, 'bold'))
    draw.text((bx + b_w - w_85, sy + 57), "85%", font=get_num_font(11.5, 'bold'), fill=(239, 68, 68))
    draw.rounded_rectangle([bx, sy + 75, bx + b_w, sy + 75 + 16], radius=8, fill=(48, 20, 28))
    draw.rounded_rectangle([bx, sy + 75, bx + int(b_w * 0.85), sy + 75 + 16], radius=8, fill=(239, 68, 68))
    
    draw.text((bx, sy + 101), "포춘매치 힐링", font=get_font(10, 'bold'), fill=C_GOLD_HERO)
    w_12 = draw.textlength("12%", font=get_num_font(11.5, 'bold'))
    draw.text((bx + b_w - w_12, sy + 101), "12%", font=get_num_font(11.5, 'bold'), fill=C_GREEN_ACC)
    draw.rounded_rectangle([bx, sy + 119, bx + b_w, sy + 119 + 16], radius=8, fill=(20, 26, 42))
    draw.rounded_rectangle([bx, sy + 119, bx + int(b_w * 0.12), sy + 119 + 16], radius=8, fill=C_GREEN_ACC)
    draw_pill_badge(draw, cx=bx + b_w // 2, cy=sy + 166, text="도파민 힐링 · 86% 개선", font=get_font(9.5, 'bold'), theme='green', has_dot=False, pad_x=10, height=24, solid=True)
    
    # CARD 3: INDUSTRY GAP (Vertical Bar Chart)
    c3_x = c2_x + card_w + gap
    draw.rounded_rectangle([c3_x, sy, c3_x + card_w, sy + card_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    
    draw_pill_badge(draw, left_x=c3_x + 24, cy=sy + 26, text="SERVICE GAP", font=get_font(10, 'bold'), theme='cyan', has_dot=False, pad_x=8, height=22)
    draw.text((c3_x + 24, sy + 58), "관계 케미스트리의 시각화 부재", font=get_font(16.5, 'bold'), fill=C_TITLE_WHITE)
    draw.text((c3_x + 24, sy + 88), "국내 주요 운세 앱은 단순 점수(75점)만 나열할 뿐,\n'어떤 오행이 상호 보완되는가'를 시각화하지 못함.", font=get_font(11.5, 'medium'), fill=C_TEXT_BODY, spacing=4)
    draw.text((c3_x + 24, sy + 144), "0 / 16개", font=get_num_font(38, 'black'), fill=C_CYAN_ACCENT)
    draw.text((c3_x + 24, sy + 188), "국내 16대 운세 앱 전수조사 (오행 레이더 0%)", font=get_font(11, 'bold'), fill=C_TEXT_MUTED)
    
    draw_pill_badge(draw, cx=c3_x + card_w - 90, cy=sy + 32, text="시각화 지원율", font=get_font(9, 'bold'), theme='cyan', has_dot=False, pad_x=8, height=20)
    col_w_chart = 36
    draw.rounded_rectangle([c3_x + card_w - 120, sy + 70, c3_x + card_w - 120 + col_w_chart, sy + 160], radius=4, fill=(28, 36, 56))
    draw.text((c3_x + card_w - 102, sy + 172), "기존(0%)", font=get_font(9.5, 'bold'), fill=C_TEXT_MUTED, anchor='mm')
    
    draw.rounded_rectangle([c3_x + card_w - 65, sy + 70, c3_x + card_w - 65 + col_w_chart, sy + 160], radius=4, fill=C_CYAN_ACCENT)
    draw.text((c3_x + card_w - 47, sy + 172), "본앱(100%)", font=get_font(9.5, 'bold'), fill=C_CYAN_ACCENT, anchor='mm')
    
    # 2. BOTTOM: SWOT Matrix & Strategic Outcomes
    b_y = 500
    swot_w = 830
    swot_h = 415
    draw.rounded_rectangle([100, b_y, 100 + swot_w, b_y + swot_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw.text((125, b_y + 20), "SWOT ANALYSIS : 명리학과 서양 점성술의 융합 전략", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.line([(125, b_y + 48), (100 + swot_w - 25, b_y + 48)], fill=(229, 192, 123, 30), width=1)
    
    s_x = 125
    s_y = b_y + 65
    qw = 380
    qh = 160
    
    # S (Strength)
    draw.rounded_rectangle([s_x, s_y, s_x + qw, s_y + qh], radius=10, fill=(12, 38, 28, 255), outline=(16, 185, 129, 200), width=1)
    draw_pill_badge(draw, left_x=s_x + 14, cy=s_y + 22, text="Strength (강점)", font=get_font(10, 'bold'), theme='green', has_dot=False, pad_x=10, height=24, solid=True)
    s_pts = ["01  0.3초 고유 우주 좌표 및 오행 레이더", "02  92% 정밀 사주 일주 + 별자리 결합", "03  외부 전송 없는 안전한 프라이빗 보관"]
    dy = s_y + 56
    for p in s_pts:
        draw.text((s_x + 14, dy), p, font=get_font(11.5, 'medium'), fill=(52, 211, 153))
        dy += 24
        
    # W (Weakness)
    w_x = s_x + qw + 15
    draw.rounded_rectangle([w_x, s_y, w_x + qw, s_y + qh], radius=10, fill=(48, 16, 24, 255), outline=(239, 68, 68, 200), width=1)
    draw_pill_badge(draw, left_x=w_x + 14, cy=s_y + 22, text="Weakness (약점)", font=get_font(10, 'bold'), theme='red', has_dot=False, pad_x=10, height=24, solid=True)
    w_pts = ["01  초기 스타트업 브랜드 인지도 제약", "02  출생 시각 미입력 시 스마트 보정 안내", "03  명리학 전문가 1:1 상담 부재"]
    dy = s_y + 56
    for p in w_pts:
        draw.text((w_x + 14, dy), p, font=get_font(11.5, 'medium'), fill=(255, 140, 140))
        dy += 24
        
    # O (Opportunity)
    o_y = s_y + qh + 10
    draw.rounded_rectangle([s_x, o_y, s_x + qw, o_y + qh], radius=10, fill=(35, 30, 15, 255), outline=(229, 192, 123, 200), width=1)
    draw_pill_badge(draw, left_x=s_x + 14, cy=o_y + 22, text="Opportunity (기회)", font=get_font(10, 'bold'), theme='gold', has_dot=False, pad_x=10, height=24, solid=True)
    o_pts = ["01  2030 MZ세대의 사주/타로 바이럴 공유 88%", "02  복잡한 한자 없는 모던 힐링 디자인 니즈", "03  친구·연인과의 소셜 인연 매칭 수요 폭증"]
    dy = o_y + 56
    for p in o_pts:
        draw.text((s_x + 14, dy), p, font=get_font(11.5, 'medium'), fill=(255, 215, 0))
        dy += 24
        
    # T (Threat)
    draw.rounded_rectangle([w_x, o_y, w_x + qw, o_y + qh], radius=10, fill=(30, 18, 48, 255), outline=(168, 85, 247, 200), width=1)
    draw_pill_badge(draw, left_x=w_x + 14, cy=o_y + 22, text="Threat (위협)", font=get_font(10, 'bold'), theme='purple', has_dot=False, pad_x=10, height=24, solid=True)
    t_pts = ["01  기존 대형 운세 앱의 마케팅 공세", "02  비과학적 편견에 따른 앱 수명 주기 리스크", "03  생성형 AI 텍스트 챗봇과의 경쟁"]
    dy = o_y + 56
    for p in t_pts:
        draw.text((w_x + 14, dy), p, font=get_font(11.5, 'medium'), fill=(216, 180, 254))
        dy += 24
        
    # Right: 3 Strategic Outcomes Cards
    strat_x = 100 + swot_w + 30
    strat_w = 860
    strat_h = 415
    draw.rounded_rectangle([strat_x, b_y, strat_x + strat_w, b_y + strat_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw.text((strat_x + 25, b_y + 20), "STRATEGIC OUTCOMES : 도출된 3대 제품 혁신 전략", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.line([(strat_x + 25, b_y + 48), (strat_x + strat_w - 25, b_y + 48)], fill=(229, 192, 123, 30), width=1)
    
    outcomes = [
        ("01", "한자 텍스트 나열을 0.3초 우주 좌표 메타포로 치환",
         "AS-IS : 난해한 한자와 복잡한 신살 설명으로 사용자의 74.2%가 첫 화면에서 이탈",
         "TO-BE : 생년월일시 기반 0.3초 우주 좌표 카드 & 24절기 천체 나침반으로 직관성 극대화", "gold"),
        ("02", "5각형 오행 실시간 레이더 차트를 통한 결핍 에너지 시각화",
         "AS-IS : '목 기운이 부족하다'는 텍스트만 있어 구체적인 조화 상태를 인지하기 어려움",
         "TO-BE : 5각형 레이더 다각형으로 목화토금수 에너지 비율과 맞춤 라이프스타일 팁 0.1초 제공", "purple"),
        ("03", "두 사람의 케미스트리를 증명하는 92% 정밀 궁합 매칭",
         "AS-IS : 단순 75점과 같은 단일 수치만 제공하여 실제 관계에서의 조화 방안 부재",
         "TO-BE : 일주 합충 + 오행 상생상극 중첩 차트로 보완점과 데이트 시크릿 솔루션 동시 제시", "cyan")
    ]
    
    sy_out = b_y + 65
    for num, o_title, o_asis, o_tobe, o_theme in outcomes:
        draw.rounded_rectangle([strat_x + 25, sy_out, strat_x + strat_w - 25, sy_out + 102], radius=12, fill=(20, 26, 42, 255), outline=(229, 192, 123, 40), width=1)
        draw.rounded_rectangle([strat_x + 40, sy_out + 14, strat_x + 68, sy_out + 38], radius=6, fill=(229, 192, 123, 255))
        draw.text((strat_x + 54, sy_out + 26), num, font=get_font(12, 'bold'), fill=(7, 10, 18), anchor='mm')
        draw.text((strat_x + 78, sy_out + 26), o_title, font=get_font(14, 'bold'), fill=(244, 246, 252), anchor='lm')
        draw.text((strat_x + 40, sy_out + 46), o_asis, font=get_font(11.5, 'regular'), fill=(255, 140, 140))
        draw.text((strat_x + 40, sy_out + 70), o_tobe, font=get_font(11.5, 'bold'), fill=(255, 215, 0))
        sy_out += 114
        
    draw_slide_footer(draw, 2)
    save_slide(base, 2)

# ==============================================================
# SLIDE 03: TARGET & PERSONA (2x2 Matrix, Benchmark, Personas)
# ==============================================================
def make_slide_03():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=3,
        category_en="TARGET & PERSONA | SEGMENTATION MATRIX & BENCHMARK",
        title_white="명확한 시각화와 소셜 공유를 ",
        title_gold="원하는 핵심 사용자",
        subtitle_kr="관계 지향성과 데이터 수용도로 정의한 2x2 타깃 매트릭스와 2인의 핵심 페르소나"
    )
    
    # 1. TOP-LEFT: 2x2 Target Segmentation Matrix
    col_w = 845
    gap_x = 30
    col1_x = 100
    col2_x = col1_x + col_w + gap_x # 975 (ends at 975 + 845 = 1820)
    
    t_x = col1_x
    t_y = 234
    t_w = col_w
    t_h = 378
    draw.rounded_rectangle([t_x, t_y, t_x + t_w, t_y + t_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw.text((t_x + 24, t_y + 18), "TARGET SEGMENTATION MATRIX (타깃 세그먼트 분석)", font=get_font(14, 'bold'), fill=(244, 246, 252))
    draw.text((t_x + 24, t_y + 38), "관계 지향성과 데이터 시각화 수용도에 따른 4대 사용자 유형 분류", font=get_font(11.5, 'medium'), fill=(163, 176, 204))
    
    grid_w = 560
    grid_h = 260
    grid_x = t_x + (t_w - grid_w) // 2
    grid_y = t_y + 76
    qw = (grid_w - 16) // 2
    qh = (grid_h - 16) // 2
    
    axis_x = grid_x + qw + 8
    axis_y = grid_y + qh + 8
    draw.line([(axis_x, grid_y), (axis_x, grid_y + grid_h)], fill=(229, 192, 123, 80), width=2)
    draw.line([(grid_x, axis_y), (grid_x + grid_w, axis_y)], fill=(229, 192, 123, 80), width=2)
    
    draw.text((axis_x, grid_y - 12), "▲ 관계 지향 (인연/궁합)", font=get_font(10, 'bold'), fill=(255, 215, 0), anchor='ms')
    draw.text((axis_x, grid_y + grid_h + 16), "▼ 자아 탐색 (개인 성향)", font=get_font(10, 'bold'), fill=(163, 176, 204), anchor='ma')
    draw.text((grid_x - 12, axis_y), "◀ 텍스트/미신", font=get_font(10, 'bold'), fill=(163, 176, 204), anchor='rm')
    draw.text((grid_x + grid_w + 12, axis_y), "데이터/시각화 ▶", font=get_font(10, 'bold'), fill=(0, 229, 255), anchor='lm')
    
    # Q1: Top-Right (Core Target)
    q1_x = grid_x + qw + 16
    q1_y = grid_y
    draw.rounded_rectangle([q1_x, q1_y, q1_x + qw, q1_y + qh], radius=8, fill=(35, 30, 15, 255), outline=(229, 192, 123, 200), width=1)
    draw_pill_badge(draw, left_x=q1_x + 12, cy=q1_y + 22, text="CORE TARGET", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=8, height=22, solid=True)
    draw.text((q1_x + 12, q1_y + 44), "도파민 소셜 매처", font=get_font(13, 'bold'), fill=(255, 215, 0))
    draw.text((q1_x + 12, q1_y + 68), "친구/연인과의 케미스트리 공유 열망\n5각형 오행 레이더 & 92% 궁합 최우선 수용", font=get_font(11, 'regular'), fill=(244, 246, 252), spacing=3)
    
    # Q2: Bottom-Right (Primary Target)
    q2_x = q1_x
    q2_y = grid_y + qh + 16
    draw.rounded_rectangle([q2_x, q2_y, q2_x + qw, q2_y + qh], radius=8, fill=(10, 36, 48, 255), outline=(0, 229, 255, 200), width=1)
    draw_pill_badge(draw, left_x=q2_x + 12, cy=q2_y + 22, text="PRIMARY TARGET", font=get_font(9.5, 'bold'), theme='cyan', has_dot=True, pad_x=8, height=22, solid=True)
    draw.text((q2_x + 12, q2_y + 44), "데이터 힐링 탐색자", font=get_font(13, 'bold'), fill=(0, 229, 255))
    draw.text((q2_x + 12, q2_y + 68), "복잡한 사주를 시각적으로 이해하고자 함\n결핍 오행 보완 팁 적극 활용", font=get_font(11, 'regular'), fill=(244, 246, 252), spacing=3)
    
    # Q3: Top-Left (Secondary Target)
    q3_x = grid_x
    q3_y = grid_y
    draw.rounded_rectangle([q3_x, q3_y, q3_x + qw, q3_y + qh], radius=8, fill=(30, 18, 48, 255), outline=(168, 85, 247, 200), width=1)
    draw_pill_badge(draw, left_x=q3_x + 12, cy=q3_y + 22, text="SECONDARY TARGET", font=get_font(9.5, 'bold'), theme='purple', has_dot=True, pad_x=8, height=22, solid=True)
    draw.text((q3_x + 12, q3_y + 44), "캐주얼 운세 팔로워", font=get_font(13, 'bold'), fill=(216, 180, 254))
    draw.text((q3_x + 12, q3_y + 68), "매일 아침 길시와 행운 아이템 확인\n솔루션 : 원터치 데일리 타로 리추얼", font=get_font(11, 'regular'), fill=(244, 246, 252), spacing=3)
    
    # Q4: Bottom-Left (Potential Target)
    q4_x = grid_x
    q4_y = grid_y + qh + 16
    draw.rounded_rectangle([q4_x, q4_y, q4_x + qw, q4_y + qh], radius=8, fill=(20, 26, 42, 255), outline=(100, 116, 139, 200), width=1)
    draw_pill_badge(draw, left_x=q4_x + 12, cy=q4_y + 22, text="POTENTIAL TARGET", font=get_font(9.5, 'bold'), theme='slate', has_dot=True, pad_x=8, height=22, solid=True)
    draw.text((q4_x + 12, q4_y + 44), "전통 철학관 방문자", font=get_font(13, 'bold'), fill=(203, 213, 225))
    draw.text((q4_x + 12, q4_y + 68), "고액 상담 경험 있으나 모바일 편의성 추구\n솔루션 : 신뢰도 높은 정밀 일주 분석", font=get_font(11, 'regular'), fill=(163, 176, 204), spacing=3)
    
    # 2. TOP-RIGHT: Competitive Benchmark Table (Strictly aligned to col2_x=975, w=845)
    c_x = col2_x
    c_y = 234
    c_w = col_w
    c_h = 378
    draw.rounded_rectangle([c_x, c_y, c_x + c_w, c_y + c_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw.text((c_x + 24, c_y + 18), "경쟁사 서비스 비교 분석 (Competitive Benchmark)", font=get_font(14, 'bold'), fill=(244, 246, 252))
    draw.text((c_x + 24, c_y + 38), "국내 주요 운세/타로 솔루션 대비 포춘매치의 5대 사용자 경험 차별점", font=get_font(11.5, 'medium'), fill=(163, 176, 204))
    
    tbl_x = c_x + 20
    tbl_w = c_w - 40 # 805
    th_y = c_y + 64
    th_h = 36
    th_cy = th_y + th_h // 2
    row_h = 46
    total_tbl_h = th_h + 5 * row_h
    
    # 4 Clearly Defined Columns with Distinct Widths
    col1_w = 155
    col2_w = 195
    col3_w = 195
    col4_w = tbl_w - (col1_w + col2_w + col3_w) # 260
    
    c1_x = tbl_x
    c2_x = c1_x + col1_w
    c3_x = c2_x + col2_w
    c4_x = c3_x + col3_w
    
    # Entire Table Chassis with Integrated Border
    draw.rounded_rectangle([tbl_x, th_y, tbl_x + tbl_w, th_y + total_tbl_h], radius=8, fill=(14, 20, 36, 240), outline=(229, 192, 123, 70), width=1)
    # Header Row Background
    draw.rounded_rectangle([tbl_x, th_y, tbl_x + tbl_w, th_y + th_h], radius=8, fill=(24, 32, 54))
    
    # Col 4 Flush Integrated Column Tint (Seamless grid integration, no awkward outer ring)
    draw.rounded_rectangle([c4_x, th_y, tbl_x + tbl_w, th_y + total_tbl_h], radius=8, fill=(38, 30, 14, 180))
    # Col 4 Left Separator Line
    draw.line([(c4_x, th_y), (c4_x, th_y + total_tbl_h)], fill=(229, 192, 123, 140), width=1)
    
    # Clear Column Headers
    draw.text((c1_x + 14, th_cy), "비교 항목", font=get_font(11.5, 'bold'), fill=C_TITLE_WHITE, anchor='lm')
    draw.text((c2_x + 14, th_cy), "오프라인 철학관", font=get_font(11.5, 'bold'), fill=C_TEXT_BODY, anchor='lm')
    draw.text((c3_x + 14, th_cy), "기존 운세 앱", font=get_font(11.5, 'bold'), fill=C_TEXT_BODY, anchor='lm')
    draw.text((c4_x + 16, th_cy), "포춘매치 (본 서비스)", font=get_font(11.5, 'extrabold'), fill=(255, 215, 0), anchor='lm')
    draw_pill_badge(draw, left_x=c4_x + 152, cy=th_cy, text="OURS", font=get_font(7.5, 'bold'), theme='gold', solid=True, pad_x=4, height=16)
    
    # Vertical Column Divider Lines in Header
    draw.line([(c2_x, th_y + 4), (c2_x, th_y + th_h - 4)], fill=(229, 192, 123, 60), width=1)
    draw.line([(c3_x, th_y + 4), (c3_x, th_y + th_h - 4)], fill=(229, 192, 123, 60), width=1)
    
    rows = [
        ("입력 방식", "복잡한 간지 수기 입력", "반복적인 생년월일 타이핑", "0.3초 우주 좌표 즉각 도출"),
        ("데이터 시각화", "난해한 한자 텍스트 나열", "단순 점수 게이지 바", "5각 실시간 오행 레이더 차트"),
        ("관계 궁합 분석", "단순 길흉 판정 (대길/흉)", "단순 점수(75점) 나열", "92% 정밀 상생 시너지 리포트"),
        ("감성 인터랙션", "정적 텍스트 페이지", "단순 화면 터치", "3D 카드 셔플 & 손맛 햅틱 타로"),
        ("개인정보 보호", "서버 DB 전송 및 수집", "광고 트래커 개인정보 추적", "외부 전송 없는 안심 프라이빗 보관")
    ]
    
    for idx, (dim, m1, m2, m3) in enumerate(rows):
        ry = th_y + th_h + idx * row_h
        rcy = ry + row_h // 2
        # Horizontal row divider lines
        draw.line([(tbl_x, ry), (c4_x, ry)], fill=(229, 192, 123, 40), width=1)
        draw.line([(c4_x + 10, ry), (c4_x + col4_w - 10, ry)], fill=(229, 192, 123, 30), width=1)
        # Vertical column divider lines
        draw.line([(c2_x, ry + 4), (c2_x, ry + row_h - 4)], fill=(229, 192, 123, 40), width=1)
        draw.line([(c3_x, ry + 4), (c3_x, ry + row_h - 4)], fill=(229, 192, 123, 40), width=1)
        
        draw.text((c1_x + 14, rcy), dim, font=get_font(11, 'bold'), fill=C_TITLE_WHITE, anchor='lm')
        draw.text((c2_x + 14, rcy), m1, font=get_font(10.5, 'medium'), fill=C_TEXT_BODY, anchor='lm')
        draw.text((c3_x + 14, rcy), m2, font=get_font(10.5, 'medium'), fill=C_TEXT_BODY, anchor='lm')
        draw.text((c4_x + 14, rcy), "✓ " + m3, font=get_font(11, 'bold'), fill=(255, 215, 0), anchor='lm')
        
    # 3. BOTTOM: 2 Senior Persona Cards (Strictly aligned to col1_x=100 and col2_x=975, w=845)
    p_y = 636
    p_w = col_w # 845
    p_h = 335
    
    # Persona A (Left Column: 100 to 945)
    draw.rounded_rectangle([col1_x, p_y, col1_x + p_w, p_y + p_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    b_p1 = draw_pill_badge(draw, left_x=col1_x + 24, cy=p_y + 24, text="PRIMARY PERSONA · A", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=8, height=22)
    draw.text((b_p1[2] + 16, p_y + 24), "김서윤 (27세, IT 프로덕트 디자이너 / INFP)", font=get_font(13.5, 'bold'), fill=C_TITLE_WHITE, anchor='lm')
    draw.text((col1_x + 24, p_y + 54), "“난해한 한자 사주 말고, 감각적인 데이터로 나와 상대방의 기운을 확인하고 싶어요.”", font=get_font(12, 'semibold'), fill=C_GOLD_HERO)
    
    draw_behavior_slider(draw, col1_x + 24, p_y + 86, p_w - 48, "비주얼 민감도", "낮음", "극도로 높음", 0.95, theme='gold')
    draw_behavior_slider(draw, col1_x + 24, p_y + 116, p_w - 48, "데이터 수용도", "직관형", "분석형", 0.85, theme='cyan')
    draw_behavior_slider(draw, col1_x + 24, p_y + 146, p_w - 48, "소셜 공유 의향", "혼자만 봄", "적극 공유", 0.80, theme='purple')
    
    draw.text((col1_x + 24, p_y + 188), "핵심 목표   감각적인 5각형 레이더로 결핍 오행을 채우고 궁합 조율", font=get_font(11, 'medium'), fill=C_TEXT_BODY)
    draw.text((col1_x + 24, p_y + 212), "주요 불편   불길한 말로 겁주는 미신 마케팅과 텍스트 과부하", font=get_font(11, 'medium'), fill=C_RED_ACC)
    draw.text((col1_x + 24, p_y + 236), "사용 맥락   iPhone 16 Pro, Figma, 인스타그램 스토리 헤비 유저", font=get_font(11, 'medium'), fill=C_TEXT_MUTED)
    
    # Persona B (Right Column: 975 to 1820)
    draw.rounded_rectangle([col2_x, p_y, col2_x + p_w, p_y + p_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    b_p2 = draw_pill_badge(draw, left_x=col2_x + 24, cy=p_y + 24, text="SECONDARY PERSONA · B", font=get_font(9.5, 'bold'), theme='purple', has_dot=True, pad_x=8, height=22)
    draw.text((b_p2[2] + 16, p_y + 24), "이도현 (31세, 스타트업 전략 기획자 / ENTP)", font=get_font(13.5, 'bold'), fill=C_TITLE_WHITE, anchor='lm')
    draw.text((col2_x + 24, p_y + 54), "“단순한 미신 말고, 두 사람의 성향이 어떻게 맞물리는지 과학적으로 보고 싶어요.”", font=get_font(12, 'semibold'), fill=C_PURPLE_ACC)
    
    draw_behavior_slider(draw, col2_x + 24, p_y + 86, p_w - 48, "비주얼 민감도", "낮음", "극도로 높음", 0.75, theme='gold')
    draw_behavior_slider(draw, col2_x + 24, p_y + 116, p_w - 48, "데이터 수용도", "직관형", "분석형", 0.90, theme='cyan')
    draw_behavior_slider(draw, col2_x + 24, p_y + 146, p_w - 48, "소셜 공유 의향", "혼자만 봄", "적극 공유", 0.90, theme='purple')
    
    draw.text((col2_x + 24, p_y + 188), "핵심 목표   파트너와의 상호 보완성을 정량적 오행 스코어로 파악", font=get_font(11, 'medium'), fill=C_TEXT_BODY)
    draw.text((col2_x + 24, p_y + 212), "주요 불편   왜 잘 맞는지 근거를 설명해주지 않는 불친절한 결과", font=get_font(11, 'medium'), fill=C_RED_ACC)
    draw.text((col2_x + 24, p_y + 236), "사용 맥락   Galaxy S24 Ultra, Notion, 정보 구조 및 프라이버시 민감", font=get_font(11, 'medium'), fill=C_TEXT_MUTED)
    
    draw_slide_footer(draw, 3)
    save_slide(base, 3)

# ==============================================================
# SLIDE 04: INFORMATION ARCHITECTURE (IA Tree, 5 Domains, 15 Cards)
# ==============================================================
def make_slide_04():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=4,
        category_en="INFORMATION ARCHITECTURE · SERVICE STRUCTURE",
        title_white="복잡함을 덜어내고 직관성을 높인 ",
        title_gold="5대 화면 메뉴 구조",
        subtitle_kr="나의 사주부터 오행 분석, 인연 궁합, 힐링 타로까지 편안하게 둘러보는 직관적인 서비스 계층"
    )
    
    # Top-Right Badge: Clean, Compact Overview (w=340, h=60, nicely proportioned)
    top_badge_x = 1480
    top_badge_y = 65
    draw.rounded_rectangle([top_badge_x, top_badge_y, top_badge_x + 340, top_badge_y + 60], radius=10, fill=(14, 20, 36, 220), outline=(229, 192, 123, 60), width=1)
    draw_pill_badge(draw, left_x=top_badge_x + 16, cy=top_badge_y + 30, text="서비스 구성", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=8, height=24)
    draw.text((top_badge_x + 110, top_badge_y + 20), "5대 메인 탭", font=get_font(12, 'bold'), fill=(244, 246, 252))
    draw.text((top_badge_x + 110, top_badge_y + 39), "총 15개 직관적 화면 설계", font=get_font(10.5, 'medium'), fill=(163, 176, 204))
    
    # Level 0 Root Node: Compact, Centered, Clean Korean!
    # Width: 460px (x: 730 to 1190) - NOT overly wide!
    root_x1, root_y1, root_x2, root_y2 = 730, 226, 1190, 286
    draw.rounded_rectangle([root_x1, root_y1, root_x2, root_y2], radius=12, fill=(14, 20, 36), outline=(229, 192, 123), width=2)
    b_root = draw_pill_badge(draw, left_x=root_x1 + 18, cy=root_y1 + 30, text="시작 화면", font=get_font(10, 'bold'), theme='gold', has_dot=True, pad_x=10, height=26)
    draw.text((b_root[2] + 16, root_y1 + 19), "포춘매치 전체 메뉴 구조", font=get_font(14.5, 'bold'), fill=(244, 246, 252))
    draw.text((b_root[2] + 16, root_y1 + 41), "사주와 궁합, 타로를 쉽고 편안하게 탐색하는 5대 핵심 메뉴", font=get_font(10.5, 'medium'), fill=(163, 176, 204))
    
    cw = 328
    cgap = 20
    cols_x = [100 + i * (cw + cgap) for i in range(5)]
    col_centers = [cx + cw // 2 for cx in cols_x]
    
    draw.line([(960, root_y2), (960, 308)], fill=(229, 192, 123), width=2)
    draw.ellipse([956, 304, 964, 312], fill=(255, 215, 0))
    draw.line([(col_centers[0], 308), (col_centers[-1], 308)], fill=(229, 192, 123, 180), width=2)
    for cx in col_centers:
        draw.ellipse([cx - 4, 308 - 4, cx + 4, 308 + 4], fill=(255, 215, 0))
        draw_arrow(draw, (cx, 308), (cx, 330), col=(229, 192, 123), width=2, arrow_size=4)
        
    domains_data = [
        ("01. 우주 사주", "나의 사주 좌표", "생년월일시로 알아보는 나만의 고유한 성향과 운세", [
            ("기본 화면", "나의 우주 좌표", "생년월일시 4주 8글자를 세련된 우주 좌표로 시각화", False),
            ("안내 화면", "오늘의 운세 나침반", "24절기와 오늘의 천간지지를 반영한 맞춤 운세", True),
            ("상세 화면", "행운의 시간 & 방위", "오늘 나에게 좋은 기운이 들어오는 골든 타임 안내", True)
        ]),
        ("02. 오행 분석", "5가지 기운 밸런스", "목·화·토·금·수 오행 분포와 부족한 기운 보완 가이드", [
            ("차트 화면", "5가지 오행 레이더", "목·화·토·금·수 에너지 비율을 5각형 차트로 쉽게 확인", True),
            ("추천 화면", "부족한 기운 보완", "나에게 부족한 기운을 채워주는 색상과 음식, 행동 추천", True),
            ("안내 팝업", "오행 상생상극 안내", "서로 돕고 견제하는 자연의 순환 원리를 알기 쉽게 설명", False)
        ]),
        ("03. 인연 궁합", "두 사람의 조화도", "사주와 별자리를 종합하여 서로 잘 맞는 시너지 분석", [
            ("리포트", "정밀 인연 궁합", "두 사람의 생년월일을 비교하여 성향 일치도와 조화 점수 분석", True),
            ("입력 창", "간편 인연 등록", "함께 보고 싶은 상대방 정보를 손쉽게 저장하고 관리", False),
            ("비교 화면", "둘만의 오행 비교", "두 사람의 오행 차트를 겹쳐서 서로 채워주는 기운 확인", True)
        ]),
        ("04. 힐링 타로", "오늘의 타로 리딩", "가볍게 카드를 뽑아 마음의 위로와 조언을 얻는 리추얼", [
            ("기본 화면", "22종 메이저 타로", "아름다운 일러스트와 함께 읽는 키워드 중심의 명쾌한 해석", False),
            ("체험 화면", "직관적인 카드 셔플", "손끝으로 카드를 섞고 펼치며 즐기는 편안한 인터랙션", True),
            ("인터랙션", "실감나는 카드 뒤집기", "카드를 선택하고 넘기는 순간 부드러운 진동 피드백", True)
        ]),
        ("05. 맞춤 설정", "나의 기록 & 설정", "저장한 궁합과 타로 기록을 안전하게 보관하고 관리", [
            ("기록 화면", "나만의 안심 보관함", "마음에 남는 타로 카드와 소중한 궁합 리포트를 안전 보관", True),
            ("상점 화면", "프리미엄 복채 상점", "깊이 있는 상세 해석을 위한 이용권 충전", False),
            ("보안 화면", "개인정보 안심 보관", "소중한 사주 정보는 외부 서버 없이 내 기기에만 안전 보관", True)
        ])
    ]
    
    for i, (dom_code, dom_name, dom_desc, containers) in enumerate(domains_data):
        cx = cols_x[i]
        draw.rounded_rectangle([cx, 330, cx + cw, 402], radius=10, fill=(35, 30, 15, 255), outline=(229, 192, 123, 180), width=1)
        draw.text((cx + 18, 344), dom_code, font=get_font(10, 'bold'), fill=(255, 215, 0))
        draw.text((cx + 18, 363), dom_name, font=get_font(13.5, 'bold'), fill=(244, 246, 252))
        draw.text((cx + 18, 383), dom_desc, font=get_font(9, 'medium'), fill=(163, 176, 204))
        
        tree_x = cx + 16
        draw.line([(tree_x, 402), (tree_x, 672)], fill=(229, 192, 123, 100), width=2)
        
        card_w = cw - 32
        card_x = cx + 32
        cy = 414
        card_h = 82
        gap = 10
        
        for scr_type, title, desc, is_new in containers:
            draw.line([(tree_x, cy + 20), (card_x, cy + 20)], fill=(229, 192, 123, 120), width=2)
            draw.ellipse([tree_x - 3, cy + 20 - 3, tree_x + 3, cy + 20 + 3], fill=(255, 215, 0))
            
            card_bg = (14, 20, 36, 230)
            card_bd = (229, 192, 123, 50)
            draw.rounded_rectangle([card_x, cy, card_x + card_w, cy + card_h], radius=8, fill=card_bg, outline=card_bd, width=1)
            
            draw_pill_badge(draw, left_x=card_x + 14, cy=cy + 15, text=scr_type, font=get_font(8.5, 'bold'), theme='gray', pad_x=6, height=18)
            if is_new:
                draw_pill_badge(draw, left_x=card_x + card_w - 46, cy=cy + 15, text="핵심", font=get_font(8, 'bold'), theme='gold', pad_x=6, height=18, solid=True)
                
            draw.text((card_x + 14, cy + 39), title, font=get_font(12, 'bold'), fill=(244, 246, 252), anchor='lm')
            draw.text((card_x + 14, cy + 62), desc, font=get_font(9.5, 'regular'), fill=(163, 176, 204), anchor='lm')
            cy += card_h + gap
            
    # Bottom: 4 IA Principles (4 balanced cards with comfortable width!)
    bar_y = 730
    bp_w = 415
    bp_gap = 20
    bp_h = 195
    
    pillars = [
        ("01", "단계별 쉬운 정보 제공", "처음부터 어려운 내용을 쏟아내지 않고 사주, 오행, 궁합 순서로 차근차근 안내합니다.",
         ["· 생년월일 입력 후 핵심 좌표부터 단계적 안내", "· 난해한 한자 대신 시각적 차트로 쉬운 이해"]),
        ("02", "한 손 간편 전환", "복잡한 메뉴 이동 없이 한 번의 탭으로 상대방 궁합과 내 사주를 빠르게 오갑니다.",
         ["· 엄지 영역 내 배치된 편안한 화면 전환", "· 저장된 인연 프로필을 터치 한 번으로 즉시 교체"]),
        ("03", "생생한 손맛의 타로", "직접 카드를 섞고 뒤집는 듯한 부드러운 손끝 터치감과 진동으로 힐링을 줍니다.",
         ["· 물리 엔진 기반의 실감나는 카드 셔플", "· 카드를 뽑는 순간 전해지는 기분 좋은 진동 피드백"]),
        ("04", "100% 기기 내 안심 보관", "소중한 생년월일과 사주 기록을 외부 서버에 보내지 않고 내 기기에만 안전하게 보관합니다.",
         ["· 회원가입이나 개인정보 입력 부담 제로", "· 내 기기 안에만 암호화 저장되는 프라이빗 안심 환경"])
    ]
    
    for pidx, (pnum, ptitle, pdesc, psub_lines) in enumerate(pillars):
        px = 100 + pidx * (bp_w + bp_gap)
        draw.rounded_rectangle([px, bar_y, px + bp_w, bar_y + bp_h], radius=12, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
        
        draw.rounded_rectangle([px + 18, bar_y + 18, px + 52, bar_y + 44], radius=6, fill=(35, 30, 15), outline=(229, 192, 123, 180), width=1)
        draw.text((px + 35, bar_y + 31), pnum, font=get_font(11, 'bold'), fill=(255, 215, 0), anchor='mm')
        
        draw.text((px + 62, bar_y + 31), ptitle, font=get_font(13.5, 'bold'), fill=(244, 246, 252), anchor='lm')
        draw.line([(px + 18, bar_y + 54), (px + bp_w - 18, bar_y + 54)], fill=(229, 192, 123, 40), width=1)
        
        words = pdesc.split(' ')
        lines = []
        cur_l = ""
        for w in words:
            test = (cur_l + ' ' + w).strip()
            if draw.textlength(test, font=get_font(10.5, 'regular')) <= bp_w - 36:
                cur_l = test
            else:
                lines.append(cur_l)
                cur_l = w
        if cur_l:
            lines.append(cur_l)
            
        dy = bar_y + 70
        for l in lines[:2]:
            draw.text((px + 18, dy), l, font=get_font(10.5, 'regular'), fill=(203, 213, 225))
            dy += 20
            
        dy += 6
        for subl in psub_lines:
            draw.text((px + 18, dy), subl, font=get_font(9.5, 'medium'), fill=(163, 176, 204))
            dy += 18
            
    draw_slide_footer(draw, 4)
    save_slide(base, 4)

print("Slide 01 to 04 updated cleanly.")

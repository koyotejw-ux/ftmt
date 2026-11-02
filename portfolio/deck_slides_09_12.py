import os
import math
import numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageFilter
from build_executive_ftmt_deck import (
    W, H, MOCKUP_DIR, get_font, get_num_font, wrap_text_by_words,
    draw_diamond, draw_arrow, draw_dashed_line, draw_dashed_arrow,
    draw_pill_badge, draw_dotted_callout,
    create_cosmic_base, draw_slide_header, draw_slide_footer, save_slide,
    C_TITLE_WHITE, C_GOLD_HERO, C_GOLD_MUTED, C_TEXT_BODY, C_TEXT_MUTED,
    C_CYAN_ACCENT, C_PURPLE_ACC, C_GREEN_ACC, C_RED_ACC, C_BORDER_GOLD
)

# ==============================================================
# SLIDE 09: DEEP DIVE 02 - COSMIC COMPATIBILITY MATCH ENGINE
# ==============================================================
# ==============================================================
# SLIDE 09: CORE FEATURE 02 - COSMIC COMPATIBILITY MATCH ENGINE (QUANT INVERSION & 2-STEP FLOW)
# ==============================================================
def make_slide_09():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    # -------------------------------------------------------------
    # 1. Left Column: Grouped Header Card & Quant Theory & Guard (x=100, w=540)
    # -------------------------------------------------------------
    lx = 100
    lw = 540
    
    # 1-A. Unified Kicker Badge
    draw_pill_badge(draw, left_x=lx, cy=78, text="09 CORE FEATURE | COSMIC COMPATIBILITY MATCH ENGINE", font=get_font(10.5, 'bold'), theme='gold', has_dot=True, pad_x=10, height=26)
    
    # Headline
    t1_a = "두 사람의 케미스트리를 증명하는 "
    t1_b = "정밀 인연 매칭"
    font_title = get_font(31, 'extrabold')
    w_t1_a = draw.textlength(t1_a, font=font_title)
    draw.text((lx, 116), t1_a, font=font_title, fill=C_TITLE_WHITE)
    draw.text((lx + w_t1_a, 116), t1_b, font=font_title, fill=C_GOLD_HERO)
    
    t2_a = "92% 조화도와 "
    t2_b = "상생 시너지를 분석해요."
    w_t2_a = draw.textlength(t2_a, font=font_title)
    draw.text((lx, 158), t2_a, font=font_title, fill=C_CYAN_ACCENT)
    draw.text((lx + w_t2_a, 158), t2_b, font=font_title, fill=C_TITLE_WHITE)
    
    desc_text = "단순한 길흉 통보가 아닌 사주 일주 합충과 오행 상생 결합으로 나와 상대방의 관계 케미스트리를 기기에서 즉각 도출합니다."
    desc_lines = wrap_text_by_words(desc_text, get_font(12, 'medium'), lw, draw)
    dy = 212
    for dl in desc_lines:
        draw.text((lx, dy), dl, font=get_font(12, 'medium'), fill=C_TEXT_BODY)
        dy += 19
        
    # 1-B. Card 1: 다차원 인연 융합 케미스트리 모델
    q1_y = 310
    q1_h = 230
    draw.rounded_rectangle([lx, q1_y, lx + lw, q1_y + q1_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    draw_pill_badge(draw, left_x=lx + 24, cy=q1_y + 30, text="CHEMISTRY SOLVER", font=get_font(10, 'bold'), theme='gold', has_dot=True, pad_x=10, height=24)
    draw.text((lx + 200, q1_y + 20), "사주 일주론 & 별자리 감성 융합 궁합 분석 모델", font=get_font(15, 'bold'), fill=C_TITLE_WHITE)
    draw.line([(lx + 24, q1_y + 52), (lx + lw - 24, q1_y + 52)], fill=(229, 192, 123, 40), width=1)
    
    # Formula Box
    f_box_y = q1_y + 64
    draw.rounded_rectangle([lx + 24, f_box_y, lx + lw - 24, f_box_y + 54], radius=10, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
    draw.text((lx + lw//2, f_box_y + 27), "Score = a·정신적끌림 + b·생활패턴일치 + c·오행상생보완 + d·별자리감성", font=get_font(13.5, 'bold'), fill=C_GOLD_HERO, anchor='mm')
    
    draw.text((lx + 24, f_box_y + 68), "단순한 1회성 점수 통보가 아닌, 천간의 정신적 유대(35%)와 지지의 생활 습관 일치도(25%),\n상호 결핍 보완 시너지(25%)를 종합 분석하여 실생활에 유용한 관계 조율 팁을 전달합니다.", font=get_font(11.5, 'medium'), fill=C_TEXT_BODY, spacing=5)
    
    # 1-C. Card 2: 출생시 결측 사전 가드 & 태양시 보정
    q2_y = 560
    q2_h = 200
    draw.rounded_rectangle([lx, q2_y, lx + lw, q2_y + q2_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    draw_pill_badge(draw, left_x=lx + 24, cy=q2_y + 30, text="UX BOUNDARY GUARD", font=get_font(10, 'bold'), theme='cyan', has_dot=True, pad_x=10, height=24)
    draw.text((lx + 215, q2_y + 20), "태어난 시각 미입력 안심 보정 가이드", font=get_font(15, 'bold'), fill=C_TITLE_WHITE)
    draw.line([(lx + 24, q2_y + 52), (lx + lw - 24, q2_y + 52)], fill=(229, 192, 123, 40), width=1)
    
    draw.text((lx + 24, q2_y + 68), "상대방 태어난 시를 모르는 일반적인 데이트 상황에서도 입력 오류 없이 안전하게 분석되도록\n정오(12:00) 기준 태양시 보정 모드를 제공하여 일주 중심의 높은 신뢰도를 유지합니다.", font=get_font(11.5, 'medium'), fill=C_TEXT_BODY, spacing=5)
    
    # Safety Boundary Chips
    draw.rounded_rectangle([lx + 24, q2_y + 130, lx + lw//2 - 10, q2_y + 180], radius=8, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
    draw.text((lx + 36, q2_y + 142), "태어난 시간 미입력 안내", font=get_font(10, 'bold'), fill=C_GOLD_HERO)
    draw.text((lx + 36, q2_y + 160), "누락 방지 스마트 추천 가이드", font=get_font(9.5, 'medium'), fill=C_TEXT_BODY)
    
    draw.rounded_rectangle([lx + lw//2 + 10, q2_y + 130, lx + lw - 24, q2_y + 180], radius=8, fill=(12, 42, 30), outline=(16, 185, 129, 100), width=1)
    draw.text((lx + lw//2 + 22, q2_y + 142), "핵심 사주 성향 집중 분석", font=get_font(10, 'bold'), fill=C_GREEN_ACC)
    draw.text((lx + lw//2 + 22, q2_y + 160), "생년월일 기반 신뢰도 92% 보존", font=get_font(9.5, 'medium'), fill=C_TEXT_BODY)
    
    # 1-D. Left Bottom Audit Pill
    draw.rounded_rectangle([lx, 780, lx + lw, 970], radius=14, fill=(24, 32, 54), outline=(229, 192, 123, 70), width=1)
    draw.text((lx + 24, 796), "정밀 궁합 매칭 서비스의 3대 핵심 UX 원칙:", font=get_font(11.5, 'bold'), fill=C_GOLD_HERO)
    draw.text((lx + 24, 822), "1. 마찰 없는 입력 : 출생시 모름 토글과 1-Tap 시트로 상대방 프로필 즉각 추가", font=get_font(10.5, 'medium'), fill=C_TEXT_BODY)
    draw.text((lx + 24, 844), "2. 완전한 안심 프라이버시 : 민감한 궁합 리포트를 외부 전송 없이 기기 내 안전 보관", font=get_font(10.5, 'medium'), fill=C_TEXT_BODY)
    draw.text((lx + 24, 866), "3. 양방향 관점 전환 : 나와 상대방 입장의 상생 리포트를 실시간 교차 확인", font=get_font(10.5, 'medium'), fill=C_TEXT_BODY)
    draw.text((lx + 24, 892), "✓ 2030 세대 3,400명 실증 테스트 완료 · 인스타그램 스토리 자발적 바이럴 41.8%", font=get_font(10.5, 'bold'), fill=C_CYAN_ACCENT)
    
    # -------------------------------------------------------------
    # 2. Center Column: Grand Hero Phone Mockup (iphone_05_match)
    # -------------------------------------------------------------
    phone_match_path = f"{MOCKUP_DIR}/iphone_05_match.png"
    if os.path.exists(phone_match_path):
        screen_target = Image.open(phone_match_path).convert('RGBA')
        ph = 640
        pw = int(round(ph * (screen_target.width / screen_target.height)))
        phone_t = screen_target.resize((pw, ph), Image.Resampling.LANCZOS)
        
        px = 715
        py = 234
        
        sh_center = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        shc_draw = ImageDraw.Draw(sh_center)
        shc_draw.rounded_rectangle([px + 12, py + 16, px + pw - 12, py + ph + 24], radius=36, fill=(0, 0, 0, 140))
        shc_draw.ellipse([px - 20, py + ph - 25, px + pw + 20, py + ph + 35], fill=(229, 192, 123, 50))
        sh_center = sh_center.filter(ImageFilter.GaussianBlur(26))
        base = Image.alpha_composite(base, sh_center)
        base.paste(phone_t, (px, py), phone_t)
        draw = ImageDraw.Draw(base)
        
    # -------------------------------------------------------------
    # 3. Right Column: 2-Step Verified Flow Card + Zodiac Telemetry Report Card (x=1100, w=720)
    # -------------------------------------------------------------
    rx = 1100
    rw = 720
    
    # 3-A. 2-Step Verified Flow Card (Containing 2 Step Mockups)
    step_y = 234
    step_h = 475
    draw.rounded_rectangle([rx, step_y, rx + rw, step_y + step_h], radius=18, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    
    draw_pill_badge(draw, left_x=rx + 28, cy=step_y + 30, text="VERIFIED WORKFLOW", font=get_font(10, 'bold'), theme='gold', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 220, step_y + 20), "2단계 인연 등록 & 정밀 케미스트리 검증 워크플로우", font=get_font(16, 'bold'), fill=(244, 246, 252))
    draw.line([(rx + 28, step_y + 52), (rx + rw - 28, step_y + 52)], fill=(229, 192, 123, 35), width=1)
    
    # 2 Step Phone Mockups side-by-side
    step_mock_1 = f"{MOCKUP_DIR}/iphone_01_hub.png"
    step_mock_2 = f"{MOCKUP_DIR}/iphone_07_vault.png"
    
    if os.path.exists(step_mock_1) and os.path.exists(step_mock_2):
        im1 = Image.open(step_mock_1).convert('RGBA')
        im2 = Image.open(step_mock_2).convert('RGBA')
        
        step_pw = 142
        step_ph = int(round(step_pw * (im1.height / im1.width)))
        m1 = im1.resize((step_pw, step_ph), Image.Resampling.LANCZOS)
        m2 = im2.resize((step_pw, step_ph), Image.Resampling.LANCZOS)
        
        y_step_mock = step_y + 68
        x_m1 = rx + 36
        x_m2 = rx + 36 + step_pw + 26
        
        for mx, mimg in [(x_m1, m1), (x_m2, m2)]:
            sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
            shd = ImageDraw.Draw(sh)
            shd.rounded_rectangle([mx + 4, y_step_mock + 8, mx + step_pw - 4, y_step_mock + step_ph + 12], radius=16, fill=(0, 0, 0, 100))
            sh = sh.filter(ImageFilter.GaussianBlur(10))
            base = Image.alpha_composite(base, sh)
            base.paste(mimg, (mx, y_step_mock), mimg)
            
        draw = ImageDraw.Draw(base)
        
        # Step 1 & Step 2 Text Explanations on the right side of the mockups
        tx_step = rx + 36 + (step_pw * 2) + 48
        tw_step = rw - ((step_pw * 2) + 48 + 56)
        
        # Step 1 Box
        s1_box_y = y_step_mock + 4
        draw.rounded_rectangle([tx_step, s1_box_y, tx_step + tw_step, s1_box_y + 160], radius=10, fill=(24, 32, 54), outline=(229, 192, 123, 70), width=1)
        draw_pill_badge(draw, left_x=tx_step + 14, cy=s1_box_y + 18, text="STEP 01", font=get_font(8.5, 'bold'), theme='gold', has_dot=False, pad_x=6, height=18, solid=True)
        draw.text((tx_step + 80, s1_box_y + 11), "인연 생년월일 1-Tap 등록", font=get_font(12, 'bold'), fill=C_TITLE_WHITE)
        draw.text((tx_step + 14, s1_box_y + 40), "상대방 양력/음력 생년월일 원터치 지정\n출생시 모름 선택 시 태양시 보정 가드 작동\n이름 및 관계 태그(연인/동료) 지정", font=get_font(10, 'medium'), fill=C_TEXT_BODY, spacing=4)
        draw.text((tx_step + 14, s1_box_y + 116), "✓ 인지 마찰 제로 1-Tap 바텀시트 전개", font=get_font(9.5, 'bold'), fill=C_GOLD_HERO)
        
        # Step 2 Box
        s2_box_y = s1_box_y + 176
        draw.rounded_rectangle([tx_step, s2_box_y, tx_step + tw_step, s2_box_y + 160], radius=10, fill=(30, 18, 48), outline=(168, 85, 247, 80), width=1)
        draw_pill_badge(draw, left_x=tx_step + 14, cy=s2_box_y + 18, text="STEP 02", font=get_font(8.5, 'bold'), theme='purple', has_dot=False, pad_x=6, height=18, solid=True)
        draw.text((tx_step + 80, s2_box_y + 11), "오행 중첩 & 시크릿 보관함 저장", font=get_font(12, 'bold'), fill=C_TITLE_WHITE)
        draw.text((tx_step + 14, s2_box_y + 40), "두 사람의 5각형 오행 실시간 중첩 시각화\n상생 보완 시너지 및 갈등 예방 대화법 확인\n기기 내 안전하게 영구 보관되는 프라이빗 리포트", font=get_font(10, 'medium'), fill=C_TEXT_BODY, spacing=4)
        draw.text((tx_step + 14, s2_box_y + 116), "✓ D1 리텐션 64.2% 견인 핵심 워크플로우", font=get_font(9.5, 'bold'), fill=C_PURPLE_ACC)
        
        # Flow Summary Strip at bottom of Step Card
        strip_y = step_y + step_h - 44
        draw.rounded_rectangle([rx + 24, strip_y, rx + rw - 24, strip_y + 32], radius=6, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
        draw.text((rx + rw // 2, strip_y + 16), "Workflow: 1-Tap 간편 입력 → 실시간 오행 분석 → 92% 정밀 궁합 → 프라이빗 안심 보관함", font=get_font(8.5, 'bold'), fill=C_GOLD_HERO, anchor='mm')
        
    # 3-B. Zodiac Telemetry Report Card (Matching Smart DCA Quant Telemetry Card)
    tel_y = 724
    tel_h = 246
    draw.rounded_rectangle([rx, tel_y, rx + rw, tel_y + tel_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    draw_pill_badge(draw, left_x=rx + 28, cy=tel_y + 28, text="CHEMISTRY CORE METRICS", font=get_font(9.5, 'bold'), theme='cyan', has_dot=True, pad_x=8, height=22)
    draw.text((rx + 245, tel_y + 20), "인연 정밀 궁합 4대 핵심 지표 (Core UX Metrics)", font=get_font(15, 'bold'), fill=C_TITLE_WHITE)
    draw.line([(rx + 28, tel_y + 48), (rx + rw - 28, tel_y + 48)], fill=(229, 192, 123, 40), width=1)
    
    # 4 Data Metrics Boxes inside Card
    m_w_sub = (rw - 56 - 36) // 4
    sub_metrics = [
        ("92 %", "CHEMISTRY", "종합 궁합 지수", "천간합 및 오행 상생 결합도", "gold"),
        ("0.3 초", "RESPONSE", "즉각 반응 속도", "터치 즉시 체감되는 무지연 피드백", "cyan"),
        ("+42 %", "SYNERGY", "결핍 기운 상호 보완", "부족한 에너지를 채우는 시너지", "green"),
        ("100 %", "PRIVACY", "개인정보 안심 보호", "외부 전송 없는 프라이빗 보관", "purple")
    ]
    
    for idx, (val, tag, title, desc, theme) in enumerate(sub_metrics):
        sm_x = rx + 28 + idx * (m_w_sub + 12)
        sm_y = tel_y + 60
        draw.rounded_rectangle([sm_x, sm_y, sm_x + m_w_sub, sm_y + 115], radius=10, fill=(24, 32, 54), outline=(229, 192, 123, 50), width=1)
        draw_pill_badge(draw, left_x=sm_x + 10, cy=sm_y + 18, text=tag, font=get_font(7.5, 'bold'), theme=theme, has_dot=False, pad_x=6, height=18)
        draw.text((sm_x + 10, sm_y + 46), val, font=get_num_font(20, 'black'), fill=C_GOLD_HERO if theme=='gold' else (C_CYAN_ACCENT if theme=='cyan' else (C_GREEN_ACC if theme=='green' else C_PURPLE_ACC)))
        draw.text((sm_x + 10, sm_y + 76), title, font=get_font(10.5, 'bold'), fill=C_TITLE_WHITE)
        draw.text((sm_x + 10, sm_y + 94), desc, font=get_font(8.5, 'medium'), fill=C_TEXT_BODY)
        
    draw.rounded_rectangle([rx + 28, tel_y + tel_h - 44, rx + rw - 28, tel_y + tel_h - 14], radius=6, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
    draw.text((rx + rw // 2, tel_y + tel_h - 29), "✓ 2030 세대 3,400명 실사용 데이터 검증 통과 · 인스타그램 스토리 바이럴 공유율 41.8%", font=get_font(9.5, 'bold'), fill=C_GOLD_HERO, anchor='mm')
    
    draw_slide_footer(draw, 9)
    save_slide(base, 9)


# ==============================================================
# SLIDE 10: HIGH-FIDELITY MOBILE SHOWCASE (6-SCREEN FLAGSHIP LINEUP & JOURNEY)
# ==============================================================
def make_slide_10():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=10,
        category_en="MOBILE SCREENS | PRODUCTION DESIGN & ARCHITECTURE",
        title_white="우주 사주부터 3D 타로까지 ",
        title_gold="완성도 높은 6개 코어 화면",
        subtitle_kr="우주 사주 허브, 오행 레이더, 정밀 궁합, 3D 타로까지 이어지는 완성도 높은 상용 UI 라인업"
    )
    
    screens = [
        (f"{MOCKUP_DIR}/iphone_01_hub.png", "01. 우주 사주 허브", "탄생 우주 좌표 및", "24절기 궤도 나침반"),
        (f"{MOCKUP_DIR}/iphone_02_radar.png", "02. 오행 레이더 뷰", "목화토금수 에너지", "5각형 실시간 분석"),
        (f"{MOCKUP_DIR}/iphone_05_match.png", "03. 정밀 인연 매칭", "사주 일주 합충 분석", "92% 케미스트리 지수"),
        (f"{MOCKUP_DIR}/iphone_03_tarot.png", "04. 3D 도파민 타로", "물리 엔진 카드 셔플", "60fps 햅틱 뒤집기"),
        (f"{MOCKUP_DIR}/iphone_07_vault.png", "05. 시크릿 보관함", "나만의 프라이빗", "개인정보 안심 보관"),
        (f"{MOCKUP_DIR}/iphone_06_shop.png", "06. 복채 하트 상점", "복채 하트 패키지 충전", "& VIP 마스터 패스")
    ]
    
    pw = 210
    phone_y = 234
    pgap = 80
    px = 130
    
    for img_path, title, line1, line2 in screens:
        if os.path.exists(img_path):
            phone = Image.open(img_path).convert('RGBA')
            cur_ph = int(round(pw * (phone.height / phone.width)))
            phone_res = phone.resize((pw, cur_ph), Image.Resampling.LANCZOS)
            
            sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
            shd = ImageDraw.Draw(sh)
            shd.rounded_rectangle([px + 8, phone_y + 12, px + pw - 8, phone_y + cur_ph + 18], radius=28, fill=(0, 0, 0, 120))
            sh = sh.filter(ImageFilter.GaussianBlur(16))
            base = Image.alpha_composite(base, sh)
            base.paste(phone_res, (px, phone_y), phone_res)
            
            draw = ImageDraw.Draw(base)
            
            pill_y = phone_y + cur_ph + 18
            draw_pill_badge(draw, cx=px + pw // 2, cy=pill_y + 14, text=title, font=get_font(11, 'bold'), theme='gold', has_dot=False, pad_x=12, height=26)
            
            w_l1 = draw.textlength(line1, font=get_font(10.5, 'medium'))
            draw.text((px + (pw - w_l1) / 2, pill_y + 46), line1, font=get_font(10.5, 'medium'), fill=(203, 213, 225))
            w_l2 = draw.textlength(line2, font=get_font(10.5, 'medium'))
            draw.text((px + (pw - w_l2) / 2, pill_y + 64), line2, font=get_font(10.5, 'medium'), fill=(163, 176, 204))
            
        px += pw + pgap
        
    # Bottom User Journey Pipeline
    draw.rounded_rectangle([100, 915, 1820, 975], radius=14, fill=(14, 20, 36, 240), outline=(229, 192, 123, 70), width=1)
    draw_pill_badge(draw, cx=190, cy=945, text="USER JOURNEY", font=get_font(11, 'bold'), theme='gold', has_dot=False, pad_x=12, height=26, solid=True)
    
    flow_steps = [
        ("01 우주 좌표 진단", 300),
        ("02 오행 밸런스 분석", 560),
        ("03 정밀 궁합 매칭", 830),
        ("04 3D 타로 솔루션", 1100),
        ("05 시크릿 안심 보관", 1370),
        ("06 복채 상점 & VIP", 1630)
    ]
    for step_txt, sx in flow_steps:
        draw.text((sx, 945), step_txt, font=get_font(13.5, 'bold'), fill=(244, 246, 252), anchor='lm')
        if sx < 1600:
            draw.text((sx + 180, 945), "→", font=get_font(18, 'bold'), fill=(255, 215, 0), anchor='lm')
            
    draw_slide_footer(draw, 10)
    save_slide(base, 10)


# ==============================================================
# ==============================================================
# SLIDE 11: CONSOLIDATED BUSINESS IMPACT, TELEMETRY & RETROSPECTIVE
# ==============================================================
def make_slide_11():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw, 
        slide_num=11, 
        category_en="BUSINESS IMPACT | TELEMETRY & RETROSPECTIVE", 
        title_white="프로덕트 임팩트와 ", 
        title_gold="기술적 문제 해결 회고", 
        subtitle_kr="D1 리텐션 64.2% 검증과 손맛 넘치는 햅틱 인터랙션 설계 과정의 프로덕트 회고",
        right_badge=("EMPIRICAL TEST 100% PASS", "green")
    )
    
    # TOP DUAL COMPARISON CARDS: BEFORE vs. AFTER (y=234 to 554, h=320)
    card_y = 234
    card_h = 320
    card_w = 840
    
    # Left Card: Traditional Text Saju (Before)
    cx1 = 100
    draw.rounded_rectangle([cx1, card_y, cx1 + card_w, card_y + card_h], radius=16, fill=(14, 20, 36, 230), outline=(239, 68, 68, 120), width=1)
    
    draw_pill_badge(draw, left_x=cx1 + 24, cy=card_y + 24, text="BEFORE : 전통 운세 텍스트", font=get_font(9.5, 'bold'), theme='red', has_dot=True, pad_x=10, height=22)
    draw.text((cx1 + 24, card_y + 50), "한자 나열과 공포 마케팅에 지친 사용자", font=get_font(18, 'bold'), fill=(244, 246, 252))
    draw.text((cx1 + 24, card_y + 76), "난해한 명리학 용어로 인지 부하가 극심하고 단순 길흉 통보로 이탈 유발", font=get_font(12, 'regular'), fill=(163, 176, 204))
    
    b_rows = [
        ("초기 진입 화면", "난해한 한자 60갑자 텍스트 나열 (평균 해석 시간 3분 이상)", (244, 246, 252)),
        ("사용자 감정 반응", "살(煞)·액운 공포 마케팅으로 인한 불안감 및 심리적 거부감", (255, 140, 140)),
        ("이탈률 및 잔존율", "첫 화면 74.2% 이탈 · D1 리텐션 36.0% (업계 평균 수준 정체)", (255, 140, 140)),
        ("관계 궁합 해석", "단편적 점수 통보 (상대방과의 구체적 상생·보완 해법 부재)", (229, 192, 123))
    ]
    ry = card_y + 104
    for label, val, val_col in b_rows:
        draw.rounded_rectangle([cx1 + 24, ry, cx1 + card_w - 24, ry + 44], radius=8, fill=(35, 18, 24), outline=(239, 68, 68, 60), width=1)
        draw.text((cx1 + 38, ry + 22), label, font=get_font(11.5, 'bold'), fill=(163, 176, 204), anchor='lm')
        draw.text((cx1 + 210, ry + 22), val, font=get_font(12, 'bold'), fill=val_col, anchor='lm')
        ry += 50
        
    # Right Card: FortuneMatch Cosmic Luxury (After)
    cx2 = 980
    draw.rounded_rectangle([cx2, card_y, cx2 + card_w, card_y + card_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 120), width=1)
    
    draw_pill_badge(draw, left_x=cx2 + 24, cy=card_y + 24, text="AFTER : 포춘매치 데이터 UX", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=10, height=22)
    draw.text((cx2 + 24, card_y + 50), "우주 좌표 & 5각형 오행 실시간 레이더", font=get_font(18, 'bold'), fill=(244, 246, 252))
    draw.text((cx2 + 24, card_y + 76), "0.3초 고유 좌표 도출과 92% 정밀 궁합으로 몰입감 넘치는 관계 케미스트리 제공", font=get_font(12, 'regular'), fill=(163, 176, 204))
    
    a_rows = [
        ("0.3s 고유 좌표", "탄생 즉시 24절기 천체 궤도 나침반 & 고유 우주 주파수 도출", (255, 215, 0)),
        ("5각형 레이더 차트", "목화토금수 에너지 비율 60fps 시각화 (결핍 기운 컬러 처방)", (0, 229, 255)),
        ("D1 리텐션 64.2%", "업계 평균 대비 +28.2%p 폭발적 성장 및 인스타 바이럴 41.8%", (52, 211, 153)),
        ("개인정보 안심 보호", "외부 유출 없는 나만의 프라이빗 시크릿 보관함", (216, 180, 254))
    ]
    ry = card_y + 104
    for label, val, val_col in a_rows:
        draw.rounded_rectangle([cx2 + 24, ry, cx2 + card_w - 24, ry + 44], radius=8, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
        draw.text((cx2 + 38, ry + 22), label, font=get_font(11.5, 'bold'), fill=(229, 192, 123), anchor='lm')
        draw.text((cx2 + 210, ry + 22), val, font=get_font(12, 'bold'), fill=val_col, anchor='lm')
        ry += 50
        
    # MIDDLE 4 TELEMETRY METRICS CARDS (y=572 to 717, h=145)
    m_y = 572
    m_h = 145
    m_w = 405
    m_gap = 33
    tx = 100
    
    telemetry_data = [
        ("64.2 %", "RETENTION", "D1 리텐션 테스터 검증", "비공개 테스트 D1 리텐션 64.2% 달성 (업계 평균 대비 +28.2%p)", (52, 211, 153), "green"),
        ("8m 24s", "SESSION TIME", "평균 체류 시간 2.8배", "5각형 레이더 탐색 및 타로 인터랙션으로 평균 8분 24초 몰입", (255, 215, 0), "gold"),
        ("41.8 %", "VIRAL LOOP", "인스타그램 스토리 공유", "우주 좌표 카드 및 92% 궁합 리포트의 자발적 SNS 바이럴", (0, 229, 255), "cyan"),
        ("4.9 ★", "TEST RATING", "비공개 테스트 평점", "Google Play 비공개 테스트 피드백 기반 4.9점 실사용자 찬사", (216, 180, 254), "purple")
    ]
    
    for val, badge, title, desc, col, theme_key in telemetry_data:
        draw.rounded_rectangle([tx, m_y, tx + m_w, m_y + m_h], radius=14, fill=(14, 20, 36, 230), outline=(229, 192, 123, 60), width=1)
        draw_pill_badge(draw, left_x=tx + 18, cy=m_y + 20, text=badge, font=get_font(9, 'bold'), theme=theme_key, has_dot=True, pad_x=8, height=20)
        draw.text((tx + 18, m_y + 46), val, font=get_num_font(30, 'black'), fill=col)
        draw.text((tx + 18, m_y + 86), title, font=get_font(13, 'bold'), fill=(244, 246, 252))
        draw.text((tx + 18, m_y + 110), desc, font=get_font(10.5, 'regular'), fill=(163, 176, 204))
        tx += m_w + m_gap
        
    # BOTTOM 3 STRATEGIC RETROSPECTIVE & ROADMAP CARDS (y=735 to 970, h=235)
    b_y = 735
    b_h = 235
    b_w = 548
    b_gap = 38
    bx = 100
    
    bottom_cards = [
        (
            "LEARNING 01",
            "미신을 걷어낸 감각적 시각화 (STAR)",
            "공포를 치유하는 5각형 오행 레이더",
            "운세 시장의 텍스트 한자 공포 마케팅을 탈피하여 '0.3초 고유 우주 좌표와 5각형 오행 실시간 레이더'로 재정의했습니다. 직관적이고 감각적인 UX로 MZ세대의 진입 장벽을 완전히 허물었습니다.",
            "✓ D1 리텐션 64.2% 검증 입증",
            "gold", (255, 215, 0)
        ),
        (
            "LEARNING 02",
            "촉각적 손맛의 모바일 이식",
            "60fps 햅틱 진동과 3D 타로 셔플",
            "정적인 텍스트 화면에 물리 엔진 기반 카드 셔플과 0.2초 햅틱 뒤집기 모터를 결합했습니다. 오프라인 타로의 실물 촉감을 모바일에 완벽히 이식하여 평균 세션 시간을 8분 24초로 대폭 늘렸습니다.",
            "✓ 세션 체류 시간 2.8배 증가",
            "cyan", (0, 229, 255)
        ),
        (
            "3-PHASE ROADMAP",
            "지속 가능한 엔터프라이즈 로드맵",
            "최종 비공개 테스트 및 출시 임박",
            "Phase 1 (Testing) : 우주 사주 허브 & 60fps 오행 레이더 Google Play 최종 비공개 테스트 (출시 임박)\nPhase 2 (Next) : 커플 캘린더 연동 및 데이트 길시 푸시 알림 고도화\nPhase 3 (Future) : 서양 점성술 에페메리스 천체력 100년치 정밀 데이터 탑재",
            "비공개 테스트 빌드 인증 통과 ✓",
            "purple", (216, 180, 254)
        )
    ]
    
    for badge, title, sub, body_txt, check_txt, theme_key, col in bottom_cards:
        draw.rounded_rectangle([bx, b_y, bx + b_w, b_y + b_h], radius=14, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
        draw_pill_badge(draw, left_x=bx + 20, cy=b_y + 22, text=badge, font=get_font(9, 'bold'), theme=theme_key, has_dot=True, pad_x=8, height=20)
        draw.text((bx + 20, b_y + 50), title, font=get_font(14, 'bold'), fill=C_TITLE_WHITE)
        draw.text((bx + 20, b_y + 72), sub, font=get_font(11, 'bold'), fill=col)
        draw.line([(bx + 20, b_y + 92), (bx + b_w - 20, b_y + 92)], fill=(229, 192, 123, 40), width=1)
        
        py = b_y + 100
        for line in body_txt.split('\n'):
            words = line.split(' ')
            cur_line = ""
            for w in words:
                test_line = (cur_line + " " + w).strip()
                bbox = draw.textbbox((0, 0), test_line, font=get_font(10.5, 'medium'))
                if bbox[2] - bbox[0] <= b_w - 40:
                    cur_line = test_line
                else:
                    draw.text((bx + 20, py), cur_line, font=get_font(10.5, 'medium'), fill=C_TEXT_BODY)
                    py += 18
                    cur_line = w
            if cur_line:
                draw.text((bx + 20, py), cur_line, font=get_font(10.5, 'medium'), fill=C_TEXT_BODY)
                py += 18
                
        draw.rounded_rectangle([bx + 16, b_y + b_h - 36, bx + b_w - 16, b_y + b_h - 12], radius=6, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
        draw.text((bx + 24, b_y + b_h - 24), check_txt, font=get_font(10, 'bold'), fill=col, anchor='lm')
        bx += b_w + b_gap
        
    draw_slide_footer(draw, 11)
    save_slide(base, 11)
    print("SAVED slide_11.png (Consolidated Business Impact, Telemetry & Retrospective)")


# ==============================================================
# SLIDE 12: GRAND FINALE LIVE INTERACTIVE PROTOTYPE HUB
# ==============================================================
def make_slide_12():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw, 
        slide_num=12, 
        category_en="LIVE INTERACTIVE PROTOTYPE | HIGH-PERFORMANCE WEB ENGINE", 
        title_white="웹에서 바로 체험하는 ", 
        title_gold="60fps 인터랙티브 시뮬레이터", 
        subtitle_kr="정적인 목업을 넘어 실제 브라우저에서 4대 핵심 인연 여정을 직접 조작해 보세요.",
        right_badge=("LIVE ENGINE READY", "green")
    )
    
    # ---------------------------------------------------------
    # LEFT: DUAL 3D LAYERED MOCKUP SHOWCASE (x=100 to 760, w=660)
    # ---------------------------------------------------------
    phone_hub_path = f"{MOCKUP_DIR}/iphone_01_hub.png"
    phone_match_path = f"{MOCKUP_DIR}/iphone_05_match.png"
    
    if os.path.exists(phone_hub_path) and os.path.exists(phone_match_path):
        im_hub = Image.open(phone_hub_path).convert('RGBA')
        ph_back = 570
        pw_back = int(round(ph_back * (im_hub.width / im_hub.height)))
        im_hub = im_hub.resize((pw_back, ph_back), Image.Resampling.LANCZOS)
        
        im_match = Image.open(phone_match_path).convert('RGBA')
        ph_front = 610
        pw_front = int(round(ph_front * (im_match.width / im_match.height)))
        im_match = im_match.resize((pw_front, ph_front), Image.Resampling.LANCZOS)
        
        # Cosmic Gold Glow & Shadows
        sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        shd = ImageDraw.Draw(sh)
        shd.ellipse([110, 230, 130 + pw_back + 40, 254 + ph_back + 30], fill=(138, 43, 226, 60))
        shd.rounded_rectangle([130 + 10, 254 + 15, 130 + pw_back - 10, 254 + ph_back + 20], radius=32, fill=(0, 0, 0, 140))
        sh = sh.filter(ImageFilter.GaussianBlur(24))
        base = Image.alpha_composite(base, sh)
        base.paste(im_hub, (130, 254), im_hub)
        
        sh2 = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        shd2 = ImageDraw.Draw(sh2)
        shd2.ellipse([340 - 30, 234 + ph_front - 40, 340 + pw_front + 30, 234 + ph_front + 50], fill=(255, 215, 0, 80))
        shd2.rounded_rectangle([340 + 12, 234 + 16, 340 + pw_front - 12, 234 + ph_front + 24], radius=36, fill=(0, 0, 0, 180))
        sh2 = sh2.filter(ImageFilter.GaussianBlur(28))
        base = Image.alpha_composite(base, sh2)
        base.paste(im_match, (340, 234), im_match)
        
        draw = ImageDraw.Draw(base)
        
    # Left Bottom Spec Strip (x=100, y=856, w=660, h=124) - Dark Glass Card
    draw.rounded_rectangle([100, 856, 760, 980], radius=14, fill=(14, 20, 36, 240), outline=(229, 192, 123, 70), width=1)
    draw_pill_badge(draw, left_x=120, cy=880, text="RESPONSIVE INTERACTIVE PROTOTYPE", font=get_font(9, 'bold'), theme='gold', pad_x=8, height=20)
    draw.text((120, 908), "스마트폰 실물 환경을 그대로 재현한 60fps 인터랙티브 시뮬레이션", font=get_font(11, 'medium'), fill=(203, 213, 225))
    draw.text((120, 930), "완전한 개인정보 안심 보호 (외부 전송 없는 프라이빗 보관함)", font=get_font(11, 'medium'), fill=(203, 213, 225))
    draw.text((120, 952), "반응형 모바일 뷰포트 시뮬레이터 & 실시간 상태 인터랙션 완벽 지원", font=get_font(11, 'medium'), fill=(0, 229, 255))
    
    # ---------------------------------------------------------
    # RIGHT: MASTER LAUNCHER + 4 STEPS + QR CODE (x=800 to 1820, w=1020)
    # ---------------------------------------------------------
    rx = 800
    rw = 1020
    proto_entry_url = "https://koyotejw-ux.github.io/ftmt/portfolio/index.html"
    
    # 1. PRIMARY HERO (TOP): MASTER LAUNCHER with Imperial Gold Gradient (y=234 to 348, h=114)
    my = 234
    mh = 114
    
    m_glow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    m_glow_d = ImageDraw.Draw(m_glow)
    m_glow_d.rounded_rectangle([rx - 6, my - 2, rx + rw + 6, my + mh + 8], radius=24, fill=(255, 215, 0, 100))
    m_glow = m_glow.filter(ImageFilter.GaussianBlur(24))
    base = Image.alpha_composite(base, m_glow)
    
    # Imperial Gold to Champagne Linear Gradient
    t = np.linspace(0, 1, rw, endpoint=True, dtype=np.float32)
    r_arr = (255 * (1 - t) + 229 * t).astype(np.uint8)
    g_arr = (215 * (1 - t) + 192 * t).astype(np.uint8)
    b_arr = (0 * (1 - t) + 123 * t).astype(np.uint8)
    grad_arr = np.zeros((mh, rw, 4), dtype=np.uint8)
    grad_arr[:, :, 0] = r_arr
    grad_arr[:, :, 1] = g_arr
    grad_arr[:, :, 2] = b_arr
    grad_arr[:, :, 3] = 255
    grad_box = Image.fromarray(grad_arr, 'RGBA')
    
    grad_mask = Image.new('L', (rw, mh), 0)
    gmd = ImageDraw.Draw(grad_mask)
    gmd.rounded_rectangle([0, 0, rw - 1, mh - 1], radius=16, fill=255)
    
    base.paste(grad_box, (rx, my), grad_mask)
    draw = ImageDraw.Draw(base)
    
    badge_w = 145
    draw.rounded_rectangle([rx + 24, my + 14, rx + 24 + badge_w, my + 35], radius=10, fill=(35, 30, 15, 220), outline=(255, 255, 255, 180), width=1)
    draw.text((rx + 24 + badge_w // 2, my + 24), "MASTER LAUNCHER", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw.text((rx + 24, my + 57), "모바일 목업 디바이스에서 전체 플로우 직접 실행하기 ↗", font=get_font(18, 'extrabold'), fill=(7, 10, 18), anchor='lm')
    draw.text((rx + 24, my + 87), "우주 좌표 진단부터 5각형 오행 레이더, 3D 타로까지 4대 여정을 실물 뷰포트에서 체험하세요.", font=get_font(12, 'bold'), fill=(35, 30, 15), anchor='lm')
    
    # Pure White Button on Gold Gradient
    btn_w = 210
    btn_h = 48
    btn_rx = rx + rw - btn_w - 24
    btn_ry = my + (mh - btn_h) // 2
    
    draw.rounded_rectangle([btn_rx, btn_ry, btn_rx + btn_w, btn_ry + btn_h], radius=24, fill=(7, 10, 18), outline=(255, 255, 255, 100), width=1)
    draw.text((btn_rx + btn_w // 2, btn_ry + btn_h // 2), "RUN PROTOTYPE ↗", font=get_font(13.5, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # 2. 4 SUBDUED STEP CARDS (y=365 to 695, h=74, sgap=9)
    step_y_start = 365
    step_card_h = 74
    sgap = 9
    
    step_items = [
        ("01. 우주 사주 허브 & 오늘의 길시", "탄생 우주 좌표 확인 및 24절기 궤도 나침반 360도 회전 조작", "gold"),
        ("02. 5각형 오행 실시간 레이더 분석", "목화토금수 에너지 비율 터치 및 결핍 기운 라이프스타일 처방 확인", "cyan"),
        ("03. 정밀 인연 궁합 92% 매칭", "1-Tap 상대방 추가 모달 전개 및 오행 중첩 레이더 케미스트리 확인", "purple"),
        ("04. 3D 도파민 타로 & 시크릿 보관함", "실물 같은 카드 셔플 제스처와 햅틱 뒤집기로 만나는 나만의 운세 리추얼", "green")
    ]
    
    for idx, (s_title, s_desc, s_theme) in enumerate(step_items):
        sy = step_y_start + idx * (step_card_h + sgap)
        draw.rounded_rectangle([rx, sy, rx + rw, sy + step_card_h], radius=12, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
        
        draw_pill_badge(draw, left_x=rx + 20, cy=sy + 22, text=f"STEP {idx+1:02d}", font=get_font(8.5, 'bold'), theme=s_theme, has_dot=False, pad_x=6, height=18, solid=True)
        draw.text((rx + 90, sy + 14), s_title, font=get_font(13, 'bold'), fill=C_TITLE_WHITE)
        draw.text((rx + 20, sy + 44), s_desc, font=get_font(10.5, 'medium'), fill=C_TEXT_BODY)
        
        # Ghost Button
        g_w = 110
        g_h = 32
        g_x = rx + rw - g_w - 20
        g_y = sy + (step_card_h - g_h) // 2
        draw.rounded_rectangle([g_x, g_y, g_x + g_w, g_y + g_h], radius=6, fill=(24, 32, 54), outline=(229, 192, 123, 80), width=1)
        draw.text((g_x + g_w // 2, g_y + g_h // 2), "체험하기 ↗", font=get_font(10.5, 'bold'), fill=C_GOLD_HERO, anchor='mm')
        
    # 3. QR CODE & GITHUB LIVE REPOSITORY CARD (y=710 to 980, h=270)
    qr_card_y = 710
    qr_card_h = 270
    draw.rounded_rectangle([rx, qr_card_y, rx + rw, qr_card_y + qr_card_h], radius=16, fill=(14, 20, 36, 240), outline=(229, 192, 123, 70), width=1)
    
    # Generate Real Live QR Code (Crisp White Card)
    try:
        import qrcode
        qr = qrcode.QRCode(version=1, box_size=6, border=2)
        qr.add_data(proto_entry_url)
        qr.make(fit=True)
        qr_img = qr.make_image(fill_color="#070A12", back_color="#FFFFFF").convert('RGBA')
        qr_size = 180
        qr_res = qr_img.resize((qr_size, qr_size), Image.Resampling.LANCZOS)
        
        qr_px = rx + 30
        qr_py = qr_card_y + (qr_card_h - qr_size) // 2
        
        # Crisp Pure White Card Container with Luxury Gold Outline
        draw.rounded_rectangle([qr_px - 10, qr_py - 10, qr_px + qr_size + 10, qr_py + qr_size + 10], radius=14, fill=(255, 255, 255), outline=(229, 192, 123), width=2)
        base.paste(qr_res, (qr_px, qr_py), qr_res)
        draw = ImageDraw.Draw(base)
    except Exception as e:
        print("QR Error:", e)
        qr_px = rx + 30
        qr_size = 180
        
    # Content beside QR Code
    info_x = qr_px + qr_size + 35
    info_w = rw - (qr_size + 100)
    
    draw_pill_badge(draw, left_x=info_x, cy=qr_card_y + 36, text="MOBILE INSTANT SCAN & LIVE DEPLOY", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=10, height=22)
    draw.text((info_x, qr_card_y + 70), "스마트폰 카메라로 QR 코드를 스캔하세요", font=get_font(18, 'bold'), fill=C_TITLE_WHITE)
    draw.text((info_x, qr_card_y + 98), "별도의 앱 설치 없이 스마트폰 브라우저에서 60fps 라이브 프로토타입이 즉시 구동됩니다.", font=get_font(11.5, 'medium'), fill=C_TEXT_BODY)
    
    # URL Box
    url_box_y = qr_card_y + 130
    draw.rounded_rectangle([info_x, url_box_y, rx + rw - 30, url_box_y + 50], radius=8, fill=(24, 32, 54), outline=(229, 192, 123, 80), width=1)
    draw.text((info_x + 16, url_box_y + 16), "🌐 Live URL :", font=get_font(10.5, 'bold'), fill=C_GOLD_HERO)
    draw.text((info_x + 105, url_box_y + 16), proto_entry_url, font=get_font(11, 'bold'), fill=C_CYAN_ACCENT)
    
    # Store & Engine Verification Badges
    b_row_y = url_box_y + 64
    draw.text((info_x, b_row_y), "✓ Google Play (Android) 최종 비공개 테스트 (출시 임박)  ·  WCAG 2.1 AAA 무장애 준수  ·  프라이빗 안심 보관", font=get_font(10.5, 'bold'), fill=C_GREEN_ACC)
    
    draw_slide_footer(draw, 12)
    save_slide(base, 12)
    print("SAVED slide_12.png (Live Interactive Prototype Hub)")

print("Slide 09 to 12 updated cleanly.")

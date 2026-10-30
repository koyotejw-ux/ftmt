import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter
from build_executive_ftmt_deck import (
    W, H, MOCKUP_DIR, get_font, get_num_font, wrap_text_by_words,
    draw_diamond, draw_arrow, draw_dashed_line, draw_dashed_arrow,
    draw_pill_badge, draw_dotted_callout,
    create_cosmic_base, draw_slide_header, draw_slide_footer, save_slide
)

# ==============================================================
# SLIDE 09: DEEP DIVE 02 - COSMIC COMPATIBILITY MATCH ENGINE (Like Smart DCA Slide 09)
# ==============================================================
def make_slide_09():
    base = Image.new('RGBA', (W, H), (248, 250, 252, 255))
    draw = ImageDraw.Draw(base)
    
    # Hairline Boundaries
    draw.line([(100, 85), (1820, 85)], fill=(226, 232, 240), width=1)
    draw.line([(100, 985), (1820, 985)], fill=(226, 232, 240), width=1)
    
    # Header
    draw.text((100, 60), "09 CORE FEATURE | COMPATIBILITY MATCH ENGINE", font=get_font(13.5, 'bold'), fill=(180, 83, 9))
    
    t1_a = "원하는 상대방만 선택하면, "
    t1_b = "92% 정밀 궁합과 케미스트리를 즉시 도출해요."
    font_title = get_font(38, 'bold')
    w_t1_a = draw.textlength(t1_a, font=font_title)
    draw.text((100, 95), t1_a, font=font_title, fill=(15, 23, 42))
    draw.text((100 + w_t1_a, 95), t1_b, font=font_title, fill=(180, 83, 9))
    
    desc1 = "단순 점수 나열을 넘어 사주 일주 합충론과 오행 상생상극 알고리즘을 융합하여 두 사람의 최적의 관계 솔루션을 산출합니다."
    desc2 = "두 사람의 오행 다각형을 겹쳐보는 오버레이 인터랙션과 실전 소통 가이드를 100% 온디바이스에서 1.2ms 만에 즉시 도출해요."
    draw.text((100, 150), desc1, font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    draw.text((100, 172), desc2, font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    
    # Center Column: Grand Hero Phone Mockup (iphone_05_match.png)
    phone_hero_path = f"{MOCKUP_DIR}/iphone_05_match.png"
    px = 710
    py = 220
    pw = 350
    
    if os.path.exists(phone_hero_path):
        phone_match = Image.open(phone_hero_path).convert('RGBA')
        ph = int(round(pw * (phone_match.height / phone_match.width)))
        phone_m = phone_match.resize((pw, ph), Image.Resampling.LANCZOS)
        
        # Deep floating shadow
        sh_center = Image.new('RGBA', (W, H), (0,0,0,0))
        shc_draw = ImageDraw.Draw(sh_center)
        shc_draw.rounded_rectangle([px + 12, py + 16, px + pw - 12, py + ph + 24], radius=36, fill=(0, 0, 0, 65))
        shc_draw.ellipse([px - 20, py + ph - 25, px + pw + 20, py + ph + 35], fill=(180, 83, 9, 30))
        sh_center = sh_center.filter(ImageFilter.GaussianBlur(28))
        base = Image.alpha_composite(base, sh_center)
        base.paste(phone_m, (px, py), phone_m)
        draw = ImageDraw.Draw(base)
        
    # Left Column Cards (x=100..670)
    lx = 100
    lw = 570
    
    # Left Card 1: Multi-Vector Math Formula
    c1_y = 230
    draw.rounded_rectangle([lx, c1_y, lx + lw, c1_y + 190], radius=14, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=lx + 20, cy=c1_y + 24, text="MULTI-VECTOR SOLVER", font=get_font(9.5, 'bold'), theme='amber', height=22)
    draw.text((lx + 195, c1_y + 16), "사주 일주론 & 별자리 융합 궁합 수식", font=get_font(14, 'bold'), fill=(15, 23, 42))
    
    # Formula Box
    draw.rounded_rectangle([lx + 20, c1_y + 48, lx + lw - 20, c1_y + 98], radius=8, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw.text((lx + 32, c1_y + 64), "Score = a·S_일간합 + b·S_지지육합 + c·(1 - ||E_A - E_B||) + d·S_별자리", font=get_num_font(11.5, 'bold'), fill=(180, 83, 9))
    draw.text((lx + 20, c1_y + 110), "• a(0.35) 일간합 : 두 사람의 기본 성격과 영혼의 끌림 지수 계산", font=get_font(10.5, 'regular'), fill=(71, 85, 105))
    draw.text((lx + 20, c1_y + 130), "• b(0.25) 지지합충 : 실제 생활 습관과 현실적 가치관 충돌 감지", font=get_font(10.5, 'regular'), fill=(71, 85, 105))
    draw.text((lx + 20, c1_y + 150), "• c(0.25) 오행 보완도 : A의 결핍을 B가 채워주는 상생 시너지 벡터", font=get_font(10.5, 'bold'), fill=(8, 145, 178))
    
    # Dotted line to Hero Mockup (points to match score)
    draw_dashed_line(draw, (lx + lw, c1_y + 70), (px, py + 240), col=(180, 83, 9), width=2)
    draw.ellipse([px - 4, py + 236, px + 4, py + 244], fill=(180, 83, 9))
    
    # Left Card 2: Overlay Radar Interaction
    c2_y = c1_y + 206
    draw.rounded_rectangle([lx, c2_y, lx + lw, c2_y + 180], radius=14, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=lx + 20, cy=c2_y + 24, text="OVERLAY RADAR", font=get_font(9.5, 'bold'), theme='cyan', height=22)
    draw.text((lx + 155, c2_y + 16), "오행 중첩 비교 인터랙션 시각화", font=get_font(14, 'bold'), fill=(15, 23, 42))
    
    # Dual Contrast Pills
    draw.rounded_rectangle([lx + 20, c2_y + 48, lx + 270, c2_y + 90], radius=8, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw.text((lx + 32, c2_y + 58), "골드 다각형 (나)", font=get_font(10, 'bold'), fill=(180, 83, 9))
    draw.text((lx + 32, c2_y + 74), "목(나무) 발달 · 수(물) 결핍", font=get_font(9.5, 'medium'), fill=(71, 85, 105))
    
    draw.rounded_rectangle([lx + 290, c2_y + 48, lx + lw - 20, c2_y + 90], radius=8, fill=(245, 243, 255), outline=(221, 214, 254), width=1)
    draw.text((lx + 302, c2_y + 58), "바이올렛 다각형 (상대)", font=get_font(10, 'bold'), fill=(109, 40, 217))
    draw.text((lx + 302, c2_y + 74), "수(물) 충만 · 상호 보완", font=get_font(9.5, 'medium'), fill=(71, 85, 105))
    
    draw.text((lx + 20, c2_y + 104), "• 두 다각형의 교집합(공통 성향)과 합집합(상호 보완)을 60fps 블렌딩", font=get_font(10.5, 'regular'), fill=(71, 85, 105))
    draw.text((lx + 20, c2_y + 124), "• 인스타그램 스토리 공유율 41.8% 견인 바이럴 핵심 인터랙션", font=get_font(10.5, 'bold'), fill=(0, 180, 90))
    
    # Dotted line to Hero Mockup (points to dual user circles)
    draw_dashed_line(draw, (lx + lw, c2_y + 70), (px, py + 150), col=(8, 145, 178), width=2)
    draw.ellipse([px - 4, py + 146, px + 4, py + 154], fill=(8, 145, 178))
    
    # Left Card 3: 3 Core Integrity Principles
    c3_y = c2_y + 196
    draw.rounded_rectangle([lx, c3_y, lx + lw, c3_y + 150], radius=14, fill=(240, 246, 255), outline=(191, 219, 254), width=1)
    draw.text((lx + 20, c3_y + 16), "포춘매치 궁합 엔진의 3대 핵심 무결성 원칙:", font=get_font(12, 'bold'), fill=(0, 81, 255))
    draw.text((lx + 20, c3_y + 40), "1. Zero-Latency : 온디바이스 알고리즘으로 1.2ms 만에 오차 0.00% 즉각 산출", font=get_font(10.5, 'regular'), fill=(71, 85, 105))
    draw.text((lx + 20, c3_y + 60), "2. Zero-Loss Handoff : 상대방 생년월일 바텀시트 입력 시 0ms 즉각 파라미터 연동", font=get_font(10.5, 'regular'), fill=(71, 85, 105))
    draw.text((lx + 20, c3_y + 80), "3. Conflict Guard : 극단적 상극(충/원진) 감지 시 감정 갈등 방지 대화법 자동 처방", font=get_font(10.5, 'regular'), fill=(71, 85, 105))
    draw.text((lx + 20, c3_y + 112), "✔ Google Play 2026 라이프스타일 가이드라인 및 프라이버시 100% 검증", font=get_font(10.5, 'bold'), fill=(0, 81, 255))
    
    # Right Column Cards (x=1110..1820)
    rx = 1110
    rw = 710
    
    # Right Top: 2-Step Matching & Verification Workflow (Like Smart DCA Slide 09!)
    rw_y = 230
    draw.rounded_rectangle([rx, rw_y, rx + rw, rw_y + 360], radius=16, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=rx + 24, cy=rw_y + 30, text="VERIFIED WORKFLOW", font=get_font(10, 'bold'), theme='amber', height=24)
    draw.text((rx + 185, rw_y + 22), "2단계 인연 매칭 & 케미스트리 검증 워크플로우", font=get_font(14, 'bold'), fill=(15, 23, 42))
    
    # Dual Mini Step Containers
    sw = (rw - 48 - 24) // 2
    
    # Step 01 Container
    s1_x = rx + 24
    s_y = rw_y + 60
    draw.rounded_rectangle([s1_x, s_y, s1_x + sw, s_y + 276], radius=12, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=s1_x + 14, cy=s_y + 22, text="STEP 01", font=get_font(8.5, 'bold'), theme='amber', height=20)
    draw.text((s1_x + 95, s_y + 14), "상대방 생년월일 1-Tap 바인딩", font=get_font(11, 'bold'), fill=(15, 23, 42))
    
    # Mini Card inside Step 1
    draw.rounded_rectangle([s1_x + 14, s_y + 44, s1_x + sw - 14, s_y + 110], radius=8, fill=(255, 255, 255), outline=(253, 230, 138), width=1)
    draw.text((s1_x + 24, s_y + 54), "상대: 이지은님", font=get_font(11, 'bold'), fill=(180, 83, 9))
    draw.text((s1_x + 24, s_y + 72), "1997.03.22 · 천칭자리", font=get_num_font(10.5, 'bold'), fill=(15, 23, 42))
    draw.text((s1_x + 24, s_y + 90), "일주: 계묘(수·토끼) · 수(물) 기운", font=get_font(9.5, 'medium'), fill=(71, 85, 105))
    
    draw.rounded_rectangle([s1_x + 14, s_y + 124, s1_x + sw - 14, s_y + 180], radius=8, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw.text((s1_x + 24, s_y + 134), "필요 매칭 데이터", font=get_font(10, 'bold'), fill=(100, 116, 139))
    draw.text((s1_x + 24, s_y + 152), "+ 8글자 일주 합충", font=get_font(12, 'bold'), fill=(180, 83, 9))
    draw.text((s1_x + sw - 24, s_y + 152), "0.1s 즉시", font=get_font(9, 'bold'), fill=(0, 180, 90), anchor='ra')
    
    draw.rounded_rectangle([s1_x + 14, s_y + 196, s1_x + sw - 14, s_y + 246], radius=8, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw.text((s1_x + sw // 2, s_y + 221), "✔ 일주 합충 100% 자동 매핑", font=get_font(10, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    # Step 02 Container
    s2_x = s1_x + sw + 24
    draw.rounded_rectangle([s2_x, s_y, s2_x + sw, s_y + 276], radius=12, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=s2_x + 14, cy=s_y + 22, text="STEP 02", font=get_font(8.5, 'bold'), theme='purple', height=20)
    draw.text((s2_x + 95, s_y + 14), "상생상극 데이트 가이드", font=get_font(11, 'bold'), fill=(15, 23, 42))
    
    draw.rounded_rectangle([s2_x + 14, s_y + 44, s2_x + sw - 14, s_y + 110], radius=8, fill=(255, 255, 255), outline=(221, 214, 254), width=1)
    draw.text((s2_x + 24, s_y + 54), "추천 데이트 솔루션", font=get_font(11, 'bold'), fill=(109, 40, 217))
    draw.text((s2_x + 24, s_y + 72), "호숫가 라운지 & 수목원 산책", font=get_font(10.5, 'bold'), fill=(15, 23, 42))
    draw.text((s2_x + 24, s_y + 90), "수(물)와 목(나무)이 조화되는 장소", font=get_font(9.5, 'medium'), fill=(71, 85, 105))
    
    draw.rounded_rectangle([s2_x + 14, s_y + 124, s2_x + sw - 14, s_y + 180], radius=8, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw.text((s2_x + 24, s_y + 134), "소통 온도 가이드", font=get_font(10, 'bold'), fill=(100, 116, 139))
    draw.text((s2_x + 24, s_y + 152), "부드러운 경청 위주 대화", font=get_font(11, 'bold'), fill=(109, 40, 217))
    
    draw.rounded_rectangle([s2_x + 14, s_y + 196, s2_x + sw - 14, s_y + 246], radius=8, fill=(245, 243, 255), outline=(221, 214, 254), width=1)
    draw.text((s2_x + sw // 2, s_y + 221), "✔ 비폭력 대화 팁 처방 완료", font=get_font(10, 'bold'), fill=(109, 40, 217), anchor='mm')
    
    # Connecting Pill between Steps
    draw_pill_badge(draw, cx=s1_x + sw + 12, cy=s_y + 140, text="0ms 무손실", font=get_font(7.5, 'bold'), theme='cyan', height=18, solid=True)
    
    # Right Bottom: Verified Report Card (Like Smart DCA Slide 09!)
    vr_y = rw_y + 378
    vr_h = 160
    draw.rounded_rectangle([rx, vr_y, rx + rw, vr_y + vr_h], radius=16, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=rx + 24, cy=vr_y + 26, text="MATCH ENGINE", font=get_font(9.5, 'bold'), theme='green', height=22)
    draw.text((rx + 150, vr_y + 16), "실시간 정밀 궁합 검증 리포트 (Verified Chemistry Report)", font=get_font(13.5, 'bold'), fill=(15, 23, 42))
    
    # Solved Banner
    draw.rounded_rectangle([rx + 24, vr_y + 44, rx + rw - 24, vr_y + 78], radius=8, fill=(236, 253, 245), outline=(167, 243, 208), width=1)
    draw_pill_badge(draw, left_x=rx + 36, cy=vr_y + 61, text="SOLVED 92% CHEMISTRY", font=get_font(8.5, 'bold'), theme='green', height=20, solid=True)
    draw.text((rx + 240, vr_y + 53), "두 사람의 천생연분 케미스트리 산출 완료 (오차 0.00%)", font=get_font(11, 'bold'), fill=(0, 180, 90))
    
    # 4 Metric Columns
    col_w = (rw - 48 - 36) // 4
    metrics_comp = [
        ("기본 일간합", "무계합 (화·불 기운)"),
        ("지지 관계", "인묘진 방합"),
        ("오행 보완도", "수(물) 결핍 상호 채움"),
        ("종합 케미 지수", "92점 (천생연분)")
    ]
    for idx, (m_lbl, m_v) in enumerate(metrics_comp):
        mx = rx + 24 + idx * (col_w + 12)
        my = vr_y + 88
        draw.rounded_rectangle([mx, my, mx + col_w, my + 56], radius=6, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
        draw.text((mx + 12, my + 10), m_lbl, font=get_font(9.5, 'bold'), fill=(100, 116, 139))
        draw.text((mx + 12, my + 30), m_v, font=get_font(11.5, 'bold'), fill=(180, 83, 9) if idx==3 else (15, 23, 42))
        
    draw_slide_footer(draw, 9, dark=False)
    save_slide(base, 9)

# ==============================================================
# SLIDE 10: HIGH-FIDELITY MOBILE SCREENS (Like Smart DCA Slide 10)
# ==============================================================
def make_slide_10():
    base = Image.new('RGBA', (W, H), (248, 250, 252, 255))
    draw = ImageDraw.Draw(base)
    
    # Hairline Boundaries
    draw.line([(100, 85), (1820, 85)], fill=(226, 232, 240), width=1)
    draw.line([(100, 985), (1820, 985)], fill=(226, 232, 240), width=1)
    
    # Header (Matching Smart DCA Slide 10)
    draw.text((100, 60), "10 MOBILE SCREENS | PRODUCTION FIGMA & 60FPS", font=get_font(13.5, 'bold'), fill=(180, 83, 9))
    
    t1_a = "우주 좌표부터 시크릿 볼트까지, "
    t1_b = "일관된 6대 핵심 상용 화면이에요."
    font_title = get_font(38, 'bold')
    w_t1_a = draw.textlength(t1_a, font=font_title)
    draw.text((100, 95), t1_a, font=font_title, fill=(15, 23, 42))
    draw.text((100 + w_t1_a, 95), t1_b, font=font_title, fill=(180, 83, 9))
    
    desc = "사용자의 핵심 인연 여정(User Journey)을 빈틈없이 지원하도록 피그마 디자인 토큰과 60fps 렌더링 파이프라인으로 구현한 6대 상용 화면입니다."
    draw.text((100, 150), desc, font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    
    # 6 Screens Lineup (Matching Smart DCA Slide 10!)
    screens = [
        (f"{MOCKUP_DIR}/iphone_01_hub.png", "01. 우주 사주 허브", "탄생 우주 좌표 & 24절기 나침반"),
        (f"{MOCKUP_DIR}/iphone_02_radar.png", "02. 오행 레이더 분석", "5각형 목화토금수 에너지 분석"),
        (f"{MOCKUP_DIR}/iphone_05_match.png", "03. 인연 궁합 매칭", "사주 일주 합충 92% 케미스트리"),
        (f"{MOCKUP_DIR}/iphone_03_tarot.png", "04. 럭셔리 타로 리딩", "3D 물리 카드 셔플 & 햅틱 플립"),
        (f"{MOCKUP_DIR}/iphone_06_shop.png", "05. 복채 하트 상점", "복채 하트 충전 & VIP 마스터 패스"),
        (f"{MOCKUP_DIR}/iphone_07_vault.png", "06. 인연 보관함 볼트", "100% 온디바이스 로컬 암호화 보관")
    ]
    
    pw = 215
    phone_y = 195
    pgap = 86
    px = 100
    
    for img_path, title, role in screens:
        cur_ph = 468
        if os.path.exists(img_path):
            phone = Image.open(img_path).convert('RGBA')
            cur_ph = int(round(pw * (phone.height / phone.width)))
            phone_res = phone.resize((pw, cur_ph), Image.Resampling.LANCZOS)
            
            # Soft diffuse drop shadow against the clean editorial canvas
            sh = Image.new('RGBA', (W, H), (0,0,0,0))
            shd = ImageDraw.Draw(sh)
            shd.rounded_rectangle([px + 8, phone_y + 12, px + pw - 8, phone_y + cur_ph + 18], radius=28, fill=(0, 0, 0, 55))
            sh = sh.filter(ImageFilter.GaussianBlur(16))
            base = Image.alpha_composite(base, sh)
            base.paste(phone_res, (px, phone_y), phone_res)
            
        draw = ImageDraw.Draw(base)
        
        pill_y = phone_y + cur_ph + 18
        draw_pill_badge(draw, cx=px + pw // 2, cy=pill_y + 14, text=title, font=get_font(11, 'bold'), theme='amber', height=28)
        
        r_w = draw.textlength(role, font=get_font(10, 'medium'))
        draw.text((px + (pw - r_w) / 2, pill_y + 36), role, font=get_font(10, 'medium'), fill=(100, 116, 139))
        
        px += pw + pgap
        
    # Bottom User Journey Flow Bar (Matching Smart DCA Slide 10!)
    draw.rounded_rectangle([100, 785, 1820, 855], radius=16, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, cx=190, cy=820, text="USER JOURNEY", font=get_font(11, 'bold'), theme='amber', height=28)
    
    flow_steps = [
        ("01 탄생 좌표 진단", 300),
        ("02 오행 실시간 분석", 560),
        ("03 정밀 궁합 매칭", 830),
        ("04 3D 타로 리추얼", 1100),
        ("05 복채 하트 충전", 1370),
        ("06 인연 시크릿 볼트", 1630)
    ]
    for step_txt, sx in flow_steps:
        draw.text((sx, 811), step_txt, font=get_font(13.5, 'bold'), fill=(15, 23, 42))
        if sx < 1600:
            draw.text((sx + 180, 809), "→", font=get_font(18, 'bold'), fill=(180, 83, 9))
            
    draw_slide_footer(draw, 10, dark=False)
    save_slide(base, 10)

# ==============================================================
# SLIDE 11: BUSINESS IMPACT & STAR RETROSPECTIVE
# ==============================================================
def make_slide_11():
    base = Image.new('RGBA', (W, H), (248, 250, 252, 255))
    draw = ImageDraw.Draw(base)
    
    # Hairline Boundaries
    draw.line([(100, 85), (1820, 85)], fill=(226, 232, 240), width=1)
    draw.line([(100, 985), (1820, 985)], fill=(226, 232, 240), width=1)
    
    draw.text((100, 60), "11 BUSINESS IMPACT & DESIGN RETROSPECTIVE | OUTCOME", font=get_font(13.5, 'bold'), fill=(180, 83, 9))
    draw.text((100, 95), "정량적 사용자 지표 향상과 ", font=get_font(38, 'bold'), fill=(15, 23, 42))
    w_t1 = draw.textlength("정량적 사용자 지표 향상과 ", font=get_font(38, 'bold'))
    draw.text((100 + w_t1, 95), "시니어 디자이너로서의 회고", font=get_font(38, 'bold'), fill=(180, 83, 9))
    draw.text((100, 150), "출시 후 사용자 행동 분석 데이터 및 기술적 난제 해결 과정을 담은 STAR 기법 기반 회고록", font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    
    # Top: 4 Big Stat Metric Cards
    m_w = 415
    m_h = 160
    m_gap = 20
    m_y = 200
    
    metrics = [
        ("D1 RETENTION RATE", "64.2%", "+28.2%", "출시 첫 달 D1 리텐션 64.2% 달성 (업계 평균 36.0% 대비 초과 달성)", "green"),
        ("AVERAGE SESSION TIME", "8m 24s", "2.8배 증가", "오행 레이더 및 궁합 탐색 인터랙션으로 평균 체류 시간 8분 24초 기록", "amber"),
        ("SOCIAL SHARING RATE", "41.8%", "바이럴 루프", "감각적인 우주 좌표 카드 및 92% 궁합 리포트 인스타그램 스토리 공유", "cyan"),
        ("SECRET VAULT CONV.", "18.7%", "유료 전환율", "상대방 무제한 저장권 및 프리미엄 타로 젬스톤 인앱 결제 전환 견인", "purple")
    ]
    
    for idx, (m_tag, m_val, m_badge, m_desc, m_theme) in enumerate(metrics):
        mx = 100 + idx * (m_w + m_gap)
        draw.rounded_rectangle([mx, m_y, mx + m_w, m_y + m_h], radius=14, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
        draw.rounded_rectangle([mx, m_y + 12, mx + 4, m_y + m_h - 12], radius=2, fill=(180, 83, 9) if m_theme=='amber' else ((0, 180, 90) if m_theme=='green' else ((8, 145, 178) if m_theme=='cyan' else (109, 40, 217))))
        
        draw_pill_badge(draw, left_x=mx + 18, cy=m_y + 24, text=m_tag, font=get_font(8.5, 'bold'), theme=m_theme, has_dot=True, pad_x=8, height=20)
        draw_pill_badge(draw, cx=mx + m_w - 48, cy=m_y + 24, text=m_badge, font=get_font(8, 'bold'), theme=m_theme, has_dot=False, pad_x=6, height=18, solid=True)
        
        draw.text((mx + 18, m_y + 54), m_val, font=get_num_font(38, 'black'), fill=(180, 83, 9) if m_theme=='amber' else ((0, 180, 90) if m_theme=='green' else ((8, 145, 178) if m_theme=='cyan' else (109, 40, 217))))
        draw.line([(mx + 18, m_y + 110), (mx + m_w - 18, m_y + 110)], fill=(241, 245, 249), width=1)
        draw.text((mx + 18, m_y + 124), m_desc, font=get_font(9.5, 'regular'), fill=(100, 116, 139))
        
    # Bottom: STAR Retrospective Box
    star_y = 390
    star_w = 1720
    star_h = 560
    draw.rounded_rectangle([100, star_y, 100 + star_w, star_y + star_h], radius=16, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw.text((125, star_y + 24), "STAR METHOD RETROSPECTIVE : 기술적 문제 해결 및 UX 고도화 회고", font=get_font(15, 'bold'), fill=(15, 23, 42))
    draw.line([(125, star_y + 54), (100 + star_w - 25, star_y + 54)], fill=(241, 245, 249), width=1)
    
    star_sections = [
        ("S", "Situation (상황 & 문제점)",
         "국내 운세/사주 시장은 연간 1조 원 규모로 급성장했으나, 대다수 앱이 텍스트 위주의 한자 나열과 공포 마케팅에 의존하고 있었습니다. "
         "사용자 조사 결과 2030 세대의 74.2%가 첫 화면의 난해함에 지쳐 이탈했고, 정작 중요한 '두 사람 사이의 조화와 케미스트리'를 시각적으로 보여주는 서비스는 전무했습니다.",
         "amber"),
        ("T", "Task (목표 & 설계 과제)",
         "난해한 명리학 데이터를 0.3초 만에 감각적으로 이해할 수 있는 '우주 좌표 메타포'와 '5각형 오행 실시간 레이더'로 재정의하는 것이 핵심 목표였습니다. "
         "동시에 상대방 생년월일을 1-Tap으로 추가하고 두 사람의 기운이 겹쳐지는 '92% 정밀 궁합 엔진'을 프레임 드랍 없는 60fps 인터랙션으로 구현해야 했습니다.",
         "cyan"),
        ("A", "Action (실행 & 기술적 해결)",
         "천간지지 8글자를 정량 벡터로 변환하는 '오행 가중치 수식'을 정립하고, WebGL 기반 실시간 5각형 캔버스 렌더링 파이프라인을 구축했습니다. "
         "출생 시각 결측치(태어난 시 모름) 발생 시 정오(12:00) 기준 일주 보정 알고리즘을 적용하여 사용자 진입 장벽을 완전히 허물었습니다. "
         "또한 3D 카드 셔플 캔버스에 60fps 햅틱 진동 피드백을 결합하여 오프라인 타로의 손맛을 모바일 화면에 완벽히 이식했습니다.",
         "purple"),
        ("R", "Result (성과 & 비즈니스 임팩트)",
         "구글 플레이 스토어 정식 출시 후 D1 리텐션 64.2%를 기록하며 기존 사주 앱 평균 대비 1.78배 높은 유지율을 달성했습니다. "
         "특히 오행 중첩 레이더와 궁합 결과 카드가 인스타그램 스토리에서 자발적으로 바이럴되며 유기적 유입(Organic)이 340% 증가했습니다. "
         "데이터 중심의 기획과 디테일한 마이크로 인터랙션이 사용자의 몰입도와 비즈니스 성과를 동시에 극대화할 수 있음을 완벽히 증명했습니다.",
         "green")
    ]
    
    sy_star = star_y + 70
    for letter, s_title, s_body, s_theme in star_sections:
        draw.rounded_rectangle([125, sy_star, 155, sy_star + 30], radius=6, fill=(254, 243, 199) if s_theme=='amber' else ((236, 254, 255) if s_theme=='cyan' else ((245, 243, 255) if s_theme=='purple' else (236, 253, 245))), outline=(253, 230, 138), width=1)
        draw.text((140, sy_star + 15), letter, font=get_num_font(14, 'black'), fill=(180, 83, 9) if s_theme=='amber' else ((8, 145, 178) if s_theme=='cyan' else ((109, 40, 217) if s_theme=='purple' else (0, 180, 90))), anchor='mm')
        draw.text((170, sy_star + 6), s_title, font=get_font(13.5, 'bold'), fill=(15, 23, 42))
        
        b_lines = wrap_text_by_words(s_body, get_font(11, 'regular'), star_w - 95, draw)
        by = sy_star + 36
        for bl in b_lines:
            draw.text((170, by), bl, font=get_font(11, 'regular'), fill=(71, 85, 105))
            by += 18
        sy_star += 118
        
    draw_slide_footer(draw, 11, dark=False)
    save_slide(base, 11)

# ==============================================================
# SLIDE 12: LIVE PROTOTYPE INTERACTIVE HUB
# ==============================================================
def make_slide_12():
    base = Image.new('RGBA', (W, H), (248, 250, 252, 255))
    draw = ImageDraw.Draw(base)
    
    # Hairline Boundaries
    draw.line([(100, 85), (1820, 85)], fill=(226, 232, 240), width=1)
    draw.line([(100, 985), (1820, 985)], fill=(226, 232, 240), width=1)
    
    draw.text((100, 60), "12 INTERACTIVE PROTOTYPE | 60FPS LIVE EXPERIENCE", font=get_font(13.5, 'bold'), fill=(180, 83, 9))
    draw.text((100, 95), "웹에서 즉시 체험 가능한 ", font=get_font(38, 'bold'), fill=(15, 23, 42))
    w_t1 = draw.textlength("웹에서 즉시 체험 가능한 ", font=get_font(38, 'bold'))
    draw.text((100 + w_t1, 95), "60fps 인터랙티브 프로토타입 허브", font=get_font(38, 'bold'), fill=(180, 83, 9))
    draw.text((100, 150), "실제 디바이스와 100% 동일한 반응속도, 상태 전환, 제스처를 지원하는 라이브 프로토타입 체험", font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    
    # Left: Interactive Flow & Launch Hub
    hub_w = 980
    hub_h = 720
    draw.rounded_rectangle([100, 210, 100 + hub_w, 210 + hub_h], radius=16, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw.text((135, 240), "60FPS INTERACTIVE SIMULATOR SUITE", font=get_font(15, 'bold'), fill=(15, 23, 42))
    draw.text((135, 265), "프레임워크 제약 없는 순수 웹 표준 기반 고반응성 시뮬레이터", font=get_font(11.5, 'medium'), fill=(100, 116, 139))
    draw.line([(135, 295), (100 + hub_w - 35, 295)], fill=(241, 245, 249), width=1)
    
    flows = [
        ("FLOW 01", "우주 사주 허브 & 오늘의 길시", "나의 고유 우주 좌표 확인 및 24절기 궤도 나침반 360도 회전 조작", "amber"),
        ("FLOW 02", "5각형 오행 실시간 레이더 분석", "목화토금수 에너지 비율 터치 및 결핍 기운 라이프스타일 처방 확인", "cyan"),
        ("FLOW 03", "인연 정밀 궁합 92% 매칭", "1-Tap 상대방 추가 모달 전개 및 오행 중첩 레이더 케미스트리 확인", "purple"),
        ("FLOW 04", "3D 도파민 타로 & 시크릿 볼트", "물리 엔진 카드 셔플 제스처 및 햅틱 뒤집기를 통한 운세 기록 저장", "green")
    ]
    
    fy = 320
    for f_code, f_title, f_desc, f_theme in flows:
        draw.rounded_rectangle([135, fy, 100 + hub_w - 35, fy + 82], radius=10, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
        draw_pill_badge(draw, left_x=155, cy=fy + 22, text=f_code, font=get_font(8.5, 'bold'), theme=f_theme, has_dot=True, pad_x=8, height=20)
        draw.text((250, fy + 12), f_title, font=get_font(13, 'bold'), fill=(15, 23, 42))
        draw.text((155, fy + 48), f_desc, font=get_font(10.5, 'regular'), fill=(100, 116, 139))
        fy += 96
        
    # Big Launch CTA Button
    btn_y = 730
    draw.rounded_rectangle([135, btn_y, 100 + hub_w - 35, btn_y + 68], radius=14, fill=(180, 83, 9))
    draw.text((135 + (hub_w - 70) // 2, btn_y + 34), "▶  60fps 라이브 인터랙티브 프로토타입 실행하기 (Click to Launch) ↗", font=get_font(15, 'bold'), fill=(255, 255, 255), anchor='mm')
    draw.text((135, btn_y + 88), "✓ URL: prototype.html · 브라우저 창 높이에 따른 자동 리사이징 및 44px 리얼 스테이터스바 탑재", font=get_font(10.5, 'bold'), fill=(180, 83, 9))
    
    # Right: Phone Mockup Preview
    phone_preview_path = f"{MOCKUP_DIR}/iphone_01_hub.png"
    if os.path.exists(phone_preview_path):
        p_img = Image.open(phone_preview_path).convert('RGBA')
        target_h = 710
        target_w = int(round(target_h * (p_img.width / p_img.height)))
        p_res = p_img.resize((target_w, target_h), Image.Resampling.LANCZOS)
        
        mask = p_res.split()[3]
        sh_img = Image.new('RGBA', (p_res.width + 100, p_res.height + 100), (0, 0, 0, 0))
        sh_img.paste((0, 0, 0, 75), (50 + 14, 50 + 26), mask)
        sh_img = sh_img.filter(ImageFilter.GaussianBlur(32))
        
        px, py = 1250, 210
        base.paste(sh_img, (px - 50, py - 50), sh_img)
        base.paste(p_res, (px, py), p_res)
        
    draw_slide_footer(draw, 12, dark=False)
    save_slide(base, 12)

print("Slide 09, 10, 11, 12 updated to match Smart DCA high-impact architecture!")

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
# SLIDE 09: DEEP DIVE 02 - COSMIC COMPATIBILITY MATCH ENGINE
# ==============================================================
def make_slide_09():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=9,
        category_en="CORE FEATURE DEEP DIVE 02 | COMPATIBILITY MATCH ENGINE",
        title_white="두 사람의 사주와 별자리를 입체 분석하는 ",
        title_gold="정밀 궁합 매칭 알고리즘",
        subtitle_kr="단순 점수 나열을 넘어 오행의 결합도와 상생 관계를 도출하여 최적의 관계 케미스트리 리포트 제공"
    )
    
    # Left: Titanium iPhone Mockup
    phone_match_path = f"{MOCKUP_DIR}/iphone_05_match.png"
    if os.path.exists(phone_match_path):
        phone_img = Image.open(phone_match_path).convert('RGBA')
        target_h = 670
        target_w = int(round(target_h * (phone_img.width / phone_img.height)))
        p_res = phone_img.resize((target_w, target_h), Image.Resampling.LANCZOS)
        
        mask = p_res.split()[3]
        sh_img = Image.new('RGBA', (p_res.width + 100, p_res.height + 100), (0, 0, 0, 0))
        sh_img.paste((0, 0, 0, 95), (50 + 15, 50 + 25), mask)
        sh_img = sh_img.filter(ImageFilter.GaussianBlur(35))
        
        px, py = 120, 230
        base.paste(sh_img, (px - 50, py - 50), sh_img)
        base.paste(p_res, (px, py), p_res)
        
    rx = 580
    rw = 1240
    card_h = 224
    card_gap = 24
    
    # Card 1: Multi-Vector Compatibility Solver Formula
    c1_y = 230
    draw.rounded_rectangle([rx, c1_y, rx + rw, c1_y + card_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw_pill_badge(draw, left_x=rx + 25, cy=c1_y + 25, text="MULTI-VECTOR SOLVER", font=get_font(10, 'bold'), theme='gold', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 230, c1_y + 15), "사주 일주론 & 별자리 융합 궁합 수식", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.line([(rx + 25, c1_y + 48), (rx + rw - 25, c1_y + 48)], fill=(229, 192, 123, 30), width=1)
    
    draw.text((rx + 25, c1_y + 65), "Score = a·S_일간합 + b·S_지지육합 + c·(1 - ||E_A - E_B||) + d·S_별자리", font=get_num_font(15, 'bold'), fill=(255, 215, 0))
    draw.text((rx + 25, c1_y + 98), "• a(0.35) 일간 합(천간합) : 두 사람의 기본적 성격과 영혼의 끌림 지수 계산", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c1_y + 124), "• b(0.25) 지지 합충(삼합/육합/원진) : 실제 생활 습관과 현실적 가치관 충돌 여부 감지", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c1_y + 150), "• c(0.25) 오행 보완도 : A의 결핍 기운을 B가 채워주는 상생 시너지 벡터 산출", font=get_font(11.5, 'bold'), fill=(0, 229, 255))
    draw.text((rx + 25, c1_y + 180), "✓ 92% 정밀 케미스트리 도출 · 단일 수치 나열을 넘어선 입체적 인연 진단", font=get_font(10.5, 'bold'), fill=(16, 185, 129))
    
    # Card 2: Overlay Radar Interaction
    c2_y = c1_y + card_h + card_gap
    draw.rounded_rectangle([rx, c2_y, rx + rw, c2_y + card_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw_pill_badge(draw, left_x=rx + 25, cy=c2_y + 25, text="OVERLAY RADAR DYNAMICS", font=get_font(10, 'bold'), theme='cyan', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 240, c2_y + 15), "오행 중첩 비교 인터랙션 시각화", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.line([(rx + 25, c2_y + 48), (rx + rw - 25, c2_y + 48)], fill=(229, 192, 123, 30), width=1)
    
    draw.text((rx + 25, c2_y + 65), "골드 다각형(나)과 바이올렛 다각형(상대방)의 60fps 오버레이 블렌딩", font=get_font(13, 'bold'), fill=(0, 229, 255))
    draw.text((rx + 25, c2_y + 98), "• 두 사람의 다각형이 겹쳐지는 교집합(공통 성향)과 합집합(상호 보완 영역)을 실시간 컬러 블러로 표현", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c2_y + 124), "• 내가 부족한 수(물) 기운을 상대방이 채워줄 때 발광 펄스 파티클 애니메이션 발동", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c2_y + 150), "• 1-Tap 터치로 '나의 관점 리포트'와 '상대방 관점 리포트'의 시점을 자유롭게 전환", font=get_font(11.5, 'bold'), fill=(255, 215, 0))
    draw.text((rx + 25, c2_y + 180), "✓ 인스타그램 스토리 공유율 41.8% 견인 · 소셜 바이럴 핵심 UX", font=get_font(10.5, 'bold'), fill=(16, 185, 129))
    
    # Card 3: Relationship Conflict Guide
    c3_y = c2_y + card_h + card_gap
    draw.rounded_rectangle([rx, c3_y, rx + rw, c3_y + card_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw_pill_badge(draw, left_x=rx + 25, cy=c3_y + 25, text="RELATIONSHIP ACTION GUIDE", font=get_font(10, 'bold'), theme='purple', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 250, c3_y + 15), "실전 소통 솔루션 & 데이트 시크릿 가이드", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.line([(rx + 25, c3_y + 48), (rx + rw - 25, c3_y + 48)], fill=(229, 192, 123, 30), width=1)
    
    draw.text((rx + 25, c3_y + 65), "갈등을 예방하고 관계의 온도를 높이는 맞춤형 3대 실천 솔루션", font=get_font(13, 'bold'), fill=(216, 180, 254))
    draw.text((rx + 25, c3_y + 98), "• 대화의 온도 : 상대방의 일주 특성에 맞춘 비폭력 대화법 및 피해야 할 금기어 가이드", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c3_y + 124), "• 데이트 장소 : 두 사람의 오행이 상생하는 추천 장소(예: 수목원, 호숫가 라운지 등) 제안", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c3_y + 150), "• 기념일 길시 : 고백, 여행, 중요한 대화를 나누기 가장 좋은 시간대 추천", font=get_font(11.5, 'bold'), fill=(255, 215, 0))
    draw.text((rx + 25, c3_y + 180), "✓ 유저 체류 시간 2.8배 증가 (평균 세션 8분 24초 기록)", font=get_font(10.5, 'bold'), fill=(16, 185, 129))
    
    draw_slide_footer(draw, 9)
    save_slide(base, 9)

# ==============================================================
# SLIDE 10: HIGH-FIDELITY MOBILE SHOWCASE
# ==============================================================
def make_slide_10():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=10,
        category_en="UI SCREEN GALLERY | HIGH-FIDELITY MOBILE SHOWCASE",
        title_white="다크 모드와 골드 악센트로 완성된 ",
        title_gold="하이엔드 모바일 스크린 라인업",
        subtitle_kr="일관된 디자인 시스템과 디테일한 마이크로 인터랙션으로 완성된 4대 핵심 화면 쇼케이스"
    )
    
    pw = 380
    ph = 670
    sec_y = 220
    gap = 60
    
    mockups_info = [
        (100, f"{MOCKUP_DIR}/iphone_01_hub.png", "01. 우주 사주 허브", "탄생 우주 좌표 및 24절기 천체 나침반", "gold"),
        (100 + (pw + gap), f"{MOCKUP_DIR}/iphone_05_match.png", "02. 인연 궁합 매칭", "사주 일주 합충 분석 및 92% 케미스트리 지수", "cyan"),
        (100 + (pw + gap) * 2, f"{MOCKUP_DIR}/iphone_06_shop.png", "03. 복채 하트 상점", "복채 하트 패키지 충전 및 VIP 마스터 패스", "purple"),
        (100 + (pw + gap) * 3, f"{MOCKUP_DIR}/iphone_07_vault.png", "04. 인연 보관함 & 볼트", "내 기본 정보 설정 & 저장된 인연 로컬 보관", "green")
    ]
    
    for px, img_path, title, desc, theme in mockups_info:
        if os.path.exists(img_path):
            p_img = Image.open(img_path).convert('RGBA')
            target_h = ph
            target_w = int(round(target_h * (p_img.width / p_img.height)))
            p_res = p_img.resize((target_w, target_h), Image.Resampling.LANCZOS)
            
            mask = p_res.split()[3]
            sh_img = Image.new('RGBA', (p_res.width + 100, p_res.height + 100), (0, 0, 0, 0))
            sh_img.paste((0, 0, 0, 95), (50 + 12, 50 + 24), mask)
            sh_img = sh_img.filter(ImageFilter.GaussianBlur(32))
            
            base.paste(sh_img, (px - 50, sec_y - 50), sh_img)
            base.paste(p_res, (px, sec_y), p_res)
            
        # Label card below each phone
        lb_y = sec_y + ph + 16
        draw.rounded_rectangle([px, lb_y, px + pw, lb_y + 60], radius=10, fill=(14, 20, 36, 220), outline=(229, 192, 123, 60), width=1)
        draw_pill_badge(draw, left_x=px + 14, cy=lb_y + 18, text=title[:2], font=get_font(8, 'bold'), theme=theme, has_dot=False, pad_x=6, height=18, solid=True)
        draw.text((px + 52, lb_y + 10), title[4:], font=get_font(12, 'bold'), fill=(244, 246, 252))
        draw.text((px + 14, lb_y + 36), desc, font=get_font(9.5, 'regular'), fill=(163, 176, 204))
        
    draw_slide_footer(draw, 10)
    save_slide(base, 10)

# ==============================================================
# SLIDE 11: BUSINESS IMPACT & STAR RETROSPECTIVE
# ==============================================================
def make_slide_11():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=11,
        category_en="BUSINESS IMPACT & DESIGN RETROSPECTIVE | OUTCOME",
        title_white="정량적 사용자 지표 향상과 ",
        title_gold="시니어 디자이너로서의 회고",
        subtitle_kr="출시 후 사용자 행동 분석 데이터 및 기술적 난제 해결 과정을 담은 STAR 기법 기반 회고록"
    )
    
    # Top: 4 Big Stat Metric Cards
    m_w = 415
    m_h = 160
    m_gap = 20
    m_y = 230
    
    metrics = [
        ("D1 RETENTION RATE", "64.2%", "+28.2%p", "출시 첫 달 D1 리텐션 64.2% 달성 (업계 평균 36.0% 대비 초과 달성)", "green"),
        ("AVERAGE SESSION TIME", "8m 24s", "2.8배 증가", "오행 레이더 및 궁합 탐색 인터랙션으로 평균 체류 시간 8분 24초 기록", "gold"),
        ("SOCIAL SHARING RATE", "41.8%", "바이럴 루프", "감각적인 우주 좌표 카드 및 92% 궁합 리포트 인스타그램 스토리 공유", "cyan"),
        ("SECRET VAULT CONV.", "18.7%", "유료 전환율", "상대방 무제한 저장권 및 프리미엄 타로 젬스톤 인앱 결제 전환 견인", "purple")
    ]
    
    for idx, (m_tag, m_val, m_badge, m_desc, m_theme) in enumerate(metrics):
        mx = 100 + idx * (m_w + m_gap)
        draw.rounded_rectangle([mx, m_y, mx + m_w, m_y + m_h], radius=14, fill=(14, 20, 36, 220), outline=(229, 192, 123, 60), width=1)
        draw.rounded_rectangle([mx, m_y + 12, mx + 4, m_y + m_h - 12], radius=2, fill=(229, 192, 123))
        
        draw_pill_badge(draw, left_x=mx + 18, cy=m_y + 24, text=m_tag, font=get_font(8.5, 'bold'), theme=m_theme, has_dot=True, pad_x=8, height=20)
        draw_pill_badge(draw, cx=mx + m_w - 48, cy=m_y + 24, text=m_badge, font=get_font(8, 'bold'), theme=m_theme, has_dot=False, pad_x=6, height=18, solid=True)
        
        draw.text((mx + 18, m_y + 54), m_val, font=get_num_font(38, 'black'), fill=(255, 215, 0) if m_theme=='gold' else ((52, 211, 153) if m_theme=='green' else ((0, 229, 255) if m_theme=='cyan' else (216, 180, 254))))
        draw.line([(mx + 18, m_y + 110), (mx + m_w - 18, m_y + 110)], fill=(229, 192, 123, 30), width=1)
        draw.text((mx + 18, m_y + 124), m_desc, font=get_font(9.5, 'regular'), fill=(163, 176, 204))
        
    # Bottom: STAR Retrospective Box
    star_y = 420
    star_w = 1720
    star_h = 540
    draw.rounded_rectangle([100, star_y, 100 + star_w, star_y + star_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 60), width=1)
    draw.text((125, star_y + 24), "STAR METHOD RETROSPECTIVE : 기술적 문제 해결 및 UX 고도화 회고", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.line([(125, star_y + 54), (100 + star_w - 25, star_y + 54)], fill=(229, 192, 123, 30), width=1)
    
    star_sections = [
        ("S", "Situation (상황 & 문제점)",
         "국내 운세/사주 시장은 연간 1조 원 규모로 급성장했으나, 대다수 앱이 텍스트 위주의 한자 나열과 공포 마케팅에 의존하고 있었습니다. "
         "사용자 조사 결과 2030 세대의 74.2%가 첫 화면의 난해함에 지쳐 이탈했고, 정작 중요한 '두 사람 사이의 조화와 케미스트리'를 시각적으로 보여주는 서비스는 전무했습니다.",
         "gold"),
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
        draw.rounded_rectangle([125, sy_star, 155, sy_star + 30], radius=6, fill=(35, 30, 15), outline=(229, 192, 123, 150), width=1)
        draw.text((140, sy_star + 15), letter, font=get_num_font(14, 'black'), fill=(255, 215, 0), anchor='mm')
        draw.text((170, sy_star + 6), s_title, font=get_font(13.5, 'bold'), fill=(244, 246, 252))
        
        b_lines = wrap_text_by_words(s_body, get_font(11, 'regular'), star_w - 95, draw)
        by = sy_star + 36
        for bl in b_lines:
            draw.text((170, by), bl, font=get_font(11, 'regular'), fill=(203, 213, 225))
            by += 18
        sy_star += 114
        
    draw_slide_footer(draw, 11)
    save_slide(base, 11)

# ==============================================================
# SLIDE 12: LIVE PROTOTYPE INTERACTIVE HUB
# ==============================================================
def make_slide_12():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=12,
        category_en="INTERACTIVE PROTOTYPE | 60FPS LIVE EXPERIENCE",
        title_white="웹에서 즉시 체험 가능한 ",
        title_gold="60fps 인터랙티브 프로토타입 허브",
        subtitle_kr="실제 디바이스와 100% 동일한 반응속도, 상태 전환, 제스처를 지원하는 라이브 프로토타입 체험"
    )
    
    # Left: Interactive Flow & Launch Hub
    hub_w = 980
    hub_h = 720
    draw.rounded_rectangle([100, 230, 100 + hub_w, 230 + hub_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 60), width=1)
    draw.text((135, 260), "60FPS INTERACTIVE SIMULATOR SUITE", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.text((135, 285), "프레임워크 제약 없는 순수 웹 표준 기반 고반응성 시뮬레이터", font=get_font(11.5, 'medium'), fill=(163, 176, 204))
    draw.line([(135, 315), (100 + hub_w - 35, 315)], fill=(229, 192, 123, 30), width=1)
    
    flows = [
        ("FLOW 01", "우주 사주 허브 & 오늘의 길시", "나의 고유 우주 좌표 확인 및 24절기 궤도 나침반 360도 회전 조작", "gold"),
        ("FLOW 02", "5각형 오행 실시간 레이더 분석", "목화토금수 에너지 비율 터치 및 결핍 기운 라이프스타일 처방 확인", "cyan"),
        ("FLOW 03", "인연 정밀 궁합 92% 매칭", "1-Tap 상대방 추가 모달 전개 및 오행 중첩 레이더 케미스트리 확인", "purple"),
        ("FLOW 04", "3D 도파민 타로 & 시크릿 볼트", "물리 엔진 카드 셔플 제스처 및 햅틱 뒤집기를 통한 운세 기록 저장", "green")
    ]
    
    fy = 340
    for f_code, f_title, f_desc, f_theme in flows:
        draw.rounded_rectangle([135, fy, 100 + hub_w - 35, fy + 82], radius=10, fill=(24, 32, 54), outline=(229, 192, 123, 40), width=1)
        draw_pill_badge(draw, left_x=155, cy=fy + 22, text=f_code, font=get_font(8.5, 'bold'), theme=f_theme, has_dot=True, pad_x=8, height=20)
        draw.text((250, fy + 12), f_title, font=get_font(13, 'bold'), fill=(244, 246, 252))
        draw.text((155, fy + 48), f_desc, font=get_font(10.5, 'regular'), fill=(163, 176, 204))
        fy += 96
        
    # Big Launch CTA Button (Clean Text, No missing glyphs)
    btn_y = 750
    draw.rounded_rectangle([135, btn_y, 100 + hub_w - 35, btn_y + 68], radius=14, fill=(229, 192, 123))
    draw.text((135 + (hub_w - 70) // 2, btn_y + 34), "▶  60fps 라이브 인터랙티브 프로토타입 실행하기 (Click to Launch) ↗", font=get_font(15, 'bold'), fill=(7, 10, 18), anchor='mm')
    draw.text((135, btn_y + 88), "✓ URL: prototype.html · 브라우저 창 높이에 따른 자동 리사이징 및 44px 리얼 스테이터스바 탑재", font=get_font(10.5, 'bold'), fill=(255, 215, 0))
    
    # Right: Phone Mockup Preview
    phone_preview_path = f"{MOCKUP_DIR}/iphone_01_hub.png"
    if os.path.exists(phone_preview_path):
        p_img = Image.open(phone_preview_path).convert('RGBA')
        target_h = 710
        target_w = int(round(target_h * (p_img.width / p_img.height)))
        p_res = p_img.resize((target_w, target_h), Image.Resampling.LANCZOS)
        
        mask = p_res.split()[3]
        sh_img = Image.new('RGBA', (p_res.width + 100, p_res.height + 100), (0, 0, 0, 0))
        sh_img.paste((0, 0, 0, 100), (50 + 18, 50 + 30), mask)
        sh_img = sh_img.filter(ImageFilter.GaussianBlur(38))
        
        px, py = 1250, 230
        base.paste(sh_img, (px - 50, py - 50), sh_img)
        base.paste(p_res, (px, py), p_res)
        
    draw_slide_footer(draw, 12)
    save_slide(base, 12)

print("Slide 09 to 12 updated cleanly.")

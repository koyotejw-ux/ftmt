import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter
from build_executive_ftmt_deck import (
    W, H, MOCKUP_DIR, get_font, get_num_font, get_material_icon_font, wrap_text_by_words,
    draw_diamond, draw_arrow, draw_dashed_line, draw_dashed_arrow,
    draw_pill_badge, draw_dotted_callout,
    create_cosmic_base, draw_slide_header, draw_slide_footer, save_slide,
    C_TITLE_WHITE, C_GOLD_HERO, C_GOLD_MUTED, C_TEXT_BODY, C_TEXT_MUTED,
    C_CYAN_ACCENT, C_PURPLE_ACC, C_GREEN_ACC, C_RED_ACC, C_BORDER_GOLD
)

# ==============================================================
# SLIDE 05: USER FLOW & EXPERIENCE LOGIC
# ==============================================================
def make_slide_05():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=5,
        category_en="USER FLOW & EXPERIENCE LOGIC | STATE MACHINE",
        title_white="입력부터 매칭까지 ",
        title_gold="마찰 없는 사용자 여정",
        subtitle_kr="좌표 자동 연산과 결측치 보정 가드로 이탈률을 0으로 줄인 상태 전이 로직"
    )
    
    # TOP-RIGHT: 서비스 UX 플로우차트 기호 범례 (Clean UX Flow Legend)
    leg_x = 1220
    leg_y = 68
    leg_w = 600
    leg_h = 80
    draw.rounded_rectangle([leg_x, leg_y, leg_x + leg_w, leg_y + leg_h], radius=10, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw_pill_badge(draw, left_x=leg_x + 14, cy=leg_y + 18, text="UX FLOW NOTATION", font=get_font(8, 'bold'), theme='gold', has_dot=True, pad_x=6, height=18)
    draw.text((leg_x + 140, leg_y + 18), "플로우차트 기호 및 상태 전이 범례", font=get_font(11, 'bold'), fill=(244, 246, 252), anchor='lm')
    
    # 4 Clean UX Flowchart Legend Elements
    # 1. 화면/UI (Screen)
    draw.rounded_rectangle([leg_x + 14, leg_y + 44, leg_x + 64, leg_y + 68], radius=4, fill=(24, 32, 54), outline=(100, 116, 139), width=1)
    draw.text((leg_x + 39, leg_y + 56), "Screen", font=get_font(8, 'bold'), fill=(203, 213, 225), anchor='mm')
    draw.text((leg_x + 72, leg_y + 56), "화면/UI", font=get_font(9.5, 'medium'), fill=(163, 176, 204), anchor='lm')
    
    # 2. 사용자 행동 (Action)
    draw.rounded_rectangle([leg_x + 138, leg_y + 44, leg_x + 188, leg_y + 68], radius=4, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw.text((leg_x + 163, leg_y + 56), "Action", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    draw.text((leg_x + 196, leg_y + 56), "사용자 행동", font=get_font(9.5, 'medium'), fill=(163, 176, 204), anchor='lm')
    
    # 3. 분기 판단 (Decision)
    draw.rounded_rectangle([leg_x + 282, leg_y + 44, leg_x + 342, leg_y + 68], radius=4, fill=(35, 30, 15), outline=(255, 215, 0), width=1)
    draw.text((leg_x + 312, leg_y + 56), "Decision", font=get_font(7.5, 'bold'), fill=(255, 215, 0), anchor='mm')
    draw.text((leg_x + 350, leg_y + 56), "가드 분기", font=get_font(9.5, 'medium'), fill=(163, 176, 204), anchor='lm')
    
    # 4. 시스템 피드백 (Feedback)
    draw.rounded_rectangle([leg_x + 424, leg_y + 44, leg_x + 484, leg_y + 68], radius=4, fill=(12, 38, 28), outline=(16, 185, 129), width=1)
    draw.text((leg_x + 454, leg_y + 56), "Feedback", font=get_font(7.5, 'bold'), fill=(52, 211, 153), anchor='mm')
    draw.text((leg_x + 492, leg_y + 56), "피드백", font=get_font(9.5, 'medium'), fill=(163, 176, 204), anchor='lm')
    
    cw = 328
    cgap = 20
    cols_x = [100 + i * (cw + cgap) for i in range(5)]
    col_centers = [cx + cw // 2 for cx in cols_x]
    
    stages_info = [
        ("STAGE 01", "탄생 데이터 입력", "Birth Input & Setup"),
        ("STAGE 02", "우주 사주 허브", "Cosmic Hub & Coordinates"),
        ("STAGE 03", "오행 레이더 분석", "Five Elements Analysis"),
        ("STAGE 04", "정밀 인연 매칭", "Compatibility Chemistry"),
        ("STAGE 05", "타로 & 시크릿 볼트", "Tarot Reading & Vault")
    ]
    
    for i, (st_code, st_name, st_en) in enumerate(stages_info):
        cx = cols_x[i]
        draw.rounded_rectangle([cx, 234, cx + cw, 284], radius=8, fill=(35, 30, 15, 255), outline=(229, 192, 123, 180), width=1)
        draw_pill_badge(draw, left_x=cx + 16, cy=249, text=st_code, font=get_font(7.5, 'bold'), theme='gold', pad_x=5, height=16)
        draw.text((cx + 86, 249), st_name, font=get_font(11, 'bold'), fill=(244, 246, 252), anchor='lm')
        draw.text((cx + 16, 269), st_en, font=get_font(8.5, 'medium'), fill=(163, 176, 204), anchor='lm')
        
        if i < 4:
            arrow_start_x = cx + cw
            arrow_end_x = cols_x[i + 1]
            draw_arrow(draw, (arrow_start_x + 2, 259), (arrow_end_x - 2, 259), col=(229, 192, 123), width=2, arrow_size=4)
            
    # Compact node width fitting content perfectly
    nw = 224
    
    # Track 1: Stage 01
    c0 = col_centers[0]
    draw.rounded_rectangle([c0 - 75, 300, c0 + 75, 328], radius=14, fill=(229, 192, 123))
    draw.text((c0, 314), "Start : 앱 실행", font=get_font(9.5, 'bold'), fill=(7, 10, 18), anchor='mm')
    draw_arrow(draw, (c0, 328), (c0, 344), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c0 - nw // 2, 344, c0 + nw // 2, 388], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c0 - 98, cy=358, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 358), "스플래시 & 로컬 환경", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c0, 375), "기기 로컬 암호화 세션 검증", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c0, 388), (c0, 406), col=(229, 192, 123), width=2, arrow_size=4)
    
    # Diamond: 최초 실행?
    draw_diamond(draw, cx=c0, cy=432, w=176, h=52, fill=(35, 30, 15), outline=(255, 215, 0), width=2)
    draw.text((c0, 432), "기존 프로필 존재?", font=get_font(9.5, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Branch No -> Onboarding
    draw_dashed_line(draw, (c0 + 88, 432), (cols_x[0] + cw - 16, 432), col=(0, 229, 255), width=1)
    draw.text(((c0 + 88 + cols_x[0] + cw - 16) // 2, 422), "No (신규)", font=get_font(7.5, 'bold'), fill=(0, 229, 255), anchor='mm')
    draw_dashed_arrow(draw, (cols_x[0] + cw - 16, 432), (cols_x[0] + cw - 16, 464), col=(0, 229, 255), width=1, arrow_size=3)
    draw.rounded_rectangle([cols_x[0] + cw - 88, 464, cols_x[0] + cw - 6, 496], radius=5, fill=(10, 36, 48), outline=(0, 229, 255), width=1)
    draw.text((cols_x[0] + cw - 47, 475), "생년월일 온보딩", font=get_font(7.5, 'bold'), fill=(0, 229, 255), anchor='mm')
    draw.text((cols_x[0] + cw - 47, 486), "좌표 자동 연산", font=get_font(7, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_dashed_line(draw, (cols_x[0] + cw - 47, 496), (cols_x[0] + cw - 47, 524), col=(0, 229, 255), width=1)
    draw_dashed_arrow(draw, (cols_x[0] + cw - 47, 524), (c0 + nw // 2, 524), col=(0, 229, 255), width=1, arrow_size=3)
    
    # Branch Yes -> Load
    draw_arrow(draw, (c0, 458), (c0, 502), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text((c0 - 30, 480), "Yes (기존)", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw.rounded_rectangle([c0 - nw // 2, 502, c0 + nw // 2, 546], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c0 - 98, cy=516, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 516), "내 우주 좌표 로드 완료", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c0, 533), "4주 8글자 및 일주 동물 바인딩", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c0, 546), (c0, 564), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c0 - nw // 2, 564, c0 + nw // 2, 608], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    b_s = draw_pill_badge(draw, left_x=c0 - 98, cy=578, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 578), "우주 사주 허브 자동 전환", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c0, 595), "0.3초 만에 나침반 궤도 렌더링", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c0, 608), (c0, 626), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c0 - nw // 2, 626, c0 + nw // 2, 672], radius=6, fill=(12, 38, 28), outline=(16, 185, 129), width=1)
    b_s = draw_pill_badge(draw, left_x=c0 - 98, cy=640, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 640), "메인 좌표 세션 활성화", font=get_font(9, 'bold'), fill=(255, 255, 255), anchor='lm')
    draw.text((c0, 656), "하단 독 네비게이션 4대 탭 노출", font=get_font(7.5, 'medium'), fill=(209, 250, 229), anchor='mm')
    
    # Handover to Stage 02
    draw_arrow(draw, (cols_x[0] + cw, 647), (cols_x[1], 647), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text(((cols_x[0] + cw + cols_x[1]) // 2, 635), "진입 ->", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Track 2: Stage 02
    c1 = col_centers[1]
    draw.rounded_rectangle([c1 - nw // 2, 300, c1 + nw // 2, 344], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c1 - 98, cy=314, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 314), "우주 사주 허브 메인 뷰", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c1, 331), "24절기 천체 궤도 & 좌표 표출", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c1, 344), (c1, 360), col=(229, 192, 123), width=2, arrow_size=4)
    
    # Decision Container: 3 Core Features
    draw.rounded_rectangle([c1 - nw // 2, 360, c1 + nw // 2, 464], radius=6, fill=(24, 32, 54), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c1 - 98, cy=374, text="DECISION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 374), "3대 인터랙션 선택 진입", font=get_font(8.5, 'bold'), fill=(255, 215, 0), anchor='lm')
    
    draw.rounded_rectangle([c1 - 98, 387, c1 + 98, 408], radius=4, fill=(14, 20, 36), outline=(229, 192, 123, 40), width=1)
    draw.text((c1, 397), "A. 오행 실시간 레이더 탭", font=get_font(8, 'medium'), fill=(203, 213, 225), anchor='mm')
    draw.rounded_rectangle([c1 - 98, 412, c1 + 98, 433], radius=4, fill=(14, 20, 36), outline=(229, 192, 123, 40), width=1)
    draw.text((c1, 422), "B. 인연 정밀 궁합 탭", font=get_font(8, 'medium'), fill=(203, 213, 225), anchor='mm')
    draw.rounded_rectangle([c1 - 98, 437, c1 + 98, 458], radius=4, fill=(14, 20, 36), outline=(229, 192, 123, 40), width=1)
    draw.text((c1, 447), "C. 도파민 럭셔리 타로 탭", font=get_font(8, 'medium'), fill=(203, 213, 225), anchor='mm')
    draw_arrow(draw, (c1, 464), (c1, 482), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c1 - nw // 2, 482, c1 + nw // 2, 526], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    b_s = draw_pill_badge(draw, left_x=c1 - 98, cy=496, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 496), "오늘의 금전운 길시 확인", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c1, 513), "오후 14:30~16:00 황금 길시 표출", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c1, 526), (c1, 544), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c1 - nw // 2, 544, c1 + nw // 2, 588], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c1 - 98, cy=558, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 558), "24절기 나침반 인터랙션", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c1, 575), "손끝 드래그 360도 천체 회전", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c1, 588), (c1, 606), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c1 - nw // 2, 606, c1 + nw // 2, 652], radius=6, fill=(12, 38, 28), outline=(16, 185, 129), width=1)
    b_s = draw_pill_badge(draw, left_x=c1 - 98, cy=620, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 620), "오행 분석 파라미터 전달", font=get_font(9, 'bold'), fill=(255, 255, 255), anchor='lm')
    draw.text((c1, 636), "천간/지지 오행 비율 0ms 파싱", font=get_font(7.5, 'medium'), fill=(209, 250, 229), anchor='mm')
    
    # Handover to Stage 03
    draw_arrow(draw, (cols_x[1] + cw, 629), (cols_x[2], 629), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text(((cols_x[1] + cw + cols_x[2]) // 2, 617), "분석 ->", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Track 3: Stage 03 (Five Elements)
    c2 = col_centers[2]
    draw.rounded_rectangle([c2 - nw // 2, 300, c2 + nw // 2, 344], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c2 - 98, cy=314, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 314), "5각형 실시간 레이더 화면", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c2, 331), "목화토금수 정규화 다각형 드로잉", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c2, 344), (c2, 360), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c2 - nw // 2, 360, c2 + nw // 2, 404], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    b_s = draw_pill_badge(draw, left_x=c2 - 98, cy=374, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 374), "결핍 오행 원터치 분석 탭", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c2, 391), "부족한 기운(수·물 결핍) 감지", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c2, 404), (c2, 422), col=(229, 192, 123), width=2, arrow_size=4)
    
    # Diamond: 결핍 기운 존재 여부?
    draw_diamond(draw, cx=c2, cy=448, w=176, h=52, fill=(35, 30, 15), outline=(255, 215, 0), width=2)
    draw.text((c2, 448), "결핍 기운 감지?", font=get_font(9.5, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Branch Yes -> Prescribe
    draw_arrow(draw, (c2, 474), (c2, 518), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text((c2 - 25, 496), "Yes", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw.rounded_rectangle([c2 - nw // 2, 518, c2 + nw // 2, 562], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c2 - 98, cy=532, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 532), "오행 처방 가이드 시트", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c2, 549), "행운 컬러(블랙), 음식 솔루션", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c2, 562), (c2, 580), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c2 - nw // 2, 580, c2 + nw // 2, 626], radius=6, fill=(12, 38, 28), outline=(16, 185, 129), width=1)
    b_s = draw_pill_badge(draw, left_x=c2 - 98, cy=594, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 594), "오행 데이터 캐싱 완료", font=get_font(9, 'bold'), fill=(255, 255, 255), anchor='lm')
    draw.text((c2, 610), "상대방 궁합 연산 시 오행 중첩", font=get_font(7.5, 'medium'), fill=(209, 250, 229), anchor='mm')
    
    # Handover to Stage 04
    draw_arrow(draw, (cols_x[2] + cw, 603), (cols_x[3], 603), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text(((cols_x[2] + cw + cols_x[3]) // 2, 591), "매칭 ->", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Track 4: Stage 04 (Compatibility)
    c3 = col_centers[3]
    draw.rounded_rectangle([c3 - nw // 2, 300, c3 + nw // 2, 344], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c3 - 98, cy=314, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 314), "인연 궁합 매칭 메인 뷰", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c3, 331), "인연 추가 모달 및 리스트 표출", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c3, 344), (c3, 360), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c3 - nw // 2, 360, c3 + nw // 2, 404], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    b_s = draw_pill_badge(draw, left_x=c3 - 98, cy=374, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 374), "상대 생년월일 입력/선택", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c3, 391), "1-Tap 시트에서 상대 정보 바인딩", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c3, 404), (c3, 422), col=(229, 192, 123), width=2, arrow_size=4)
    
    # Diamond: 상대방 출생시 인지 여부?
    draw_diamond(draw, cx=c3, cy=448, w=176, h=52, fill=(35, 30, 15), outline=(255, 215, 0), width=2)
    draw.text((c3, 448), "출생시 인지 여부?", font=get_font(9.5, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw_arrow(draw, (c3, 474), (c3, 518), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text((c3 - 25, 496), "Yes", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw.rounded_rectangle([c3 - nw // 2, 518, c3 + nw // 2, 562], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c3 - 98, cy=532, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 532), "92% 정밀 궁합 리포트", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c3, 549), "오행 중첩 & 케미 종합 점수", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c3, 562), (c3, 580), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c3 - nw // 2, 580, c3 + nw // 2, 626], radius=6, fill=(12, 38, 28), outline=(16, 185, 129), width=1)
    b_s = draw_pill_badge(draw, left_x=c3 - 98, cy=594, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 594), "인연 궁합 볼트 저장", font=get_font(9, 'bold'), fill=(255, 255, 255), anchor='lm')
    draw.text((c3, 610), "상대와의 데이트 팁 솔루션 완료", font=get_font(7.5, 'medium'), fill=(209, 250, 229), anchor='mm')
    
    # Handover to Stage 05
    draw_arrow(draw, (cols_x[3] + cw, 603), (cols_x[4], 603), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text(((cols_x[3] + cw + cols_x[4]) // 2, 591), "타로 ->", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Track 5: Stage 05 (Tarot & Vault)
    c4 = col_centers[4]
    draw.rounded_rectangle([c4 - nw // 2, 300, c4 + nw // 2, 344], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c4 - 98, cy=314, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 314), "3D 타로 셔플 캔버스 진입", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c4, 331), "22장 메이저 아르카나 덱 준비", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c4, 344), (c4, 360), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c4 - nw // 2, 360, c4 + nw // 2, 404], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    b_s = draw_pill_badge(draw, left_x=c4 - 98, cy=374, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 374), "손끝 드래그 셔플 & 선택", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c4, 391), "선택 순간 60fps 햅틱 진동 발동", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c4, 404), (c4, 422), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c4 - nw // 2, 422, c4 + nw // 2, 466], radius=6, fill=(30, 18, 48), outline=(168, 85, 247), width=1)
    b_s = draw_pill_badge(draw, left_x=c4 - 98, cy=436, text="ANIMATION", font=get_font(6.5, 'bold'), theme='purple', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 436), "3D 카드 뒤집기 애니", font=get_font(9, 'bold'), fill=(216, 180, 254), anchor='lm')
    draw.text((c4, 453), "골드 아우라 & 심층 키워드 해설", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c4, 466), (c4, 484), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c4 - nw // 2, 484, c4 + nw // 2, 528], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    b_s = draw_pill_badge(draw, left_x=c4 - 98, cy=498, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((b_s[2] + 8, 498), "시크릿 볼트 기록 암호화", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c4, 515), "온디바이스 SQLite 보관 누적", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c4, 528), (c4, 546), col=(229, 192, 123), width=2, arrow_size=4)
    
    # End Capsule (High contrast: Dark background with crisp gold outline & pure white text)
    draw.rounded_rectangle([c4 - 80, 546, c4 + 80, 576], radius=15, fill=(16, 185, 129), outline=(52, 211, 153), width=2)
    draw.text((c4, 561), "End : 리추얼 완료", font=get_font(10, 'bold'), fill=(7, 10, 18), anchor='mm')
    
    # Bottom: 4 Key Logic Architecture Cards
    bp_y = 785
    bp_h = 160
    bp_w = 415
    bp_gap = 20
    logic_cards = [
        ("01", "무한 루프 방지 및 결측치 자동 보정", "출생 시간을 모르는 사용자를 위해 정오(12:00) 기준 일주 보정 알고리즘을 적용하여 진입 차단 방지", "gold"),
        ("02", "로컬 상태 관리 (Riverpod StateNotifier)", "사용자 프로필, 오늘의 길시, 오행 레이더 수치를 단일 상태 저장소로 바인딩하여 0ms 렌더링", "cyan"),
        ("03", "햅틱 진동 피드백 엔진 통합", "카드 선택, 레이더 터치, 궁합 산출 완료 순간 기기 햅틱 모터를 구동하여 높은 실물감 부여", "purple"),
        ("04", "100% 오프라인 캐싱 & 볼트 보안", "네트워크 단절 상태에서도 기존 계산된 좌표와 궁합 리포트를 무손실 열람 가능하도록 설계", "green")
    ]
    for idx, (l_num, l_title, l_desc, l_theme) in enumerate(logic_cards):
        px = 100 + idx * (bp_w + bp_gap)
        draw.rounded_rectangle([px, bp_y, px + bp_w, bp_y + bp_h], radius=12, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
        draw_pill_badge(draw, left_x=px + 18, cy=bp_y + 24, text=f"LOGIC {l_num}", font=get_font(8.5, 'bold'), theme=l_theme, has_dot=True, pad_x=8, height=20)
        draw.text((px + 18, bp_y + 52), l_title, font=get_font(12.5, 'bold'), fill=(244, 246, 252))
        draw.line([(px + 18, bp_y + 72), (px + bp_w - 18, bp_y + 72)], fill=(229, 192, 123, 30), width=1)
        b_lines = wrap_text_by_words(l_desc, get_font(10, 'regular'), bp_w - 36, draw)
        by = bp_y + 84
        for bl in b_lines:
            draw.text((px + 18, by), bl, font=get_font(10, 'regular'), fill=(163, 176, 204))
            by += 16
            
    draw_slide_footer(draw, 5)
    save_slide(base, 5)

# ==============================================================
# SLIDE 06: WIREFRAME & ERGONOMIC ARCHITECTURE
# ==============================================================
def make_slide_06():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=6,
        category_en="WIREFRAME & INTERACTION CALLOUTS | ERGONOMIC DESIGN",
        title_white="한 손 조작에 최적화된 ",
        title_gold="엄지존(Thumb Zone) UI",
        subtitle_kr="Fitts' Law를 적용한 4대 핵심 화면 와이어프레임과 하단 인터랙션 아키텍처"
    )
    
    pw = 380
    ph = 530
    sec_y = 230
    gap = 60
    
    p1_x = 100
    p2_x = p1_x + pw + gap
    p3_x = p2_x + pw + gap
    p4_x = p3_x + pw + gap
    
    def draw_wf_chassis(x, title, theme='gold'):
        draw.rounded_rectangle([x, sec_y, x + pw, sec_y + ph], radius=24, fill=(14, 20, 36, 240), outline=(229, 192, 123, 100), width=2)
        draw.rounded_rectangle([x + pw // 2 - 40, sec_y + 12, x + pw // 2 + 40, sec_y + 28], radius=8, fill=(7, 10, 18))
        draw_pill_badge(draw, left_x=x + 18, cy=sec_y + 44, text=title, font=get_font(8.5, 'bold'), theme=theme, pad_x=8, height=20)
        draw.rounded_rectangle([x + pw // 2 - 35, sec_y + ph - 12, x + pw // 2 + 35, sec_y + ph - 8], radius=2, fill=(229, 192, 123, 120))
        
    # Screen 1: 우주 사주 허브
    draw_wf_chassis(p1_x, "① SCR-01 · 우주 사주 허브", "gold")
    draw.rounded_rectangle([p1_x + 18, sec_y + 64, p1_x + pw - 18, sec_y + 130], radius=10, fill=(24, 32, 54), outline=(229, 192, 123, 60), width=1)
    draw.text((p1_x + 28, sec_y + 76), "나(본인)님의 고유 우주 좌표", font=get_font(10, 'bold'), fill=(255, 215, 0))
    draw.text((p1_x + 28, sec_y + 98), "무인(황금 호랑이) · 사자자리 · O형", font=get_font(11, 'bold'), fill=(244, 246, 252))
    
    # Orbit Dial Wireframe
    dial_cy = sec_y + 225
    dial_cx = p1_x + pw // 2
    draw.ellipse([dial_cx - 75, dial_cy - 75, dial_cx + 75, dial_cy + 75], outline=(229, 192, 123, 80), width=1)
    draw.ellipse([dial_cx - 50, dial_cy - 50, dial_cx + 50, dial_cy + 50], outline=(229, 192, 123, 140), width=1)
    draw.ellipse([dial_cx - 24, dial_cy - 24, dial_cx + 24, dial_cy + 24], fill=(35, 30, 15), outline=(255, 215, 0), width=1)
    draw.text((dial_cx, dial_cy), "음양 조화", font=get_font(10, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw.rounded_rectangle([p1_x + 18, sec_y + 320, p1_x + pw - 18, sec_y + 390], radius=10, fill=(35, 30, 15), outline=(229, 192, 123, 100), width=1)
    draw.text((p1_x + 28, sec_y + 332), "오늘 나에게 터지는 금전운 길시", font=get_font(9.5, 'bold'), fill=(255, 215, 0))
    draw.text((p1_x + 28, sec_y + 354), "14:30 ~ 16:00 (신시·오후)", font=get_num_font(16, 'bold'), fill=(255, 255, 255))
    
    # CTA inside thumb zone
    draw.rounded_rectangle([p1_x + 18, sec_y + 440, p1_x + pw - 18, sec_y + 490], radius=12, fill=(229, 192, 123))
    draw.text((p1_x + pw // 2, sec_y + 465), "오행 분석 리포트 확인 ↗", font=get_font(12, 'bold'), fill=(7, 10, 18), anchor='mm')
    
    # Screen 2: 오행 레이더
    draw_wf_chassis(p2_x, "② SCR-02 · 오행 레이더 뷰", "cyan")
    draw.rounded_rectangle([p2_x + 18, sec_y + 64, p2_x + pw - 18, sec_y + 110], radius=10, fill=(10, 36, 48), outline=(0, 229, 255, 80), width=1)
    draw.text((p2_x + 28, sec_y + 76), "목·화·토·금·수 오행 밸런스", font=get_font(10, 'bold'), fill=(0, 229, 255))
    draw.text((p2_x + 28, sec_y + 92), "에너지 조화율: 78.5% (수·물 기운 보완 필요)", font=get_font(9.5, 'regular'), fill=(203, 213, 225))
    
    # Pentagon Radar Wireframe
    rcy = sec_y + 225
    rcx = p2_x + pw // 2
    r_pts = []
    for ang in range(0, 360, 72):
        rad = math.radians(ang - 90)
        r_pts.append((rcx + 70 * math.cos(rad), rcy + 70 * math.sin(rad)))
    draw.polygon(r_pts, outline=(0, 229, 255, 100), width=1)
    
    inner_pts = []
    r_vals = [0.8, 0.9, 0.7, 0.4, 0.3]
    for idx, ang in enumerate(range(0, 360, 72)):
        rad = math.radians(ang - 90)
        inner_pts.append((rcx + 70 * r_vals[idx] * math.cos(rad), rcy + 70 * r_vals[idx] * math.sin(rad)))
    draw.polygon(inner_pts, fill=(0, 229, 255, 50), outline=(0, 229, 255), width=2)
    
    draw.rounded_rectangle([p2_x + 18, sec_y + 320, p2_x + pw - 18, sec_y + 410], radius=10, fill=(24, 32, 54), outline=(100, 116, 139), width=1)
    draw.text((p2_x + 28, sec_y + 332), "오행 결핍 기운 즉시 보완책", font=get_font(9.5, 'bold'), fill=(0, 229, 255))
    draw.text((p2_x + 28, sec_y + 354), "행운의 색상  블랙 & 미드나잇 블루", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p2_x + 28, sec_y + 372), "행운의 음식  해산물, 블랙푸드, 생수", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p2_x + 28, sec_y + 390), "최적의 방위  북쪽 (수 기운 유입)", font=get_font(9, 'medium'), fill=(203, 213, 225))
    
    draw.rounded_rectangle([p2_x + 18, sec_y + 440, p2_x + pw - 18, sec_y + 490], radius=12, fill=(0, 229, 255))
    draw.text((p2_x + pw // 2, sec_y + 465), "인연 궁합 매칭하러 가기 ↗", font=get_font(12, 'bold'), fill=(7, 10, 18), anchor='mm')
    
    # Screen 3: 정밀 궁합 매칭
    draw_wf_chassis(p3_x, "③ SCR-03 · 정밀 궁합 매칭", "purple")
    draw.rounded_rectangle([p3_x + 18, sec_y + 64, p3_x + pw - 18, sec_y + 110], radius=10, fill=(30, 18, 48), outline=(168, 85, 247, 80), width=1)
    draw.text((p3_x + 28, sec_y + 76), "상대방과의 정밀 케미스트리", font=get_font(10, 'bold'), fill=(216, 180, 254))
    draw.text((p3_x + 28, sec_y + 92), "상대: 이지은님 (계묘년 · 토끼띠 · 천칭자리)", font=get_font(9.5, 'regular'), fill=(203, 213, 225))
    
    # Match Score Circle
    mcy = sec_y + 225
    mcx = p3_x + pw // 2
    draw.ellipse([mcx - 65, mcy - 65, mcx + 65, mcy + 65], outline=(168, 85, 247, 100), width=2)
    draw.ellipse([mcx - 52, mcy - 52, mcx + 52, mcy + 52], fill=(30, 18, 48), outline=(216, 180, 254), width=1)
    draw.text((mcx, mcy - 10), "92%", font=get_num_font(26, 'black'), fill=(255, 215, 0), anchor='mm')
    draw.text((mcx, mcy + 16), "천생연분 케미", font=get_font(9, 'bold'), fill=(216, 180, 254), anchor='mm')
    
    draw.rounded_rectangle([p3_x + 18, sec_y + 320, p3_x + pw - 18, sec_y + 410], radius=10, fill=(24, 32, 54), outline=(100, 116, 139), width=1)
    draw.text((p3_x + 28, sec_y + 332), "사주 일주 상호 조화 분석", font=get_font(9.5, 'bold'), fill=(216, 180, 254))
    draw.text((p3_x + 28, sec_y + 354), "천간 합  무계합 (불의 기운 생성)", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p3_x + 28, sec_y + 372), "지지 관계  인묘진 방합 목 기운 활성화", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p3_x + 28, sec_y + 390), "오행 상생  나의 토 기운을 상대방이 보완", font=get_font(9, 'medium'), fill=(52, 211, 153))
    
    draw.rounded_rectangle([p3_x + 18, sec_y + 440, p3_x + pw - 18, sec_y + 490], radius=12, fill=(138, 43, 226))
    draw.text((p3_x + pw // 2, sec_y + 465), "궁합 결과 볼트에 저장 ↗", font=get_font(12, 'bold'), fill=(255, 255, 255), anchor='mm')
    
    # Screen 4: 럭셔리 타로
    draw_wf_chassis(p4_x, "④ SCR-04 · 럭셔리 타로 & 볼트", "gold")
    draw.rounded_rectangle([p4_x + 18, sec_y + 64, p4_x + pw - 18, sec_y + 110], radius=10, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
    draw.text((p4_x + 28, sec_y + 76), "오늘의 메이저 아르카나 타로", font=get_font(10, 'bold'), fill=(255, 215, 0))
    draw.text((p4_x + 28, sec_y + 92), "손끝으로 덱을 셔플하고 1장을 뽑으세요", font=get_font(9.5, 'regular'), fill=(203, 213, 225))
    
    # Card Wireframe
    tcy = sec_y + 225
    tcx = p4_x + pw // 2
    draw.rounded_rectangle([tcx - 45, tcy - 70, tcx + 45, tcy + 70], radius=8, fill=(35, 30, 15), outline=(255, 215, 0), width=2)
    draw.text((tcx, tcy - 15), "THE", font=get_font(9, 'bold'), fill=(229, 192, 123), anchor='mm')
    draw.text((tcx, tcy + 5), "SUN", font=get_font(15, 'black'), fill=(255, 215, 0), anchor='mm')
    draw.text((tcx, tcy + 25), "태양 카드 (XIX)", font=get_font(8.5, 'bold'), fill=(244, 246, 252), anchor='mm')
    
    draw.rounded_rectangle([p4_x + 18, sec_y + 320, p4_x + pw - 18, sec_y + 410], radius=10, fill=(24, 32, 54), outline=(100, 116, 139), width=1)
    draw.text((p4_x + 28, sec_y + 332), "심층 리딩 & 시크릿 조언", font=get_font(9.5, 'bold'), fill=(255, 215, 0))
    draw.text((p4_x + 28, sec_y + 354), "핵심 키워드  성공, 활력, 관계의 명확성", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p4_x + 28, sec_y + 372), "관계 조언  솔직한 대화가 운을 열어줌", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p4_x + 28, sec_y + 390), "볼트 보관  온디바이스 자동 암호화 저장", font=get_font(9, 'medium'), fill=(163, 176, 204))
    
    draw.rounded_rectangle([p4_x + 18, sec_y + 440, p4_x + pw - 18, sec_y + 490], radius=12, fill=(229, 192, 123))
    draw.text((p4_x + pw // 2, sec_y + 465), "시크릿 볼트 기록 확인 ↗", font=get_font(12, 'bold'), fill=(7, 10, 18), anchor='mm')
    
    # Bottom: 4 Ergonomic System Cards
    bp_y = 785
    bp_h = 160
    bp_w = 415
    bp_gap = 20
    ergo_cards = [
        ("01", "THUMB-ZONE 48dp", "Fitts' Law 한 손 조작성 최적화", "한 손 파지 시 엄지가 닿는 하단 120dp 반경 내 주요 액션 버튼을 집중 배치하여 이동 피로 65% 절감", "gold"),
        ("02", "BOUNDARY GUARD", "출생시 결측치 자동 보정 엔진", "출생 시간을 모르는 경우 정오(12:00) 기준 태양시 보정 및 일주 중심 분석 가이드 자동 작동", "cyan"),
        ("03", "HAPTIC FIDELITY", "60fps 햅틱 진동 피드백", "3D 타로 카드 플립 및 궁합 매칭 도출 순간 진동 모터를 제어하여 살아있는 실물 촉각 전달", "purple"),
        ("04", "ZERO-LOSS VAULT", "100% 온디바이스 로컬 암호화", "분석된 사주 및 타로 기록을 외부 유출 없이 SQLite 로컬 DB에 암호화하여 영구 보존", "green")
    ]
    for idx, (e_num, e_badge, e_title, e_desc, e_theme) in enumerate(ergo_cards):
        px = 100 + idx * (bp_w + bp_gap)
        draw.rounded_rectangle([px, bp_y, px + bp_w, bp_y + bp_h], radius=12, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
        draw_pill_badge(draw, left_x=px + 18, cy=bp_y + 24, text=e_badge, font=get_font(8.5, 'bold'), theme=e_theme, has_dot=True, pad_x=8, height=20)
        draw.text((px + 18, bp_y + 52), e_title, font=get_font(12.5, 'bold'), fill=(244, 246, 252))
        draw.line([(px + 18, bp_y + 72), (px + bp_w - 18, bp_y + 72)], fill=(229, 192, 123, 30), width=1)
        b_lines = wrap_text_by_words(e_desc, get_font(10, 'regular'), bp_w - 36, draw)
        by = bp_y + 84
        for bl in b_lines:
            draw.text((px + 18, by), bl, font=get_font(10, 'regular'), fill=(163, 176, 204))
            by += 16
            
    draw_slide_footer(draw, 6)
    save_slide(base, 6)

# ==============================================================
# SLIDE 07: VISUAL DESIGN SYSTEM & BRAND TOKENS (HIGH-DENSITY 5-FOUNDATION)
# ==============================================================
def make_slide_07():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=7,
        category_en="DESIGN SYSTEM | BRAND IDENTITY & COMPONENT ARCHITECTURE",
        title_white="Cosmic Luxury 무드의 ",
        title_gold="일관된 디자인 시스템",
        subtitle_kr="기하학적 천체 그리드, WCAG 2.1 AAA 고대비 컬러, 8pt 베이스라인 토큰 체계"
    )
    
    # Coordinates
    # Row 1 (y=234 to 574, h=340) - 3 Columns
    r1_y = 234
    r1_h = 340
    
    col1_x = 100
    col1_w = 540
    
    col2_x = 665
    col2_w = 540
    
    col3_x = 1230
    col3_w = 590
    
    # -------------------------------------------------------------
    # CARD 01 (Upper Left): FORTUNEMATCH DESIGN CORE CONCEPTS (UX & GUI)
    # -------------------------------------------------------------
    draw.rounded_rectangle([col1_x, r1_y, col1_x + col1_w, r1_y + r1_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    b1_box = draw_pill_badge(draw, left_x=col1_x + 24, cy=r1_y + 30, text="FOUNDATION 01", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=8, height=22)
    draw.text((b1_box[2] + 14, r1_y + 30), "포춘매치 디자인 핵심 컨셉 (UX & GUI 철학)", font=get_font(13.0, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.line([(col1_x + 24, r1_y + 52), (col1_x + col1_w - 24, r1_y + 52)], fill=(229, 192, 123, 35), width=1)
    
    principles = [
        ("01. Cosmic Luxury (우주적 럭셔리 · Fear-Free)",
         "미신적 공포 마케팅과 난해한 한자 나열을 배제한 멘탈 큐레이션",
         "심연의 우주를 담은 Deep Obsidian(#070A12) & Imperial Gold(#FFD700) AAA 배색",
         (255, 215, 0)),
        ("02. Five-Elements Vector (오행 벡터화 · Dynamic Radar)",
         "천간지지 8글자를 목·화·토·금·수 정량 5각형 극좌표계로 즉각 시각화",
         "60fps WebGL 실시간 캔버스 렌더링, 상생·상극 오버레이 블렌딩 & 결핍 보완 솔루션",
         (0, 229, 255)),
        ("03. Dopamine Interaction (도파민 인터랙션 · Haptic Tactility)",
         "운세 확인을 즐거운 탐색 경험으로 전환하는 3D 타로 셔플 & 햅틱 모터 제어",
         "물리 엔진 기반 카드 스프레드, 0.2초 햅틱 플립, AES-256 로컬 암호화 시크릿 볼트",
         (168, 85, 247))
    ]
    py_start = r1_y + 64
    for p_title, ux_text, gui_text, p_accent in principles:
        draw.rounded_rectangle([col1_x + 24, py_start, col1_x + col1_w - 24, py_start + 70], radius=10, fill=(24, 32, 54), outline=(229, 192, 123, 40), width=1)
        draw.text((col1_x + 36, py_start + 13), p_title, font=get_font(10.2, 'bold'), fill=p_accent)
        draw.text((col1_x + 36, py_start + 32), "[UX 컨셉]", font=get_font(8.2, 'bold'), fill=(244, 246, 252))
        draw.text((col1_x + 88, py_start + 32), ux_text, font=get_font(8.2, 'regular'), fill=(203, 213, 225))
        draw.text((col1_x + 36, py_start + 49), "[GUI 컨셉]", font=get_font(8.2, 'bold'), fill=(244, 246, 252))
        draw.text((col1_x + 88, py_start + 49), gui_text, font=get_font(8.2, 'regular'), fill=(163, 176, 204))
        py_start += 78
        
    draw.rounded_rectangle([col1_x + 24, r1_y + r1_h - 38, col1_x + col1_w - 24, r1_y + r1_h - 14], radius=6, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
    draw.text((col1_x + col1_w // 2, r1_y + r1_h - 26), "Core Concepts: Cosmic Luxury · Five-Elements Vector · Dopamine Tactility", font=get_font(8.8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # -------------------------------------------------------------
    # CARD 02 (Upper Center): APP ICON GEOMETRIC DRAFTING GRID & SPEC
    # -------------------------------------------------------------
    draw.rounded_rectangle([col2_x, r1_y, col2_x + col2_w, r1_y + r1_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    b2_box = draw_pill_badge(draw, left_x=col2_x + 24, cy=r1_y + 30, text="FOUNDATION 02", font=get_font(9.5, 'bold'), theme='cyan', has_dot=True, pad_x=8, height=22)
    draw.text((b2_box[2] + 14, r1_y + 30), "앱 아이콘 기하학 천체 와이어프레임 & 조형 규격", font=get_font(13.5, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.line([(col2_x + 24, r1_y + 52), (col2_x + col2_w - 24, r1_y + 52)], fill=(229, 192, 123, 35), width=1)
    
    ic_box_x = col2_x + 22
    ic_box_y = r1_y + 62
    ic_box_size = 178
    
    draw.rounded_rectangle([ic_box_x, ic_box_y, ic_box_x + ic_box_size, ic_box_y + ic_box_size], radius=12, fill=(7, 10, 18), outline=(229, 192, 123, 50), width=1)
    
    cx = ic_box_x + ic_box_size // 2
    cy = ic_box_y + ic_box_size // 2
    
    S = 136
    R = S / 2.0
    r_in = R * 0.425
    r_mid = math.sqrt(2) * r_in
    ext = 18
    grid_line_color = (229, 192, 123, 100)
    
    draw.line([(cx - R - ext, cy - R - ext), (cx + R + ext, cy + R + ext)], fill=grid_line_color, width=1)
    draw.line([(cx - R - ext, cy + R + ext), (cx + R + ext, cy - R - ext)], fill=grid_line_color, width=1)
    
    draw.line([(cx - R - ext, cy - R), (cx + R + ext, cy - R)], fill=grid_line_color, width=1)
    draw.line([(cx - R, cy - r_in), (cx + R, cy - r_in)], fill=grid_line_color, width=1)
    draw.line([(cx - R, cy), (cx + R, cy)], fill=grid_line_color, width=1)
    draw.line([(cx - R, cy + r_in), (cx + R, cy + r_in)], fill=grid_line_color, width=1)
    draw.line([(cx - R - ext, cy + R), (cx + R + ext, cy + R)], fill=grid_line_color, width=1)
    
    draw.line([(cx - R, cy - R - ext), (cx - R, cy + R + ext)], fill=grid_line_color, width=1)
    draw.line([(cx - r_in, cy - R), (cx - r_in, cy + R)], fill=grid_line_color, width=1)
    draw.line([(cx, cy - R), (cx, cy + R)], fill=grid_line_color, width=1)
    draw.line([(cx + r_in, cy - R), (cx + r_in, cy + R)], fill=grid_line_color, width=1)
    draw.line([(cx + R, cy - R - ext), (cx + R, cy + R + ext)], fill=grid_line_color, width=1)
    
    draw.ellipse([cx - r_in, cy - r_in, cx + r_in, cy + r_in], outline=grid_line_color, width=1)
    draw.ellipse([cx - r_mid, cy - r_mid, cx + r_mid, cy + r_mid], outline=grid_line_color, width=1)
    draw.ellipse([cx - R, cy - R, cx + R, cy + R], outline=grid_line_color, width=1)
    
    r_corner = int(round(S * 0.225))
    draw.rounded_rectangle([cx - R, cy - R, cx + R, cy + R], radius=r_corner, outline=grid_line_color, width=1)
    
    ftmt_icon_path = 'd:/097.flutter_project/auto_portfolio/ftmt/assets/app_icon.png'
    if os.path.exists(ftmt_icon_path):
        try:
            raw_icon = Image.open(ftmt_icon_path).convert('RGBA')
            resized = raw_icon.resize((S, S), Image.Resampling.LANCZOS)
            
            s_layer = Image.new('RGBA', (W, H), (0, 0, 0, 0))
            sdraw = ImageDraw.Draw(s_layer)
            sdraw.rounded_rectangle([cx - S//2 + 2, cy - S//2 + 4, cx + S//2 + 2, cy + S//2 + 6], radius=r_corner + 2, fill=(0, 0, 0, 120))
            s_layer = s_layer.filter(ImageFilter.GaussianBlur(6))
            base = Image.alpha_composite(base, s_layer)
            
            icon_layer = Image.new('RGBA', (W, H), (0, 0, 0, 0))
            icon_layer.paste(resized, (cx - S//2, cy - S//2))
            base = Image.alpha_composite(base, icon_layer)
            draw = ImageDraw.Draw(base)
            
            grid_gold = (255, 215, 0, 160)
            draw.line([(cx - R, cy - R), (cx + R, cy + R)], fill=grid_gold, width=1)
            draw.line([(cx - R, cy + R), (cx + R, cy - R)], fill=grid_gold, width=1)
            draw.line([(cx - R, cy), (cx + R, cy)], fill=grid_gold, width=1)
            draw.line([(cx, cy - R), (cx, cy + R)], fill=grid_gold, width=1)
            draw.ellipse([cx - r_in, cy - r_in, cx + r_in, cy + r_in], outline=grid_gold, width=1)
            draw.ellipse([cx - r_mid, cy - r_mid, cx + r_mid, cy + r_mid], outline=grid_gold, width=1)
            draw.rounded_rectangle([cx - S//2, cy - S//2, cx + S//2, cy + S//2], radius=r_corner, outline=(255, 215, 0, 220), width=1)
        except Exception as e:
            print("Icon paste error:", e)
            
    draw.text((cx, ic_box_y + ic_box_size + 13), "Cosmic Zodiac Squircle Grid (1024×1024)", font=get_font(8.5, 'bold'), fill=(255, 215, 0), anchor='mm')
    draw.text((cx, ic_box_y + ic_box_size + 27), "Inner Ø288 · Mid Ø408 · Outer Ø680 · R22.5%", font=get_num_font(7.5, 'medium'), fill=(163, 176, 204), anchor='mm')
    
    m_x = ic_box_x + ic_box_size + 16
    specs = [
        ("01. 천체 궤도 3대 동심원 & 황금비 분할",
         "태양 궤도, 황도 12궁, 오행 회전축을 기하학적 동심원으로 정렬하여",
         "24절기와 우주 좌표가 만나는 시각적 황금비(Golden Ratio) 구축"),
        ("02. Dynamic Squircle Curvature (R22.5%)",
         "연속 곡률(Continuous Curvature) 기반 스쿼클 마스킹으로",
         "구글 플레이 스토어 및 안드로이드 Adaptive Icon 완벽 대응"),
        ("03. 5각형 오행 크레스트 & 골드 스타 아크",
         "목화토금수 에너지 중심축과 밤하늘 궤도를 상징하는 아크가",
         "키라인 그리드 45° 대각선에 100% 정렬된 럭셔리 아이덴티티 완성")
    ]
    sy = r1_y + 64
    for title, l1, l2 in specs:
        draw.text((m_x, sy), title, font=get_font(10, 'bold'), fill=(255, 215, 0) if "01" in title else (244, 246, 252))
        draw.text((m_x, sy + 18), l1, font=get_font(8.5, 'regular'), fill=(203, 213, 225))
        draw.text((m_x, sy + 32), l2, font=get_font(8.5, 'regular'), fill=(163, 176, 204))
        sy += 54
        
    draw.rounded_rectangle([col2_x + 24, r1_y + r1_h - 38, col2_x + col2_w - 24, r1_y + r1_h - 14], radius=6, fill=(35, 30, 15), outline=(229, 192, 123, 60), width=1)
    draw.text((col2_x + col2_w // 2, r1_y + r1_h - 26), "Golden Ratio Keyline Drafting Grid & Continuous Squircle Specification", font=get_font(8.8, 'bold'), fill=(229, 192, 123), anchor='mm')
    
    # -------------------------------------------------------------
    # CARD 03 (Upper Right): 24dp ICONOGRAPHY SYSTEM (FLUTTER MATERIAL)
    # -------------------------------------------------------------
    draw.rounded_rectangle([col3_x, r1_y, col3_x + col3_w, r1_y + r1_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    b3_box = draw_pill_badge(draw, left_x=col3_x + 24, cy=r1_y + 30, text="FOUNDATION 03", font=get_font(9.5, 'bold'), theme='purple', has_dot=True, pad_x=8, height=22)
    draw.text((b3_box[2] + 14, r1_y + 30), "Flutter Material Rounded 24dp 아이코노그라피", font=get_font(13.5, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.line([(col3_x + 24, r1_y + 52), (col3_x + col3_w - 24, r1_y + 52)], fill=(229, 192, 123, 35), width=1)
    
    draw.text((col3_x + 24, r1_y + 64), "Grid 24×24dp  ·  Optical Center  ·  Production Flutter Icons.*_rounded 토큰 1:1 바인딩", font=get_font(9, 'bold'), fill=(255, 215, 0))
    
    icons_data = [
        ("우주 사주 허브", "Icons.auto_awesome", 0xf556),
        ("오행 레이더 뷰", "Icons.radar_rounded", 0xf00b8),
        ("정밀 인연 매칭", "Icons.favorite_rounded", 0xf73b),
        ("3D 도파민 타로", "Icons.style_rounded", 0xf01e0),
        ("시크릿 볼트", "Icons.lock_outline_rounded", 0xf88c),
        ("VIP 마스터 패스", "Icons.workspace_premium", 0xf0289),
        ("인연 저장 히스토리", "Icons.history_toggle_off", 0xf7f0),
        ("복채 상점 충전", "Icons.diamond_rounded", 0xf69d),
    ]
    
    ic_start_y = r1_y + 86
    ic_w = (col3_w - 48 - 30) // 4
    ic_h = 96
    mat_font_icon = get_material_icon_font(23)
    
    for idx, (iname, itoken, icp) in enumerate(icons_data):
        row = idx // 4
        col = idx % 4
        ix = col3_x + 24 + col * (ic_w + 10)
        iy = ic_start_y + row * (ic_h + 10)
        
        draw.rounded_rectangle([ix, iy, ix + ic_w, iy + ic_h], radius=10, fill=(24, 32, 54), outline=(229, 192, 123, 40), width=1)
        
        icx = ix + ic_w // 2
        icy = iy + 26
        draw.rounded_rectangle([icx - 17, icy - 17, icx + 17, icy + 17], radius=8, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
        draw.text((icx, icy), chr(icp), font=mat_font_icon, fill=(255, 215, 0), anchor='mm')
        
        draw.text((icx, iy + 53), iname, font=get_font(10, 'bold'), fill=(244, 246, 252), anchor='mm')
        draw.text((icx, iy + 68), itoken, font=get_font(7.5, 'bold'), fill=(229, 192, 123), anchor='mm')
        draw.text((icx, iy + 82), f"{hex(icp)} · 24dp", font=get_font(7.5, 'regular'), fill=(163, 176, 204), anchor='mm')
        
    draw.rounded_rectangle([col3_x + 24, r1_y + r1_h - 38, col3_x + col3_w - 24, r1_y + r1_h - 14], radius=6, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
    draw.text((col3_x + col3_w // 2, r1_y + r1_h - 26), "Flutter 런타임 MaterialIcons-Regular.otf 실기기 렌더링 및 코드 토큰 100% 동기화", font=get_font(9.5, 'medium'), fill=(255, 215, 0), anchor='mm')
    
    # -------------------------------------------------------------
    # LOWER ROW (y=594 to 970, h=376): 2 WIDE COLUMNS
    # -------------------------------------------------------------
    r2_y = 594
    r2_h = 376
    
    colA_x = 100
    colA_w = 840
    
    colB_x = 960
    colB_w = 860
    
    # -------------------------------------------------------------
    # CARD 04 (Lower Left): FOUNDATION DESIGN TOKENS (COLOR, TYPE, RADIUS, ELEVATION)
    # -------------------------------------------------------------
    draw.rounded_rectangle([colA_x, r2_y, colA_x + colA_w, r2_y + r2_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    b4_box = draw_pill_badge(draw, left_x=colA_x + 28, cy=r2_y + 32, text="FOUNDATION 04", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=8, height=22)
    draw.text((b4_box[2] + 14, r2_y + 32), "파운데이션 토큰 아키텍처 & Pretendard 타이포그래피", font=get_font(14, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.line([(colA_x + 28, r2_y + 54), (colA_x + colA_w - 28, r2_y + 54)], fill=(229, 192, 123, 35), width=1)
    
    col_w_inner = (colA_w - 56 - 20) // 2
    
    # Left Half: Hero Brand Color (#FFD700), Semantics, Gradients, Elevation
    hb_y = r2_y + 64
    draw.rounded_rectangle([colA_x + 28, hb_y, colA_x + 28 + col_w_inner, hb_y + 58], radius=10, fill=(35, 30, 15), outline=(255, 215, 0), width=2)
    draw.text((colA_x + 42, hb_y + 12), "PRIMARY IMPERIAL GOLD", font=get_font(12, 'bold'), fill=(255, 215, 0))
    draw.text((colA_x + 42, hb_y + 28), "Color / Brand / Primary  ·  #FFD700", font=get_num_font(9, 'medium'), fill=(229, 192, 123))
    draw.text((colA_x + 42, hb_y + 42), "우주의 권위와 인연의 고귀함을 상징하는 럭셔리 골드", font=get_font(8, 'regular'), fill=(203, 213, 225))
    draw_pill_badge(draw, cx=colA_x + 28 + col_w_inner - 48, cy=hb_y + 29, text="8.6:1 AAA", font=get_font(8.5, 'bold'), theme='gold', has_dot=False, pad_x=7, height=20)
    
    sub_swatches = [
        ("Aurora Violet", "#8A2BE2", (138, 43, 226), "타로 아우라"),
        ("Cyan Neon", "#00E5FF", (0, 229, 255), "오행 레이더"),
        ("Jade Green", "#10B981", (16, 185, 129), "상생 & 길시"),
        ("Deep Obsidian", "#070A12", (7, 10, 18), "우주 캔버스"),
        ("Secret Rose", "#F43F5E", (244, 63, 94), "궁합 하트"),
    ]
    sw_w = (col_w_inner - 32) // 5
    sw_y = hb_y + 66
    for i, (s_name, s_hex, s_col, s_usage) in enumerate(sub_swatches):
        sx = colA_x + 28 + i * (sw_w + 8)
        draw.rounded_rectangle([sx, sw_y, sx + sw_w, sw_y + 58], radius=7, fill=(24, 32, 54), outline=(229, 192, 123, 40), width=1)
        draw.rounded_rectangle([sx + 5, sw_y + 5, sx + sw_w - 5, sw_y + 20], radius=3, fill=s_col)
        draw.text((sx + 5, sw_y + 24), s_name, font=get_font(7.5, 'bold'), fill=(244, 246, 252))
        draw.text((sx + 5, sw_y + 35), s_hex, font=get_num_font(7.5, 'bold'), fill=(229, 192, 123))
        draw.text((sx + 5, sw_y + 46), s_usage, font=get_font(6.8, 'medium'), fill=(163, 176, 204))
        
    gr_y = sw_y + 68
    draw.text((colA_x + 28, gr_y), "시그니처 브랜드 그라디언트 (Brand Gradients):", font=get_font(9, 'bold'), fill=(229, 192, 123))
    gradients_data = [
        ("Cosmic Imperial", (255, 215, 0), (229, 192, 123)),
        ("Nebula Violet", (138, 43, 226), (216, 180, 254)),
        ("Astro Cyan Wave", (0, 229, 255), (14, 165, 233)),
        ("Obsidian Surface", (14, 20, 36), (30, 41, 59)),
    ]
    gr_w = (col_w_inner - 24) // 4
    for idx, (g_name, g_c1, g_c2) in enumerate(gradients_data):
        gx = colA_x + 28 + idx * (gr_w + 8)
        for step in range(gr_w):
            ratio = step / max(1, gr_w - 1)
            rc = int(g_c1[0] + (g_c2[0] - g_c1[0]) * ratio)
            gc = int(g_c1[1] + (g_c2[1] - g_c1[1]) * ratio)
            bc = int(g_c1[2] + (g_c2[2] - g_c1[2]) * ratio)
            draw.line([(gx + step, gr_y + 14), (gx + step, gr_y + 30)], fill=(rc, gc, bc))
        draw.rounded_rectangle([gx, gr_y + 14, gx + gr_w, gr_y + 30], radius=4, outline=(229, 192, 123, 80), width=1)
        draw.text((gx + gr_w//2, gr_y + 36), g_name, font=get_font(7, 'bold'), fill=(163, 176, 204), anchor='mm')
        
    el_y = gr_y + 48
    draw.text((colA_x + 28, el_y), "엘레베이션 & 뎁스 토큰 (Elevation Hierarchy):", font=get_font(9, 'bold'), fill=(229, 192, 123))
    elevations = [
        ("Elevation 1 (2dp)", "Y:2 Blur:6", "카드 서피스"),
        ("Elevation 2 (8dp)", "Y:8 Blur:20", "모달 · 바텀시트"),
        ("Elevation 3 (16dp)", "Y:16 Blur:32", "3D 타로 플로팅"),
    ]
    el_w = (col_w_inner - 16) // 3
    for idx, (el_title, el_spec, el_use) in enumerate(elevations):
        ex = colA_x + 28 + idx * (el_w + 8)
        ey = el_y + 14
        draw.rounded_rectangle([ex, ey, ex + el_w, ey + 42], radius=6, fill=(24, 32, 54), outline=(229, 192, 123, 40), width=1)
        draw.text((ex + 8, ey + 6), el_title, font=get_font(7.5, 'bold'), fill=(255, 215, 0))
        draw.text((ex + 8, ey + 18), el_spec, font=get_num_font(7.2, 'medium'), fill=(163, 176, 204))
        draw.text((ex + 8, ey + 29), el_use, font=get_font(7, 'regular'), fill=(203, 213, 225))
        
    # Right Half of Card 04: Typography & Corner Radius Token Matrix
    ty_x = colA_x + 28 + col_w_inner + 20
    ty_w = col_w_inner
    
    t_rows = [
        ("Display 28", "Bold", "92% 궁합 케미스트리", False),
        ("Headline 20", "Bold", "우주 사주 고유 좌표", False),
        ("Title 16", "SemiBold", "오행 실시간 레이더 분석", False),
        ("Body 14", "Regular", "14:30 ~ 16:00 금전운 길시", False),
        ("Caption 11", "Medium", "AES-256 로컬 암호화 완료", False),
    ]
    ty_start = r2_y + 64
    for i, (t_role, t_weight, t_sample, is_mono) in enumerate(t_rows):
        ry = ty_start + i * 25
        draw.rounded_rectangle([ty_x, ry, ty_x + ty_w, ry + 21], radius=5, fill=(24, 32, 54), outline=(229, 192, 123, 40), width=1)
        draw.text((ty_x + 8, ry + 4), t_role, font=get_font(8.5, 'bold'), fill=(255, 215, 0))
        draw.text((ty_x + 85, ry + 4), t_weight, font=get_font(8, 'medium'), fill=(163, 176, 204))
        draw.text((ty_x + ty_w - 8, ry + 4), t_sample, font=get_font(8, 'semibold'), fill=(244, 246, 252), anchor='ra')
        
    sp_box_y = ty_start + len(t_rows) * 25 + 6
    sp_box_h = (r2_y + r2_h - 26) - sp_box_y
    draw.rounded_rectangle([ty_x, sp_box_y, ty_x + ty_w, sp_box_y + sp_box_h], radius=10, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
    
    draw.text((ty_x + 12, sp_box_y + 9), "코너 라운드 & 스페이싱 토큰 규칙 (Foundation Rules)", font=get_font(9.5, 'bold'), fill=(255, 215, 0))
    draw_pill_badge(draw, cx=ty_x + ty_w - 44, cy=sp_box_y + 16, text="8pt Grid", font=get_font(7.5, 'bold'), theme='gold', has_dot=False, pad_x=5, height=16)
    
    r_swatches = [
        ("radius.sm", "8px", 8, "태그 · 칩"),
        ("radius.md", "12px", 12, "버튼 · 인풋창"),
        ("radius.lg", "16px", 16, "결과 카드 · 모달"),
        ("radius.full", "999px", 19, "필 뱃지 · CTA"),
    ]
    rw_item = (ty_w - 24 - 18) // 4
    r_y = sp_box_y + 28
    for idx, (r_token, r_val, r_px, r_usage) in enumerate(r_swatches):
        rx = ty_x + 12 + idx * (rw_item + 6)
        draw.rounded_rectangle([rx, r_y, rx + rw_item, r_y + 46], radius=r_px, fill=(24, 32, 54), outline=(255, 215, 0), width=1)
        draw.rounded_rectangle([rx + 4, r_y + 4, rx + rw_item - 4, r_y + 18], radius=max(2, r_px - 3), fill=(35, 30, 15))
        draw.text((rx + rw_item // 2, r_y + 11), f"R {r_val}", font=get_font(7.5, 'bold'), fill=(255, 215, 0), anchor='mm')
        draw.text((rx + rw_item // 2, r_y + 25), r_token, font=get_num_font(6.8, 'bold'), fill=(244, 246, 252), anchor='mm')
        draw.text((rx + rw_item // 2, r_y + 36), r_usage, font=get_font(6.5, 'regular'), fill=(163, 176, 204), anchor='mm')
        
    sy_line = r_y + 52
    draw.text((ty_x + 12, sy_line), "스페이싱 토큰 (Spatial Scale): 4·8·12·16·24·32pt 기반 베이스라인 그리드", font=get_font(8, 'regular'), fill=(203, 213, 225))
    draw.text((ty_x + 12, sy_line + 14), "고정폭 숫자 (Tabular Figures): 실시간 궁합 점수 및 절기 궤도 각도 떨림 방지", font=get_font(8, 'regular'), fill=(203, 213, 225))
    draw.text((ty_x + 12, sy_line + 28), "3-Tier 토큰 파이프라인: Global(Primitive) → Semantic(Context) → Component 1:1", font=get_font(8, 'bold'), fill=(255, 215, 0))
    
    draw.text((colA_x + 28, r2_y + r2_h - 17), "WCAG 2.1 AAA 8.6:1 초고대비율 준수 · 디자인 시스템 시맨틱 토큰 100% 동기화 아키텍처", font=get_font(9, 'regular'), fill=(163, 176, 204))
    
    # -------------------------------------------------------------
    # CARD 05 (Lower Right): ATOMIC UI COMPONENT KIT
    # -------------------------------------------------------------
    draw.rounded_rectangle([colB_x, r2_y, colB_x + colB_w, r2_y + r2_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    b5_box = draw_pill_badge(draw, left_x=colB_x + 28, cy=r2_y + 32, text="FOUNDATION 05", font=get_font(9.5, 'bold'), theme='cyan', has_dot=True, pad_x=8, height=22)
    draw.text((b5_box[2] + 14, r2_y + 32), "프로덕션 아토믹 UI 컴포넌트 킷", font=get_font(14, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.line([(colB_x + 28, r2_y + 54), (colB_x + colB_w - 28, r2_y + 54)], fill=(229, 192, 123, 35), width=1)
    
    k1_y = r2_y + 68
    k1_w = (colB_w - 56 - 20) // 2
    
    # Birth Coordinates Input Stepper Box
    draw.rounded_rectangle([colB_x + 28, k1_y, colB_x + 28 + k1_w, k1_y + 80], radius=10, fill=(24, 32, 54), outline=(255, 215, 0), width=2)
    draw.text((colB_x + 40, k1_y + 10), "탄생 시각 & 24절기 정밀 스텝퍼", font=get_font(9.5, 'bold'), fill=(255, 215, 0))
    draw.text((colB_x + 40, k1_y + 30), "1998. 08. 14 (양력)", font=get_num_font(14, 'bold'), fill=(244, 246, 252))
    draw_pill_badge(draw, cx=colB_x + 28 + k1_w - 40, cy=k1_y + 26, text="ACTIVE", font=get_font(8, 'bold'), theme='gold', has_dot=False, pad_x=5, height=18)
    
    draw.rounded_rectangle([colB_x + 40, k1_y + 50, colB_x + 28 + k1_w - 12, k1_y + 72], radius=5, fill=(35, 30, 15), outline=(229, 192, 123, 60), width=1)
    mat_font_btn = get_material_icon_font(15)
    draw.text((colB_x + 58, k1_y + 61), chr(0xf00f1), font=mat_font_btn, fill=(255, 215, 0), anchor='mm')
    draw.text((colB_x + 28 + k1_w // 2, k1_y + 61), "사시(巳時) 09:30~11:30 (시각 보정)", font=get_font(9.5, 'bold'), fill=(244, 246, 252), anchor='mm')
    draw.text((colB_x + 28 + k1_w - 28, k1_y + 61), chr(0xf537), font=mat_font_btn, fill=(255, 215, 0), anchor='mm')
    
    # Zodiac Chemistry Summary & Gender Toggle Box
    k2_x = colB_x + 28 + k1_w + 20
    draw.rounded_rectangle([k2_x, k1_y, k2_x + k1_w, k1_y + 80], radius=10, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
    draw.text((k2_x + 14, k1_y + 10), "상대방 인연 요약 & 오행 토글", font=get_font(9.5, 'bold'), fill=(255, 215, 0))
    draw.text((k2_x + 14, k1_y + 30), "궁합 지수 92% (천간합·방합 성립)", font=get_font(13.5, 'bold'), fill=(244, 246, 252))
    draw.text((k2_x + 14, k1_y + 54), "결핍 오행 보완: 수(물) 기운 +42% 시너지", font=get_font(9.5, 'bold'), fill=(0, 229, 255))
    
    # Gender/Element Segmented Control
    draw.rounded_rectangle([k2_x + k1_w - 95, k1_y + 48, k2_x + k1_w - 14, k1_y + 70], radius=11, fill=(24, 32, 54), outline=(229, 192, 123, 60), width=1)
    draw.rounded_rectangle([k2_x + k1_w - 93, k1_y + 50, k2_x + k1_w - 56, k1_y + 68], radius=9, fill=(255, 215, 0))
    draw.text((k2_x + k1_w - 75, k1_y + 59), "상생", font=get_font(8, 'bold'), fill=(7, 10, 18), anchor='mm')
    draw.text((k2_x + k1_w - 35, k1_y + 59), "상극", font=get_font(8, 'bold'), fill=(163, 176, 204), anchor='mm')
    
    # Bottom Half of Card 05: Action CTA & Secret Vault Component
    k3_y = k1_y + 92
    draw.rounded_rectangle([colB_x + 28, k3_y, colB_x + 28 + k1_w, r2_y + r2_h - 24], radius=10, fill=(24, 32, 54), outline=(229, 192, 123, 40), width=1)
    draw.text((colB_x + 40, k3_y + 14), "인터랙티브 CTA 버튼 시스템", font=get_font(11, 'bold'), fill=(244, 246, 252))
    draw.text((colB_x + 40, k3_y + 32), "엄지 조작성 고려 R12 / 52dp 규격", font=get_font(8.5, 'regular'), fill=(163, 176, 204))
    
    draw.rounded_rectangle([colB_x + 40, k3_y + 54, colB_x + 28 + k1_w - 12, k3_y + 94], radius=12, fill=(229, 192, 123))
    draw.text((colB_x + 28 + k1_w // 2, k3_y + 74), "궁합 결과 볼트에 암호화 저장 ↗", font=get_font(10.5, 'bold'), fill=(7, 10, 18), anchor='mm')
    
    draw.rounded_rectangle([colB_x + 40, k3_y + 104, colB_x + 28 + k1_w - 12, k3_y + 144], radius=12, fill=(35, 30, 15), outline=(255, 215, 0), width=1)
    draw.text((colB_x + 28 + k1_w // 2, k3_y + 124), "다시 타로 셔플하기 (재시도)", font=get_font(10, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw.rounded_rectangle([k2_x, k3_y, k2_x + k1_w, r2_y + r2_h - 24], radius=10, fill=(30, 18, 48), outline=(168, 85, 247, 80), width=1)
    draw.text((k2_x + 14, k3_y + 14), "시크릿 볼트 (SQLite 암호화 모듈)", font=get_font(11, 'bold'), fill=(216, 180, 254))
    draw.text((k2_x + 14, k3_y + 32), "외부 서버 무전송 · 100% 온디바이스", font=get_font(8.5, 'regular'), fill=(163, 176, 204))
    
    draw.rounded_rectangle([k2_x + 14, k3_y + 54, k2_x + k1_w - 14, k3_y + 94], radius=8, fill=(24, 32, 54), outline=(229, 192, 123, 60), width=1)
    draw.text((k2_x + 26, k3_y + 68), "암호화 키: AES-256 GCM Salted", font=get_font(9, 'bold'), fill=(255, 215, 0))
    draw.text((k2_x + 26, k3_y + 82), "저장된 인연: 총 12명 (보안 보관 중)", font=get_font(8.5, 'regular'), fill=(203, 213, 225))
    
    draw.rounded_rectangle([k2_x + 14, k3_y + 104, k2_x + k1_w - 14, k3_y + 144], radius=8, fill=(24, 32, 54), outline=(168, 85, 247, 60), width=1)
    draw.text((k2_x + 26, k3_y + 118), "타로 아르카나 기록: 38회 완료", font=get_font(9, 'bold'), fill=(216, 180, 254))
    draw.text((k2_x + 26, k3_y + 132), "로컬 DB 용량: 142KB · 제로 누수 보장", font=get_font(8.5, 'regular'), fill=(16, 185, 129))
    
    draw_slide_footer(draw, 7)
    save_slide(base, 7)


# ==============================================================
# ==============================================================
# SLIDE 08: CORE FEATURE 01 - FIVE ELEMENTS INTERACTIVE RADAR (3-COLUMN TRI-PANE)
# ==============================================================
def make_slide_08():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    # -------------------------------------------------------------
    # 1. Left Column: Grouped Header Card & Comparison Pane (x=100, w=490)
    # -------------------------------------------------------------
    lx = 100
    lw = 490
    
    # 1-A. Unified Kicker Badge
    draw_pill_badge(draw, left_x=lx, cy=78, text="08 CORE FEATURE | 5-ELEMENTS INTERACTIVE RADAR", font=get_font(10.5, 'bold'), theme='gold', has_dot=True, pad_x=10, height=26)
    
    # Headline
    t1_a = "내 기운을 한눈에 파악하는 "
    t1_b = "5각 실시간 레이더"
    font_title = get_font(31, 'extrabold')
    w_t1_a = draw.textlength(t1_a, font=font_title)
    draw.text((lx, 116), t1_a, font=font_title, fill=(244, 246, 252))
    draw.text((lx + w_t1_a, 116), t1_b, font=font_title, fill=(255, 215, 0))
    
    t2_a = "0.3초 만에 "
    t2_b = "오행 밸런스를 확인해요."
    w_t2_a = draw.textlength(t2_a, font=font_title)
    draw.text((lx, 158), t2_a, font=font_title, fill=(0, 229, 255))
    draw.text((lx + w_t2_a, 158), t2_b, font=font_title, fill=(244, 246, 252))
    
    desc_text = "천간·지지 8글자를 목·화·토·금·수 5각형 극좌표계로 즉각 시각화했습니다. 결핍된 에너지를 0.3초 만에 파악하고 맞춤 라이프스타일 처방을 전달합니다."
    desc_lines = wrap_text_by_words(desc_text, get_font(12, 'regular'), lw, draw)
    dy = 212
    for dl in desc_lines:
        draw.text((lx, dy), dl, font=get_font(12, 'regular'), fill=(163, 176, 204))
        dy += 19
        
    # 1-B. Comparison Container Card (Traditional Text vs 5-Elements Radar)
    comp_y = 310
    comp_h = 660
    draw.rounded_rectangle([lx, comp_y, lx + lw, comp_y + comp_h], radius=18, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    
    draw_pill_badge(draw, left_x=lx + 24, cy=comp_y + 30, text="PARADIGM COMPARISON", font=get_font(9.5, 'bold'), theme='slate', has_dot=False, pad_x=8, height=22)
    draw.text((lx + 185, comp_y + 22), "기존 한자 나열 vs 5각형 실시간 레이더", font=get_font(14, 'bold'), fill=(244, 246, 252))
    draw.line([(lx + 24, comp_y + 50), (lx + lw - 24, comp_y + 50)], fill=(229, 192, 123, 35), width=1)
    
    # 2 Comparison Mockups (iphone_01_hub vs iphone_02_radar)
    screen_hub_path = f"{MOCKUP_DIR}/iphone_01_hub.png"
    screen_match_path = f"{MOCKUP_DIR}/iphone_02_radar.png"
    
    if os.path.exists(screen_hub_path) and os.path.exists(screen_match_path):
        screen_hub = Image.open(screen_hub_path).convert('RGBA')
        screen_match = Image.open(screen_match_path).convert('RGBA')
        
        s_w = 170
        s_h = int(round(s_w * (screen_hub.height / screen_hub.width)))
        s1 = screen_hub.resize((s_w, s_h), Image.Resampling.LANCZOS)
        s2 = screen_match.resize((s_w, s_h), Image.Resampling.LANCZOS)
        
        y_screen = comp_y + 68
        x_s1 = lx + 32
        x_s2 = lx + lw - 32 - s_w
        
        draw_pill_badge(draw, cx=x_s1 + s_w//2, cy=y_screen + 14, text="난해한 만세력 텍스트", font=get_font(10, 'bold'), theme='slate', has_dot=False, pad_x=10, height=22)
        draw_pill_badge(draw, cx=x_s2 + s_w//2, cy=y_screen + 14, text="5각형 실시간 레이더", font=get_font(10, 'bold'), theme='gold', has_dot=False, pad_x=10, height=22)
        
        for sx, simg in [(x_s1, s1), (x_s2, s2)]:
            sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
            shd = ImageDraw.Draw(sh)
            shd.rounded_rectangle([sx + 6, y_screen + 34, sx + s_w - 6, y_screen + 34 + s_h], radius=22, fill=(0, 0, 0, 100))
            sh = sh.filter(ImageFilter.GaussianBlur(12))
            base = Image.alpha_composite(base, sh)
            base.paste(simg, (sx, y_screen + 28), simg)
            
        draw = ImageDraw.Draw(base)
        by_s1 = y_screen + 28 + s_h + 16
        draw.rounded_rectangle([x_s1, by_s1, x_s1 + s_w, comp_y + comp_h - 18], radius=10, fill=(24, 32, 54), outline=(100, 116, 139), width=1)
        draw.text((x_s1 + 10, by_s1 + 10), "고전 텍스트 사주 방식", font=get_font(10, 'bold'), fill=C_TEXT_BODY)
        draw.text((x_s1 + 10, by_s1 + 28), "난해한 한자 텍스트 나열\n인지 부하 극심 (이탈 74%)\n미신적 공포 마케팅 피로감", font=get_font(9.5, 'medium'), fill=C_TEXT_MUTED, spacing=4)
        
        draw.rounded_rectangle([x_s2, by_s1, x_s2 + s_w, comp_y + comp_h - 18], radius=10, fill=(35, 30, 15), outline=(229, 192, 123, 80), width=1)
        draw.text((x_s2 + 10, by_s1 + 10), "포춘매치 60fps 레이더", font=get_font(10, 'bold'), fill=C_GOLD_HERO)
        draw.text((x_s2 + 10, by_s1 + 28), "5개 축 극좌표계 벡터화\n손끝 터치 감성 인터랙션\n1-Tap 터치 즉각 보완 처방", font=get_font(9.5, 'bold'), fill=C_GOLD_HERO, spacing=4)
        
    # -------------------------------------------------------------
    # 2. Center Column: Grand Hero Phone Mockup (Center Stage)
    # -------------------------------------------------------------
    phone_hero_path = f"{MOCKUP_DIR}/iphone_02_radar.png"
    if os.path.exists(phone_hero_path):
        phone_raw = Image.open(phone_hero_path).convert('RGBA')
        ph = 640
        pw = int(round(ph * (phone_raw.width / phone_raw.height)))
        phone_v = phone_raw.resize((pw, ph), Image.Resampling.LANCZOS)
        
        px = 670
        py = 234
        
        sh_center = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        shc_draw = ImageDraw.Draw(sh_center)
        shc_draw.rounded_rectangle([px + 12, py + 16, px + pw - 12, py + ph + 24], radius=36, fill=(0, 0, 0, 140))
        shc_draw.ellipse([px - 20, py + ph - 25, px + pw + 20, py + ph + 35], fill=(229, 192, 123, 50))
        sh_center = sh_center.filter(ImageFilter.GaussianBlur(26))
        base = Image.alpha_composite(base, sh_center)
        base.paste(phone_v, (px, py), phone_v)
        draw = ImageDraw.Draw(base)
        
    # -------------------------------------------------------------
    # 3. Right Column: 3 Distinct Grouped Feature Cards (x=1050, w=770)
    # -------------------------------------------------------------
    rx = 1050
    rw = 770
    
    # CARD 1: 5-Elements UX Vectorization Card
    c1_y = 234
    c1_h = 145
    draw.rounded_rectangle([rx, c1_y, rx + rw, c1_y + c1_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    draw_pill_badge(draw, left_x=rx + 28, cy=c1_y + 30, text="UX VISUALIZATION", font=get_font(10, 'bold'), theme='gold', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 230, c1_y + 20), "사주 8글자를 5각형 극좌표계 레이더로 시각화", font=get_font(17, 'bold'), fill=C_TITLE_WHITE)
    draw.line([(rx + 28, c1_y + 50), (rx + rw - 28, c1_y + 50)], fill=(229, 192, 123, 40), width=1)
    
    c1_desc = "사용자가 태어난 생년월일시의 8글자를 복잡한 표 대신 목·화·토·금·수 5대 에너지의 면적으로 재해석했습니다.\n극좌표계 다각형을 통해 본인의 강점 기운과 결핍된 기운을 0.1초 만에 한눈에 조망할 수 있는 직관적 UI를 구현했습니다."
    draw.text((rx + 28, c1_y + 64), c1_desc, font=get_font(12, 'medium'), fill=C_TEXT_BODY, spacing=5)
    draw.text((rx + 28, c1_y + 116), "✓ 인지 부하 74% 절감 · 직관적 극좌표계 UI · 5대 고유 파동 색상(목/화/토/금/수) 시각화", font=get_font(11, 'bold'), fill=C_GOLD_HERO)
    
    # CARD 2: 60fps Interactive Tactile Experience Card
    c2_y = 394
    c2_h = 145
    draw.rounded_rectangle([rx, c2_y, rx + rw, c2_y + c2_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    draw_pill_badge(draw, left_x=rx + 28, cy=c2_y + 30, text="TACTILE INTERACTION", font=get_font(10, 'bold'), theme='cyan', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 245, c2_y + 20), "손끝 터치에 반응하는 60fps 감성 인터랙션", font=get_font(17, 'bold'), fill=C_TITLE_WHITE)
    draw.line([(rx + 28, c2_y + 50), (rx + rw - 28, c2_y + 50)], fill=(229, 192, 123, 40), width=1)
    
    c2_desc = "정적인 차트를 탈피하여 각 꼭짓점을 터치하면 해당 기운이 팽창하고 햅틱 진동 피드백이 발생합니다.\n화면 전환 시 부드러운 다각형 모핑 애니메이션을 통해 살아 숨 쉬는 우주 에너지의 감성적 조작감을 제공합니다."
    draw.text((rx + 28, c2_y + 64), c2_desc, font=get_font(12, 'medium'), fill=C_TEXT_BODY, spacing=5)
    draw.text((rx + 28, c2_y + 116), "✓ 60fps 모핑 애니메이션 · 1-Tap 햅틱 터치 피드백 · 상생·상극 오버레이 하이라이트", font=get_font(11, 'bold'), fill=C_CYAN_ACCENT)
    
    # CARD 3: Lifestyle Remedy Solution Card
    c3_y = 554
    c3_h = 145
    draw.rounded_rectangle([rx, c3_y, rx + rw, c3_y + c3_h], radius=16, fill=(14, 20, 36, 230), outline=(229, 192, 123, 70), width=1)
    draw_pill_badge(draw, left_x=rx + 28, cy=c3_y + 30, text="LIFESTYLE CURATION", font=get_font(10, 'bold'), theme='purple', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 245, c3_y + 20), "결핍 기운 맞춤형 데일리 라이프스타일 처방", font=get_font(17, 'bold'), fill=C_TITLE_WHITE)
    draw.line([(rx + 28, c3_y + 50), (rx + rw - 28, c3_y + 50)], fill=(229, 192, 123, 40), width=1)
    
    c3_desc = "단순한 결핍 통보에 그치지 않고, 일상에서 즉각 실천 가능한 4대 감성 라이프스타일 가이드를 제시합니다.\n부족한 기운을 채우는 패션 컬러 코디, 힐링 푸드 테라피, 업무 집중도를 높이는 책상 방위를 1-Tap으로 연결합니다."
    draw.text((rx + 28, c3_y + 64), c3_desc, font=get_font(12, 'medium'), fill=C_TEXT_BODY, spacing=5)
    draw.text((rx + 28, c3_y + 116), "✓ 사용자 만족도 96.4% · 데일리 리텐션 견인 1위 · 인스타그램 스토리 공유 41.8%", font=get_font(11, 'bold'), fill=C_PURPLE_ACC)
    
    # 4-Item Feature Strip at Bottom Right (y=714 to 970, h=256)
    b_strip_y = 714
    b_strip_h = 256
    draw.rounded_rectangle([rx, b_strip_y, rx + rw, b_strip_y + b_strip_h], radius=16, fill=(24, 32, 54), outline=(229, 192, 123, 70), width=1)
    draw_pill_badge(draw, left_x=rx + 24, cy=b_strip_y + 28, text="RADAR UX PRINCIPLES", font=get_font(9.5, 'bold'), theme='gold', has_dot=True, pad_x=8, height=22)
    draw.text((rx + 220, b_strip_y + 20), "오행 실시간 레이더 4대 핵심 서비스 기획 & UX 원칙", font=get_font(15, 'bold'), fill=C_TITLE_WHITE)
    draw.line([(rx + 24, b_strip_y + 48), (rx + rw - 24, b_strip_y + 48)], fill=(229, 192, 123, 40), width=1)
    
    radar_principles = [
        ("01. Zero-Friction Visual Handoff", "사주 8글자를 읽지 않고 5각형 형태만으로 본인의 기운 밸런스를 0.3초 만에 직관 파악"),
        ("02. Seamless Haptic & Micro-Motion", "터치 반응형 다각형 모핑과 햅틱 모터를 연동하여 실물 나침반을 만지는 듯한 감성 손맛 전달"),
        ("03. Modern Color Semantics", "동양 전통 오행색(청/적/황/백/흑)을 현대적 세련된 네온 파스텔 톤으로 재해석하여 시각적 피로 차단"),
        ("04. 1-Tap Daily Lifestyle Action", "부족한 에너지를 채우는 패션/음식/행동 팁을 매일 아침 길시 리포트와 함께 원터치 전달")
    ]
    py_rp = b_strip_y + 62
    for rp_title, rp_desc in radar_principles:
        draw.text((rx + 24, py_rp), rp_title, font=get_font(11.5, 'bold'), fill=C_GOLD_HERO)
        draw.text((rx + 24, py_rp + 18), rp_desc, font=get_font(10.5, 'medium'), fill=C_TEXT_BODY)
        py_rp += 46
        
    draw_slide_footer(draw, 8)
    save_slide(base, 8)


print("Slide 05 to 08 updated cleanly.")

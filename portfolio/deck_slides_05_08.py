import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter
from build_executive_ftmt_deck import (
    W, H, MOCKUP_DIR, get_font, get_num_font, wrap_text_by_words,
    draw_diamond, draw_arrow, draw_dashed_line, draw_dashed_arrow,
    draw_pill_badge, draw_dotted_callout,
    create_cosmic_base, draw_slide_header, draw_slide_footer, save_slide
)

def draw_gradient_bar(base, bbox, color_start, color_end, radius=6):
    x1, y1, x2, y2 = bbox
    bw = max(1, x2 - x1)
    bh = max(1, y2 - y1)
    bar_img = Image.new('RGBA', (bw, bh))
    r1, g1, b1 = color_start[:3]
    r2, g2, b2 = color_end[:3]
    for x in range(bw):
        t = x / max(1, bw - 1)
        r = int(r1 + (r2 - r1) * t)
        g = int(g1 + (g2 - g1) * t)
        b = int(b1 + (b2 - b1) * t)
        for y in range(bh):
            bar_img.putpixel((x, y), (r, g, b, 255))
            
    # Rounded mask
    mask = Image.new('L', (bw, bh), 0)
    m_draw = ImageDraw.Draw(mask)
    m_draw.rounded_rectangle([0, 0, bw, bh], radius=radius, fill=255)
    
    base.paste(bar_img, (x1, y1), mask)

# ==============================================================
# SLIDE 05: USER FLOW & EXPERIENCE LOGIC
# ==============================================================
def make_slide_05():
    # Use clean, high-contrast luxury editorial canvas like Smart DCA
    base = Image.new('RGBA', (W, H), (248, 250, 252, 255))
    draw = ImageDraw.Draw(base)
    
    # Hairline Boundaries
    draw.line([(100, 85), (1820, 85)], fill=(226, 232, 240), width=1)
    draw.line([(100, 985), (1820, 985)], fill=(226, 232, 240), width=1)
    
    # Header
    draw.text((100, 60), "05 USER FLOW & EXPERIENCE LOGIC | STATE MACHINE", font=get_font(13.5, 'bold'), fill=(180, 83, 9))
    draw.text((100, 95), "인지적 마찰을 제로화한 ", font=get_font(38, 'bold'), fill=(15, 23, 42))
    w_t1 = draw.textlength("인지적 마찰을 제로화한 ", font=get_font(38, 'bold'))
    draw.text((100 + w_t1, 95), "단계별 사용자 인터랙션 흐름도", font=get_font(38, 'bold'), fill=(180, 83, 9))
    draw.text((100, 150), "탄생 좌표 입력부터 오행 분석, 궁합 매칭, 타로 솔루션으로 이어지는 논리적 상태 전이(State Machine)", font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    
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
        draw.rounded_rectangle([cx, 210, cx + cw, 260], radius=8, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
        draw_pill_badge(draw, left_x=cx + 14, cy=225, text=st_code, font=get_font(8, 'bold'), theme='amber', pad_x=6, height=18)
        draw.text((cx + 95, 225), st_name, font=get_font(11.5, 'bold'), fill=(15, 23, 42), anchor='lm')
        draw.text((cx + 14, 246), st_en, font=get_font(8.5, 'medium'), fill=(180, 83, 9), anchor='lm')
        
        if i < 4:
            arrow_start_x = cx + cw
            arrow_end_x = cols_x[i + 1]
            draw_arrow(draw, (arrow_start_x + 2, 235), (arrow_end_x - 2, 235), col=(180, 83, 9), width=2, arrow_size=4)
            
    nw = 260
    
    # Track 1: Stage 01
    c0 = col_centers[0]
    draw.rounded_rectangle([c0 - 75, 276, c0 + 75, 304], radius=14, fill=(180, 83, 9))
    draw.text((c0, 290), "Start : 앱 실행", font=get_font(9.5, 'bold'), fill=(255, 255, 255), anchor='mm')
    draw_arrow(draw, (c0, 304), (c0, 320), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c0 - nw // 2, 320, c0 + nw // 2, 364], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c0 - 114, cy=334, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c0 - 54, 334), "스플래시 & 로컬 환경 로드", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c0, 351), "기기 로컬 암호화 저장소 세션 검증", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c0, 364), (c0, 382), col=(180, 83, 9), width=2, arrow_size=4)
    
    # Diamond: 최초 실행?
    draw_diamond(draw, cx=c0, cy=408, w=176, h=52, fill=(254, 243, 199), outline=(180, 83, 9), width=2)
    draw.text((c0, 408), "기존 프로필 존재?", font=get_font(9.5, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    # Branch No -> Onboarding
    draw_dashed_line(draw, (c0 + 88, 408), (cols_x[0] + cw - 16, 408), col=(8, 145, 178), width=1)
    draw.text(((c0 + 88 + cols_x[0] + cw - 16) // 2, 398), "No (신규)", font=get_font(7.5, 'bold'), fill=(8, 145, 178), anchor='mm')
    draw_dashed_arrow(draw, (cols_x[0] + cw - 16, 408), (cols_x[0] + cw - 16, 440), col=(8, 145, 178), width=1, arrow_size=3)
    draw.rounded_rectangle([cols_x[0] + cw - 88, 440, cols_x[0] + cw - 6, 472], radius=5, fill=(236, 254, 255), outline=(165, 243, 252), width=1)
    draw.text((cols_x[0] + cw - 47, 451), "생년월일 온보딩", font=get_font(7.5, 'bold'), fill=(8, 145, 178), anchor='mm')
    draw.text((cols_x[0] + cw - 47, 462), "좌표 자동 연산", font=get_font(7, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_dashed_line(draw, (cols_x[0] + cw - 47, 472), (cols_x[0] + cw - 47, 500), col=(8, 145, 178), width=1)
    draw_dashed_arrow(draw, (cols_x[0] + cw - 47, 500), (c0 + nw // 2, 500), col=(8, 145, 178), width=1, arrow_size=3)
    
    # Branch Yes -> Load
    draw_arrow(draw, (c0, 434), (c0, 478), col=(180, 83, 9), width=2, arrow_size=4)
    draw.text((c0 - 30, 456), "Yes (기존)", font=get_font(8, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    draw.rounded_rectangle([c0 - nw // 2, 478, c0 + nw // 2, 522], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c0 - 114, cy=492, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c0 - 54, 492), "내 우주 좌표 로드 완료", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c0, 509), "4주 8글자 및 일주 동물·별자리 바인딩", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c0, 522), (c0, 540), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c0 - nw // 2, 540, c0 + nw // 2, 584], radius=6, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw_pill_badge(draw, left_x=c0 - 114, cy=554, text="ACTION", font=get_font(6.5, 'bold'), theme='amber', pad_x=4, height=14)
    draw.text((c0 - 54, 554), "우주 사주 허브 자동 전환", font=get_font(9, 'bold'), fill=(180, 83, 9), anchor='lm')
    draw.text((c0, 571), "0.3초 만에 나침반 궤도 렌더링 준비", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c0, 584), (c0, 602), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c0 - nw // 2, 602, c0 + nw // 2, 648], radius=6, fill=(236, 253, 245), outline=(167, 243, 208), width=1)
    draw_pill_badge(draw, left_x=c0 - 114, cy=616, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((c0 - 44, 616), "메인 좌표 세션 활성화", font=get_font(9, 'bold'), fill=(0, 180, 90), anchor='lm')
    draw.text((c0, 632), "하단 독 네비게이션 4대 코어 탭 노출", font=get_font(7.5, 'medium'), fill=(100, 116, 139), anchor='mm')
    
    # Handover to Stage 02
    draw_arrow(draw, (cols_x[0] + cw, 623), (cols_x[1], 623), col=(180, 83, 9), width=2, arrow_size=4)
    draw.text(((cols_x[0] + cw + cols_x[1]) // 2, 611), "진입 ->", font=get_font(8, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    # Track 2: Stage 02
    c1 = col_centers[1]
    draw.rounded_rectangle([c1 - nw // 2, 276, c1 + nw // 2, 320], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=290, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c1 - 54, 290), "우주 사주 허브 메인 뷰", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c1, 307), "24절기 천체 궤도 & 우주 좌표 카드 표출", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c1, 320), (c1, 336), col=(180, 83, 9), width=2, arrow_size=4)
    
    # Decision Container: 3 Core Features
    draw.rounded_rectangle([c1 - nw // 2, 336, c1 + nw // 2, 440], radius=6, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=350, text="DECISION", font=get_font(6.5, 'bold'), theme='amber', pad_x=4, height=14)
    draw.text((c1 - 48, 350), "3대 인터랙션 선택 진입", font=get_font(8.5, 'bold'), fill=(180, 83, 9), anchor='lm')
    
    draw.rounded_rectangle([c1 - 114, 363, c1 + 114, 384], radius=4, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw.text((c1, 373), "A. 오행 실시간 레이더 분석 탭", font=get_font(8, 'medium'), fill=(71, 85, 105), anchor='mm')
    draw.rounded_rectangle([c1 - 114, 388, c1 + 114, 409], radius=4, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw.text((c1, 398), "B. 인연 정밀 궁합 매칭 탭", font=get_font(8, 'medium'), fill=(71, 85, 105), anchor='mm')
    draw.rounded_rectangle([c1 - 114, 413, c1 + 114, 434], radius=4, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw.text((c1, 423), "C. 도파민 럭셔리 타로 탭", font=get_font(8, 'medium'), fill=(71, 85, 105), anchor='mm')
    draw_arrow(draw, (c1, 440), (c1, 458), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c1 - nw // 2, 458, c1 + nw // 2, 502], radius=6, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=472, text="ACTION", font=get_font(6.5, 'bold'), theme='amber', pad_x=4, height=14)
    draw.text((c1 - 54, 472), "오늘의 금전운 길시 확인", font=get_font(9, 'bold'), fill=(180, 83, 9), anchor='lm')
    draw.text((c1, 489), "오후 14:30~16:00 황금 길시 팝업 표출", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c1, 502), (c1, 520), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c1 - nw // 2, 520, c1 + nw // 2, 564], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=534, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c1 - 54, 534), "24절기 나침반 인터랙션", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c1, 551), "손끝 드래그 시 360도 천체 회전 렌더링", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c1, 564), (c1, 582), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c1 - nw // 2, 582, c1 + nw // 2, 628], radius=6, fill=(236, 253, 245), outline=(167, 243, 208), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=596, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((c1 - 44, 596), "오행 분석 모듈 파라미터 전달", font=get_font(9, 'bold'), fill=(0, 180, 90), anchor='lm')
    draw.text((c1, 612), "천간/지지 8글자 오행 비율 0ms 파싱 완료", font=get_font(7.5, 'medium'), fill=(100, 116, 139), anchor='mm')
    
    # Handover to Stage 03
    draw_arrow(draw, (cols_x[1] + cw, 605), (cols_x[2], 605), col=(180, 83, 9), width=2, arrow_size=4)
    draw.text(((cols_x[1] + cw + cols_x[2]) // 2, 593), "분석 ->", font=get_font(8, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    # Track 3: Stage 03 (Five Elements)
    c2 = col_centers[2]
    draw.rounded_rectangle([c2 - nw // 2, 276, c2 + nw // 2, 320], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c2 - 114, cy=290, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c2 - 54, 290), "5각형 실시간 레이더 화면", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c2, 307), "목·화·토·금·수 정규화 다각형 즉시 드로잉", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c2, 320), (c2, 336), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c2 - nw // 2, 336, c2 + nw // 2, 380], radius=6, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw_pill_badge(draw, left_x=c2 - 114, cy=350, text="ACTION", font=get_font(6.5, 'bold'), theme='amber', pad_x=4, height=14)
    draw.text((c2 - 54, 350), "결핍 오행 원터치 분석 탭", font=get_font(9, 'bold'), fill=(180, 83, 9), anchor='lm')
    draw.text((c2, 367), "부족한 기운(예: 수·물 기운 결핍) 감지", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c2, 380), (c2, 398), col=(180, 83, 9), width=2, arrow_size=4)
    
    # Diamond: 결핍 기운 존재 여부?
    draw_diamond(draw, cx=c2, cy=424, w=176, h=52, fill=(254, 243, 199), outline=(180, 83, 9), width=2)
    draw.text((c2, 424), "결핍 기운 감지?", font=get_font(9.5, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    # Branch Yes -> Prescribe
    draw_arrow(draw, (c2, 450), (c2, 494), col=(180, 83, 9), width=2, arrow_size=4)
    draw.text((c2 - 25, 472), "Yes", font=get_font(8, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    draw.rounded_rectangle([c2 - nw // 2, 494, c2 + nw // 2, 538], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c2 - 114, cy=508, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c2 - 54, 508), "오행 처방 가이드 바텀시트", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c2, 525), "행운의 컬러(블랙), 음식, 방위 솔루션 제시", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c2, 538), (c2, 556), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c2 - nw // 2, 556, c2 + nw // 2, 602], radius=6, fill=(236, 253, 245), outline=(167, 243, 208), width=1)
    draw_pill_badge(draw, left_x=c2 - 114, cy=570, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((c2 - 44, 570), "오행 데이터 캐싱 완료", font=get_font(9, 'bold'), fill=(0, 180, 90), anchor='lm')
    draw.text((c2, 586), "상대방과의 궁합 연산 시 오행 중첩 준비", font=get_font(7.5, 'medium'), fill=(100, 116, 139), anchor='mm')
    
    # Handover to Stage 04
    draw_arrow(draw, (cols_x[2] + cw, 579), (cols_x[3], 579), col=(180, 83, 9), width=2, arrow_size=4)
    draw.text(((cols_x[2] + cw + cols_x[3]) // 2, 567), "매칭 ->", font=get_font(8, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    # Track 4: Stage 04 (Compatibility)
    c3 = col_centers[3]
    draw.rounded_rectangle([c3 - nw // 2, 276, c3 + nw // 2, 320], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c3 - 114, cy=290, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c3 - 54, 290), "인연 궁합 매칭 메인 뷰", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c3, 307), "인연 추가 모달 및 기존 상대방 리스트 표출", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c3, 320), (c3, 336), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c3 - nw // 2, 336, c3 + nw // 2, 380], radius=6, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw_pill_badge(draw, left_x=c3 - 114, cy=350, text="ACTION", font=get_font(6.5, 'bold'), theme='amber', pad_x=4, height=14)
    draw.text((c3 - 54, 350), "상대방 생년월일 입력/선택", font=get_font(9, 'bold'), fill=(180, 83, 9), anchor='lm')
    draw.text((c3, 367), "1-Tap 바텀시트에서 상대 정보 즉각 바인딩", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c3, 380), (c3, 398), col=(180, 83, 9), width=2, arrow_size=4)
    
    # Diamond: 상대방 출생시 인지 여부?
    draw_diamond(draw, cx=c3, cy=424, w=176, h=52, fill=(254, 243, 199), outline=(180, 83, 9), width=2)
    draw.text((c3, 424), "출생시 인지 여부?", font=get_font(9.5, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    draw_arrow(draw, (c3, 450), (c3, 494), col=(180, 83, 9), width=2, arrow_size=4)
    draw.text((c3 - 25, 472), "Yes", font=get_font(8, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    draw.rounded_rectangle([c3 - nw // 2, 494, c3 + nw // 2, 538], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c3 - 114, cy=508, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c3 - 54, 508), "92% 정밀 궁합 리포트 생성", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c3, 525), "오행 중첩 레이더 & 케미스트리 종합 점수", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c3, 538), (c3, 556), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c3 - nw // 2, 556, c3 + nw // 2, 602], radius=6, fill=(236, 253, 245), outline=(167, 243, 208), width=1)
    draw_pill_badge(draw, left_x=c3 - 114, cy=570, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((c3 - 44, 570), "인연 궁합 볼트 영구 저장", font=get_font(9, 'bold'), fill=(0, 180, 90), anchor='lm')
    draw.text((c3, 586), "상대방과의 데이트 팁 및 조화 솔루션 완료", font=get_font(7.5, 'medium'), fill=(100, 116, 139), anchor='mm')
    
    # Handover to Stage 05
    draw_arrow(draw, (cols_x[3] + cw, 579), (cols_x[4], 579), col=(180, 83, 9), width=2, arrow_size=4)
    draw.text(((cols_x[3] + cw + cols_x[4]) // 2, 567), "타로 ->", font=get_font(8, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    # Track 5: Stage 05 (Tarot & Vault)
    c4 = col_centers[4]
    draw.rounded_rectangle([c4 - nw // 2, 276, c4 + nw // 2, 320], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c4 - 114, cy=290, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c4 - 54, 290), "3D 타로 셔플 캔버스 진입", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c4, 307), "22장 메이저 아르카나 물리 덱 준비", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c4, 320), (c4, 336), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c4 - nw // 2, 336, c4 + nw // 2, 380], radius=6, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw_pill_badge(draw, left_x=c4 - 114, cy=350, text="ACTION", font=get_font(6.5, 'bold'), theme='amber', pad_x=4, height=14)
    draw.text((c4 - 54, 350), "손끝 드래그 셔플 & 카드 선택", font=get_font(9, 'bold'), fill=(180, 83, 9), anchor='lm')
    draw.text((c4, 367), "선택 순간 60fps 햅틱 진동 피드백 발동", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c4, 380), (c4, 398), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c4 - nw // 2, 398, c4 + nw // 2, 442], radius=6, fill=(245, 243, 255), outline=(221, 214, 254), width=1)
    draw_pill_badge(draw, left_x=c4 - 114, cy=412, text="ANIMATION", font=get_font(6.5, 'bold'), theme='purple', pad_x=4, height=14)
    draw.text((c4 - 44, 412), "3D 카드 뒤집기 애니메이션", font=get_font(9, 'bold'), fill=(109, 40, 217), anchor='lm')
    draw.text((c4, 429), "골드 아우라 파티클 & 심층 키워드 해설", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c4, 442), (c4, 460), col=(180, 83, 9), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c4 - nw // 2, 460, c4 + nw // 2, 504], radius=6, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=c4 - 114, cy=474, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c4 - 54, 474), "시크릿 볼트 기록 암호화", font=get_font(9, 'bold'), fill=(15, 23, 42), anchor='lm')
    draw.text((c4, 491), "온디바이스 SQLite 보관 및 히스토리 누적", font=get_font(8, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw_arrow(draw, (c4, 504), (c4, 522), col=(180, 83, 9), width=2, arrow_size=4)
    
    # End Capsule
    draw.rounded_rectangle([c4 - 75, 522, c4 + 75, 550], radius=14, fill=(0, 180, 90))
    draw.text((c4, 536), "End : 리추얼 완료", font=get_font(9.5, 'bold'), fill=(255, 255, 255), anchor='mm')
    
    # Bottom: 4 Key Logic Architecture Cards
    bp_y = 750
    bp_h = 195
    bp_w = 415
    bp_gap = 20
    logic_cards = [
        ("01", "무한 루프 방지 및 결측치 자동 보정", "출생 시간을 모르는 사용자를 위해 정오(12:00) 기준 일주 보정 알고리즘을 적용하여 진입 차단 방지", "amber"),
        ("02", "로컬 상태 관리 (Riverpod StateNotifier)", "사용자 프로필, 오늘의 길시, 오행 레이더 수치를 단일 상태 저장소로 바인딩하여 0ms 렌더링", "cyan"),
        ("03", "햅틱 진동 피드백 엔진 통합", "카드 선택, 레이더 터치, 궁합 산출 완료 순간 기기 햅틱 모터를 구동하여 높은 실물감 부여", "purple"),
        ("04", "100% 오프라인 캐싱 & 볼트 보안", "네트워크 단절 상태에서도 기존 계산된 좌표와 궁합 리포트를 무손실 열람 가능하도록 설계", "green")
    ]
    for idx, (l_num, l_title, l_desc, l_theme) in enumerate(logic_cards):
        px = 100 + idx * (bp_w + bp_gap)
        draw.rounded_rectangle([px, bp_y, px + bp_w, bp_y + bp_h], radius=12, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
        draw.rounded_rectangle([px, bp_y + 12, px + 4, bp_y + bp_h - 12], radius=2, fill=(180, 83, 9) if l_theme=='amber' else ((8, 145, 178) if l_theme=='cyan' else ((109, 40, 217) if l_theme=='purple' else (0, 180, 90))))
        draw_pill_badge(draw, left_x=px + 18, cy=bp_y + 24, text=f"LOGIC {l_num}", font=get_font(8.5, 'bold'), theme=l_theme, has_dot=True, pad_x=8, height=20)
        draw.text((px + 18, bp_y + 52), l_title, font=get_font(12.5, 'bold'), fill=(15, 23, 42))
        draw.line([(px + 18, bp_y + 72), (px + bp_w - 18, bp_y + 72)], fill=(241, 245, 249), width=1)
        b_lines = wrap_text_by_words(l_desc, get_font(10.5, 'regular'), bp_w - 36, draw)
        by = bp_y + 86
        for bl in b_lines:
            draw.text((px + 18, by), bl, font=get_font(10.5, 'regular'), fill=(71, 85, 105))
            by += 18
            
    draw_slide_footer(draw, 5, dark=False)
    save_slide(base, 5)

# ==============================================================
# SLIDE 06: WIREFRAME & ERGONOMIC ARCHITECTURE (Like Smart DCA Slide 06)
# ==============================================================
def make_slide_06():
    # Crisp, luxury editorial canvas (Matching Smart DCA Slide 06 structure & highlight power)
    base = Image.new('RGBA', (W, H), (248, 250, 252, 255))
    draw = ImageDraw.Draw(base)
    
    # Hairline Boundaries
    draw.line([(100, 85), (1820, 85)], fill=(226, 232, 240), width=1)
    draw.line([(100, 985), (1820, 985)], fill=(226, 232, 240), width=1)
    
    # Header
    draw.text((100, 60), "06 WIREFRAME | MOBILE UX & ERGONOMIC ARCHITECTURE", font=get_font(13.5, 'bold'), fill=(180, 83, 9))
    draw.text((100, 95), "실제 앱 구조를 그대로 반영한 ", font=get_font(38, 'bold'), fill=(15, 23, 42))
    w_t1 = draw.textlength("실제 앱 구조를 그대로 반영한 ", font=get_font(38, 'bold'))
    draw.text((100 + w_t1, 95), "4대 모바일 와이어프레임과 인체공학적 설계", font=get_font(38, 'bold'), fill=(180, 83, 9))
    draw.text((100, 150), "우주 허브·오행 레이더·정밀 궁합·럭셔리 타로 4대 핵심 화면의 골격 구조와 한 손 조작을 위한 엄지 조작 반경(Thumb-Zone) 인체공학 설계", font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    
    # UPPER SECTION: 4 Screen Wireframe Chassis (pw=350, ph=510, gap=56)
    pw = 350
    ph = 510
    sec_y = 190
    gap = 56
    
    p1_x = 100
    p2_x = p1_x + pw + gap
    p3_x = p2_x + pw + gap
    p4_x = p3_x + pw + gap
    
    def draw_wf_chassis(x, scr_num, scr_title, theme='amber'):
        draw.rounded_rectangle([x, sec_y, x + pw, sec_y + ph], radius=24, fill=(255, 255, 255), outline=(15, 23, 42), width=2)
        # Notch / Dynamic Island
        draw.rounded_rectangle([x + pw // 2 - 32, sec_y + 8, x + pw // 2 + 32, sec_y + 22], radius=7, fill=(15, 23, 42))
        draw_pill_badge(draw, cx=x + pw // 2, cy=sec_y + 40, text=f"{scr_num} · {scr_title}", font=get_font(9.5, 'bold'), theme=theme, pad_x=8, height=22)
        
    def draw_step_connector(x1, x2, label_top, label_bot):
        cx = (x1 + x2) // 2
        cy = sec_y + ph // 2 - 20
        # Line
        draw.line([(x1 + 6, cy), (x2 - 6, cy)], fill=(203, 213, 225), width=2)
        # Center Circle with Arrow
        draw.ellipse([cx - 15, cy - 15, cx + 15, cy + 15], fill=(255, 255, 255), outline=(180, 83, 9), width=2)
        draw.text((cx, cy), "→", font=get_font(12, 'bold'), fill=(180, 83, 9), anchor='mm')
        # Labels
        draw.text((cx, cy - 22), label_top, font=get_font(7, 'bold'), fill=(15, 23, 42), anchor='mm')
        draw.text((cx, cy + 22), label_bot, font=get_font(6.5, 'medium'), fill=(100, 116, 139), anchor='mm')
        
    def draw_callout_pin(px, py, pin_num, pin_text, theme='amber', align_right=False):
        draw.ellipse([px - 10, py - 10, px + 10, py + 10], fill=(180, 83, 9) if theme=='amber' else ((8, 145, 178) if theme=='cyan' else ((109, 40, 217) if theme=='purple' else (0, 180, 90))))
        draw.text((px, py), str(pin_num), font=get_font(8.5, 'bold'), fill=(255, 255, 255), anchor='mm')
        # Pin badge
        if align_right:
            draw_pill_badge(draw, cx=px - 58, cy=py, text=pin_text, font=get_font(7.5, 'bold'), theme=theme, has_dot=False, pad_x=6, height=18, solid=True)
        else:
            draw_pill_badge(draw, cx=px + 58, cy=py, text=pin_text, font=get_font(7.5, 'bold'), theme=theme, has_dot=False, pad_x=6, height=18, solid=True)

    # -------------------------------------------------------------
    # Chassis 1: SCR-01 · 우주 사주 허브
    # -------------------------------------------------------------
    draw_wf_chassis(p1_x, "SCR-01", "우주 사주 허브", "amber")
    
    # Banner: VIP 광고제거
    v_y = sec_y + 58
    draw.rounded_rectangle([p1_x + 14, v_y, p1_x + pw - 14, v_y + 24], radius=6, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw.text((p1_x + 22, v_y + 6), "★ 2026 탄생 우주 좌표 활성화", font=get_font(8.5, 'bold'), fill=(180, 83, 9))
    draw.text((p1_x + pw - 22, v_y + 6), "LIVE", font=get_num_font(8.5, 'bold'), fill=(180, 83, 9), anchor='ra')
    
    # Coordinate Card
    sc_y = v_y + 30
    draw.rounded_rectangle([p1_x + 14, sc_y, p1_x + pw - 14, sc_y + 82], radius=10, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
    draw.text((p1_x + 24, sc_y + 10), "나(본인)님의 고유 우주 좌표", font=get_font(9, 'bold'), fill=(180, 83, 9))
    draw.text((p1_x + 24, sc_y + 28), "무인(황금 호랑이)", font=get_font(13.5, 'bold'), fill=(15, 23, 42))
    draw.text((p1_x + 24, sc_y + 48), "사자자리 · O형 · 목 기운 발달", font=get_font(9, 'bold'), fill=(71, 85, 105))
    draw_pill_badge(draw, cx=p1_x + pw - 46, cy=sc_y + 51, text="ACTIVE", font=get_font(8, 'bold'), theme='amber', has_dot=False, pad_x=6, height=18, solid=True)
    draw.text((p1_x + 24, sc_y + 66), "• 4주 8글자 1초 자동 바인딩", font=get_font(8, 'medium'), fill=(100, 116, 139))
    
    # 24절기 천체 나침반 다이얼 Wireframe
    dial_cy = sc_y + 140
    dial_cx = p1_x + pw // 2
    draw.ellipse([dial_cx - 50, dial_cy - 50, dial_cx + 50, dial_cy + 50], outline=(226, 232, 240), width=1)
    draw.ellipse([dial_cx - 32, dial_cy - 32, dial_cx + 32, dial_cy + 32], outline=(253, 230, 138), width=1)
    draw.ellipse([dial_cx - 16, dial_cy - 16, dial_cx + 16, dial_cy + 16], fill=(254, 243, 199), outline=(180, 83, 9), width=1)
    draw.text((dial_cx, dial_cy), "음양", font=get_font(8.5, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    # Golden Time Banner
    gt_y = dial_cy + 60
    draw.rounded_rectangle([p1_x + 14, gt_y, p1_x + pw - 14, gt_y + 42], radius=8, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw.text((p1_x + 22, gt_y + 8), "오늘의 금전운 터지는 길시", font=get_font(8.5, 'bold'), fill=(180, 83, 9))
    draw.text((p1_x + 22, gt_y + 24), "14:30 ~ 16:00 (신시)", font=get_num_font(11, 'bold'), fill=(15, 23, 42))
    
    # Thumb-Zone Colored Shading & Action CTA Button
    tz_y = sec_y + ph - 88
    draw.rounded_rectangle([p1_x + 6, tz_y, p1_x + pw - 6, sec_y + ph - 6], radius=18, fill=(254, 243, 199, 100))
    draw.text((p1_x + pw // 2, tz_y + 12), "Thumb-Zone (48dp)", font=get_font(8, 'bold'), fill=(180, 83, 9), anchor='mm')
    
    btn_y = tz_y + 24
    draw.rounded_rectangle([p1_x + 14, btn_y, p1_x + pw - 14, btn_y + 40], radius=10, fill=(180, 83, 9))
    draw.text((p1_x + pw // 2, btn_y + 20), "+ 오행 분석 리포트 확인 ↗", font=get_font(10.5, 'bold'), fill=(255, 255, 255), anchor='mm')
    
    # Callout Pin 1
    draw_callout_pin(p1_x + 24, btn_y + 20, 1, "Fitts' 한 손 조작 존", "amber")
    
    # Step Connector 1 -> 2
    draw_step_connector(p1_x + pw, p2_x, "01 -> 02 사주 허브 진입", "1-Tap 빠른 로드")

    # -------------------------------------------------------------
    # Chassis 2: SCR-02 · 오행 레이더 뷰
    # -------------------------------------------------------------
    draw_wf_chassis(p2_x, "SCR-02", "오행 레이더 뷰", "cyan")
    
    # Energy Balance Card
    b2_y = sec_y + 58
    draw.rounded_rectangle([p2_x + 14, b2_y, p2_x + pw - 14, b2_y + 50], radius=8, fill=(236, 254, 255), outline=(165, 243, 252), width=1)
    draw.text((p2_x + 22, b2_y + 8), "목·화·토·금·수 오행 밸런스", font=get_font(9, 'bold'), fill=(8, 145, 178))
    draw.text((p2_x + 22, b2_y + 26), "에너지 조화율: 78.5% (수 결핍)", font=get_font(10.5, 'bold'), fill=(15, 23, 42))
    draw_pill_badge(draw, cx=p2_x + pw - 46, cy=b2_y + 25, text="수(물) 결핍", font=get_font(8, 'bold'), theme='cyan', has_dot=False, pad_x=6, height=18, solid=True)
    
    # Pentagon Radar Wireframe
    rcy = b2_y + 115
    rcx = p2_x + pw // 2
    r_pts = []
    for ang in range(0, 360, 72):
        rad = math.radians(ang - 90)
        r_pts.append((rcx + 55 * math.cos(rad), rcy + 55 * math.sin(rad)))
    draw.polygon(r_pts, outline=(165, 243, 252), width=1)
    
    inner_pts = []
    r_vals = [0.85, 0.9, 0.7, 0.45, 0.25]
    for idx, ang in enumerate(range(0, 360, 72)):
        rad = math.radians(ang - 90)
        inner_pts.append((rcx + 55 * r_vals[idx] * math.cos(rad), rcy + 55 * r_vals[idx] * math.sin(rad)))
    draw.polygon(inner_pts, fill=(236, 254, 255), outline=(8, 145, 178), width=2)
    
    # Callout Pin 2 on Radar
    draw_callout_pin(rcx + 40, rcy - 20, 2, "5각형 오행 극좌표계 연산", "cyan")
    
    # Chips Row: 5 Elements
    c_y = rcy + 70
    chips = ["목(30%)", "화(25%)", "토(15%)", "금(20%)", "수(10%)"]
    cx_chip = p2_x + 14
    for cp in chips:
        draw.rounded_rectangle([cx_chip, c_y, cx_chip + 58, c_y + 20], radius=5, fill=(240, 246, 255), outline=(191, 219, 254), width=1)
        draw.text((cx_chip + 29, c_y + 10), cp, font=get_font(7.5, 'bold'), fill=(8, 145, 178), anchor='mm')
        cx_chip += 65
        
    # Remedy Guide Box
    rm_y = c_y + 28
    draw.rounded_rectangle([p2_x + 14, rm_y, p2_x + pw - 14, rm_y + 60], radius=8, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
    draw.text((p2_x + 22, rm_y + 8), "결핍 기운 맞춤형 즉시 보완책", font=get_font(8.5, 'bold'), fill=(8, 145, 178))
    draw.text((p2_x + 22, rm_y + 24), "• 행운의 색상: 블랙 & 네이비", font=get_font(8, 'medium'), fill=(71, 85, 105))
    draw.text((p2_x + 22, rm_y + 40), "• 추천 음식: 해산물, 블랙푸드, 생수", font=get_font(8, 'medium'), fill=(71, 85, 105))
    
    # Thumb-Zone Colored Shading & CTA
    draw.rounded_rectangle([p2_x + 6, tz_y, p2_x + pw - 6, sec_y + ph - 6], radius=18, fill=(236, 254, 255, 100))
    draw.text((p2_x + pw // 2, tz_y + 12), "Thumb-Zone (48dp)", font=get_font(8, 'bold'), fill=(8, 145, 178), anchor='mm')
    
    draw.rounded_rectangle([p2_x + 14, btn_y, p2_x + pw - 14, btn_y + 40], radius=10, fill=(8, 145, 178))
    draw.text((p2_x + pw // 2, btn_y + 20), "인연 궁합 매칭하러 가기 ↗", font=get_font(10.5, 'bold'), fill=(255, 255, 255), anchor='mm')
    
    # Step Connector 2 -> 3
    draw_step_connector(p2_x + pw, p3_x, "02 -> 03 오행 레이더 연동", "0.1s 벡터 산출")

    # -------------------------------------------------------------
    # Chassis 3: SCR-03 · 정밀 궁합 매칭
    # -------------------------------------------------------------
    draw_wf_chassis(p3_x, "SCR-03", "정밀 궁합 매칭", "purple")
    
    # Match Info Card
    m3_y = sec_y + 58
    draw.rounded_rectangle([p3_x + 14, m3_y, p3_x + pw - 14, m3_y + 50], radius=8, fill=(245, 243, 255), outline=(221, 214, 254), width=1)
    draw.text((p3_x + 22, m3_y + 8), "사주 일주 합충 & 별자리 궁합", font=get_font(9, 'bold'), fill=(109, 40, 217))
    draw.text((p3_x + 22, m3_y + 26), "상대: 이지은님 (계묘년·천칭자리)", font=get_font(10.5, 'bold'), fill=(15, 23, 42))
    draw_pill_badge(draw, cx=p3_x + pw - 46, cy=m3_y + 25, text="천생연분", font=get_font(8, 'bold'), theme='purple', has_dot=False, pad_x=6, height=18, solid=True)
    
    # Match Score Circle
    mcy = m3_y + 115
    mcx = p3_x + pw // 2
    draw.ellipse([mcx - 52, mcy - 52, mcx + 52, mcy + 52], outline=(221, 214, 254), width=2)
    draw.ellipse([mcx - 42, mcy - 42, mcx + 42, mcy + 42], fill=(245, 243, 255), outline=(109, 40, 217), width=1)
    draw.text((mcx, mcy - 8), "92%", font=get_num_font(22, 'black'), fill=(109, 40, 217), anchor='mm')
    draw.text((mcx, mcy + 14), "천생연분 케미", font=get_font(8, 'bold'), fill=(109, 40, 217), anchor='mm')
    
    # Callout Pin 3 on Score
    draw_callout_pin(mcx + 42, mcy - 20, 3, "92% 일주 합충 매칭 엔진", "purple")
    
    # Saju Chemistry Breakdown
    sc_br_y = mcy + 62
    draw.rounded_rectangle([p3_x + 14, sc_br_y, p3_x + pw - 14, sc_br_y + 68], radius=8, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
    draw.text((p3_x + 22, sc_br_y + 8), "상호 오행 조화 분석", font=get_font(8.5, 'bold'), fill=(109, 40, 217))
    draw.text((p3_x + 22, sc_br_y + 24), "• 천간 합: 무계합(불의 기운 생성)", font=get_font(8, 'medium'), fill=(71, 85, 105))
    draw.text((p3_x + 22, sc_br_y + 38), "• 지지 관계: 인묘진 방합 목 활성화", font=get_font(8, 'medium'), fill=(71, 85, 105))
    draw.text((p3_x + 22, sc_br_y + 52), "• 오행 상생: 나의 토를 상대방이 보완", font=get_font(8, 'bold'), fill=(0, 180, 90))
    
    # Thumb-Zone Colored Shading & CTA
    draw.rounded_rectangle([p3_x + 6, tz_y, p3_x + pw - 6, sec_y + ph - 6], radius=18, fill=(245, 243, 255, 100))
    draw.text((p3_x + pw // 2, tz_y + 12), "Thumb-Zone (48dp)", font=get_font(8, 'bold'), fill=(109, 40, 217), anchor='mm')
    
    draw.rounded_rectangle([p3_x + 14, btn_y, p3_x + pw - 14, btn_y + 40], radius=10, fill=(109, 40, 217))
    draw.text((p3_x + pw // 2, btn_y + 20), "궁합 결과 볼트에 저장 ↗", font=get_font(10.5, 'bold'), fill=(255, 255, 255), anchor='mm')
    
    # Step Connector 3 -> 4
    draw_step_connector(p3_x + pw, p4_x, "03 -> 04 궁합 결과 도출", "상생상극 솔루션")

    # -------------------------------------------------------------
    # Chassis 4: SCR-04 · 3D 타로 & 볼트
    # -------------------------------------------------------------
    draw_wf_chassis(p4_x, "SCR-04", "3D 타로 & 볼트", "green")
    
    # Tarot Header Card
    t4_y = sec_y + 58
    draw.rounded_rectangle([p4_x + 14, t4_y, p4_x + pw - 14, t4_y + 50], radius=8, fill=(236, 253, 245), outline=(167, 243, 208), width=1)
    draw.text((p4_x + 22, t4_y + 8), "오늘의 메이저 아르카나 타로", font=get_font(9, 'bold'), fill=(0, 180, 90))
    draw.text((p4_x + 22, t4_y + 26), "손끝으로 덱을 셔플하고 1장 선택", font=get_font(10.5, 'bold'), fill=(15, 23, 42))
    draw_pill_badge(draw, cx=p4_x + pw - 46, cy=t4_y + 25, text="60 FPS", font=get_font(8, 'bold'), theme='green', has_dot=False, pad_x=6, height=18, solid=True)
    
    # Tarot Card Wireframe
    tcy = t4_y + 115
    tcx = p4_x + pw // 2
    draw.rounded_rectangle([tcx - 38, tcy - 52, tcx + 38, tcy + 52], radius=8, fill=(254, 243, 199), outline=(180, 83, 9), width=2)
    draw.text((tcx, tcy - 12), "THE", font=get_font(8, 'bold'), fill=(180, 83, 9), anchor='mm')
    draw.text((tcx, tcy + 4), "SUN", font=get_font(13, 'black'), fill=(180, 83, 9), anchor='mm')
    draw.text((tcx, tcy + 22), "태양 (XIX)", font=get_font(7.5, 'bold'), fill=(15, 23, 42), anchor='mm')
    
    # Callout Pin 4 on Tarot Card
    draw_callout_pin(tcx + 38, tcy - 20, 4, "60fps 햅틱 진동 피드백", "green")
    
    # Reading Summary Box
    t_sm_y = tcy + 62
    draw.rounded_rectangle([p4_x + 14, t_sm_y, p4_x + pw - 14, t_sm_y + 68], radius=8, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
    draw.text((p4_x + 22, t_sm_y + 8), "심층 리딩 & 시크릿 조언", font=get_font(8.5, 'bold'), fill=(0, 180, 90))
    draw.text((p4_x + 22, t_sm_y + 24), "• 키워드: 성공, 활력, 관계의 명확성", font=get_font(8, 'medium'), fill=(71, 85, 105))
    draw.text((p4_x + 22, t_sm_y + 38), "• 관계 조언: 솔직한 대화가 운을 열어줌", font=get_font(8, 'medium'), fill=(71, 85, 105))
    draw.text((p4_x + 22, t_sm_y + 52), "• 볼트 보관: SQLite 로컬 암호화 저장", font=get_font(8, 'bold'), fill=(0, 180, 90))
    
    # Thumb-Zone Colored Shading & CTA
    draw.rounded_rectangle([p4_x + 6, tz_y, p4_x + pw - 6, sec_y + ph - 6], radius=18, fill=(236, 253, 245, 100))
    draw.text((p4_x + pw // 2, tz_y + 12), "Thumb-Zone (48dp)", font=get_font(8, 'bold'), fill=(0, 180, 90), anchor='mm')
    
    draw.rounded_rectangle([p4_x + 14, btn_y, p4_x + pw - 14, btn_y + 40], radius=10, fill=(0, 180, 90))
    draw.text((p4_x + pw // 2, btn_y + 20), "시크릿 볼트 기록 확인 ↗", font=get_font(10.5, 'bold'), fill=(255, 255, 255), anchor='mm')

    # -------------------------------------------------------------
    # LOWER SECTION: 4 System Architecture Cards with Checkmarks
    # -------------------------------------------------------------
    b_card_y = 730
    b_card_h = 220
    b_card_w = 415
    b_gap = 20
    
    cards_info = [
        (1, "THUMB-ZONE 48dp", "Fitts' Law 한 손 조작성 최적화",
         "한 손 파지 시 엄지가 닿는 하단 120dp 반경 내 주요 액션 버튼(오행 분석, 인연 매칭, 카드 셔플)을 집중 배치하여 이동 피로를 65% 절감했습니다.",
         "✔ 엄지 도달 속도 0.18s 입증", "amber"),
        (2, "BOUNDARY GUARD", "출생시 결측치 자동 보정 엔진",
         "출생 시간을 모르는 사용자를 위해 정오(12:00) 기준 태양시 보정 및 일주 중심 분석 가이드를 자동 작동하여 사용자 이탈을 원천 차단했습니다.",
         "✔ 결측치(태어난 시 모름) 자동 보정", "cyan"),
        (3, "MULTI-VECTOR SOLVER", "92% 정밀 일주 합충 궁합 알고리즘",
         "사주 일주의 천간합·지지육합과 별자리 데이터를 다변수 벡터로 결합하여 두 사람의 성향 일치도와 보완점을 과학적으로 산출합니다.",
         "✔ 92% 정밀 케미스트리 산출", "purple"),
        (4, "ZERO-LOSS VAULT", "60fps 햅틱 진동 피드백 & 볼트",
         "카드 선택과 궁합 산출 순간 햅틱 모터를 구동하여 실물 손맛을 전달하고, 생성된 모든 기록을 외부 유출 없이 SQLite 로컬 DB에 영구 보존합니다.",
         "✔ 100% 온디바이스 로컬 암호화 무손실 보관", "green")
    ]
    
    for idx, (c_num, c_tag, c_title, c_desc, c_chk, c_theme) in enumerate(cards_info):
        cx = 100 + idx * (b_card_w + b_gap)
        draw.rounded_rectangle([cx, b_card_y, cx + b_card_w, b_card_y + b_card_h], radius=14, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
        # Left colored stripe
        draw.rounded_rectangle([cx, b_card_y + 14, cx + 4, b_card_y + b_card_h - 14], radius=2, fill=(180, 83, 9) if c_theme=='amber' else ((8, 145, 178) if c_theme=='cyan' else ((109, 40, 217) if c_theme=='purple' else (0, 180, 90))))
        
        draw_pill_badge(draw, left_x=cx + 18, cy=b_card_y + 26, text=f"{c_num} · {c_tag}", font=get_font(8.5, 'bold'), theme=c_theme, pad_x=8, height=20)
        draw.text((cx + 18, b_card_y + 54), c_title, font=get_font(13.5, 'bold'), fill=(15, 23, 42))
        draw.line([(cx + 18, b_card_y + 76), (cx + b_card_w - 18, b_card_y + 76)], fill=(241, 245, 249), width=1)
        
        b_lines = wrap_text_by_words(c_desc, get_font(10.5, 'regular'), b_card_w - 36, draw)
        by = b_card_y + 90
        for bl in b_lines:
            draw.text((cx + 18, by), bl, font=get_font(10.5, 'regular'), fill=(71, 85, 105))
            by += 18
            
        # Checkmark Pill at bottom
        draw.rounded_rectangle([cx + 18, b_card_y + b_card_h - 38, cx + b_card_w - 18, b_card_y + b_card_h - 12], radius=6, fill=(240, 246, 255) if c_theme=='cyan' else ((254, 243, 199) if c_theme=='amber' else ((245, 243, 255) if c_theme=='purple' else (236, 253, 245))))
        draw.text((cx + 26, b_card_y + b_card_h - 26), c_chk, font=get_font(9.5, 'bold'), fill=(8, 145, 178) if c_theme=='cyan' else ((180, 83, 9) if c_theme=='amber' else ((109, 40, 217) if c_theme=='purple' else (0, 180, 90))), anchor='lm')
        
    draw_slide_footer(draw, 6, dark=False)
    save_slide(base, 6)

# ==============================================================
# SLIDE 07: VISUAL DESIGN SYSTEM (Like Smart DCA Slide 07)
# ==============================================================
def make_slide_07():
    base = Image.new('RGBA', (W, H), (248, 250, 252, 255))
    draw = ImageDraw.Draw(base)
    
    # Hairline Boundaries
    draw.line([(100, 85), (1820, 85)], fill=(226, 232, 240), width=1)
    draw.line([(100, 985), (1820, 985)], fill=(226, 232, 240), width=1)
    
    # Editorial Header
    draw.text((100, 60), "07 DESIGN SYSTEM | BRAND IDENTITY & REAL UI COMPONENTS", font=get_font(13.5, 'bold'), fill=(180, 83, 9))
    draw.text((100, 95), "우주의 신비로움과 정밀함을 규정하는 ", font=get_font(38, 'bold'), fill=(15, 23, 42))
    w_t1 = draw.textlength("우주의 신비로움과 정밀함을 규정하는 ", font=get_font(38, 'bold'))
    draw.text((100 + w_t1, 95), "비주얼 아이덴티티 & 디자인 시스템", font=get_font(38, 'bold'), fill=(180, 83, 9))
    draw.text((100, 150), "포춘매치 실제 앱의 AppColors 토큰, Pretendard 타이포그래피, 그리고 프로덕션에 구현된 실물 UI 컴포넌트 라이브러리", font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    
    left_x = 100
    left_w = 780
    right_x = 910
    right_w = 910
    
    row1_y = 195
    row1_h = 365
    row2_y = 585
    row2_h = 385
    
    # =========================================================================
    # CARD A1 (Top Left): APPCOLORS TOKEN & CONTRAST ARCHITECTURE
    # =========================================================================
    draw.rounded_rectangle([left_x, row1_y, left_x + left_w, row1_y + row1_h], radius=18, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=left_x + 32, cy=row1_y + 36, text="FOUNDATION 01", font=get_font(10, 'bold'), theme='amber', has_dot=True, pad_x=10, height=24)
    draw.text((left_x + 160, row1_y + 26), "AppColors Token & Contrast Architecture", font=get_font(16, 'bold'), fill=(15, 23, 42))
    draw.line([(left_x + 32, row1_y + 60), (left_x + left_w - 32, row1_y + 60)], fill=(241, 245, 249), width=1)
    
    # Hero Color Swatch Card: Imperial Gold #FFD700
    hb_y = row1_y + 74
    draw.rounded_rectangle([left_x + 32, hb_y, left_x + left_w - 32, hb_y + 76], radius=12, fill=(255, 215, 0))
    draw.text((left_x + 50, hb_y + 14), "PRIMARY IMPERIAL GOLD", font=get_font(15, 'bold'), fill=(7, 10, 18))
    draw.text((left_x + 50, hb_y + 36), "AppColors.imperialGold  ·  #FFD700 (Dark Surface: #070A12)", font=get_num_font(11.5, 'bold'), fill=(7, 10, 18))
    draw.text((left_x + 50, hb_y + 54), "황금빛 우주 주파수와 최고의 인연을 상징하는 시그니처 골드", font=get_font(10, 'bold'), fill=(35, 30, 15))
    draw_pill_badge(draw, cx=left_x + left_w - 95, cy=hb_y + 38, text="14.2:1 AAA", font=get_font(11, 'bold'), theme='dark', has_dot=False, pad_x=12, height=28)
    
    # 5 Semantic Swatches
    sub_swatches = [
        ("Deep Obsidian", "#070A12", (7, 10, 18), "우주 캔버스"),
        ("Surface Slate", "#0E1424", (14, 20, 36), "대시보드 서피스"),
        ("Aurora Violet", "#8A2BE2", (138, 43, 226), "타로 아우라"),
        ("Cyan Neon", "#00E5FF", (0, 229, 255), "오행 레이더"),
        ("Champagne", "#E5C07B", (229, 192, 123), "럭셔리 보더"),
    ]
    sw_w = (left_w - 64 - 40) // 5
    sw_y = hb_y + 90
    for i, (s_name, s_hex, s_col, s_usage) in enumerate(sub_swatches):
        sx = left_x + 32 + i * (sw_w + 10)
        draw.rounded_rectangle([sx, sw_y, sx + sw_w, sw_y + 80], radius=10, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
        draw.rounded_rectangle([sx + 8, sw_y + 8, sx + sw_w - 8, sw_y + 28], radius=6, fill=s_col)
        draw.text((sx + 8, sw_y + 34), s_name, font=get_font(9.5, 'bold'), fill=(15, 23, 42))
        draw.text((sx + 8, sw_y + 48), s_hex, font=get_num_font(9, 'bold'), fill=(71, 85, 105))
        draw.text((sx + 8, sw_y + 62), s_usage, font=get_font(8, 'medium'), fill=(100, 116, 139))
        
    # Signature Cosmic Gradients
    gr_y = sw_y + 92
    draw.text((left_x + 32, gr_y), "Signature App Gradients (AppColors):", font=get_font(11, 'bold'), fill=(71, 85, 105))
    gradients_data = [
        ("cosmicGold", (255, 215, 0), (229, 192, 123)),
        ("auroraViolet", (138, 43, 226), (216, 180, 254)),
        ("celestialNight", (7, 10, 18), (24, 32, 54)),
        ("radarCyan", (0, 229, 255), (8, 145, 178)),
    ]
    gr_w = (left_w - 64 - 36) // 4
    for idx, (g_name, g_c1, g_c2) in enumerate(gradients_data):
        gx = left_x + 32 + idx * (gr_w + 12)
        draw_gradient_bar(base, [gx, gr_y + 20, gx + gr_w, gr_y + 44], g_c1, g_c2, radius=6)
        draw.text((gx + gr_w // 2, gr_y + 54), g_name, font=get_font(8.5, 'bold'), fill=(71, 85, 105), anchor='mm')
        
    draw.text((left_x + 32, row1_y + row1_h - 18), "✓ WCAG 2.1 AAA 7:1+ 초고대비율 엄격 준수 · AppColors 싱글톤 토큰 시스템", font=get_font(10, 'regular'), fill=(100, 116, 139))
    
    # =========================================================================
    # CARD A2 (Bottom Left): PRETENDARD TYPOGRAPHY & SPATIAL TOKENS
    # =========================================================================
    draw.rounded_rectangle([left_x, row2_y, left_x + left_w, row2_y + row2_h], radius=18, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=left_x + 32, cy=row2_y + 36, text="FOUNDATION 02", font=get_font(10, 'bold'), theme='amber', has_dot=True, pad_x=10, height=24)
    draw.text((left_x + 160, row2_y + 26), "Pretendard Typography & Spatial Tokens", font=get_font(16, 'bold'), fill=(15, 23, 42))
    draw.line([(left_x + 32, row2_y + 60), (left_x + left_w - 32, row2_y + 60)], fill=(241, 245, 249), width=1)
    
    t_rows = [
        ("Display 28", "Black", "고유 우주 좌표 헤더", "무인(황금 호랑이) · 사자자리", True),
        ("Headline 20", "Bold", "오행 및 궁합 메인 스코어", "천생연분 케미스트리 92%", False),
        ("Title 16", "SemiBold", "일주 선택 셀렉터 & 버튼", "사주 일주론(탄생일) 합·충 궁합", False),
        ("Body 14", "Regular", "오행 결핍 처방 가이드", "부족한 수(물) 기운을 채우는 맞춤 처방", False),
        ("Caption 11", "Medium", "보조 메타 정보 & 시간", "오늘 금전운 터지는 시간 14:30~16:00", False),
    ]
    ty_start = row2_y + 74
    for i, (t_role, t_weight, t_desc, t_sample, is_mono) in enumerate(t_rows):
        ry = ty_start + i * 40
        draw.rounded_rectangle([left_x + 32, ry, left_x + left_w - 32, ry + 34], radius=8, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
        draw.text((left_x + 46, ry + 9), t_role, font=get_font(11, 'bold'), fill=(180, 83, 9))
        draw.text((left_x + 140, ry + 9), t_weight, font=get_font(10.5, 'medium'), fill=(100, 116, 139))
        draw.text((left_x + 225, ry + 9), t_desc, font=get_font(10.5, 'regular'), fill=(71, 85, 105))
        draw.text((left_x + left_w - 46, ry + 9), t_sample, font=get_num_font(12, 'bold') if is_mono else get_font(11, 'semibold'), fill=(15, 23, 42), anchor='ra')
        
    sp_box_y = ty_start + len(t_rows) * 40 + 10
    draw.rounded_rectangle([left_x + 32, sp_box_y, left_x + left_w - 32, row2_y + row2_h - 18], radius=12, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw.text((left_x + 48, sp_box_y + 12), "OpenType `FontFeature.tabularFigures()` 타뷸라 넘버 & 4/8pt 그리드", font=get_font(12, 'bold'), fill=(180, 83, 9))
    draw.text((left_x + 48, sp_box_y + 32), "• Tabular Numbers : 실시간 60fps 오행 각도 및 궁합 스코어 변동 시 숫자 폭의 떨림(Jitter) 방지", font=get_font(10, 'regular'), fill=(71, 85, 105))
    draw.text((left_x + 48, sp_box_y + 49), "• Spatial System   : 4pt/8pt 모듈 그리드 · 코너 라운딩 `r-8`, `r-12`, `r-16`, `r-24`, `r-full`", font=get_font(10, 'regular'), fill=(71, 85, 105))
    draw.text((left_x + 48, sp_box_y + 66), "• Elevation Tokens : Level 1 (좌표 카드 2dp) · Level 2 (인연 모달 8dp) · Level 3 (타로 셔플 16dp)", font=get_font(10, 'regular'), fill=(71, 85, 105))

    # =========================================================================
    # CARD B1 (Top Right): REAL APP UI COMPONENTS 01 (COSMIC HUB & INPUTS)
    # =========================================================================
    draw.rounded_rectangle([right_x, row1_y, right_x + right_w, row1_y + row1_h], radius=18, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=right_x + 32, cy=row1_y + 36, text="COMPONENTS 01", font=get_font(10, 'bold'), theme='amber', has_dot=True, pad_x=10, height=24)
    draw.text((right_x + 170, row1_y + 26), "Real App UI Components (우주 좌표 허브 & 조작 스텝퍼)", font=get_font(16, 'bold'), fill=(15, 23, 42))
    draw.line([(right_x + 32, row1_y + 60), (right_x + right_w - 32, row1_y + 60)], fill=(241, 245, 249), width=1)
    
    # Component 1: Coordinate Summary Card
    c1_y = row1_y + 74
    draw.rounded_rectangle([right_x + 32, c1_y, right_x + right_w - 32, c1_y + 92], radius=14, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw.text((right_x + 50, c1_y + 14), "나(본인)님의 고유 우주 좌표", font=get_font(12, 'bold'), fill=(180, 83, 9))
    draw.text((right_x + 50, c1_y + 36), "무인(황금 호랑이) · 사자자리 · A형", font=get_num_font(17, 'black'), fill=(15, 23, 42))
    draw.text((right_x + 50, c1_y + 64), "1995.08.15 14:30 (태어난 시간 보정 완료)", font=get_font(11.5, 'bold'), fill=(180, 83, 9))
    draw_pill_badge(draw, cx=right_x + 360, cy=c1_y + 71, text="음양오행 밸런스 78.5%", font=get_font(9.5, 'bold'), theme='green', has_dot=True, pad_x=8, height=22)
    
    # Segmented Toggle
    tog_x = right_x + right_w - 180
    tog_y = c1_y + 14
    draw.rounded_rectangle([tog_x, tog_y, tog_x + 130, tog_y + 32], radius=16, fill=(255, 255, 255), outline=(203, 213, 225), width=1)
    draw.rounded_rectangle([tog_x + 2, tog_y + 2, tog_x + 64, tog_y + 30], radius=14, fill=(180, 83, 9))
    draw.text((tog_x + 33, tog_y + 16), "양력", font=get_font(9.5, 'bold'), fill=(255, 255, 255), anchor='mm')
    draw.text((tog_x + 96, tog_y + 16), "음력", font=get_font(9.5, 'medium'), fill=(100, 116, 139), anchor='mm')
    draw.text((right_x + right_w - 50, c1_y + 65), "24절기 천체 궤도 360° 연동", font=get_font(10.5, 'bold'), fill=(180, 83, 9), anchor='ra')
    
    # Dual Components: Stepper & Compass
    dual_y = c1_y + 106
    dual_w = (right_w - 64 - 18) // 2
    
    # Left Dual: Saju Stepper Selector
    draw.rounded_rectangle([right_x + 32, dual_y, right_x + 32 + dual_w, dual_y + 94], radius=12, fill=(248, 250, 252), outline=(180, 83, 9), width=2)
    draw.text((right_x + 48, dual_y + 12), "상대방 일주 선택 & 조절 스텝퍼", font=get_font(10.5, 'bold'), fill=(180, 83, 9))
    draw.text((right_x + 48, dual_y + 36), "기축(토·황금소)", font=get_font(16, 'bold'), fill=(15, 23, 42))
    draw.line([(right_x + 175, dual_y + 36), (right_x + 175, dual_y + 58)], fill=(180, 83, 9), width=2)
    draw_pill_badge(draw, cx=right_x + 32 + dual_w - 45, cy=dual_y + 34, text="ACTIVE", font=get_font(9, 'bold'), theme='amber', has_dot=False, pad_x=6, height=20)
    
    # Stepper Control [ - ] 1997 [ + ]
    st_y = dual_y + 62
    draw.rounded_rectangle([right_x + 48, st_y, right_x + 48 + 140, st_y + 24], radius=6, fill=(255, 255, 255), outline=(203, 213, 225), width=1)
    draw.text((right_x + 65, st_y + 12), "-", font=get_font(11, 'bold'), fill=(180, 83, 9), anchor='mm')
    draw.text((right_x + 118, st_y + 12), "1997년생", font=get_num_font(9.5, 'bold'), fill=(15, 23, 42), anchor='mm')
    draw.text((right_x + 170, st_y + 12), "+", font=get_font(11, 'bold'), fill=(180, 83, 9), anchor='mm')
    draw.text((right_x + 32 + dual_w - 18, st_y + 12), "1-Tap 간편 인연 바인딩", font=get_font(9, 'medium'), fill=(100, 116, 139), anchor='ra')
    
    # Right Dual: 24 Solar Compass Widget
    draw.rounded_rectangle([right_x + 32 + dual_w + 18, dual_y, right_x + right_w - 32, dual_y + 94], radius=12, fill=(248, 250, 252), outline=(226, 232, 240), width=1)
    draw.text((right_x + 32 + dual_w + 34, dual_y + 12), "24절기 천체 나침반 엔진", font=get_font(10.5, 'bold'), fill=(15, 23, 42))
    draw.text((right_x + 32 + dual_w + 34, dual_y + 36), "현재 계절: 입동 절기 수(물) 기운", font=get_font(12, 'bold'), fill=(8, 145, 178))
    draw.text((right_x + 32 + dual_w + 34, dual_y + 54), "일진 천간지지 및 계절 기운 360° 실시간 궤도 회전", font=get_font(9.5, 'regular'), fill=(100, 116, 139))
    draw_pill_badge(draw, cx=right_x + right_w - 65, cy=dual_y + 76, text="60 FPS 궤도", font=get_font(8.5, 'bold'), theme='cyan', has_dot=True, pad_x=6, height=18)

    # =========================================================================
    # CARD B2 (Bottom Right): REAL APP UI COMPONENTS 02 (RADAR & MATCH KIT)
    # =========================================================================
    draw.rounded_rectangle([right_x, row2_y, right_x + right_w, row2_y + row2_h], radius=18, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    draw_pill_badge(draw, left_x=right_x + 32, cy=row2_y + 36, text="COMPONENTS 02", font=get_font(10, 'bold'), theme='purple', has_dot=True, pad_x=10, height=24)
    draw.text((right_x + 170, row2_y + 26), "Real App UI Components (오행 레이더 & 궁합 케미스트리 킷)", font=get_font(16, 'bold'), fill=(15, 23, 42))
    draw.line([(right_x + 32, row2_y + 60), (right_x + right_w - 32, row2_y + 60)], fill=(241, 245, 249), width=1)
    
    # Preset Chips Row
    cp_y = row2_y + 76
    draw.text((right_x + 32, cp_y), "오행 기운 즉시 보완 프리셋 칩:", font=get_font(11, 'bold'), fill=(71, 85, 105))
    chips_data = [
        ("목 +10%", "green"), ("화 +5%", "red"), ("토 밸런스", "amber"), ("금 보완", "slate"), ("수 충전", "cyan")
    ]
    cx_cp = right_x + 32
    for c_txt, c_thm in chips_data:
        draw.rounded_rectangle([cx_cp, cp_y + 20, cx_cp + 120, cp_y + 54], radius=8, fill=(248, 250, 252), outline=(203, 213, 225), width=1)
        draw.text((cx_cp + 60, cp_y + 37), c_txt, font=get_font(11, 'bold'), fill=(15, 23, 42), anchor='mm')
        cx_cp += 132
        
    # Action CTA Buttons Row
    btn_row_y = cp_y + 80
    draw.text((right_x + 32, btn_row_y), "시그니처 인터랙션 CTA 버튼 규격 (Height 52dp):", font=get_font(11, 'bold'), fill=(71, 85, 105))
    
    # Primary CTA
    draw.rounded_rectangle([right_x + 32, btn_row_y + 20, right_x + 32 + 380, btn_row_y + 72], radius=12, fill=(180, 83, 9))
    draw.text((right_x + 32 + 190, btn_row_y + 46), "⚡ 오행 분석 리포트 확인 ↗", font=get_font(13.5, 'bold'), fill=(255, 255, 255), anchor='mm')
    
    # Secondary CTA
    draw.rounded_rectangle([right_x + 32 + 400, btn_row_y + 20, right_x + right_w - 32, btn_row_y + 72], radius=12, fill=(255, 255, 255), outline=(109, 40, 217), width=2)
    draw.text((right_x + 32 + 400 + (right_w - 64 - 400) // 2, btn_row_y + 46), "인연 궁합 매칭하기 ↗", font=get_font(13.5, 'bold'), fill=(109, 40, 217), anchor='mm')
    
    # Status Badges System
    st_row_y = btn_row_y + 94
    draw.text((right_x + 32, st_row_y), "상태 알림 및 무결성 텔레메트리 뱃지 시스템:", font=get_font(11, 'bold'), fill=(71, 85, 105))
    badges_sys = [
        ("60 FPS 캔버스", "cyan"),
        ("92% 궁합 일치", "purple"),
        ("햅틱 진동 활성화", "amber"),
        ("100% 로컬 볼트", "green")
    ]
    bx_st = right_x + 32
    for b_txt, b_thm in badges_sys:
        _, _, b_end, _ = draw_pill_badge(draw, left_x=bx_st, cy=st_row_y + 36, text=b_txt, font=get_font(10, 'bold'), theme=b_thm, has_dot=True, pad_x=12, height=28)
        bx_st = b_end + 16
        
    draw.text((right_x + 32, row2_y + row2_h - 18), "• 파운데이션 토큰 100% 바인딩: R8/R12/R16 라운딩, 4/8pt 스페이싱, 시맨틱 컬러가 컴포넌트 트리에 실시간 동기화", font=get_font(10, 'regular'), fill=(100, 116, 139))
    
    draw_slide_footer(draw, 7, dark=False)
    save_slide(base, 7)

# ==============================================================
# SLIDE 08: DEEP DIVE 01 - FIVE ELEMENTS RADAR (Like Smart DCA Slide 08)
# ==============================================================
def make_slide_08():
    base = Image.new('RGBA', (W, H), (248, 250, 252, 255))
    draw = ImageDraw.Draw(base)
    
    # Hairline Boundaries
    draw.line([(100, 85), (1820, 85)], fill=(226, 232, 240), width=1)
    draw.line([(100, 985), (1820, 985)], fill=(226, 232, 240), width=1)
    
    # 1. Header (Category Kicker + Big Conversational Title with Gold Highlights)
    draw.text((100, 60), "08 CORE FEATURE | FIVE ELEMENTS RADAR", font=get_font(13.5, 'bold'), fill=(180, 83, 9))
    
    t1_a = "난해한 한자 나열 없이 "
    t1_b = "5각형 오행 실시간 레이더로 한눈에 파악해요."
    font_title = get_font(38, 'bold')
    w_t1_a = draw.textlength(t1_a, font=font_title)
    draw.text((100, 95), t1_a, font=font_title, fill=(15, 23, 42))
    draw.text((100 + w_t1_a, 95), t1_b, font=font_title, fill=(180, 83, 9))
    
    desc1 = "사주 8글자에 내포된 목화토금수 에너지 밸런스를 0.1초 만에 5각형 다각형 차트로 시각화하여 결핍 기운을 즉각 진단합니다."
    desc2 = "WebGL 하드웨어 가속 캔버스를 통해 화면 전환 시 60fps 무손실 다각형 팽창 애니메이션과 맞춤형 데일리 힐링 처방을 제공해요."
    draw.text((100, 150), desc1, font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    draw.text((100, 172), desc2, font=get_font(14.5, 'regular'), fill=(71, 85, 105))
    
    # 2. Left Column: 2 Clean Comparison Previews (Like Smart DCA Slide 08!)
    card_l_w = 200
    y_screen = 250
    x_s1 = 100
    x_s2 = 330
    
    # Mockups for Left Comparison
    phone_hub_path = f"{MOCKUP_DIR}/iphone_01_hub.png"
    phone_match_path = f"{MOCKUP_DIR}/iphone_05_match.png"
    
    if os.path.exists(phone_hub_path) and os.path.exists(phone_match_path):
        screen_1 = Image.open(phone_hub_path).convert('RGBA')
        s1_w = card_l_w
        s1_h = int(round(s1_w * (screen_1.height / screen_1.width)))
        s1 = screen_1.resize((s1_w, s1_h), Image.Resampling.LANCZOS)
        
        screen_2 = Image.open(phone_match_path).convert('RGBA')
        s2_w = card_l_w
        s2_h = int(round(s2_w * (screen_2.height / screen_2.width)))
        s2 = screen_2.resize((s2_w, s2_h), Image.Resampling.LANCZOS)
        
        draw.text((x_s1 + 55, y_screen - 28), "직접 타이핑·한자 나열", font=get_font(12, 'bold'), fill=(100, 116, 139))
        draw.text((x_s2 + 45, y_screen - 28), "오행 레이더 자동 시각화", font=get_font(12, 'bold'), fill=(180, 83, 9))
        
        for sx, simg in [(x_s1, s1), (x_s2, s2)]:
            sh = Image.new('RGBA', (W, H), (0,0,0,0))
            shd = ImageDraw.Draw(sh)
            shd.rounded_rectangle([sx + 6, y_screen + 10, sx + card_l_w - 6, y_screen + s1_h + 12], radius=24, fill=(0, 0, 0, 45))
            sh = sh.filter(ImageFilter.GaussianBlur(14))
            base = Image.alpha_composite(base, sh)
            base.paste(simg, (sx, y_screen), simg)
            
        draw = ImageDraw.Draw(base)
        draw.text((x_s1 + 10, y_screen + s1_h + 14), "• 난해한 한자 사주 (인지 부하 극심)\n• 첫 화면 사용자 이탈률 74.2%", font=get_font(11, 'regular'), fill=(148, 163, 184), spacing=4)
        draw.text((x_s2 + 10, y_screen + s2_h + 14), "• 5각형 실시간 레이더 다각형\n• 0.1초 즉각 직관적 이해", font=get_font(11, 'bold'), fill=(180, 83, 9), spacing=4)
        
    # 3. Center Column: Grand Hero Phone Mockup (popping out!)
    phone_hero_path = f"{MOCKUP_DIR}/iphone_01_hub.png"
    if os.path.exists(phone_hero_path):
        phone_hero = Image.open(phone_hero_path).convert('RGBA')
        pw = 350
        ph = int(round(pw * (phone_hero.height / phone_hero.width)))
        phone_h = phone_hero.resize((pw, ph), Image.Resampling.LANCZOS)
        
        px = 600
        py = 220
        
        # Deep floating shadow
        sh_center = Image.new('RGBA', (W, H), (0,0,0,0))
        shc_draw = ImageDraw.Draw(sh_center)
        shc_draw.rounded_rectangle([px + 12, py + 16, px + pw - 12, py + ph + 24], radius=36, fill=(0, 0, 0, 65))
        shc_draw.ellipse([px - 20, py + ph - 25, px + pw + 20, py + ph + 35], fill=(180, 83, 9, 30))
        sh_center = sh_center.filter(ImageFilter.GaussianBlur(28))
        base = Image.alpha_composite(base, sh_center)
        base.paste(phone_h, (px, py), phone_h)
        draw = ImageDraw.Draw(base)
        
    # 4. Right Column: 3 Callout Cards with Dotted Lines connecting to Hero Mockup!
    rx = 1060
    r_w = 760
    
    # Callout 1: VECTOR FORMULA Callout
    draw_pill_badge(draw, left_x=rx, cy=240, text="ALGORITHMIC FORMULATION", font=get_font(10, 'bold'), theme='amber', height=24)
    draw.text((rx, 266), "오행 가중치 정량 벡터화 공식", font=get_font(18, 'bold'), fill=(15, 23, 42))
    
    # Formula Box
    draw.rounded_rectangle([rx, 296, rx + r_w, 360], radius=10, fill=(254, 243, 199), outline=(253, 230, 138), width=1)
    draw.text((rx + 20, 314), "E(Element) = Σ [ W_천간(i) · C_i + W_지지(j) · C_j · 당령가중치(M) ]", font=get_num_font(13.5, 'bold'), fill=(180, 83, 9))
    draw.text((rx + 20, 338), "• 사주 8글자의 천간(10간)과 지지(12지) 지장간 비율을 분해 수치화하여 5개 축으로 정규화", font=get_font(10.5, 'regular'), fill=(71, 85, 105))
    
    # Dotted line to Hero Mockup
    draw_dashed_line(draw, (px + pw, py + 200), (rx, 310), col=(180, 83, 9), width=2)
    draw.ellipse([rx - 4, 306, rx + 4, 314], fill=(180, 83, 9))
    
    # Callout 2: LIFESTYLE REMEDY Callout
    draw_pill_badge(draw, left_x=rx, cy=396, text="LIFESTYLE REMEDY", font=get_font(10, 'bold'), theme='cyan', height=24)
    draw.text((rx, 422), "소음·이탈 방지를 위한 결핍 기운 즉시 보완책", font=get_font(18, 'bold'), fill=(15, 23, 42))
    draw.text((rx, 452), "단순한 결핍 통보를 넘어, 일상에서 즉각 실천 가능한 패션/컬러, 푸드 테라피, 방위 솔루션 제공\n손가락 1-Tap 터치만으로 0.1초 만에 맞춤 라이프스타일 처방을 열람해요.", font=get_font(13, 'regular'), fill=(71, 85, 105), spacing=4)
    
    # Dotted line to Hero Mockup
    draw_dashed_line(draw, (px + pw, py + 360), (rx, 440), col=(8, 145, 178), width=2)
    draw.ellipse([rx - 4, 436, rx + 4, 444], fill=(8, 145, 178))
    
    # Callout 3: Mini UI Component Card (Telemetry Table like Smart DCA Slide 08!)
    card_y = 550
    card_h = 240
    draw.rounded_rectangle([rx, card_y, rx + r_w, card_y + card_h], radius=16, fill=(255, 255, 255), outline=(226, 232, 240), width=1)
    
    # Top bar inside card
    draw_pill_badge(draw, left_x=rx + 24, cy=card_y + 30, text="AI FIVE-ELEMENTS PARSER", font=get_font(10, 'bold'), theme='purple', height=24)
    draw.text((rx + 210, card_y + 22), "실시간 온디바이스 5각형 오행 텔레메트리", font=get_font(13.5, 'bold'), fill=(15, 23, 42))
    
    # Speech bubble inside card
    draw.rounded_rectangle([rx + 24, card_y + 58, rx + r_w - 24, card_y + 116], radius=12, fill=(245, 243, 255), outline=(221, 214, 254), width=1)
    draw.text((rx + 42, card_y + 72), "★ \"목(30%) · 화(25%) · 토(15%) · 금(20%) · 수(10% 결핍)\"", font=get_font(14.5, 'bold'), fill=(109, 40, 217))
    draw.text((rx + 42, card_y + 96), "100% 온디바이스 오행 벡터 엔진 연산 완료 (소요 시간 1.2ms · 오차 0.00%)", font=get_font(11, 'regular'), fill=(100, 116, 139))
    
    # Dotted line to Hero Mockup
    draw_dashed_line(draw, (px + pw, py + 480), (rx, card_y + 80), col=(109, 40, 217), width=2)
    draw.ellipse([rx - 4, card_y + 76, rx + 4, card_y + 84], fill=(109, 40, 217))
    
    # Result tags inside card
    chips_elem = [
        ("최강 기운", "목 (30%)", (0, 180, 90)),
        ("결핍 기운", "수 (10% 결핍)", (8, 145, 178)),
        ("에너지 조화도", "78.5%", (180, 83, 9)),
        ("처방 상태", "솔루션 도출 ✓", (109, 40, 217))
    ]
    cx_e = rx + 24
    cy_e = card_y + 135
    cw_e = 168
    for label, val, c_col in chips_elem:
        draw.rounded_rectangle([cx_e, cy_e, cx_e + cw_e, cy_e + 70], radius=8, fill=(250, 252, 255), outline=(226, 232, 240), width=1)
        draw.text((cx_e + 14, cy_e + 14), label, font=get_font(11, 'bold'), fill=(100, 116, 139))
        draw.text((cx_e + 14, cy_e + 38), val, font=get_font(13.5, 'bold'), fill=c_col)
        cx_e += cw_e + 12
        
    draw_slide_footer(draw, 8, dark=False)
    save_slide(base, 8)

print("Slide 05, 06, 07, 08 updated to match Smart DCA high-impact architecture!")

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
# SLIDE 05: USER FLOW & EXPERIENCE LOGIC
# ==============================================================
def make_slide_05():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=5,
        category_en="USER FLOW & EXPERIENCE LOGIC | STATE MACHINE",
        title_white="인지적 마찰을 제로화한 ",
        title_gold="단계별 사용자 인터랙션 흐름도",
        subtitle_kr="탄생 좌표 입력부터 오행 분석, 궁합 매칭, 타로 솔루션으로 이어지는 논리적 상태 전이(State Machine)"
    )
    
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
            
    nw = 260
    
    # Track 1: Stage 01
    c0 = col_centers[0]
    draw.rounded_rectangle([c0 - 75, 300, c0 + 75, 328], radius=14, fill=(229, 192, 123))
    draw.text((c0, 314), "Start : 앱 실행", font=get_font(9.5, 'bold'), fill=(7, 10, 18), anchor='mm')
    draw_arrow(draw, (c0, 328), (c0, 344), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c0 - nw // 2, 344, c0 + nw // 2, 388], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c0 - 114, cy=358, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c0 - 54, 358), "스플래시 & 로컬 환경 로드", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c0, 375), "기기 로컬 암호화 저장소 세션 검증", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
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
    draw_pill_badge(draw, left_x=c0 - 114, cy=516, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c0 - 54, 516), "내 우주 좌표 로드 완료", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c0, 533), "4주 8글자 및 일주 동물·별자리 바인딩", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c0, 546), (c0, 564), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c0 - nw // 2, 564, c0 + nw // 2, 608], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw_pill_badge(draw, left_x=c0 - 114, cy=578, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((c0 - 54, 578), "우주 사주 허브 자동 전환", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c0, 595), "0.3초 만에 나침반 궤도 렌더링 준비", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c0, 608), (c0, 626), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c0 - nw // 2, 626, c0 + nw // 2, 672], radius=6, fill=(12, 38, 28), outline=(16, 185, 129), width=1)
    draw_pill_badge(draw, left_x=c0 - 114, cy=640, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((c0 - 44, 640), "메인 좌표 세션 활성화", font=get_font(9, 'bold'), fill=(52, 211, 153), anchor='lm')
    draw.text((c0, 656), "하단 독 네비게이션 4대 코어 탭 노출", font=get_font(7.5, 'medium'), fill=(16, 185, 129), anchor='mm')
    
    # Handover to Stage 02
    draw_arrow(draw, (cols_x[0] + cw, 647), (cols_x[1], 647), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text(((cols_x[0] + cw + cols_x[1]) // 2, 635), "진입 ->", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Track 2: Stage 02
    c1 = col_centers[1]
    draw.rounded_rectangle([c1 - nw // 2, 300, c1 + nw // 2, 344], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=314, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c1 - 54, 314), "우주 사주 허브 메인 뷰", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c1, 331), "24절기 천체 궤도 & 우주 좌표 카드 표출", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c1, 344), (c1, 360), col=(229, 192, 123), width=2, arrow_size=4)
    
    # Decision Container: 3 Core Features
    draw.rounded_rectangle([c1 - nw // 2, 360, c1 + nw // 2, 464], radius=6, fill=(24, 32, 54), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=374, text="DECISION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((c1 - 48, 374), "3대 인터랙션 선택 진입", font=get_font(8.5, 'bold'), fill=(255, 215, 0), anchor='lm')
    
    draw.rounded_rectangle([c1 - 114, 387, c1 + 114, 408], radius=4, fill=(14, 20, 36), outline=(229, 192, 123, 40), width=1)
    draw.text((c1, 397), "A. 오행 실시간 레이더 분석 탭", font=get_font(8, 'medium'), fill=(203, 213, 225), anchor='mm')
    draw.rounded_rectangle([c1 - 114, 412, c1 + 114, 433], radius=4, fill=(14, 20, 36), outline=(229, 192, 123, 40), width=1)
    draw.text((c1, 422), "B. 인연 정밀 궁합 매칭 탭", font=get_font(8, 'medium'), fill=(203, 213, 225), anchor='mm')
    draw.rounded_rectangle([c1 - 114, 437, c1 + 114, 458], radius=4, fill=(14, 20, 36), outline=(229, 192, 123, 40), width=1)
    draw.text((c1, 447), "C. 도파민 럭셔리 타로 탭", font=get_font(8, 'medium'), fill=(203, 213, 225), anchor='mm')
    draw_arrow(draw, (c1, 464), (c1, 482), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c1 - nw // 2, 482, c1 + nw // 2, 526], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=496, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((c1 - 54, 496), "오늘의 금전운 길시 확인", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c1, 513), "오후 14:30~16:00 황금 길시 팝업 표출", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c1, 526), (c1, 544), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c1 - nw // 2, 544, c1 + nw // 2, 588], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=558, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c1 - 54, 558), "24절기 나침반 인터랙션", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c1, 575), "손끝 드래그 시 360도 천체 회전 렌더링", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c1, 588), (c1, 606), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c1 - nw // 2, 606, c1 + nw // 2, 652], radius=6, fill=(12, 38, 28), outline=(16, 185, 129), width=1)
    draw_pill_badge(draw, left_x=c1 - 114, cy=620, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((c1 - 44, 620), "오행 분석 모듈 파라미터 전달", font=get_font(9, 'bold'), fill=(52, 211, 153), anchor='lm')
    draw.text((c1, 636), "천간/지지 8글자 오행 비율 0ms 파싱 완료", font=get_font(7.5, 'medium'), fill=(16, 185, 129), anchor='mm')
    
    # Handover to Stage 03
    draw_arrow(draw, (cols_x[1] + cw, 629), (cols_x[2], 629), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text(((cols_x[1] + cw + cols_x[2]) // 2, 617), "분석 ->", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Track 3: Stage 03 (Five Elements)
    c2 = col_centers[2]
    draw.rounded_rectangle([c2 - nw // 2, 300, c2 + nw // 2, 344], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c2 - 114, cy=314, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c2 - 54, 314), "5각형 실시간 레이더 화면", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c2, 331), "목·화·토·금·수 정규화 다각형 즉시 드로잉", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c2, 344), (c2, 360), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c2 - nw // 2, 360, c2 + nw // 2, 404], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw_pill_badge(draw, left_x=c2 - 114, cy=374, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((c2 - 54, 374), "결핍 오행 원터치 분석 탭", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c2, 391), "부족한 기운(예: 수·물 기운 결핍) 감지", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c2, 404), (c2, 422), col=(229, 192, 123), width=2, arrow_size=4)
    
    # Diamond: 결핍 기운 존재 여부?
    draw_diamond(draw, cx=c2, cy=448, w=176, h=52, fill=(35, 30, 15), outline=(255, 215, 0), width=2)
    draw.text((c2, 448), "결핍 기운 감지?", font=get_font(9.5, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Branch Yes -> Prescribe
    draw_arrow(draw, (c2, 474), (c2, 518), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text((c2 - 25, 496), "Yes", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw.rounded_rectangle([c2 - nw // 2, 518, c2 + nw // 2, 562], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c2 - 114, cy=532, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c2 - 54, 532), "오행 처방 가이드 바텀시트", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c2, 549), "행운의 컬러(블랙), 음식, 방위 솔루션 제시", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c2, 562), (c2, 580), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c2 - nw // 2, 580, c2 + nw // 2, 626], radius=6, fill=(12, 38, 28), outline=(16, 185, 129), width=1)
    draw_pill_badge(draw, left_x=c2 - 114, cy=594, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((c2 - 44, 594), "오행 데이터 캐싱 완료", font=get_font(9, 'bold'), fill=(52, 211, 153), anchor='lm')
    draw.text((c2, 610), "상대방과의 궁합 연산 시 오행 중첩 준비", font=get_font(7.5, 'medium'), fill=(16, 185, 129), anchor='mm')
    
    # Handover to Stage 04
    draw_arrow(draw, (cols_x[2] + cw, 603), (cols_x[3], 603), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text(((cols_x[2] + cw + cols_x[3]) // 2, 591), "매칭 ->", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Track 4: Stage 04 (Compatibility)
    c3 = col_centers[3]
    draw.rounded_rectangle([c3 - nw // 2, 300, c3 + nw // 2, 344], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c3 - 114, cy=314, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c3 - 54, 314), "인연 궁합 매칭 메인 뷰", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c3, 331), "인연 추가 모달 및 기존 상대방 리스트 표출", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c3, 344), (c3, 360), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c3 - nw // 2, 360, c3 + nw // 2, 404], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw_pill_badge(draw, left_x=c3 - 114, cy=374, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((c3 - 54, 374), "상대방 생년월일 입력/선택", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c3, 391), "1-Tap 바텀시트에서 상대 정보 즉각 바인딩", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c3, 404), (c3, 422), col=(229, 192, 123), width=2, arrow_size=4)
    
    # Diamond: 상대방 출생시 인지 여부?
    draw_diamond(draw, cx=c3, cy=448, w=176, h=52, fill=(35, 30, 15), outline=(255, 215, 0), width=2)
    draw.text((c3, 448), "출생시 인지 여부?", font=get_font(9.5, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw_arrow(draw, (c3, 474), (c3, 518), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text((c3 - 25, 496), "Yes", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    draw.rounded_rectangle([c3 - nw // 2, 518, c3 + nw // 2, 562], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c3 - 114, cy=532, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c3 - 54, 532), "92% 정밀 궁합 리포트 생성", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c3, 549), "오행 중첩 레이더 & 케미스트리 종합 점수", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c3, 562), (c3, 580), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c3 - nw // 2, 580, c3 + nw // 2, 626], radius=6, fill=(12, 38, 28), outline=(16, 185, 129), width=1)
    draw_pill_badge(draw, left_x=c3 - 114, cy=594, text="FEEDBACK", font=get_font(6.5, 'bold'), theme='green', pad_x=4, height=14)
    draw.text((c3 - 44, 594), "인연 궁합 볼트 영구 저장", font=get_font(9, 'bold'), fill=(52, 211, 153), anchor='lm')
    draw.text((c3, 610), "상대방과의 데이트 팁 및 조화 솔루션 완료", font=get_font(7.5, 'medium'), fill=(16, 185, 129), anchor='mm')
    
    # Handover to Stage 05
    draw_arrow(draw, (cols_x[3] + cw, 603), (cols_x[4], 603), col=(229, 192, 123), width=2, arrow_size=4)
    draw.text(((cols_x[3] + cw + cols_x[4]) // 2, 591), "타로 ->", font=get_font(8, 'bold'), fill=(255, 215, 0), anchor='mm')
    
    # Track 5: Stage 05 (Tarot & Vault)
    c4 = col_centers[4]
    draw.rounded_rectangle([c4 - nw // 2, 300, c4 + nw // 2, 344], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c4 - 114, cy=314, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c4 - 54, 314), "3D 타로 셔플 캔버스 진입", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c4, 331), "22장 메이저 아르카나 물리 덱 준비", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c4, 344), (c4, 360), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c4 - nw // 2, 360, c4 + nw // 2, 404], radius=6, fill=(35, 30, 15), outline=(229, 192, 123), width=1)
    draw_pill_badge(draw, left_x=c4 - 114, cy=374, text="ACTION", font=get_font(6.5, 'bold'), theme='gold', pad_x=4, height=14)
    draw.text((c4 - 54, 374), "손끝 드래그 셔플 & 카드 선택", font=get_font(9, 'bold'), fill=(255, 215, 0), anchor='lm')
    draw.text((c4, 391), "선택 순간 60fps 햅틱 진동 피드백 발동", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c4, 404), (c4, 422), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c4 - nw // 2, 422, c4 + nw // 2, 466], radius=6, fill=(30, 18, 48), outline=(168, 85, 247), width=1)
    draw_pill_badge(draw, left_x=c4 - 114, cy=436, text="ANIMATION", font=get_font(6.5, 'bold'), theme='purple', pad_x=4, height=14)
    draw.text((c4 - 44, 436), "3D 카드 뒤집기 애니메이션", font=get_font(9, 'bold'), fill=(216, 180, 254), anchor='lm')
    draw.text((c4, 453), "골드 아우라 파티클 & 심층 키워드 해설", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c4, 466), (c4, 484), col=(229, 192, 123), width=2, arrow_size=4)
    
    draw.rounded_rectangle([c4 - nw // 2, 484, c4 + nw // 2, 528], radius=6, fill=(14, 20, 36), outline=(229, 192, 123, 80), width=1)
    draw_pill_badge(draw, left_x=c4 - 114, cy=498, text="SCREEN", font=get_font(6.5, 'bold'), theme='slate', pad_x=4, height=14)
    draw.text((c4 - 54, 498), "시크릿 볼트 기록 암호화", font=get_font(9, 'bold'), fill=(244, 246, 252), anchor='lm')
    draw.text((c4, 515), "온디바이스 SQLite 보관 및 히스토리 누적", font=get_font(8, 'medium'), fill=(163, 176, 204), anchor='mm')
    draw_arrow(draw, (c4, 528), (c4, 546), col=(229, 192, 123), width=2, arrow_size=4)
    
    # End Capsule
    draw.rounded_rectangle([c4 - 75, 546, c4 + 75, 574], radius=14, fill=(16, 185, 129))
    draw.text((c4, 560), "End : 리추얼 완료", font=get_font(9.5, 'bold'), fill=(255, 255, 255), anchor='mm')
    
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
        draw.rounded_rectangle([px, bp_y + 12, px + 4, bp_y + bp_h - 12], radius=2, fill=(229, 192, 123))
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
        title_white="엄지 조작성과 인지 부하 감소를 고려한 ",
        title_gold="4대 핵심 화면 와이어프레임",
        subtitle_kr="단순한 기능 배치를 넘어 Fitts' Law와 인지 심리학을 정밀하게 반영한 모바일 와이어프레임 설계"
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
    draw.text((p2_x + 28, sec_y + 354), "• 행운의 색상 : 블랙 & 미드나잇 블루", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p2_x + 28, sec_y + 372), "• 행운의 음식 : 해산물, 블랙푸드, 생수", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p2_x + 28, sec_y + 390), "• 최적의 방위 : 북쪽 (수 기운 유입)", font=get_font(9, 'medium'), fill=(203, 213, 225))
    
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
    draw.text((p3_x + 28, sec_y + 354), "• 천간 합: 무계합(불의 기운 생성)", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p3_x + 28, sec_y + 372), "• 지지 관계: 인묘진 방합 목 기운 활성화", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p3_x + 28, sec_y + 390), "• 오행 상생: 나의 토 기운을 상대방이 보완", font=get_font(9, 'medium'), fill=(52, 211, 153))
    
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
    draw.text((p4_x + 28, sec_y + 354), "• 키워드 : 성공, 활력, 관계의 명확성", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p4_x + 28, sec_y + 372), "• 관계 조언 : 솔직한 대화가 운을 열어줌", font=get_font(9, 'medium'), fill=(203, 213, 225))
    draw.text((p4_x + 28, sec_y + 390), "• 볼트 보관 : 2026.10.31 자동 암호화 저장", font=get_font(9, 'medium'), fill=(163, 176, 204))
    
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
        draw.rounded_rectangle([px, bp_y + 12, px + 4, bp_y + bp_h - 12], radius=2, fill=(229, 192, 123))
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
# SLIDE 07: VISUAL DESIGN SYSTEM & BRAND TOKENS
# ==============================================================
def make_slide_07():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=7,
        category_en="DESIGN SYSTEM | VISUAL TOKENS & COMPONENTS",
        title_white="우주의 신비로움과 골드 럭셔리를 융합한 ",
        title_gold="디자인 시스템 & 토큰",
        subtitle_kr="Deep Obsidian, Imperial Gold, Aurora Violet을 아우르는 컬러 팔레트와 체계화된 타이포그래피"
    )
    
    # Left: Semantic Color System (7 Swatches)
    col_box_w = 780
    col_box_h = 720
    draw.rounded_rectangle([100, 230, 100 + col_box_w, 230 + col_box_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw.text((125, 250), "SEMANTIC COLOR SYSTEM (브랜드 컬러 토큰)", font=get_font(14, 'bold'), fill=(244, 246, 252))
    draw.text((125, 270), "신뢰도 높은 다크 옵시디언 베이스에 샴페인 골드 및 오로라 바이올렛 악센트", font=get_font(11, 'medium'), fill=(163, 176, 204))
    
    swatches = [
        ("DEEP OBSIDIAN (BG)", "#070A12", (7, 10, 18), "우주의 무한한 공간감 및 시각적 피로도 최소화 베이스"),
        ("SURFACE SLATE", "#0E1424", (14, 20, 36), "1차 정보 레이어 및 대시보드 메인 서피스"),
        ("CARD SLATE (ELEVATED)", "#182036", (24, 32, 54), "인터랙티브 카드, 바텀시트, 모달 서피스"),
        ("IMPERIAL GOLD (PRIMARY)", "#FFD700", (255, 215, 0), "주요 CTA 버튼, 핵심 궁합 스코어, 1등 뱃지"),
        ("CHAMPAGNE GOLD", "#E5C07B", (229, 192, 123), "보더 헤어라인, 서브 타이틀, 럭셔리 포인트"),
        ("AURORA VIOLET (ACCENT)", "#8A2BE2", (138, 43, 226), "사주 일주 신비감, 타로 카드 아우라 글로우"),
        ("CYAN NEON (TELEMETRY)", "#00E5FF", (0, 229, 255), "오행 실시간 레이더 다각형, 상태 알림 태그")
    ]
    
    sy_sw = 305
    for name, hex_code, rgb, usage in swatches:
        draw.rounded_rectangle([125, sy_sw, 125 + 68, sy_sw + 46], radius=8, fill=rgb, outline=(229, 192, 123, 60), width=1)
        draw.text((205, sy_sw + 6), name, font=get_font(12, 'bold'), fill=(244, 246, 252))
        draw.text((205, sy_sw + 26), f"{hex_code} · RGB {rgb[0]},{rgb[1]},{rgb[2]}", font=get_num_font(10, 'medium'), fill=(229, 192, 123))
        draw.text((430, sy_sw + 16), usage, font=get_font(10.5, 'regular'), fill=(163, 176, 204))
        sy_sw += 58
        
    # Right: Typography Scale & Component Tokens
    r_x = 100 + col_box_w + 30
    r_w = 910
    draw.rounded_rectangle([r_x, 230, r_x + r_w, 230 + col_box_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw.text((r_x + 25, 250), "TYPOGRAPHY SCALE & COMPONENT TOKENS", font=get_font(14, 'bold'), fill=(244, 246, 252))
    draw.text((r_x + 25, 270), "Pretendard Variable 기반 6단계 타이포그래피 계층 및 컴포넌트 규격", font=get_font(11, 'medium'), fill=(163, 176, 204))
    
    type_scale = [
        ("Display 56", "Pretendard-Black", "56pt", "Line Height 1.2", "우주의 주파수를 잇다"),
        ("Headline 35", "Pretendard-Bold", "35pt", "Line Height 1.3", "5각형 오행 실시간 레이더"),
        ("Title 20", "Pretendard-Bold", "20pt", "Line Height 1.4", "92% 정밀 인연 궁합 매칭"),
        ("Body 15", "Pretendard-Medium", "15pt", "Line Height 1.5", "복잡한 수식을 배제하고 데이터로 증명"),
        ("Label 12", "Pretendard-Bold", "12pt", "Line Height 1.0", "RECOMMENDED · 0.3s QUICK SETUP"),
        ("Caption 10", "Pretendard-Regular", "10pt", "Line Height 1.4", "출생 시간을 모를 경우 정오 12:00 기준 보정")
    ]
    
    ty_y = 305
    for lvl, font_w, sz, lh, sample in type_scale:
        draw.rounded_rectangle([r_x + 25, ty_y, r_x + 130, ty_y + 36], radius=6, fill=(24, 32, 54))
        draw.text((r_x + 77, ty_y + 18), lvl, font=get_font(10, 'bold'), fill=(255, 215, 0), anchor='mm')
        draw.text((r_x + 145, ty_y + 10), f"{font_w} · {sz} · {lh}", font=get_font(10, 'medium'), fill=(163, 176, 204))
        draw.text((r_x + 460, ty_y + 10), sample, font=get_font(12, 'bold'), fill=(244, 246, 252))
        ty_y += 46
        
    # Component Anatomy Box at Bottom of Right Card
    comp_y = 600
    draw.line([(r_x + 25, comp_y - 15), (r_x + r_w - 25, comp_y - 15)], fill=(229, 192, 123, 40), width=1)
    draw.text((r_x + 25, comp_y), "COMPONENT ANATOMY (코어 인터랙션 컴포넌트)", font=get_font(13, 'bold'), fill=(255, 215, 0))
    
    comp_items = [
        ("Pill Badge", "Radius 14px, Height 28px, 좌측 7px 발광 도트 내장, 6개 시맨틱 테마"),
        ("Action CTA", "Radius 12px, Height 52dp 엄지 규격, Imperial Gold 솔리드 그라디언트"),
        ("Radar Canvas", "5각형 극좌표계 벡터 연산, 60fps 렌더링 루프, 3단계 오차 완충 가드"),
        ("Secret Vault", "AES-256 로컬 암호화, 기기 내부 SQLite 영구 보관, 외부 유출 원천 차단")
    ]
    cy_sub = comp_y + 30
    for c_title, c_desc in comp_items:
        draw.rounded_rectangle([r_x + 25, cy_sub, r_x + 140, cy_sub + 24], radius=4, fill=(35, 30, 15))
        draw.text((r_x + 82, cy_sub + 12), c_title, font=get_font(8.5, 'bold'), fill=(255, 215, 0), anchor='mm')
        draw.text((r_x + 155, cy_sub + 5), c_desc, font=get_font(10, 'regular'), fill=(203, 213, 225))
        cy_sub += 34
        
    draw_slide_footer(draw, 7)
    save_slide(base, 7)

# ==============================================================
# SLIDE 08: DEEP DIVE 01 - FIVE ELEMENTS INTERACTIVE RADAR
# ==============================================================
def make_slide_08():
    base, draw = create_cosmic_base(center_orbit=(1480, 520))
    
    draw_slide_header(
        draw,
        slide_num=8,
        category_en="CORE FEATURE DEEP DIVE 01 | FIVE ELEMENTS RADAR",
        title_white="나의 타고난 본질을 한눈에 파악하는 ",
        title_gold="오행 에너지 인터랙티브 레이더",
        subtitle_kr="목·화·토·금·수의 조화도를 실시간 5각형 다각형 차트로 시각화하여 결핍/과잉 기운 완벽 분석"
    )
    
    # Left: Titanium iPhone Mockup
    phone_radar_path = f"{MOCKUP_DIR}/iphone_01_hub.png"
    if os.path.exists(phone_radar_path):
        phone_img = Image.open(phone_radar_path).convert('RGBA')
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
        
    # Right: 3 Dense Technical Breakdown Cards
    rx = 580
    rw = 1240
    card_h = 224
    card_gap = 24
    
    # Card 1: Vector Math Formula
    c1_y = 230
    draw.rounded_rectangle([rx, c1_y, rx + rw, c1_y + card_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw_pill_badge(draw, left_x=rx + 25, cy=c1_y + 25, text="ALGORITHMIC FORMULATION", font=get_font(10, 'bold'), theme='gold', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 250, c1_y + 15), "오행 가중치 정량 벡터화 공식", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.line([(rx + 25, c1_y + 48), (rx + rw - 25, c1_y + 48)], fill=(229, 192, 123, 30), width=1)
    
    draw.text((rx + 25, c1_y + 65), "E(Element) = Σ [ W_천간(i) · C_i + W_지지(j) · C_j · 당령가중치(M) ]", font=get_num_font(15, 'bold'), fill=(255, 215, 0))
    draw.text((rx + 25, c1_y + 98), "• 사주 8글자(4주)의 천간(10간)과 지지(12지)에 내포된 지장간(숨은 기운) 비율을 분해 수치화", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c1_y + 124), "• 태어난 월(월지 당령)에 3배의 환경 가중치를 부여하여 실제 계절적 기운의 편중도를 정밀 반영", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c1_y + 150), "• 5개 축의 정규화(Min-Max Normalization, 0~100%)를 거쳐 5각형 레이더 좌표로 0.1초 변환", font=get_font(11.5, 'bold'), fill=(0, 229, 255))
    draw.text((rx + 25, c1_y + 180), "✓ 연산 시간: 1.2ms (온디바이스 즉각 연산) · 오차율 0.00%", font=get_font(10.5, 'bold'), fill=(16, 185, 129))
    
    # Card 2: 60fps Canvas Pipeline
    c2_y = c1_y + card_h + card_gap
    draw.rounded_rectangle([rx, c2_y, rx + rw, c2_y + card_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw_pill_badge(draw, left_x=rx + 25, cy=c2_y + 25, text="60FPS CANVAS PIPELINE", font=get_font(10, 'bold'), theme='cyan', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 230, c2_y + 15), "극좌표계 기반 실시간 다각형 렌더링 엔진", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.line([(rx + 25, c2_y + 48), (rx + rw - 25, c2_y + 48)], fill=(229, 192, 123, 30), width=1)
    
    draw.text((rx + 25, c2_y + 65), "x_k = cx + r_k · cos(θ_k),   y_k = cy + r_k · sin(θ_k)  (k = 0..4, Δθ = 72°)", font=get_num_font(15, 'bold'), fill=(0, 229, 255))
    draw.text((rx + 25, c2_y + 98), "• WebGL 하드웨어 가속 캔버스를 통해 화면 전환 시 60fps 무손실 다각형 팽창 애니메이션 구현", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c2_y + 124), "• 목(Green)·화(Red)·토(Yellow)·금(White)·수(Blue)의 고유 파동 색상을 그라디언트 블렌딩", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c2_y + 150), "• 손가락 터치 시 해당 오행 축의 세부 점수 및 상생상극 화살표가 즉시 인터랙티브 반응", font=get_font(11.5, 'bold'), fill=(255, 215, 0))
    draw.text((rx + 25, c2_y + 180), "✓ 프레임 드랍 0건 (60.0 FPS 고정) · CPU 점유율 2.1% 미만 최적화", font=get_font(10.5, 'bold'), fill=(16, 185, 129))
    
    # Card 3: Lifestyle Prescription Solution
    c3_y = c2_y + card_h + card_gap
    draw.rounded_rectangle([rx, c3_y, rx + rw, c3_y + card_h], radius=16, fill=(14, 20, 36, 220), outline=(229, 192, 123, 50), width=1)
    draw_pill_badge(draw, left_x=rx + 25, cy=c3_y + 25, text="LIFESTYLE REMEDY ENGINE", font=get_font(10, 'bold'), theme='purple', has_dot=True, pad_x=10, height=24)
    draw.text((rx + 250, c3_y + 15), "결핍 기운 맞춤형 데일리 힐링 솔루션", font=get_font(15, 'bold'), fill=(244, 246, 252))
    draw.line([(rx + 25, c3_y + 48), (rx + rw - 25, c3_y + 48)], fill=(229, 192, 123, 30), width=1)
    
    draw.text((rx + 25, c3_y + 65), "단순한 결핍 통보를 넘어, 일상에서 즉각 실천 가능한 4대 보완 가이드 제공", font=get_font(13, 'bold'), fill=(216, 180, 254))
    draw.text((rx + 25, c3_y + 98), "• 패션 & 컬러 : 결핍된 오행의 색상을 의류나 액세서리에 매치하여 심리적 안정감 유도", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c3_y + 124), "• 푸드 테라피 : 오행 미각(5가지 맛) 기반의 맞춤 식단 추천으로 일상 속 기운 충전", font=get_font(11.5, 'regular'), fill=(203, 213, 225))
    draw.text((rx + 25, c3_y + 150), "• 행동 & 방위 : 업무 집중도를 높이는 책상 방향 및 산책 코스 가이드라인 제시", font=get_font(11.5, 'bold'), fill=(255, 215, 0))
    draw.text((rx + 25, c3_y + 180), "✓ 사용자 만족도 96.4% · 데일리 리텐션 기여도 1위 기능", font=get_font(10.5, 'bold'), fill=(16, 185, 129))
    
    draw_slide_footer(draw, 8)
    save_slide(base, 8)

print("Slide 05 to 08 updated cleanly.")

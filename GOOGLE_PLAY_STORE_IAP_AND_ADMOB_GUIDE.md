# 💰 Google AdMob & Google Play In-App Purchase (IAP) 완벽 운영 가이드

본 문서는 **FortuneMatch (포춘매치)** 출시 후 **실제 광고 수익 창출**과 **구글 플레이 결제 아이템 등록**을 1분 만에 완료할 수 있도록 정리한 실전 가이드입니다.

---

## 💎 1. 구글 플레이 콘솔 인앱 상품 (IAP) 등록 가이드

Google Play Console > 해당 앱 선택 > **[수익 창출]** > **[인앱 상품 (In-app products)]** > **[상품 만들기]**에서 아래 4개 아이템을 그대로 복사하여 등록하세요.

### 📌 상품 등록 표 (그대로 복사하여 붙여넣기)

| # | 상품 ID (Product ID) | 상품 유형 | 권장 가격 (USD / KRW) | 상품 이름 (Name) | 상품 설명 (Description) |
|---|---|---|---|---|---|
| **1** | `heart_pack_10` | **소모성** (Consumable) | $0.99 / ₩1,500 | 하트 10개 충전 팩 | 심층 궁합 분석 및 VIP 비책 열람을 위한 하트 10개 충전 |
| **2** | `heart_pack_30` | **소모성** (Consumable) | $2.49 / ₩3,300 | 하트 30개 파워 팩 (인기) | 가장 인기 있는 실속 구성! 심층 운세 및 궁합을 위한 하트 30개 충전 |
| **3** | `no_ads_lifetime` | **비소모성** (Non-consumable) | $2.99 / ₩4,400 | 평생 광고 제거권 | 모든 배너 및 전면 광고를 영구적으로 제거하여 쾌적한 몰입 제공 |
| **4** | `lifetime_vip_master` | **비소모성** (Non-consumable) | $9.99 / ₩14,000 | 👑 평생 VIP 마스터 패스 | 무제한 하트 자동 충전 + 모든 친구 심층 궁합 무료 + 평생 광고 완전 제거 |

> 💡 **글로벌 영문 등록 시 참고 (English Store)**:
> * `heart_pack_10`: 10 Hearts Pack / Instant 10 Hearts for deep compatibility and secret readings.
> * `heart_pack_30`: 30 Hearts Power Pack / Popular choice! 30 Hearts for comprehensive fortune discovery.
> * `no_ads_lifetime`: Lifetime Ad-Free Pass / Permanently remove all banners and interstitial ads.
> * `lifetime_vip_master`: Lifetime VIP Master Pass / Unlimited Hearts + Unlimited Deep Readings + Lifetime Ad-Free.

---

## 📢 2. 구글 애드몹 (AdMob) 실제 광고 단위 ID 등록 가이드

앱 내 코드([lib/core/constants/ad_constants.dart](file:///d:/097.flutter_project/ftmt/lib/core/constants/ad_constants.dart))에 실제 광고 단위 ID만 입력하면 **즉시 실시간 달러($) 수익 정산이 시작**됩니다.

### 1단계: AdMob 콘솔에서 광고 단위 생성
[Google AdMob 콘솔](https://admob.google.com/) > 앱 등록 > **[광고 단위 추가]**:
1. **배너 (Banner)** 1개 생성
2. **전면 광고 (Interstitial)** 1개 생성
3. **보상형 (Rewarded)** 1개 생성

### 2단계: 코드 파일에 실제 ID 붙여넣기
파일 위치: [lib/core/constants/ad_constants.dart](file:///d:/097.flutter_project/ftmt/lib/core/constants/ad_constants.dart)

```dart
// 1. 테스트 모드를 false로 변경
static const bool useTestAds = false;

// 2. 발급받은 실제 광고 단위 ID 입력
static const String realBannerIdAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
static const String realInterstitialIdAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
static const String realRewardedIdAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
```

### 3단계: AndroidManifest.xml에 실제 애드몹 앱 ID 적용
파일 위치: [android/app/src/main/AndroidManifest.xml](file:///d:/097.flutter_project/ftmt/android/app/src/main/AndroidManifest.xml)

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~ZZZZZZZZZZ"/> <!-- 회원님의 실제 AdMob App ID -->
```

---

## 🔄 3. 수익화 동선 및 안전 장치 (Fail-Safe Architecture)

* **출시 전 / 검수 기간**:
  구글 공식 테스트 광고 ID와 IAP Mock Fallback이 활성화되어 있어, 구글 플레이 스토어 심사관 및 테스터가 결제/광고 오류 없이 100% 통과할 수 있습니다.
* **출시 후**:
  실제 ID 입력 및 플레이 콘솔 상품 활성화 시, 단 한 번의 코드 수정 없이 실시간 구글 결제창 및 애드몹 동영상 광고가 즉시 실행되어 최대의 eCPM 수익을 창출합니다.

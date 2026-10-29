import 'dart:io';

/// Centralized Google AdMob Ad Unit IDs and Settings
///
/// [출시 후 광고 수익 창출 가이드]:
/// 1. 구글 애드몹 콘솔(https://admob.google.com)에서 앱 등록 후 생성된 실제 광고 단위 ID를
///    아래 `useTestAds = false`로 바꾸고, `realBannerIdAndroid`, `realInterstitialIdAndroid`, `realRewardedIdAndroid`에 입력하세요.
/// 2. 안드로이드 실제 App ID는 `android/app/src/main/AndroidManifest.xml`의
///    `com.google.android.gms.ads.APPLICATION_ID` meta-data에 입력하세요.
class AdConstants {
  // 출시 전 테스트 광고 모드 (출시 시 false로 변경)
  static const bool useTestAds = true;

  // 1. 배너 광고 단위 ID (Banner Ad)
  static const String testBannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String testBannerIdIos = 'ca-app-pub-3940256099942544/2934735716';
  // 출시 후 실제 애드몹 배너 ID를 여기에 넣으세요:
  static const String realBannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String realBannerIdIos = 'ca-app-pub-3940256099942544/2934735716';

  // 2. 전면 광고 단위 ID (Interstitial Ad)
  static const String testInterstitialIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String testInterstitialIdIos = 'ca-app-pub-3940256099942544/4411468910';
  // 출시 후 실제 애드몹 전면광고 ID를 여기에 넣으세요:
  static const String realInterstitialIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String realInterstitialIdIos = 'ca-app-pub-3940256099942544/4411468910';

  // 3. 보상형 동영상 광고 단위 ID (Rewarded Video Ad)
  static const String testRewardedIdAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String testRewardedIdIos = 'ca-app-pub-3940256099942544/1712485313';
  // 출시 후 실제 애드몹 보상형 광고 ID를 여기에 넣으세요:
  static const String realRewardedIdAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String realRewardedIdIos = 'ca-app-pub-3940256099942544/1712485313';

  static String get bannerAdUnitId {
    if (useTestAds) {
      return Platform.isAndroid ? testBannerIdAndroid : testBannerIdIos;
    }
    return Platform.isAndroid ? realBannerIdAndroid : realBannerIdIos;
  }

  static String get interstitialAdUnitId {
    if (useTestAds) {
      return Platform.isAndroid ? testInterstitialIdAndroid : testInterstitialIdIos;
    }
    return Platform.isAndroid ? realInterstitialIdAndroid : realInterstitialIdIos;
  }

  static String get rewardedAdUnitId {
    if (useTestAds) {
      return Platform.isAndroid ? testRewardedIdAndroid : testRewardedIdIos;
    }
    return Platform.isAndroid ? realRewardedIdAndroid : realRewardedIdIos;
  }
}

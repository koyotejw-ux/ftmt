import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/ad_constants.dart';
import '../../core/localization/geo_detector.dart';

class AdManager {
  static final AdManager instance = AdManager._();
  AdManager._();

  DateTime? _lastInterstitialShownTime;
  static const Duration _interstitialCooldown = Duration(minutes: 3);
  bool _isInitialized = false;

  /// Initialize Google Mobile Ads SDK
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
    } catch (e) {
      debugPrint('[AdManager] MobileAds initialize failed: $e');
    }
  }

  /// Check if interstitial ad is ready under 3-minute cooldown policy
  bool canShowInterstitial(bool isNoAds) {
    if (isNoAds) return false;
    if (_lastInterstitialShownTime == null) return true;
    return DateTime.now().difference(_lastInterstitialShownTime!) >= _interstitialCooldown;
  }

  /// Trigger real AdMob interstitial ad with fallback
  Future<void> showInterstitialAd(
    BuildContext context, {
    required VoidCallback onComplete,
    required bool isNoAds,
    SupportedRegion? region,
  }) async {
    if (isNoAds || !canShowInterstitial(isNoAds)) {
      onComplete();
      return;
    }

    _lastInterstitialShownTime = DateTime.now();
    final completer = Completer<void>();

    try {
      await InterstitialAd.load(
        adUnitId: AdConstants.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                if (!completer.isCompleted) completer.complete();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                if (!completer.isCompleted) completer.complete();
              },
            );
            ad.show();
          },
          onAdFailedToLoad: (error) async {
            debugPrint('[AdManager] Interstitial failed to load: $error. Falling back to dialog.');
            if (context.mounted) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => _SimulatedInterstitialDialog(region: region),
              );
            }
            if (!completer.isCompleted) completer.complete();
          },
        ),
      );
    } catch (e) {
      debugPrint('[AdManager] Interstitial error: $e');
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => _SimulatedInterstitialDialog(region: region),
        );
      }
      if (!completer.isCompleted) completer.complete();
    }

    await completer.future;
    onComplete();
  }

  /// Show Rewarded Ad: attempts real AdMob Rewarded Video first, falls back gracefully
  Future<bool> showRewardedAd(BuildContext context, {SupportedRegion? region}) async {
    final completer = Completer<bool>();
    bool rewardEarned = false;

    try {
      await RewardedAd.load(
        adUnitId: AdConstants.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                if (!completer.isCompleted) completer.complete(rewardEarned);
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                if (!completer.isCompleted) completer.complete(false);
              },
            );
            ad.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                rewardEarned = true;
              },
            );
          },
          onAdFailedToLoad: (error) async {
            debugPrint('[AdManager] RewardedAd failed to load: $error. Falling back to dialog.');
            if (context.mounted) {
              final result = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => _SimulatedRewardedDialog(region: region),
              );
              if (!completer.isCompleted) completer.complete(result ?? false);
            } else {
              if (!completer.isCompleted) completer.complete(false);
            }
          },
        ),
      );
    } catch (e) {
      debugPrint('[AdManager] RewardedAd load error: $e');
      if (context.mounted) {
        final result = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => _SimulatedRewardedDialog(region: region),
        );
        if (!completer.isCompleted) completer.complete(result ?? false);
      } else {
        if (!completer.isCompleted) completer.complete(false);
      }
    }

    return await completer.future;
  }
}

class _SimulatedInterstitialDialog extends StatefulWidget {
  final SupportedRegion? region;
  const _SimulatedInterstitialDialog({this.region});

  @override
  State<_SimulatedInterstitialDialog> createState() => _SimulatedInterstitialDialogState();
}

class _SimulatedInterstitialDialogState extends State<_SimulatedInterstitialDialog> {
  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getCloseText() {
    final lang = widget.region?.languageCode ?? 'en';
    switch (lang) {
      case 'ko':
        return '닫기 $_countdown초';
      case 'ja':
        return '閉じる $_countdown秒';
      case 'de':
        return 'Schließen in ${_countdown}s';
      case 'fr':
        return 'Fermer dans ${_countdown}s';
      case 'es':
        return 'Cerrar en ${_countdown}s';
      case 'it':
        return 'Chiudi tra ${_countdown}s';
      default:
        return 'Close in ${_countdown}s';
    }
  }

  String _getTitle() {
    final lang = widget.region?.languageCode ?? 'en';
    switch (lang) {
      case 'ko':
        return 'FortuneMatch VIP 라운지';
      case 'ja':
        return 'FortuneMatch VIP ラウンジ';
      case 'de':
        return 'FortuneMatch VIP Lounge';
      case 'fr':
        return 'FortuneMatch Salon VIP';
      case 'es':
        return 'FortuneMatch Sala VIP';
      case 'it':
        return 'FortuneMatch Lounge VIP';
      default:
        return 'FortuneMatch VIP Lounge';
    }
  }

  String _getSubtitle() {
    final lang = widget.region?.languageCode ?? 'en';
    switch (lang) {
      case 'ko':
        return '프리미엄 혜택: 광고 없는 완전한 몰입과\n무제한 친구 프로필 궁합 열람';
      case 'ja':
        return 'プレミアム特典: 広告のない快適な体験と\n制限なしのプロファイル相性閲覧';
      case 'de':
        return 'Premium-Vorteile: Werbefreies Erlebnis &\nunbegrenzte Profil-Kompatibilität';
      case 'fr':
        return 'Avantages Premium: Expérience sans publicité &\nanalyses de compatibilité illimitées';
      case 'es':
        return 'Beneficios Premium: Sin anuncios &\nlecturas de compatibilidad ilimitadas';
      case 'it':
        return 'Vantaggi Premium: Esperienza senza pubblicità &\nletture di compatibilità illimitate';
      default:
        return 'Premium Benefits: Ad-free experience &\nunlimited friend compatibility readings';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1224),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5C07B).withValues(alpha: 0.5), width: 1.5),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('AD SPONSOR', style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  Text(_getCloseText(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 20),
              const Icon(Icons.auto_awesome, color: Color(0xFFE5C07B), size: 40),
              const SizedBox(height: 14),
              Text(
                _getTitle(),
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _getSubtitle(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimulatedRewardedDialog extends StatefulWidget {
  final SupportedRegion? region;
  const _SimulatedRewardedDialog({this.region});

  @override
  State<_SimulatedRewardedDialog> createState() => _SimulatedRewardedDialogState();
}

class _SimulatedRewardedDialogState extends State<_SimulatedRewardedDialog> {
  int _secondsLeft = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getTitle() {
    final lang = widget.region?.languageCode ?? 'en';
    switch (lang) {
      case 'ko':
        return '무료 복채(하트) 충전소';
      case 'ja':
        return '無料ハートチャージ';
      case 'de':
        return 'Kostenlose Herzen-Ladestation';
      case 'fr':
        return 'Recharge de Cœurs Gratuite';
      case 'es':
        return 'Estación de Corazones Gratis';
      case 'it':
        return 'Ricarica Cuori Gratuita';
      default:
        return 'Free Heart Station';
    }
  }

  String _getSubtitle() {
    final lang = widget.region?.languageCode ?? 'en';
    switch (lang) {
      case 'ko':
        return '영상을 끝까지 시청하시면 하트 2개가 즉시 지급됩니다.';
      case 'ja':
        return '動画を最後まで視聴するとハート2個が即座に付与されます。';
      case 'de':
        return 'Sieh das Video bis zum Ende an, um sofort 2 Herzen zu erhalten.';
      case 'fr':
        return 'Regardez la vidéo jusqu’à la fin pour recevoir instantanément 2 cœurs.';
      case 'es':
        return 'Mira el video completo para recibir 2 corazones al instante.';
      case 'it':
        return 'Guarda l’intero video per ricevere subito 2 cuori.';
      default:
        return 'Watch the full video to receive 2 Hearts instantly.';
    }
  }

  String _getRewardCountdownText() {
    final lang = widget.region?.languageCode ?? 'en';
    switch (lang) {
      case 'ko':
        return '리워드 획득까지: $_secondsLeft초';
      case 'ja':
        return 'リワード獲得まで: $_secondsLeft秒';
      case 'de':
        return 'Belohnung in: ${_secondsLeft}s';
      case 'fr':
        return 'Récompense dans: ${_secondsLeft}s';
      case 'es':
        return 'Recompensa en: ${_secondsLeft}s';
      case 'it':
        return 'Ricompensa tra: ${_secondsLeft}s';
      default:
        return 'Reward in: ${_secondsLeft}s';
    }
  }

  String _getClaimButtonText() {
    final lang = widget.region?.languageCode ?? 'en';
    switch (lang) {
      case 'ko':
        return '하트 2개 받기';
      case 'ja':
        return 'ハート2個を受け取る';
      case 'de':
        return '2 Herzen erhalten';
      case 'fr':
        return 'Réclamer 2 Cœurs';
      case 'es':
        return 'Reclamar 2 Corazones';
      case 'it':
        return 'Riscatta 2 Cuori';
      default:
        return 'Claim 2 Hearts';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1224),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.6), width: 1.5),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, color: Colors.pinkAccent, size: 44),
              const SizedBox(height: 14),
              Text(
                _getTitle(),
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _getSubtitle(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 13),
              ),
              const SizedBox(height: 20),
              if (_secondsLeft > 0)
                Text(_getRewardCountdownText(), style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold))
              else
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5C07B),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.check_circle),
                  label: Text(_getClaimButtonText(), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

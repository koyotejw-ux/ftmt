import 'dart:async';
import 'package:flutter/material.dart';

class AdManager {
  static final AdManager instance = AdManager._();
  AdManager._();

  DateTime? _lastInterstitialShownTime;
  static const Duration _interstitialCooldown = Duration(minutes: 3);

  /// Check if interstitial ad is ready under 3-minute cooldown policy
  bool canShowInterstitial(bool isNoAds) {
    if (isNoAds) return false;
    if (_lastInterstitialShownTime == null) return true;
    return DateTime.now().difference(_lastInterstitialShownTime!) >= _interstitialCooldown;
  }

  /// Trigger simulated interstitial ad modal
  Future<void> showInterstitialAd(BuildContext context, {required VoidCallback onComplete, required bool isNoAds}) async {
    if (isNoAds || !canShowInterstitial(isNoAds)) {
      onComplete();
      return;
    }

    _lastInterstitialShownTime = DateTime.now();

    // Show high-end interstitial transition dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _SimulatedInterstitialDialog(),
    );

    onComplete();
  }

  /// Show Rewarded Ad simulation for +2 hearts
  Future<bool> showRewardedAd(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _SimulatedRewardedDialog(),
    );
    return result ?? false;
  }
}

class _SimulatedInterstitialDialog extends StatefulWidget {
  const _SimulatedInterstitialDialog();

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
                Text('닫기 $_countdown초', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 24),
            const Icon(Icons.auto_awesome, color: Color(0xFFE5C07B), size: 48),
            const SizedBox(height: 16),
            const Text(
              'FortuneMatch VIP 라운지',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '프리미엄 혜택: 광고 없는 완전한 몰입과\n무제한 친구 프로필 궁합 열람',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9AA7C7), fontSize: 13),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SimulatedRewardedDialog extends StatefulWidget {
  const _SimulatedRewardedDialog();

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite, color: Colors.pinkAccent, size: 48),
            const SizedBox(height: 16),
            const Text(
              '무료 복채(하트) 충전소',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '영상을 끝까지 시청하시면 하트 2개가 즉시 지급됩니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9AA7C7), fontSize: 13),
            ),
            const SizedBox(height: 24),
            if (_secondsLeft > 0)
              Text('리워드 획득까지: $_secondsLeft초', style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold))
            else
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5C07B),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.check_circle),
                label: const Text('하트 2개 받기', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}

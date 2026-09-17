import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class HeartWalletRepository {
  static const String _keyHearts = 'fm_heart_balance';
  static const String _keyLastFreeClaim = 'fm_last_free_claim_date';
  static const String _keyVipMasterPass = 'fm_vip_master_pass';
  static const String _keyNoAdsLifetime = 'fm_no_ads_lifetime';

  final SharedPreferences _prefs;
  final _heartStreamController = StreamController<int>.broadcast();

  HeartWalletRepository(this._prefs);

  static Future<HeartWalletRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    // Default initial hearts: 3
    if (!prefs.containsKey(_keyHearts)) {
      await prefs.setInt(_keyHearts, 3);
    }
    return HeartWalletRepository(prefs);
  }

  int get hearts => _prefs.getInt(_keyHearts) ?? 3;
  bool get hasVipPass => _prefs.getBool(_keyVipMasterPass) ?? false;
  bool get hasNoAds => _prefs.getBool(_keyNoAdsLifetime) ?? false;

  Stream<int> get heartStream => _heartStreamController.stream;

  /// Check if user has free daily reading left today
  bool canClaimDailyFree() {
    final lastClaim = _prefs.getString(_keyLastFreeClaim);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return lastClaim != today;
  }

  /// Mark daily free reading as used
  Future<void> consumeDailyFree() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await _prefs.setString(_keyLastFreeClaim, today);
  }

  /// Spend 1 heart for deep fortune/match report. Free if VIP.
  Future<bool> consumeHeart() async {
    if (hasVipPass) return true;

    final current = hearts;
    if (current > 0) {
      final updated = current - 1;
      await _prefs.setInt(_keyHearts, updated);
      _heartStreamController.add(updated);
      return true;
    }
    return false;
  }

  /// Add hearts from rewards (e.g. +2 hearts for Rewarded Ad) or IAP pack (+10, +30)
  Future<void> addHearts(int amount) async {
    final updated = hearts + amount;
    await _prefs.setInt(_keyHearts, updated);
    _heartStreamController.add(updated);
  }

  /// Unlock VIP Master Pass (Unlimited reports & no ads)
  Future<void> unlockVipMasterPass() async {
    await _prefs.setBool(_keyVipMasterPass, true);
    await _prefs.setBool(_keyNoAdsLifetime, true);
    _heartStreamController.add(999);
  }

  /// Unlock Lifetime No-Ads
  Future<void> unlockNoAds() async {
    await _prefs.setBool(_keyNoAdsLifetime, true);
  }
}

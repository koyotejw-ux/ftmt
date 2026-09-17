import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fortunematch/core/astronomy/saju_engine.dart';
import 'package:fortunematch/core/astronomy/solar_time_fixer.dart';
import 'package:fortunematch/core/astronomy/ephemeris_math.dart';
import 'package:fortunematch/features/match/domain/sixteen_type_matrix.dart';
import 'package:fortunematch/features/economy/data/heart_wallet_repository.dart';

void main() {
  group('FortuneMatch Core Engine Tests', () {
    test('Solar Time Fixer calculates exact longitude offset', () {
      final seoulOffset = SolarTimeFixer.calculateOffsetMinutes(126.9780, 135.0);
      expect(seoulOffset, -32);

      final tokyoOffset = SolarTimeFixer.calculateOffsetMinutes(139.6917, 135.0);
      expect(tokyoOffset, 19);
    });

    test('Saju Engine calculates Four Pillars and 5 Elements balance', () {
      final testDate = DateTime(1995, 8, 15, 14, 30);
      final pillars = SajuEngine.calculatePillars(testDate);

      expect(pillars.yearPillar.stem.name, isNotEmpty);
      expect(pillars.yearPillar.branch.animal, isNotEmpty);

      final balance = SajuEngine.calculateElementBalance(pillars);
      expect(balance.keys.length, 5);
      final total = balance.values.reduce((a, b) => a + b);
      expect(total, closeTo(1.0, 0.001));
    });

    test('Ephemeris Math derives correct Sun Sign', () {
      final signAries = EphemerisMath.getSunSign(DateTime(2026, 3, 25));
      expect(signAries, WesternZodiac.aries);

      final signLeo = EphemerisMath.getSunSign(DateTime(2026, 8, 15));
      expect(signLeo, WesternZodiac.leo);
    });

    test('16 Personalities chemistry calculation produces dual pairings', () {
      final res = SixteenTypeMatrix.calculateChemistry('ENFP', 'INTJ');
      expect(res.score, 98); // Golden pair
      expect(res.headline.contains('Golden Pair') || res.headline.contains('천생연분'), isTrue);
      expect(res.passion, inInclusiveRange(0, 100));
    });

    test('Heart Wallet Repository lifecycle', () async {
      SharedPreferences.setMockInitialValues({'fm_heart_balance': 3});
      final repo = await HeartWalletRepository.create();

      expect(repo.hearts, 3);
      final consumed = await repo.consumeHeart();
      expect(consumed, isTrue);
      expect(repo.hearts, 2);

      await repo.addHearts(2);
      expect(repo.hearts, 4);

      await repo.unlockVipMasterPass();
      expect(repo.hasVipPass, isTrue);
      expect(repo.hasNoAds, isTrue);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fortunematch/core/astronomy/saju_engine.dart';
import 'package:fortunematch/core/astronomy/solar_time_fixer.dart';
import 'package:fortunematch/core/astronomy/ephemeris_math.dart';
import 'package:fortunematch/core/localization/app_i18n.dart';
import 'package:fortunematch/features/match/domain/sixteen_type_matrix.dart';
import 'package:fortunematch/features/match/domain/match_item_engine.dart';
import 'package:fortunematch/core/localization/geo_detector.dart';
import 'package:fortunematch/core/astronomy/daily_transit_engine.dart';
import 'package:fortunematch/features/profile/data/user_profile_repository.dart';
import 'package:fortunematch/features/economy/data/heart_wallet_repository.dart';
import 'package:fortunematch/features/economy/data/iap_service.dart';
import 'package:fortunematch/features/settings/presentation/settings_screen.dart';

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

    test('Western Zodiac Match Calculation and GeoDetector integration', () {
      // 120° Trine match: 양자리(Aries) & 사수자리(Sagittarius)
      final trineRes = MatchItemEngine.calculateMatch(
        menu: MatchSubMenu.westernZodiac,
        itemA: '양자리 (♈ Aries)',
        itemB: '사수자리 (♐ Sagittarius)',
        region: SupportedRegion.korea,
      );
      expect(trineRes.score, 98);
      expect(trineRes.headline.contains('트라인') || trineRes.headline.contains('Trine'), isTrue);

      // Same sign match: 사자자리 & 사자자리
      final sameRes = MatchItemEngine.calculateMatch(
        menu: MatchSubMenu.westernZodiac,
        itemA: '사자자리 (♌ Leo)',
        itemB: '사자자리 (♌ Leo)',
        region: SupportedRegion.korea,
      );
      expect(sameRes.score, 92);

      // Ensure westernZodiac is included in all regional menus
      for (final region in SupportedRegion.values) {
        final menus = GeoDetector.getMatchMenus(region);
        expect(menus.contains(MatchSubMenu.westernZodiac), isTrue);
      }
    });

    test('Daily Transit Engine generates dynamic transit, golden hours, and aspects', () {
      final userBirthDate = DateTime(1990, 5, 20, 9, 30);
      final todayDate = DateTime(2026, 10, 25);
      final transit = DailyTransitEngine.calculateDailyTransit(
        birthDate: userBirthDate,
        today: todayDate,
        region: SupportedRegion.korea,
      );

      expect(transit.todayDayPillar.ganji, isNotEmpty);
      expect(transit.goldenHours, isNotEmpty);
      expect(transit.sajuTenGodRelation, isNotEmpty);
      expect(transit.zodiacAspectTitle, isNotEmpty);
      expect(transit.animalDailyNarrative, isNotEmpty);
      expect(transit.personalDayNumber, inInclusiveRange(1, 9));

      // Test a different day produces different transit values
      final nextDayTransit = DailyTransitEngine.calculateDailyTransit(
        birthDate: userBirthDate,
        today: DateTime(2026, 10, 26),
        region: SupportedRegion.korea,
      );
      expect(nextDayTransit.todayDayPillar.ganji != transit.todayDayPillar.ganji, isTrue);
    });

    test('User Profile Repository has no dummy contacts and provides clean vault storage', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = await UserProfileRepository.create();

      expect(repo.hasProfile, isFalse);
      expect(repo.getSavedVaultProfiles().isEmpty, isTrue);

      final newContact = UserProfile(
        name: '홍길동',
        birthDateTime: DateTime(1992, 3, 1, 8, 30),
        city: '서울특별시',
        mbti: 'INTJ',
        bloodType: 'A',
      );
      await repo.addVaultProfile(newContact);
      expect(repo.getSavedVaultProfiles().length, 1);
      expect(repo.getSavedVaultProfiles().first.name, '홍길동');

      await repo.deleteVaultProfile(0);
      expect(repo.getSavedVaultProfiles().isEmpty, isTrue);
    });

    test('I18n includes localized IAP restore and privacy policy keys for all regions', () {
      const requiredKeys = [
        'restore_purchases',
        'restore_purchases_snack',
        'iap_unavailable_snack',
        'vip_activated_snack',
        'view_privacy_policy',
        'close_btn',
      ];
      for (final region in SupportedRegion.values) {
        for (final key in requiredKeys) {
          final translated = AppI18n.tr(key, region);
          expect(translated, isNotEmpty);
          expect(translated, isNot(equals(key)));
        }
      }
    });

    test('IapService returns fallback display price when Play Store catalog is not loaded', () {
      final fallback = IapService.instance.getDisplayPrice(
        IapProductCatalog.heartPack10,
        '₩ 1.5K (\$0.99)',
      );
      expect(fallback, '₩ 1.5K (\$0.99)');
    });

    testWidgets('SettingsScreen persists toggles and opens privacy policy dialog', (tester) async {
      SharedPreferences.setMockInitialValues({
        'fm_setting_true_solar': false,
        'fm_setting_haptic': true,
        'fm_setting_ambient_sound': true,
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsScreen(
              currentRegion: SupportedRegion.korea,
              onRegionChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final switches = tester.widgetList<SwitchListTile>(find.byType(SwitchListTile)).toList();
      expect(switches.length, 3);
      expect(switches[0].value, isFalse);
      expect(switches[1].value, isTrue);

      await tester.tap(find.byType(SwitchListTile).at(1));
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('fm_setting_haptic'), isFalse);

      await tester.ensureVisible(find.text(AppI18n.tr('view_privacy_policy', SupportedRegion.korea)));
      await tester.tap(find.text(AppI18n.tr('view_privacy_policy', SupportedRegion.korea)));
      await tester.pumpAndSettle();

      expect(find.text(AppI18n.tr('vault_legal_title', SupportedRegion.korea)), findsOneWidget);
      await tester.tap(find.text(AppI18n.tr('close_btn', SupportedRegion.korea)));
      await tester.pumpAndSettle();
      expect(find.text(AppI18n.tr('vault_legal_title', SupportedRegion.korea)), findsNothing);
    });
  });
}

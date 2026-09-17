import 'dart:ui';

enum SupportedRegion {
  korea('ko_KR', '대한민국', 'KR', '₩'),
  unitedStates('en_US', 'United States', 'US', '\$'),
  japan('ja_JP', '日本', 'JP', '¥'),
  europe('fr_FR', 'Europe / Global', 'EU', '€');

  final String code;
  final String label;
  final String countryCode;
  final String currencySymbol;

  const SupportedRegion(this.code, this.label, this.countryCode, this.currencySymbol);
}

class GeoDetector {
  static SupportedRegion detectRegion([Locale? locale]) {
    final systemLocale = locale ?? PlatformDispatcher.instance.locale;
    final lang = systemLocale.languageCode.toLowerCase();
    final country = systemLocale.countryCode?.toUpperCase() ?? '';

    if (lang == 'ko' || country == 'KR') {
      return SupportedRegion.korea;
    } else if (lang == 'ja' || country == 'JP') {
      return SupportedRegion.japan;
    } else if (lang == 'fr' || lang == 'de' || lang == 'it' || lang == 'es' || country == 'FR' || country == 'DE' || country == 'GB') {
      return SupportedRegion.europe;
    } else {
      return SupportedRegion.unitedStates;
    }
  }

  // Returns ordered fortune sub-menu keys according to region
  static List<FortuneSubMenu> getFortuneMenus(SupportedRegion region) {
    switch (region) {
      case SupportedRegion.korea:
        return [
          FortuneSubMenu.saju,
          FortuneSubMenu.dailyZodiacAnimal,
          FortuneSubMenu.tarot,
          FortuneSubMenu.tojeong,
        ];
      case SupportedRegion.unitedStates:
        return [
          FortuneSubMenu.natalChart,
          FortuneSubMenu.threeCardTarot,
          FortuneSubMenu.dailyHoroscope,
          FortuneSubMenu.numerology,
        ];
      case SupportedRegion.japan:
        return [
          FortuneSubMenu.kigaku,
          FortuneSubMenu.rokusei,
          FortuneSubMenu.bloodTypeTarot,
          FortuneSubMenu.dailyHoroscope,
        ];
      case SupportedRegion.europe:
        return [
          FortuneSubMenu.celticRunes,
          FortuneSubMenu.tarotMarseille,
          FortuneSubMenu.dailyHoroscope,
          FortuneSubMenu.numerology,
        ];
    }
  }

  // Returns ordered match sub-menu keys according to region
  static List<MatchSubMenu> getMatchMenus(SupportedRegion region) {
    switch (region) {
      case SupportedRegion.korea:
        return [
          MatchSubMenu.sixteenType,
          MatchSubMenu.sajuIlju,
          MatchSubMenu.bloodType,
        ];
      case SupportedRegion.unitedStates:
        return [
          MatchSubMenu.zodiacElement,
          MatchSubMenu.sixteenType,
          MatchSubMenu.numerologyLifePath,
        ];
      case SupportedRegion.japan:
        return [
          MatchSubMenu.bloodZodiacHybrid,
          MatchSubMenu.sixteenType,
          MatchSubMenu.rokuseiMatch,
        ];
      case SupportedRegion.europe:
        return [
          MatchSubMenu.zodiacHouse,
          MatchSubMenu.numerologyLifePath,
          MatchSubMenu.celticRuneMatch,
        ];
    }
  }
}

enum FortuneSubMenu {
  saju('정통 사주 (만세력)', 'Traditional Four Pillars (Bazi)', '四柱推命 (万年暦)', 'Bazi / Four Pillars'),
  dailyZodiacAnimal('오늘의 띠별 운세', 'Eastern Daily Zodiac', '今日の干支占い', 'Eastern Daily Zodiac'),
  tarot('신비의 타로 (3-Card)', 'Mystic 3-Card Tarot', '神秘のタロット (3枚引き)', 'Mystic Tarot'),
  tojeong('신년 토정비결', 'Secret of Tojeong', '新年の秘伝', 'Tojeong Almanac'),
  natalChart('서양 점성술 (Natal Chart)', 'Western Natal Chart', '西洋占星術 (出生図)', 'Western Natal Chart'),
  threeCardTarot('3-Card 심층 타로', '3-Card Deep Tarot', '3枚引きタロット', '3-Card Tarot'),
  dailyHoroscope('일일 호로스코프', 'Daily Horoscope', 'デイリーホロスコープ', 'Daily Horoscope'),
  numerology('수비학 운명수 (Life Path)', 'Numerology Life Path', '数秘術 (運命数)', 'Numerology Life Path'),
  kigaku('구성기학 (九星気学)', 'Nine Star Ki (Kigaku)', '九星気学 (本命星)', 'Nine Star Ki'),
  rokusei('롯세이센주츠 (六星占術)', 'Six Stars Astrology', '六星占術 (運命星)', 'Six Stars Astrology'),
  bloodTypeTarot('혈액형 & 타로', 'Blood Type x Tarot', '血液型 x タロット', 'Blood Type x Tarot'),
  celticRunes('켈틱 룬 (Celtic Runes)', 'Celtic Rune Oracle', 'ケルト ルーン占い', 'Celtic Runes'),
  tarotMarseille('마르세유 정통 타로', 'Tarot of Marseille', 'マルセイユ版タロット', 'Tarot of Marseille');

  final String ko;
  final String en;
  final String ja;
  final String fr;

  const FortuneSubMenu(this.ko, this.en, this.ja, this.fr);

  String localizedTitle(SupportedRegion region) {
    switch (region) {
      case SupportedRegion.korea:
        return ko;
      case SupportedRegion.unitedStates:
        return en;
      case SupportedRegion.japan:
        return ja;
      case SupportedRegion.europe:
        return fr;
    }
  }
}

enum MatchSubMenu {
  sixteenType('16 성격유형 (MBTI) 케미', '16 Personalities Chemistry', '16タイプ性格相性 (MBTI)', '16 Personalities Match'),
  sajuIlju('사주 일주(日柱) 합·충 궁합', 'Bazi Day Pillar Harmony', '日柱の相性と引き寄せ', 'Bazi Pillar Harmony'),
  bloodType('혈액형 감성 궁합', 'Blood Type Chemistry', '血液型の惹かれ合い', 'Blood Type Chemistry'),
  zodiacElement('12별자리 4대 원소 궁합', '12 Zodiac Element Match', '12星座エレメント相性', '12 Zodiac Elements'),
  numerologyLifePath('수비학 운명수 조화도', 'Numerology Life Path Chem', '運命数の調和と共鳴', 'Numerology Harmony'),
  bloodZodiacHybrid('혈액형 x 별자리 복합 궁합', 'Blood Type x Zodiac Hybrid', '血液型 x 星座 複合相性', 'Blood x Zodiac Hybrid'),
  rokuseiMatch('롯세이센주츠 운명 궁합', 'Six Stars Fate Match', '六星占術の相性運', 'Six Stars Fate Match'),
  zodiacHouse('별자리 하우스 궁합', 'Synastry House Match', 'シナストリー相性', 'Synastry House Match'),
  celticRuneMatch('룬스톤 커플 점괘', 'Celtic Rune Dual Reading', 'ルーンストーン相性', 'Celtic Rune Match');

  final String ko;
  final String en;
  final String ja;
  final String fr;

  const MatchSubMenu(this.ko, this.en, this.ja, this.fr);

  String localizedTitle(SupportedRegion region) {
    switch (region) {
      case SupportedRegion.korea:
        return ko;
      case SupportedRegion.unitedStates:
        return en;
      case SupportedRegion.japan:
        return ja;
      case SupportedRegion.europe:
        return fr;
    }
  }
}

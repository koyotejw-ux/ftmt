import 'dart:ui';

enum SupportedRegion {
  unitedStates('en_US', 'Global (English)', 'GL', '\$'),
  korea('ko_KR', '대한민국 (한국어)', 'KR', '₩'),
  japan('ja_JP', '日本 (日本語)', 'JP', '¥'),
  unitedKingdom('en_GB', 'United Kingdom (English)', 'GB', '£'),
  germany('de_DE', 'Deutschland (Deutsch)', 'DE', '€'),
  france('fr_FR', 'France (Français)', 'FR', '€'),
  spain('es_ES', 'España (Español)', 'ES', '€'),
  italy('it_IT', 'Italia (Italiano)', 'IT', '€');

  final String code;
  final String label;
  final String countryCode;
  final String currencySymbol;

  const SupportedRegion(this.code, this.label, this.countryCode, this.currencySymbol);

  String get languageCode => code.split('_').first;
  bool get isKorean => this == SupportedRegion.korea;
  bool get isJapanese => this == SupportedRegion.japan;
  bool get isEnglish => languageCode == 'en';
  bool get isGerman => languageCode == 'de';
  bool get isFrench => languageCode == 'fr';
  bool get isSpanish => languageCode == 'es';
  bool get isItalian => languageCode == 'it';

  String get flagEmoji {
    switch (this) {
      case unitedStates: return '🌐';
      case korea: return '🇰🇷';
      case japan: return '🇯🇵';
      case unitedKingdom: return '🇬🇧';
      case germany: return '🇩🇪';
      case france: return '🇫🇷';
      case spain: return '🇪🇸';
      case italy: return '🇮🇹';
    }
  }

  static List<SupportedRegion> get selectableRegions => [
    unitedStates,
    korea,
    japan,
    unitedKingdom,
    germany,
    france,
    spain,
    italy,
  ];
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
    } else if (lang == 'de' || country == 'DE' || country == 'AT' || country == 'CH') {
      return SupportedRegion.germany;
    } else if (lang == 'fr' || country == 'FR' || country == 'BE') {
      return SupportedRegion.france;
    } else if (lang == 'es' || country == 'ES' || country == 'MX' || country == 'AR') {
      return SupportedRegion.spain;
    } else if (lang == 'it' || country == 'IT') {
      return SupportedRegion.italy;
    } else if (country == 'GB') {
      return SupportedRegion.unitedKingdom;
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
      case SupportedRegion.japan:
        return [
          FortuneSubMenu.kigaku,
          FortuneSubMenu.rokusei,
          FortuneSubMenu.bloodTypeTarot,
          FortuneSubMenu.dailyHoroscope,
        ];
      case SupportedRegion.unitedKingdom:
      case SupportedRegion.unitedStates:
        return [
          FortuneSubMenu.natalChart,
          FortuneSubMenu.threeCardTarot,
          FortuneSubMenu.dailyHoroscope,
          FortuneSubMenu.numerology,
        ];
      case SupportedRegion.germany:
      case SupportedRegion.france:
      case SupportedRegion.spain:
      case SupportedRegion.italy:
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
          MatchSubMenu.sajuIlju,
          MatchSubMenu.zodiacAnimal,
          MatchSubMenu.westernZodiac,
          MatchSubMenu.bloodType,
          MatchSubMenu.sixteenType,
        ];
      case SupportedRegion.japan:
        return [
          MatchSubMenu.westernZodiac,
          MatchSubMenu.bloodZodiacHybrid,
          MatchSubMenu.sixteenType,
          MatchSubMenu.rokuseiMatch,
        ];
      case SupportedRegion.unitedKingdom:
      case SupportedRegion.unitedStates:
        return [
          MatchSubMenu.westernZodiac,
          MatchSubMenu.zodiacElement,
          MatchSubMenu.sixteenType,
          MatchSubMenu.numerologyLifePath,
        ];
      case SupportedRegion.germany:
      case SupportedRegion.france:
      case SupportedRegion.spain:
      case SupportedRegion.italy:
        return [
          MatchSubMenu.westernZodiac,
          MatchSubMenu.zodiacHouse,
          MatchSubMenu.numerologyLifePath,
          MatchSubMenu.celticRuneMatch,
        ];
    }
  }
}

enum FortuneSubMenu {
  saju(
    ko: '정통 사주 (만세력)',
    en: 'Traditional Four Pillars (Bazi)',
    ja: '四柱推命 (万年暦)',
    de: 'Traditionelle Vier Säulen (Bazi)',
    fr: 'Bazi / Quatre Piliers Traditionnels',
    es: 'Cuatro Pilares Tradicionales (Bazi)',
    it: 'Quattro Pilastri Tradizionali (Bazi)',
  ),
  dailyZodiacAnimal(
    ko: '오늘의 띠별 운세',
    en: 'Eastern Daily Zodiac',
    ja: '今日の干支占い',
    de: 'Tägliches Östliches Horoskop',
    fr: 'Zodiaque Quotidien Oriental',
    es: 'Zodiaco Diario Oriental',
    it: 'Zodiaco Giornaliero Orientale',
  ),
  tarot(
    ko: '신비의 타로 (3-Card)',
    en: 'Mystic 3-Card Tarot',
    ja: '神秘のタロット (3枚引き)',
    de: 'Mystisches 3-Karten-Tarot',
    fr: 'Tarot Mystique à 3 Cartes',
    es: 'Tarot Místico de 3 Cartas',
    it: 'Tarocchi Mistici a 3 Carte',
  ),
  tojeong(
    ko: '신년 토정비결',
    en: 'Secret of Tojeong',
    ja: '新年の秘伝',
    de: 'Geheimnis des Tojeong',
    fr: 'Almanach Secret de Tojeong',
    es: 'Secretos del Tojeong',
    it: 'Segreto del Tojeong',
  ),
  natalChart(
    ko: '서양 점성술 (Natal Chart)',
    en: 'Western Natal Chart',
    ja: '西洋占星術 (出生図)',
    de: 'Westliches Geburtshoroskop',
    fr: 'Thème Astral Occidental',
    es: 'Carta Natal Occidental',
    it: 'Tema Natale Occidentale',
  ),
  threeCardTarot(
    ko: '3-Card 심층 타로',
    en: '3-Card Deep Tarot',
    ja: '3枚引き深層タロット',
    de: '3-Karten Tiefen-Tarot',
    fr: 'Tarot Approfondi à 3 Cartes',
    es: 'Tarot Profundo de 3 Cartas',
    it: 'Tarocchi Approfonditi a 3 Carte',
  ),
  dailyHoroscope(
    ko: '일일 호로스코프',
    en: 'Daily Horoscope',
    ja: 'デイリーホロスコープ',
    de: 'Tageshoroskop',
    fr: 'Horoscope du Jour',
    es: 'Horóscopo Diario',
    it: 'Oroscopo Giornaliero',
  ),
  numerology(
    ko: '수비학 운명수 (Life Path)',
    en: 'Numerology Life Path',
    ja: '数秘術 (運命数)',
    de: 'Numerologie Lebenszahl',
    fr: 'Numérologie : Chemin de Vie',
    es: 'Numerología : Camino de Vida',
    it: 'Numerologia : Sentiero di Vita',
  ),
  kigaku(
    ko: '구성기학 (九星気学)',
    en: 'Nine Star Ki (Kigaku)',
    ja: '九星気学 (本命星)',
    de: 'Neun-Sterne-Ki (Kigaku)',
    fr: 'Ki des 9 Étoiles (Kigaku)',
    es: 'Ki de las 9 Estrellas (Kigaku)',
    it: 'Ki delle 9 Stelle (Kigaku)',
  ),
  rokusei(
    ko: '롯세이센주츠 (六星占術)',
    en: 'Six Stars Astrology',
    ja: '六星占術 (運命星)',
    de: 'Sechs-Sterne-Astrologie',
    fr: 'Astrologie des Six Étoiles',
    es: 'Astrología de las Seis Estrellas',
    it: 'Astrologia delle Sei Stelle',
  ),
  bloodTypeTarot(
    ko: '혈액형 & 타로',
    en: 'Blood Type x Tarot',
    ja: '血液型 x タロット',
    de: 'Blutgruppe x Tarot',
    fr: 'Groupe Sanguin x Tarot',
    es: 'Grupo Sanguíneo x Tarot',
    it: 'Gruppo Sanguigno x Tarocchi',
  ),
  celticRunes(
    ko: '켈틱 룬 (Celtic Runes)',
    en: 'Celtic Rune Oracle',
    ja: 'ケルト ルーン占い',
    de: 'Keltisches Runenorakel',
    fr: 'Oracle des Runes Celtiques',
    es: 'Oráculo de Runas Celtas',
    it: 'Oracolo delle Rune Celtiche',
  ),
  tarotMarseille(
    ko: '마르세유 정통 타로',
    en: 'Tarot of Marseille',
    ja: 'マルセイユ版タロット',
    de: 'Tarot von Marseille',
    fr: 'Tarot de Marseille Authentique',
    es: 'Tarot de Marsella Tradicional',
    it: 'Tarocchi di Marsiglia',
  );

  final String ko;
  final String en;
  final String ja;
  final String de;
  final String fr;
  final String es;
  final String it;

  const FortuneSubMenu({
    required this.ko,
    required this.en,
    required this.ja,
    required this.de,
    required this.fr,
    required this.es,
    required this.it,
  });

  String localizedTitle(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko':
        return ko;
      case 'ja':
        return ja;
      case 'de':
        return de;
      case 'fr':
        return fr;
      case 'es':
        return es;
      case 'it':
        return it;
      default:
        return en;
    }
  }
}

enum MatchSubMenu {
  westernZodiac(
    ko: '12별자리 (Zodiac) 케미',
    en: '12 Zodiac Signs Chemistry',
    ja: '12星座の相性・惹かれ合い',
    de: '12 Tierkreiszeichen Harmonie',
    fr: 'Chimie des 12 Signes du Zodiaque',
    es: 'Química de los 12 Signos Zodiacales',
    it: 'Affinità dei 12 Segni Zodiacali',
  ),
  sixteenType(
    ko: '16 성격유형 (MBTI) 케미',
    en: '16 Personalities Chemistry',
    ja: '16タイプ性格相性 (MBTI)',
    de: '16 Persönlichkeiten Harmonie',
    fr: 'Chimie des 16 Personnalités',
    es: 'Compatibilidad 16 Personalidades',
    it: 'Affinità delle 16 Personalità',
  ),
  sajuIlju(
    ko: '사주 일주(日柱) 합·충 궁합',
    en: 'Bazi Day Pillar Harmony',
    ja: '日柱の相性と引き寄せ',
    de: 'Bazi Tagespfeiler Harmonie',
    fr: 'Harmonie des Piliers Bazi',
    es: 'Armonía de Pilares Bazi',
    it: 'Armonia dei Pilastri Bazi',
  ),
  zodiacAnimal(
    ko: '전통 12간지 띠 궁합',
    en: '12 Eastern Zodiac Animal Match',
    ja: '十二支・生まれ年相性',
    de: 'Östliche Tierkreis-Harmonie',
    fr: 'Harmonie du Zodiaque Oriental',
    es: 'Afinidad Zodiacal Oriental',
    it: 'Affinità Zodiacale Orientale',
  ),
  bloodType(
    ko: '혈액형 감성 궁합',
    en: 'Blood Type Chemistry',
    ja: '血液型の惹かれ合い',
    de: 'Blutgruppen-Harmonie',
    fr: 'Alchimie des Groupes Sanguins',
    es: 'Química de Grupos Sanguíneos',
    it: 'Affinità dei Gruppi Sanguigni',
  ),
  zodiacElement(
    ko: '12별자리 4대 원소 궁합',
    en: '12 Zodiac Element Match',
    ja: '12星座エレメント相性',
    de: '4 Tierkreiselemente Harmonie',
    fr: 'Harmonie des 4 Éléments Célestes',
    es: 'Afinidad de los 4 Elementos',
    it: 'Armonia dei 4 Elementi Zodiacali',
  ),
  numerologyLifePath(
    ko: '수비학 운명수 조화도',
    en: 'Numerology Life Path Chem',
    ja: '運命数の調和と共鳴',
    de: 'Numerologie Lebensweg Resonanz',
    fr: 'Harmonie du Chemin de Vie',
    es: 'Resonancia del Camino de Vida',
    it: 'Risonanza del Sentiero di Vita',
  ),
  bloodZodiacHybrid(
    ko: '혈액형 x 별자리 복합 궁합',
    en: 'Blood Type x Zodiac Hybrid',
    ja: '血液型 x 星座 複合相性',
    de: 'Blutgruppe x Tierkreis Hybrid',
    fr: 'Hybride Groupe Sanguin x Zodiaque',
    es: 'Híbrido Grupo Sanguíneo x Signo',
    it: 'Ibrido Gruppo Sanguigno x Segno',
  ),
  rokuseiMatch(
    ko: '롯세이센주츠 운명 궁합',
    en: 'Six Stars Fate Match',
    ja: '六星占術の相性運',
    de: 'Sechs-Sterne Schicksalsharmonie',
    fr: 'Affinité Fatidique des 6 Étoiles',
    es: 'Compatibilidad de las Seis Estrellas',
    it: 'Affinità Fatidica delle Sei Stelle',
  ),
  zodiacHouse(
    ko: '별자리 하우스 궁합',
    en: 'Synastry House Match',
    ja: 'シナストリーハウス相性',
    de: 'Synastrie-Häuser Harmonie',
    fr: 'Maisons Astrologiques Synastriques',
    es: 'Casas Astrológicas en Sinastría',
    it: 'Case Astrologiche in Sinastria',
  ),
  celticRuneMatch(
    ko: '룬스톤 커플 점괘',
    en: 'Celtic Rune Dual Reading',
    ja: 'ルーンストーン相性',
    de: 'Keltische Runen-Paarlesung',
    fr: 'Lecture Duo des Runes Celtiques',
    es: 'Lectura Dual de Runas Celtas',
    it: 'Lettura di Coppia delle Rune Celtiche',
  );

  final String ko;
  final String en;
  final String ja;
  final String de;
  final String fr;
  final String es;
  final String it;

  const MatchSubMenu({
    required this.ko,
    required this.en,
    required this.ja,
    required this.de,
    required this.fr,
    required this.es,
    required this.it,
  });

  String localizedTitle(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko':
        return ko;
      case 'ja':
        return ja;
      case 'de':
        return de;
      case 'fr':
        return fr;
      case 'es':
        return es;
      case 'it':
        return it;
      default:
        return en;
    }
  }
}

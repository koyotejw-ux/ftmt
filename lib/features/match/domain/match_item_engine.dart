import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import 'sixteen_type_matrix.dart';

class MatchItemEngine {
  // 1. Korea: Saju Ilju (60 甲子 일주)
  static const List<String> sajuPillars = [
    '갑자(甲子)', '을축(乙丑)', '병인(丙寅)', '정묘(丁卯)', '무진(戊辰)',
    '기사(己巳)', '경오(庚午)', '신미(辛未)', '임신(壬申)', '계유(癸酉)',
    '갑술(甲戌)', '을해(乙亥)', '병자(丙子)', '정축(丁丑)', '무인(戊寅)',
    '기묘(己卯)', '경진(庚辰)', '신사(辛巳)', '임오(壬午)', '계미(癸未)',
    '갑신(甲申)', '을유(乙酉)', '병술(丙戌)', '정해(丁亥)', '무자(戊子)',
    '기축(己丑)', '경인(庚寅)', '신묘(辛卯)', '임진(壬辰)', '계사(癸巳)',
  ];

  // 2. Korea: 12 간지 띠 (Zodiac Animals)
  static const List<String> zodiacAnimals = [
    '자(쥐띠 🐭)', '축(소띠 🐮)', '인(호랑이띠 🐯)', '묘(토끼띠 🐰)',
    '진(용띠 🐲)', '사(뱀띠 🐍)', '오(말띠 🐴)', '미(양띠 🐑)',
    '신(원숭이띠 🐵)', '유(닭띠 🐔)', '술(개띠 🐶)', '해(돼지띠 🐷)',
  ];

  // 3. Korea / Japan: Real Blood Types
  static const List<String> bloodTypes = ['A형', 'B형', 'O형', 'AB형'];

  // 4. US: 12 Zodiac 4 Elements
  static const List<String> zodiacElements = [
    'Fire (불/火 - 양/사자/사수)',
    'Earth (흙/土 - 황소/처녀/염소)',
    'Air (바람/風 - 쌍둥이/천칭/물병)',
    'Water (물/水 - 게/전갈/물고기)',
  ];

  // 5. US / Europe: Numerology Life Path Numbers (1~9, Master 11, 22)
  static const List<String> lifePathNumbers = [
    'Life Path 1 (개척자/Leader)',
    'Life Path 2 (조화자/Peacemaker)',
    'Life Path 3 (표현자/Creator)',
    'Life Path 4 (건설자/Builder)',
    'Life Path 5 (모험가/Free Spirit)',
    'Life Path 6 (수호자/Caregiver)',
    'Life Path 7 (탐구자/Philosopher)',
    'Life Path 8 (성취자/Visionary)',
    'Life Path 9 (인도자/Humanitarian)',
    'Master 11 (영적 직관자/Intuitive)',
    'Master 22 (마스터 빌더/Architect)',
  ];

  // 6. Japan: Blood Type x Zodiac Hybrid (血液型 x 星座)
  static const List<String> bloodZodiacHybrids = [
    'A형 x 양자리 (정의로운 열정파)',
    'A형 x 처녀자리 (완벽주의 배려가)',
    'B형 x 사자자리 (매혹적인 무대체질)',
    'B형 x 사수자리 (자유로운 탐험가)',
    'O형 x 황소자리 (신뢰의 든든한 바위)',
    'O형 x 천칭자리 (원만한 사교 챔피언)',
    'AB형 x 쌍둥이자리 (번뜩이는 다재다능)',
    'AB형 x 물병자리 (신비로운 천재성)',
    'A형 x 전갈자리 (깊은 헌신과 집중)',
    'B형 x 물고기자리 (풍부한 감성과 예술)',
    'O형 x 게자리 (따스한 패밀리 리더)',
    'AB형 x 염소자리 (냉철한 전략가)',
  ];

  // 7. Japan: Rokusei (六星占術 運命星)
  static const List<String> rokuseiStars = [
    '수성인 (水星人 - 지혜와 명예)',
    '금성인 (金星人 - 행동력과 사교)',
    '화성인 (火星人 - 예술성과 직관)',
    '목성인 (木星人 - 인내와 대기만성)',
    '천왕성인 (天王星人 - 이상주의와 온화)',
    '토성인 (土星人 - 엄격함과 도덕심)',
  ];

  // 8. Europe: Synastry Houses (별자리 하우스 궁합)
  static const List<String> synastryHouses = [
    '1st House (동일한 자아/자연스러운 교감)',
    '4th House (가정/영혼의 깊은 안식처)',
    '5th House (로맨스와 창조적 열정)',
    '7th House (운명적 동반자/결혼의 집)',
    '8th House (영적 변형/강렬한 마력적 결합)',
    '10th House (사회적 성공/성장 파트너)',
  ];

  // 9. Europe: Celtic Runes (룬스톤 커플 점괘)
  static const List<String> celticRunes = [
    'Fehu ᚠ (풍요와 번영의 결합)',
    'Uruz ᚢ (야생의 활력과 회복력)',
    'Thurisaz ᚦ (수호와 강인한 결의)',
    'Ansuz ᚨ (신성한 지혜와 영적 교류)',
    'Raidho ᚱ (함께 떠나는 운명의 여정)',
    'Kenaz ᚲ (빛나는 통찰과 사랑의 불꽃)',
    'Gebo ᚷ (상호 헌신과 신성한 선물)',
    'Wunjo ᚹ (기쁨과 조화로운 평화)',
  ];

  /// Returns available items for selected menu
  static List<String> getAvailableItems(MatchSubMenu menu) {
    switch (menu) {
      case MatchSubMenu.sixteenType:
        return SixteenTypeMatrix.allTypes;
      case MatchSubMenu.sajuIlju:
        return sajuPillars;
      case MatchSubMenu.zodiacAnimal:
        return zodiacAnimals;
      case MatchSubMenu.bloodType:
        return bloodTypes;
      case MatchSubMenu.zodiacElement:
        return zodiacElements;
      case MatchSubMenu.numerologyLifePath:
        return lifePathNumbers;
      case MatchSubMenu.bloodZodiacHybrid:
        return bloodZodiacHybrids;
      case MatchSubMenu.rokuseiMatch:
        return rokuseiStars;
      case MatchSubMenu.zodiacHouse:
        return synastryHouses;
      case MatchSubMenu.celticRuneMatch:
        return celticRunes;
    }
  }

  /// Get localized short aura label for display inside the glowing orbs
  static String getAuraOrbLabel(MatchSubMenu menu, String value) {
    switch (menu) {
      case MatchSubMenu.sixteenType:
        return value;
      case MatchSubMenu.sajuIlju:
        return value.split('(').first;
      case MatchSubMenu.zodiacAnimal:
        // Extract animal name e.g. "자(쥐띠 🐭)" -> "쥐띠🐭"
        if (value.contains('(') && value.contains(')')) {
          final inside = value.substring(value.indexOf('(') + 1, value.indexOf(')'));
          return inside.replaceAll(' ', '');
        }
        return value;
      case MatchSubMenu.bloodType:
        return value;
      case MatchSubMenu.zodiacElement:
        return value.split(' ').first;
      case MatchSubMenu.numerologyLifePath:
        if (value.startsWith('Life Path ')) {
          return 'Path ${value.split(' ')[2]}';
        } else if (value.startsWith('Master ')) {
          return 'M${value.split(' ')[1]}';
        }
        return value.split(' ').first;
      case MatchSubMenu.bloodZodiacHybrid:
        return value.split(' ')[0];
      case MatchSubMenu.rokuseiMatch:
        return value.split(' ')[0];
      case MatchSubMenu.zodiacHouse:
        return value.split(' ')[0];
      case MatchSubMenu.celticRuneMatch:
        return value.split(' ')[0];
    }
  }

  /// Localized labels for Me and Partner input pickers
  static String getPickerLabelA(MatchSubMenu menu, SupportedRegion region) {
    switch (menu) {
      case MatchSubMenu.sixteenType:
        return AppI18n.tr('my_type', region);
      case MatchSubMenu.sajuIlju:
        return AppI18n.tr('my_pillar_label', region);
      case MatchSubMenu.zodiacAnimal:
        return AppI18n.tr('my_animal_label', region);
      case MatchSubMenu.bloodType:
        return AppI18n.tr('my_blood_label', region);
      case MatchSubMenu.zodiacElement:
        return AppI18n.tr('my_element_label', region);
      case MatchSubMenu.numerologyLifePath:
        return AppI18n.tr('my_lifepath_label', region);
      case MatchSubMenu.bloodZodiacHybrid:
        return AppI18n.tr('my_hybrid_label', region);
      case MatchSubMenu.rokuseiMatch:
        return AppI18n.tr('my_rokusei_label', region);
      case MatchSubMenu.zodiacHouse:
        return AppI18n.tr('my_house_label', region);
      case MatchSubMenu.celticRuneMatch:
        return AppI18n.tr('my_rune_label', region);
    }
  }

  static String getPickerLabelB(MatchSubMenu menu, SupportedRegion region) {
    switch (menu) {
      case MatchSubMenu.sixteenType:
        return AppI18n.tr('partner_type', region);
      case MatchSubMenu.sajuIlju:
        return AppI18n.tr('partner_pillar_label', region);
      case MatchSubMenu.zodiacAnimal:
        return AppI18n.tr('partner_animal_label', region);
      case MatchSubMenu.bloodType:
        return AppI18n.tr('partner_blood_label', region);
      case MatchSubMenu.zodiacElement:
        return AppI18n.tr('partner_element_label', region);
      case MatchSubMenu.numerologyLifePath:
        return AppI18n.tr('partner_lifepath_label', region);
      case MatchSubMenu.bloodZodiacHybrid:
        return AppI18n.tr('partner_hybrid_label', region);
      case MatchSubMenu.rokuseiMatch:
        return AppI18n.tr('partner_rokusei_label', region);
      case MatchSubMenu.zodiacHouse:
        return AppI18n.tr('partner_house_label', region);
      case MatchSubMenu.celticRuneMatch:
        return AppI18n.tr('partner_rune_label', region);
    }
  }

  /// Main calculation method routing to specific system dynamics
  static MatchResult calculateMatch({
    required MatchSubMenu menu,
    required String itemA,
    required String itemB,
    required SupportedRegion region,
  }) {
    switch (menu) {
      case MatchSubMenu.sixteenType:
        return SixteenTypeMatrix.calculateChemistry(itemA, itemB, region: region);

      case MatchSubMenu.sajuIlju:
        return _calculateSajuIlju(itemA, itemB, region);

      case MatchSubMenu.zodiacAnimal:
        return _calculateZodiacAnimal(itemA, itemB, region);

      case MatchSubMenu.bloodType:
        return _calculateBloodType(itemA, itemB, region);

      case MatchSubMenu.zodiacElement:
        return _calculateZodiacElement(itemA, itemB, region);

      case MatchSubMenu.numerologyLifePath:
        return _calculateLifePath(itemA, itemB, region);

      case MatchSubMenu.bloodZodiacHybrid:
        return _calculateBloodZodiacHybrid(itemA, itemB, region);

      case MatchSubMenu.rokuseiMatch:
        return _calculateRokusei(itemA, itemB, region);

      case MatchSubMenu.zodiacHouse:
        return _calculateSynastryHouse(itemA, itemB, region);

      case MatchSubMenu.celticRuneMatch:
        return _calculateCelticRune(itemA, itemB, region);
    }
  }

  // 1) 사주 일주 궁합 계산 (천간합, 지지육합, 삼합)
  static MatchResult _calculateSajuIlju(String a, String b, SupportedRegion region) {
    final cleanA = a.split('(').first;
    final cleanB = b.split('(').first;

    final stems = {'갑': '기', '기': '갑', '을': '경', '경': '을', '병': '신', '신': '병', '정': '임', '임': '정', '무': '계', '계': '무'};
    final stemA = cleanA.isNotEmpty ? cleanA[0] : '';
    final stemB = cleanB.isNotEmpty ? cleanB[0] : '';

    final isStemHarmony = stems[stemA] == stemB;
    final seed = (a.hashCode ^ b.hashCode).abs();

    int score = isStemHarmony ? 97 : (75 + (seed % 20));
    String headline = isStemHarmony
        ? AppI18n.tr('match_saju_stem_harmony_title', region)
        : AppI18n.tr('match_headline_pillar', region);
    String summary = isStemHarmony
        ? AppI18n.tr('match_saju_stem_harmony_desc', region)
        : AppI18n.tr('match_summary_pillar', region);

    return MatchResult(
      score: score,
      headline: headline,
      summary: summary,
      passion: (80 + (seed % 18)).toDouble(),
      trust: (isStemHarmony ? 98 : 82 + (seed % 15)).toDouble(),
      communication: (75 + ((seed ~/ 2) % 22)).toDouble(),
      values: (isStemHarmony ? 96 : 80 + ((seed ~/ 3) % 18)).toDouble(),
      growth: (85 + ((seed ~/ 5) % 14)).toDouble(),
    );
  }

  // 2) 12간지 띠 궁합 계산 (삼합 4그룹, 육합, 상충)
  static MatchResult _calculateZodiacAnimal(String a, String b, SupportedRegion region) {
    final aChar = a.isNotEmpty ? a[0] : '';
    final bChar = b.isNotEmpty ? b[0] : '';

    final samhapGroups = [
      {'신', '자', '진'},
      {'사', '유', '축'},
      {'인', '오', '술'},
      {'해', '묘', '미'},
    ];

    final yukhap = {
      '자': '축', '축': '자', '인': '해', '해': '인',
      '묘': '술', '술': '묘', '진': '유', '유': '진',
      '사': '신', '신': '사', '오': '미', '미': '오',
    };

    final isSamhap = samhapGroups.any((g) => g.contains(aChar) && g.contains(bChar) && aChar != bChar);
    final isYukhap = yukhap[aChar] == bChar;

    int score = 76;
    String headline = AppI18n.tr('match_animal_general_title', region);
    String summary = AppI18n.tr('match_animal_general_desc', region);

    if (isSamhap) {
      score = 99;
      headline = AppI18n.tr('match_animal_samhap_title', region);
      summary = AppI18n.tr('match_animal_samhap_desc', region);
    } else if (isYukhap) {
      score = 96;
      headline = AppI18n.tr('match_animal_yukhap_title', region);
      summary = AppI18n.tr('match_animal_yukhap_desc', region);
    } else if (aChar == bChar) {
      score = 88;
      headline = AppI18n.tr('match_animal_same_title', region);
      summary = AppI18n.tr('match_animal_same_desc', region);
    }

    final seed = (a.hashCode ^ b.hashCode).abs();
    return MatchResult(
      score: score,
      headline: headline,
      summary: summary,
      passion: (isSamhap ? 95 : 75 + (seed % 20)).toDouble(),
      trust: (isYukhap ? 98 : 80 + (seed % 17)).toDouble(),
      communication: (82 + ((seed ~/ 2) % 16)).toDouble(),
      values: (isSamhap ? 97 : 78 + ((seed ~/ 3) % 19)).toDouble(),
      growth: (86 + ((seed ~/ 4) % 13)).toDouble(),
    );
  }

  // 3) 혈액형 궁합 (A, B, O, AB)
  static MatchResult _calculateBloodType(String a, String b, SupportedRegion region) {
    final typeA = a.replaceAll('형', '').trim();
    final typeB = b.replaceAll('형', '').trim();

    int score = 80;
    String headline = AppI18n.tr('match_blood_balance_title', region);
    String summary = AppI18n.tr('match_blood_balance_desc', region);

    if ((typeA == 'A' && typeB == 'O') || (typeA == 'O' && typeB == 'A')) {
      score = 96;
      headline = AppI18n.tr('match_blood_ao_title', region);
      summary = AppI18n.tr('match_blood_ao_desc', region);
    } else if ((typeA == 'B' && typeB == 'O') || (typeA == 'O' && typeB == 'B')) {
      score = 94;
      headline = AppI18n.tr('match_blood_bo_title', region);
      summary = AppI18n.tr('match_blood_bo_desc', region);
    } else if ((typeA == 'AB' && typeB == 'B') || (typeA == 'B' && typeB == 'AB')) {
      score = 90;
      headline = AppI18n.tr('match_blood_abb_title', region);
      summary = AppI18n.tr('match_blood_abb_desc', region);
    } else if (typeA == typeB) {
      score = 86;
      headline = AppI18n.tr('match_blood_same_title', region);
      summary = AppI18n.tr('match_blood_same_desc', region);
    } else if ((typeA == 'A' && typeB == 'B') || (typeA == 'B' && typeB == 'A')) {
      score = 75;
      headline = AppI18n.tr('match_blood_ab_title', region);
      summary = AppI18n.tr('match_blood_ab_desc', region);
    }

    final seed = (a.hashCode ^ b.hashCode).abs();
    return MatchResult(
      score: score,
      headline: headline,
      summary: summary,
      passion: (70 + (seed % 28)).toDouble(),
      trust: (score >= 90 ? 94 : 76 + (seed % 18)).toDouble(),
      communication: (78 + ((seed ~/ 2) % 20)).toDouble(),
      values: (score >= 90 ? 92 : 74 + ((seed ~/ 3) % 22)).toDouble(),
      growth: (80 + ((seed ~/ 4) % 18)).toDouble(),
    );
  }

  // 4) 서양 점성술 4대 원소 (Fire, Earth, Air, Water)
  static MatchResult _calculateZodiacElement(String a, String b, SupportedRegion region) {
    final elemA = a.split(' ')[0];
    final elemB = b.split(' ')[0];

    int score = 78;
    String headline = AppI18n.tr('match_headline_element', region);
    String summary = AppI18n.tr('match_summary_element', region);

    if ((elemA == 'Fire' && elemB == 'Air') || (elemA == 'Air' && elemB == 'Fire')) {
      score = 96;
      headline = AppI18n.tr('match_elem_fire_air_title', region);
      summary = AppI18n.tr('match_elem_fire_air_desc', region);
    } else if ((elemA == 'Earth' && elemB == 'Water') || (elemA == 'Water' && elemB == 'Earth')) {
      score = 95;
      headline = AppI18n.tr('match_elem_earth_water_title', region);
      summary = AppI18n.tr('match_elem_earth_water_desc', region);
    } else if (elemA == elemB) {
      score = 88;
      headline = AppI18n.tr('match_elem_same_title', region);
      summary = AppI18n.tr('match_elem_same_desc', region);
    }

    final seed = (a.hashCode ^ b.hashCode).abs();
    return MatchResult(
      score: score,
      headline: headline,
      summary: summary,
      passion: ((elemA == 'Fire' || elemB == 'Fire') ? 96 : 80 + (seed % 16)).toDouble(),
      trust: ((elemA == 'Earth' || elemB == 'Earth') ? 95 : 82 + (seed % 14)).toDouble(),
      communication: ((elemA == 'Air' || elemB == 'Air') ? 94 : 78 + ((seed ~/ 2) % 18)).toDouble(),
      values: ((elemA == 'Water' || elemB == 'Water') ? 94 : 76 + ((seed ~/ 3) % 20)).toDouble(),
      growth: (86 + ((seed ~/ 5) % 12)).toDouble(),
    );
  }

  // 5) 수비학 Life Path
  static MatchResult _calculateLifePath(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 80 + (seed % 19);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_numerology_title', region),
      summary: AppI18n.tr('match_numerology_desc', region),
      passion: (78 + (seed % 20)).toDouble(),
      trust: (85 + ((seed ~/ 2) % 14)).toDouble(),
      communication: (80 + ((seed ~/ 3) % 18)).toDouble(),
      values: (88 + ((seed ~/ 4) % 11)).toDouble(),
      growth: (92 + ((seed ~/ 5) % 8)).toDouble(),
    );
  }

  // 6) 일본 血液型 x 星座
  static MatchResult _calculateBloodZodiacHybrid(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 84 + (seed % 15);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_hybrid_title', region),
      summary: AppI18n.tr('match_hybrid_desc', region),
      passion: (82 + (seed % 16)).toDouble(),
      trust: (88 + ((seed ~/ 2) % 11)).toDouble(),
      communication: (84 + ((seed ~/ 3) % 14)).toDouble(),
      values: (86 + ((seed ~/ 4) % 12)).toDouble(),
      growth: (89 + ((seed ~/ 5) % 10)).toDouble(),
    );
  }

  // 7) 일본 육성점술 Rokusei
  static MatchResult _calculateRokusei(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 82 + (seed % 17);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_rokusei_title', region),
      summary: AppI18n.tr('match_rokusei_desc', region),
      passion: (80 + (seed % 18)).toDouble(),
      trust: (86 + ((seed ~/ 2) % 13)).toDouble(),
      communication: (83 + ((seed ~/ 3) % 15)).toDouble(),
      values: (90 + ((seed ~/ 4) % 9)).toDouble(),
      growth: (87 + ((seed ~/ 5) % 11)).toDouble(),
    );
  }

  // 8) 유럽 시나스트리 하우스
  static MatchResult _calculateSynastryHouse(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 87 + (seed % 12);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_house_title', region),
      summary: AppI18n.tr('match_house_desc', region),
      passion: (88 + (seed % 11)).toDouble(),
      trust: (91 + ((seed ~/ 2) % 8)).toDouble(),
      communication: (85 + ((seed ~/ 3) % 13)).toDouble(),
      values: (89 + ((seed ~/ 4) % 10)).toDouble(),
      growth: (94 + ((seed ~/ 5) % 6)).toDouble(),
    );
  }

  // 9) 유럽 켈틱 룬
  static MatchResult _calculateCelticRune(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 85 + (seed % 14);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_celtic_rune_title', region),
      summary: AppI18n.tr('match_celtic_rune_desc', region),
      passion: (86 + (seed % 13)).toDouble(),
      trust: (89 + ((seed ~/ 2) % 10)).toDouble(),
      communication: (82 + ((seed ~/ 3) % 16)).toDouble(),
      values: (92 + ((seed ~/ 4) % 8)).toDouble(),
      growth: (90 + ((seed ~/ 5) % 9)).toDouble(),
    );
  }
}

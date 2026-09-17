// Pure Dart Saju Engine (Four Pillars of Destiny / Bazi)
// Computes Year, Month, Day, and Hour Pillars based on sexagenary cycle (60 간지)
// and calculates Five Elements (오행: 목화토금수) balance.

enum FiveElement {
  wood('목(木)', 'Wood', 0xFF4CAF50),
  fire('화(火)', 'Fire', 0xFFF44336),
  earth('토(土)', 'Earth', 0xFFFFC107),
  metal('금(金)', 'Metal', 0xFFECEFF1),
  water('수(水)', 'Water', 0xFF2196F3);

  final String ko;
  final String en;
  final int colorValue;

  const FiveElement(this.ko, this.en, this.colorValue);
}

class HeavenlyStem {
  final String char;
  final String name;
  final FiveElement element;
  final bool isYang;

  const HeavenlyStem(this.char, this.name, this.element, this.isYang);
}

class EarthlyBranch {
  final String char;
  final String name;
  final String animal;
  final FiveElement element;

  const EarthlyBranch(this.char, this.name, this.animal, this.element);
}

class SajuEngine {
  static const List<HeavenlyStem> stems = [
    HeavenlyStem('甲', '갑', FiveElement.wood, true),
    HeavenlyStem('乙', '을', FiveElement.wood, false),
    HeavenlyStem('丙', '병', FiveElement.fire, true),
    HeavenlyStem('丁', '정', FiveElement.fire, false),
    HeavenlyStem('戊', '무', FiveElement.earth, true),
    HeavenlyStem('己', '기', FiveElement.earth, false),
    HeavenlyStem('庚', '경', FiveElement.metal, true),
    HeavenlyStem('辛', '신', FiveElement.metal, false),
    HeavenlyStem('壬', '임', FiveElement.water, true),
    HeavenlyStem('癸', '계', FiveElement.water, false),
  ];

  static const List<EarthlyBranch> branches = [
    EarthlyBranch('子', '자', '쥐', FiveElement.water),
    EarthlyBranch('丑', '축', '소', FiveElement.earth),
    EarthlyBranch('寅', '인', '호랑이', FiveElement.wood),
    EarthlyBranch('卯', '묘', '토끼', FiveElement.wood),
    EarthlyBranch('辰', '진', '용', FiveElement.earth),
    EarthlyBranch('巳', '사', '뱀', FiveElement.fire),
    EarthlyBranch('午', '오', '말', FiveElement.fire),
    EarthlyBranch('未', '미', '양', FiveElement.earth),
    EarthlyBranch('申', '신', '원숭이', FiveElement.metal),
    EarthlyBranch('酉', '유', '닭', FiveElement.metal),
    EarthlyBranch('戌', '술', '개', FiveElement.earth),
    EarthlyBranch('亥', '해', '돼지', FiveElement.water),
  ];

  /// Calculate Four Pillars from birth DateTime
  static SajuPillars calculatePillars(DateTime birthTime) {
    // 1. Year Pillar: Year offset relative to 1984 (갑자년 - JiaZi)
    int year = birthTime.year;
    // Lunar year roughly starts near Feb 4 (Ipchun)
    if (birthTime.month == 1 || (birthTime.month == 2 && birthTime.day < 4)) {
      year -= 1;
    }
    final yearStemIdx = (year - 4) % 10;
    final yearBranchIdx = (year - 4) % 12;
    final yearStem = stems[yearStemIdx >= 0 ? yearStemIdx : yearStemIdx + 10];
    final yearBranch = branches[yearBranchIdx >= 0 ? yearBranchIdx : yearBranchIdx + 12];

    // 2. Month Pillar: Determined by month and year stem
    final monthBranchIdx = (birthTime.month + 1) % 12; //寅月 start in Feb
    final monthStemIdx = ((yearStemIdx % 5) * 2 + (birthTime.month + 1)) % 10;
    final monthStem = stems[monthStemIdx];
    final monthBranch = branches[monthBranchIdx];

    // 3. Day Pillar: Julian day calculation relative to reference day
    final dayDiff = birthTime.difference(DateTime(1900, 1, 1)).inDays;
    final dayStemIdx = (dayDiff + 0) % 10;
    final dayBranchIdx = (dayDiff + 10) % 12;
    final dayStem = stems[(dayStemIdx % 10 + 10) % 10];
    final dayBranch = branches[(dayBranchIdx % 12 + 12) % 12];

    // 4. Hour Pillar: Determined by hour of birth and day stem
    final hour = birthTime.hour;
    final hourBranchIdx = ((hour + 1) ~/ 2) % 12;
    final hourStemIdx = ((dayStemIdx % 5) * 2 + hourBranchIdx) % 10;
    final hourStem = stems[hourStemIdx];
    final hourBranch = branches[hourBranchIdx];

    return SajuPillars(
      yearPillar: Pillar(yearStem, yearBranch, '년주 (Year)'),
      monthPillar: Pillar(monthStem, monthBranch, '월주 (Month)'),
      dayPillar: Pillar(dayStem, dayBranch, '일주 (Day)'),
      hourPillar: Pillar(hourStem, hourBranch, '시주 (Hour)'),
    );
  }

  /// Calculates distribution of 5 elements (Wood, Fire, Earth, Metal, Water)
  static Map<FiveElement, double> calculateElementBalance(SajuPillars pillars) {
    final counts = <FiveElement, double>{
      FiveElement.wood: 0,
      FiveElement.fire: 0,
      FiveElement.earth: 0,
      FiveElement.metal: 0,
      FiveElement.water: 0,
    };

    final allItems = [
      pillars.yearPillar.stem.element,
      pillars.yearPillar.branch.element,
      pillars.monthPillar.stem.element,
      pillars.monthPillar.branch.element,
      pillars.dayPillar.stem.element, // Day Master has weighted importance
      pillars.dayPillar.branch.element,
      pillars.hourPillar.stem.element,
      pillars.hourPillar.branch.element,
    ];

    for (int i = 0; i < allItems.length; i++) {
      // Day pillar stem (Day Master) carries 1.5x weight in orthodox analysis
      final weight = (i == 4) ? 1.5 : 1.0;
      counts[allItems[i]] = (counts[allItems[i]] ?? 0) + weight;
    }

    final total = counts.values.reduce((a, b) => a + b);
    return counts.map((k, v) => MapEntry(k, (v / total)));
  }
}

class Pillar {
  final HeavenlyStem stem;
  final EarthlyBranch branch;
  final String label;

  const Pillar(this.stem, this.branch, this.label);

  String get ganji => '${stem.char}${branch.char} (${stem.name}${branch.name})';
}

class SajuPillars {
  final Pillar yearPillar;
  final Pillar monthPillar;
  final Pillar dayPillar;
  final Pillar hourPillar;

  const SajuPillars({
    required this.yearPillar,
    required this.monthPillar,
    required this.dayPillar,
    required this.hourPillar,
  });
}

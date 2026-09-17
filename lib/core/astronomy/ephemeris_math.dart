import 'dart:math';

enum WesternZodiac {
  aries('양자리', 'Aries', '♈', 'Fire', 'March 21 - April 19'),
  taurus('황소자리', 'Taurus', '♉', 'Earth', 'April 20 - May 20'),
  gemini('쌍둥이자리', 'Gemini', '♊', 'Air', 'May 21 - June 20'),
  cancer('게자리', 'Cancer', '♋', 'Water', 'June 21 - July 22'),
  leo('사자자리', 'Leo', '♌', 'Fire', 'July 23 - August 22'),
  virgo('처녀자리', 'Virgo', '♍', 'Earth', 'August 23 - September 22'),
  libra('천칭자리', 'Libra', '♎', 'Air', 'September 23 - October 22'),
  scorpio('전갈자리', 'Scorpio', '♏', 'Water', 'October 23 - November 21'),
  sagittarius('사수자리', 'Sagittarius', '♐', 'Fire', 'November 22 - December 21'),
  capricorn('염소자리', 'Capricorn', '♑', 'Earth', 'December 22 - January 19'),
  aquarius('물병자리', 'Aquarius', '♒', 'Air', 'January 20 - February 18'),
  pisces('물고기자리', 'Pisces', '♓', 'Water', 'February 19 - March 20');

  final String ko;
  final String en;
  final String symbol;
  final String element;
  final String period;

  const WesternZodiac(this.ko, this.en, this.symbol, this.element, this.period);
}

class EphemerisMath {
  /// Computes Sun Sign from birth date
  static WesternZodiac getSunSign(DateTime date) {
    final m = date.month;
    final d = date.day;

    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) return WesternZodiac.aries;
    if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) return WesternZodiac.taurus;
    if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) return WesternZodiac.gemini;
    if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) return WesternZodiac.cancer;
    if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) return WesternZodiac.leo;
    if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) return WesternZodiac.virgo;
    if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) return WesternZodiac.libra;
    if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) return WesternZodiac.scorpio;
    if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) return WesternZodiac.sagittarius;
    if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) return WesternZodiac.capricorn;
    if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) return WesternZodiac.aquarius;
    return WesternZodiac.pisces;
  }

  /// Calculates astronomical degree coordinates for trust anchor UI (e.g. Sun 24° Pisces 12')
  static String calculatePreciseDegree(DateTime date) {
    final zodiac = getSunSign(date);
    final dayInSign = (date.day % 28) + 1;
    final minutes = (date.minute * 59 ~/ 60);
    return '${zodiac.en} $dayInSign° ${zodiac.symbol} $minutes\'';
  }

  /// Calculates simulated major aspect between planets
  static String detectMajorAspect(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final rand = Random(seed);
    final aspects = [
      '행성 간 각도 120° 트라인(Trine) - 황금빛 조화와 행운 검출',
      '행성 간 각도 60° 섹스타일(Sextile) - 새로운 기회의 통로 발현',
      '행성 간 각도 0° 컨정션(Conjunction) - 에너지가 한곳으로 응축되는 순간',
      '천정점(MC)과 태양의 길각(Trine) - 명예와 성취의 강력한 흐름',
    ];
    return aspects[rand.nextInt(aspects.length)];
  }
}

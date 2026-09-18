import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';

class SixteenTypeMatrix {
  static const List<String> allTypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP',
    'INFJ', 'INFP', 'ENFJ', 'ENFP',
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
    'ISTP', 'ISFP', 'ESTP', 'ESFP',
  ];

  /// Chemistry scores (0-100), title, and deep dynamics analysis
  static MatchResult calculateChemistry(
    String typeA,
    String typeB, {
    String? headline,
    String? summary,
    SupportedRegion region = SupportedRegion.korea,
  }) {
    typeA = typeA.toUpperCase();
    typeB = typeB.toUpperCase();

    // Natural soulmate pairings (Dual / Golden pairs)
    final goldenPairs = {
      'INTJ': ['ENFP', 'ENTP'],
      'INTP': ['ENTJ', 'ENFJ'],
      'ENTJ': ['INTP', 'INFP'],
      'ENTP': ['INFJ', 'INTJ'],
      'INFJ': ['ENTP', 'ENFP'],
      'INFP': ['ENFJ', 'ENTJ'],
      'ENFJ': ['INFP', 'ISFP'],
      'ENFP': ['INTJ', 'INFJ'],
      'ISTJ': ['ESFP', 'ESTP'],
      'ISFJ': ['ESTP', 'ESFP'],
      'ESTJ': ['ISFP', 'ISTP'],
      'ESFJ': ['ISTP', 'ISFP'],
      'ISTP': ['ESFJ', 'ESTJ'],
      'ISFP': ['ESTJ', 'ESFJ'],
      'ESTP': ['ISFJ', 'ISTJ'],
      'ESFP': ['ISTJ', 'ISFJ'],
    };

    int score = 70;
    String dynamicTitle = headline ?? AppI18n.tr('match_complementary_title', region);
    String description = summary ?? AppI18n.tr('match_complementary_desc', region);

    if (typeA == typeB) {
      score = 85;
      dynamicTitle = AppI18n.tr('mirror_pair_title', region);
      description = AppI18n.tr('mirror_pair_desc', region);
    } else if (goldenPairs[typeA]?.contains(typeB) == true) {
      score = 98;
      dynamicTitle = AppI18n.tr('golden_pair_title', region);
      description = AppI18n.tr('golden_pair_desc', region);
    } else {
      // Calculate letter matching balance
      int matchLetters = 0;
      for (int i = 0; i < 4; i++) {
        if (typeA[i] == typeB[i]) matchLetters++;
      }
      if (matchLetters == 3) {
        score = 88;
        dynamicTitle = AppI18n.tr('match_harmonious_title', region);
        description = AppI18n.tr('match_harmonious_desc', region);
      } else if (matchLetters == 1) {
        score = 64;
        dynamicTitle = AppI18n.tr('match_spark_title', region);
        description = AppI18n.tr('match_spark_desc', region);
      }
    }

    // 5-Axis balance radar ratings (Passion, Trust, Communication, Values, Growth)
    final seed = (typeA.hashCode ^ typeB.hashCode).abs();
    final passion = 75 + (seed % 25);
    final trust = 70 + ((seed ~/ 2) % 30);
    final communication = 65 + ((seed ~/ 3) % 35);
    final values = 70 + ((seed ~/ 5) % 28);
    final growth = 80 + ((seed ~/ 7) % 20);

    return MatchResult(
      score: score,
      headline: dynamicTitle,
      summary: description,
      passion: passion.toDouble(),
      trust: trust.toDouble(),
      communication: communication.toDouble(),
      values: values.toDouble(),
      growth: growth.toDouble(),
    );
  }
}

class MatchResult {
  final int score;
  final String headline;
  final String summary;
  final double passion;
  final double trust;
  final double communication;
  final double values;
  final double growth;

  const MatchResult({
    required this.score,
    required this.headline,
    required this.summary,
    required this.passion,
    required this.trust,
    required this.communication,
    required this.values,
    required this.growth,
  });
}

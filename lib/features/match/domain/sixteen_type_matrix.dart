class SixteenTypeMatrix {
  static const List<String> allTypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP',
    'INFJ', 'INFP', 'ENFJ', 'ENFP',
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
    'ISTP', 'ISFP', 'ESTP', 'ESFP',
  ];

  /// Chemistry scores (0-100), title, and deep dynamics analysis
  static MatchResult calculateChemistry(String typeA, String typeB) {
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
    String dynamicTitle = '상호 보완적인 호기심의 관계';
    String description = '서로 다른 시각에서 배울 점이 많으며 자극과 성장을 함께 추구하는 조합입니다.';

    if (typeA == typeB) {
      score = 85;
      dynamicTitle = '거울을 마주한 듯한 깊은 공감';
      description = '말하지 않아도 서로의 심리와 스트레스 지점을 정확히 꿰뚫어 보는 소울메이트입니다.';
    } else if (goldenPairs[typeA]?.contains(typeB) == true) {
      score = 98;
      dynamicTitle = '우주가 맺어준 천생연분 (Golden Pair)';
      description = '서로의 약점을 완벽하게 보완하며, 함께 있을 때 가장 나다워지는 최상의 시너지 케미입니다.';
    } else {
      // Calculate letter matching balance
      int matchLetters = 0;
      for (int i = 0; i < 4; i++) {
        if (typeA[i] == typeB[i]) matchLetters++;
      }
      if (matchLetters == 3) {
        score = 88;
        dynamicTitle = '편안함과 안정감이 가득한 안식처';
        description = '가치관과 생활 방식의 일치도가 높아 갈등 없이 오랫동안 평온함을 공유할 수 있습니다.';
      } else if (matchLetters == 1) {
        score = 64;
        dynamicTitle = '강렬한 호기심과 긴장감의 스파크';
        description = '서로 완전히 다른 별에서 온 듯한 신선한 매력에 이끌리며, 배려를 통해 가장 큰 성장을 이룹니다.';
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

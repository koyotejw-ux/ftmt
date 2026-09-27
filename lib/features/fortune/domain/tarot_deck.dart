import '../../../core/localization/geo_detector.dart';

class TarotCard {
  final int id;
  final String nameKo;
  final String nameEn;
  final String arcana; // Major or Minor
  final String uprightMeaning;
  final String uprightMeaningEn;
  final String reversedMeaning;
  final String reversedMeaningEn;
  final String astrologicalAssociation;
  final String runeSymbol;

  const TarotCard({
    required this.id,
    required this.nameKo,
    required this.nameEn,
    required this.arcana,
    required this.uprightMeaning,
    required this.uprightMeaningEn,
    required this.reversedMeaning,
    required this.reversedMeaningEn,
    required this.astrologicalAssociation,
    this.runeSymbol = '✦',
  });

  String localizedName(SupportedRegion region) {
    if (region == SupportedRegion.korea) {
      return nameKo;
    }
    return nameEn;
  }

  String localizedUprightMeaning(SupportedRegion region) {
    if (region == SupportedRegion.korea) {
      return uprightMeaning;
    }
    return uprightMeaningEn;
  }

  String localizedReversedMeaning(SupportedRegion region) {
    if (region == SupportedRegion.korea) {
      return reversedMeaning;
    }
    return reversedMeaningEn;
  }
}

class TarotDeck {
  static const List<TarotCard> majorArcana = [
    TarotCard(
      id: 0,
      nameKo: '바보 (The Fool)',
      nameEn: 'The Fool',
      arcana: 'Major',
      uprightMeaning: '새로운 시작, 순수한 모험, 무한한 잠재력과 자유',
      uprightMeaningEn: 'New Beginnings, Pure Adventure, Infinite Potential & Freedom',
      reversedMeaning: '경솔한 판단, 불필요한 위험 감수, 주저함',
      reversedMeaningEn: 'Recklessness, Unnecessary Risk, Hesitation',
      astrologicalAssociation: 'Uranus / 천왕성',
      runeSymbol: 'ᚠ',
    ),
    TarotCard(
      id: 1,
      nameKo: '마법사 (The Magician)',
      nameEn: 'The Magician',
      arcana: 'Major',
      uprightMeaning: '창조력, 탁월한 실행력, 모든 자원을 활용할 줄 아는 통찰',
      uprightMeaningEn: 'Creative Power, Mastery, Willpower & Resourcefulness',
      reversedMeaning: '재능의 남용, 속임수, 준비되지 않은 시작',
      reversedMeaningEn: 'Misuse of Power, Trickery, Unprepared Action',
      astrologicalAssociation: 'Mercury / 수성',
      runeSymbol: 'ᚨ',
    ),
    TarotCard(
      id: 2,
      nameKo: '여사제 (The High Priestess)',
      nameEn: 'The High Priestess',
      arcana: 'Major',
      uprightMeaning: '직관, 무의식의 지혜, 비밀스러운 신비와 통찰력',
      uprightMeaningEn: 'Intuition, Sacred Wisdom, Mystery & Inner Knowing',
      reversedMeaning: '비밀의 탄로, 억압된 감정, 직관 무시',
      reversedMeaningEn: 'Hidden Agendas, Suppressed Emotions, Ignoring Intuition',
      astrologicalAssociation: 'Moon / 달',
      runeSymbol: 'ᛈ',
    ),
    TarotCard(
      id: 3,
      nameKo: '여황제 (The Empress)',
      nameEn: 'The Empress',
      arcana: 'Major',
      uprightMeaning: '풍요, 창조적 결실, 모성애와 따뜻한 사랑',
      uprightMeaningEn: 'Abundance, Creative Fruitfulness, Nurturing & Warmth',
      reversedMeaning: '과잉보호, 정서적 불안, 물질적 결핍',
      reversedMeaningEn: 'Overbearing Control, Creative Block, Scarcity',
      astrologicalAssociation: 'Venus / 금성',
      runeSymbol: 'ᛒ',
    ),
    TarotCard(
      id: 4,
      nameKo: '황제 (The Emperor)',
      nameEn: 'The Emperor',
      arcana: 'Major',
      uprightMeaning: '확고한 권위, 안정적인 기반, 체계적인 통제력',
      uprightMeaningEn: 'Sovereign Authority, Solid Foundation, Structure & Stability',
      reversedMeaning: '독단, 융통성 부족, 통제 상실',
      reversedMeaningEn: 'Tyranny, Inflexibility, Lack of Discipline',
      astrologicalAssociation: 'Aries / 양자리',
      runeSymbol: 'ᚦ',
    ),
    TarotCard(
      id: 5,
      nameKo: '교황 (The Hierophant)',
      nameEn: 'The Hierophant',
      arcana: 'Major',
      uprightMeaning: '전통, 지혜로운 조언자, 영적 가르침과 신뢰',
      uprightMeaningEn: 'Spiritual Wisdom, Mentorship, Tradition & Shared Values',
      reversedMeaning: '틀에 박힌 사고, 위선, 잘못된 맹신',
      reversedMeaningEn: 'Rigid Dogma, Hypocrisy, Blind Conformity',
      astrologicalAssociation: 'Taurus / 황소자리',
      runeSymbol: 'ᚱ',
    ),
    TarotCard(
      id: 6,
      nameKo: '연인 (The Lovers)',
      nameEn: 'The Lovers',
      arcana: 'Major',
      uprightMeaning: '영혼의 결합, 운명적 선택, 조화로운 끌림',
      uprightMeaningEn: 'Soul Union, Destined Choice, Harmonic Attraction & Value Alignment',
      reversedMeaning: '불화, 유혹에 흔들림, 잘못된 선택',
      reversedMeaningEn: 'Discord, Temptation, Misalignment of Values',
      astrologicalAssociation: 'Gemini / 쌍둥이자리',
      runeSymbol: 'ᚷ',
    ),
    TarotCard(
      id: 7,
      nameKo: '전차 (The Chariot)',
      nameEn: 'The Chariot',
      arcana: 'Major',
      uprightMeaning: '단호한 전진, 승리와 극복, 의지의 승리',
      uprightMeaningEn: 'Determined Progress, Overcoming Obstacles, Victorious Drive',
      reversedMeaning: '방향 상실, 폭주, 장애물에 좌절',
      reversedMeaningEn: 'Loss of Direction, Impulsiveness, Roadblocks',
      astrologicalAssociation: 'Cancer / 게자리',
      runeSymbol: 'ᚱ',
    ),
    TarotCard(
      id: 10,
      nameKo: '운명의 수레바퀴 (Wheel of Fortune)',
      nameEn: 'Wheel of Fortune',
      arcana: 'Major',
      uprightMeaning: '운명의 전환점, 행운의 기회, 필연적인 변화',
      uprightMeaningEn: 'Turning Point of Destiny, Lucky Opportunity, Divine Timing',
      reversedMeaning: '예기치 않은 지연, 악순환, 저항할 수 없는 변화',
      reversedMeaningEn: 'Temporary Setbacks, Breaking Cycles, Resisting Inevitable Change',
      astrologicalAssociation: 'Jupiter / 목성',
      runeSymbol: 'ᛃ',
    ),
    TarotCard(
      id: 17,
      nameKo: '별 (The Star)',
      nameEn: 'The Star',
      arcana: 'Major',
      uprightMeaning: '희망, 영감, 치유의 빛과 밝은 미래',
      uprightMeaningEn: 'Hope, Serene Inspiration, Healing Light & Bright Renewal',
      reversedMeaning: '희망 상실, 비관주의, 길을 잃은 기분',
      reversedMeaningEn: 'Despair, Cynicism, Disconnection from Faith',
      astrologicalAssociation: 'Aquarius / 물병자리',
      runeSymbol: 'ᛊ',
    ),
    TarotCard(
      id: 19,
      nameKo: '태양 (The Sun)',
      nameEn: 'The Sun',
      arcana: 'Major',
      uprightMeaning: '최고의 성공, 활력, 기쁨과 명확한 결실',
      uprightMeaningEn: 'Radiant Success, Vitality, Pure Joy & Crystal Clarity',
      reversedMeaning: '일시적 구름, 과신, 지연된 성공',
      reversedMeaningEn: 'Temporary Cloudiness, Overconfidence, Delayed Celebration',
      astrologicalAssociation: 'Sun / 태양',
      runeSymbol: 'ᛋ',
    ),
    TarotCard(
      id: 21,
      nameKo: '세계 (The World)',
      nameEn: 'The World',
      arcana: 'Major',
      uprightMeaning: '완전한 성취, 통합, 새로운 차원으로의 완성',
      uprightMeaningEn: 'Wholeness, Ultimate Realization, Cosmic Fulfillment & Mastery',
      reversedMeaning: '미완성, 마지막 관문에서의 지체, 불완전한 마침표',
      reversedMeaningEn: 'Unfinished Cycles, Stagnation at the Threshold, Hesitant Completion',
      astrologicalAssociation: 'Saturn / 토성',
      runeSymbol: 'ᛞ',
    ),
  ];
}

import '../localization/geo_detector.dart';
import 'ephemeris_math.dart';
import 'saju_engine.dart';

class DailyTransitData {
  final DateTime todayDate;
  final DateTime birthDate;

  // 1. Saju Daily Pillars
  final Pillar todayDayPillar;
  final SajuPillars userPillars;
  final Map<FiveElement, double> userElementBalance;
  final String sajuTenGodRelation;
  final String sajuDailyTitle;
  final String sajuDailyNarrative;

  // 2. Auspicious Golden Hours & Dopamine Snack
  final String goldenHours;
  final String energyWarning;
  final String actionTip;

  // 3. Zodiac Daily Transit
  final WesternZodiac userSunSign;
  final WesternZodiac todaySunSign;
  final String zodiacAspectTitle;
  final String zodiacDailyNarrative;

  // 4. Eastern Animal Daily Match
  final String userAnimal;
  final String todayAnimal;
  final String animalDailyTitle;
  final String animalDailyNarrative;

  // 5. Numerology Personal Day
  final int personalDayNumber;
  final String numerologyTitle;
  final String numerologyNarrative;

  const DailyTransitData({
    required this.todayDate,
    required this.birthDate,
    required this.todayDayPillar,
    required this.userPillars,
    required this.userElementBalance,
    required this.sajuTenGodRelation,
    required this.sajuDailyTitle,
    required this.sajuDailyNarrative,
    required this.goldenHours,
    required this.energyWarning,
    required this.actionTip,
    required this.userSunSign,
    required this.todaySunSign,
    required this.zodiacAspectTitle,
    required this.zodiacDailyNarrative,
    required this.userAnimal,
    required this.todayAnimal,
    required this.animalDailyTitle,
    required this.animalDailyNarrative,
    required this.personalDayNumber,
    required this.numerologyTitle,
    required this.numerologyNarrative,
  });
}

class DailyTransitEngine {
  /// Computes fully dynamic, personalized daily transit fortune based on birth date + today's date
  static DailyTransitData calculateDailyTransit({
    required DateTime birthDate,
    DateTime? today,
    SupportedRegion region = SupportedRegion.korea,
  }) {
    final now = today ?? DateTime.now();
    final todayClean = DateTime(now.year, now.month, now.day);

    // 1. Calculate user and today's pillars
    final userPillars = SajuEngine.calculatePillars(birthDate);
    final todayPillars = SajuEngine.calculatePillars(todayClean);
    final userBalance = SajuEngine.calculateElementBalance(userPillars);

    final userStem = userPillars.dayPillar.stem;
    final todayStem = todayPillars.dayPillar.stem;
    final todayBranch = todayPillars.dayPillar.branch;

    // Saju Ten Gods / Elemental Dynamic Relation
    final userElem = userStem.element;
    final todayElem = todayStem.element;

    String tenGodRelation;
    String sajuDailyTitle;
    String sajuDailyNarrative;

    if (userElem == todayElem) {
      tenGodRelation = '비겁(比劫) - 독립과 주체성';
      if (region == SupportedRegion.korea) {
        sajuDailyTitle = '⚡ 주체적인 의지와 자신감이 돋보이는 날';
        sajuDailyNarrative =
            '오늘의 일진(${todayStem.char}${todayBranch.char})은 당신의 본원 오행(${userElem.ko})과 같은 기운이 조화롭게 임하는 날입니다. '
            '내면의 줏대가 바로 서고 독립적인 결단력이 배가됩니다. 타인의 의견에 휘둘리지 않고 본인의 소신대로 프로젝트를 밀고 나갈 때 가장 확실한 성취가 뒤따릅니다.';
      } else {
        sajuDailyTitle = '⚡ Sovereign Will & Dynamic Self-Reliance';
        sajuDailyNarrative =
            'Today\'s celestial transit resonates in harmonic alignment with your natal Day Master element. '
            'Your core conviction and natural agency are amplified. Trusting your independent judgment will unlock the clearest breakthroughs.';
      }
    } else if (_isGenerating(userElem, todayElem)) {
      tenGodRelation = '식상(食傷) - 표현과 창의성';
      if (region == SupportedRegion.korea) {
        sajuDailyTitle = '🎨 번뜩이는 창의력과 언변이 빛을 발하는 날';
        sajuDailyNarrative =
            '당신의 일간(${userStem.name})이 오늘의 일진(${todayStem.name})을 생조하는 식상의 기운이 가득합니다. '
            '가슴속에 품었던 아이디어를 세상에 내놓고 사람들과 소통하기에 최적의 시기입니다. 당신의 따뜻한 말 한마디와 기획이 주변 사람들에게 커다란 영감을 줍니다.';
      } else {
        sajuDailyTitle = '🎨 Creative Illumination & Expression';
        sajuDailyNarrative =
            'Your elemental core pours outward in vibrant generative synergy with today\'s cosmic currents. '
            'Ideas flow effortlessly and your genuine communication inspires those around you. Pitch new visions with joyful confidence.';
      }
    } else if (_isOvercoming(userElem, todayElem)) {
      tenGodRelation = '재성(財星) - 성과와 재물운';
      if (region == SupportedRegion.korea) {
        sajuDailyTitle = '💰 실질적인 성과와 재물운의 결실이 맺히는 날';
        sajuDailyNarrative =
            '당신의 주도적인 에너지가 오늘의 기운을 통제하고 결실을 맺는 재성의 흐름이 강력합니다. '
            '노력해온 일에서 눈에 보이는 성과와 금전적 보상이 실현되는 날입니다. 실리적이고 현실적인 계산으로 계약이나 중요한 결정을 내리기에 길합니다.';
      } else {
        sajuDailyTitle = '💰 Tangible Harvest & Financial Manifestation';
        sajuDailyNarrative =
            'A powerful tide of abundance and practical realization characterizes today\'s flow. '
            'Efforts crystallize into measurable milestones and prosperous outcomes. Decisive negotiations and financial choices are well-favored.';
      }
    } else if (_isOvercoming(todayElem, userElem)) {
      tenGodRelation = '관성(官星) - 명예와 리더십';
      if (region == SupportedRegion.korea) {
        sajuDailyTitle = '🏆 공신력과 명예가 오르고 리더십이 발휘되는 날';
        sajuDailyNarrative =
            '사회적 책임과 신뢰를 상징하는 관성의 에너지가 당신의 일주를 조명합니다. '
            '정직하고 품격 있는 태도가 돋보이며, 윗사람이나 중요한 파트너로부터 두터운 인정을 받게 됩니다. 공적인 일이나 평가에서 탁월한 명예운이 깃듭니다.';
      } else {
        sajuDailyTitle = '🏆 Honor, Prestige & Executive Authority';
        sajuDailyNarrative =
            'A structured current of discipline and societal honor aligns with your path. '
            'Your integrity and steadfast composure earn authoritative recognition. Professional presentations and leadership initiatives command respect.';
      }
    } else {
      tenGodRelation = '인성(印星) - 지혜와 귀인운';
      if (region == SupportedRegion.korea) {
        sajuDailyTitle = '📜 지혜의 귀인이 돕고 문서와 계약이 길한 날';
        sajuDailyNarrative =
            '오늘의 기운이 당신의 본원을 따뜻하게 품어주는 인성의 은혜로운 기운이 흐릅니다. '
            '생각지 못한 귀인의 도움이나 소중한 조언을 얻게 되며, 공부와 자격, 문서 작성 및 마음의 치유에 최고의 하루입니다. 조급해하지 말고 깊은 통찰을 다지세요.';
      } else {
        sajuDailyTitle = '📜 Sacred Mentorship & Intuitive Wisdom';
        sajuDailyNarrative =
            'Today\'s environment nurtures your foundation like a protective sanctuary. '
            'Benefactors, wise mentors, or pivotal insights emerge naturally. An auspicious day for signing covenants, reflective study, and rejuvenating vitality.';
      }
    }

    // 2. Dynamic Auspicious Golden Hours Calculation
    // Calculates dynamic hours based on user's birth hour + today's day branch index
    final seed = (todayClean.year * 10000 + todayClean.month * 100 + todayClean.day + birthDate.day + birthDate.hour).abs();
    final hourSlots = [
      '09:30 ~ 11:30 (사시/巳時)',
      '11:30 ~ 13:30 (오시/午時)',
      '13:30 ~ 15:30 (미시/未時)',
      '15:30 ~ 17:30 (신시/申時)',
      '17:30 ~ 19:30 (유시/酉時)',
      '19:30 ~ 21:30 (술시/戌時)',
      '07:30 ~ 09:30 (진시/辰時)',
    ];
    final goldenHours = hourSlots[seed % hourSlots.length];

    final warningList = [
      '목(木) 기운이 지나치게 강해 성급하게 밀어붙이는 성향',
      '화(火) 기운의 감정 기복과 충동적인 소비 성향',
      '토(土) 기운의 완고함과 고집으로 소통을 닫는 성향',
      '금(金) 기운의 날카로운 비판과 차가운 말투',
      '수(水) 기운의 지나친 걱정과 우유부단한 망설임',
    ];
    final energyWarning = region == SupportedRegion.korea
        ? '주의: 오늘 에너지를 소모시키는 요인: ${warningList[seed % warningList.length]}'
        : 'Caution today: Vulnerable to impulsive tension; maintain center and avoid hasty decisions.';

    final actionList = [
      '창가에서 5분간 심호흡하고, 중요한 결재나 제안은 골든타임에 진행하세요.',
      '따뜻한 차 한 잔으로 마음의 중심을 잡고, 미뤄둔 핵심 업무를 먼저 처리하세요.',
      '신뢰하는 동료에게 칭찬 한마디를 건네면 예상 밖의 큰 도움으로 돌아옵니다.',
      '불필요한 지출을 점검하고, 책상 위의 문서를 깔끔하게 정돈하세요.',
    ];
    final actionTip = region == SupportedRegion.korea
        ? actionList[(seed ~/ 3) % actionList.length]
        : 'Ground yourself with calm breath; schedule pivotal negotiations during your golden hours.';

    // 3. Western Zodiac Daily Aspect & Transit Horoscope
    final userSunSign = EphemerisMath.getSunSign(birthDate);
    final todaySunSign = EphemerisMath.getSunSign(todayClean);

    final signDiff = (userSunSign.index - todaySunSign.index).abs();
    final isTrine = signDiff == 4 || signDiff == 8;
    final isSextile = signDiff == 2 || signDiff == 10;
    final isConjunction = signDiff == 0;
    final isSquare = signDiff == 3 || signDiff == 9;
    final isOpposition = signDiff == 6;

    String zodiacAspectTitle;
    String zodiacDailyNarrative;

    if (isTrine) {
      zodiacAspectTitle = '🌟 120° 트라인(Trine) - 황금빛 조화와 행운의 흐름';
      zodiacDailyNarrative =
          '오늘 당신의 태양 ${userSunSign.ko}(${userSunSign.en})과 오늘의 천체 에너지가 완벽한 120° 삼분각(Trine)의 길각을 형성합니다. '
          '노력 이상의 순풍이 불어오며, 당신의 매력과 역량이 가장 자연스럽게 빛을 발하는 축복의 날입니다.';
    } else if (isSextile) {
      zodiacAspectTitle = '✨ 60° 섹스타일(Sextile) - 새로운 기회의 통로 발현';
      zodiacDailyNarrative =
          '호기심과 지적인 자극이 솟아오르는 60° 섹스타일 각도입니다. 대화와 만남 속에서 뜻밖의 해결책을 발견하게 되며, 가벼운 제안이 큰 기회로 발전합니다.';
    } else if (isConjunction) {
      zodiacAspectTitle = '☀️ 0° 컨정션(Conjunction) - 에너지가 정상에 집중되는 순간';
      zodiacDailyNarrative =
          '태양이 당신의 태양궁을 직접 통과하는 중심축의 날입니다. 강력한 생명력과 리더십이 발휘되며, 새로운 목표를 선포하고 첫걸음을 떼기에 최적입니다.';
    } else if (isSquare) {
      zodiacAspectTitle = '⚡ 90° 스퀘어(Square) - 도전을 통한 도약과 내적 연마';
      zodiacDailyNarrative =
          '익숙한 편안함을 넘어 한 단계 성장할 수 있는 역동적인 긴장각입니다. 사소한 걸림돌에 흔들리지 않고 원칙을 지키면 기대 이상의 단단한 결실을 얻습니다.';
    } else if (isOpposition) {
      zodiacAspectTitle = '⚖️ 180° 어포지션(Opposition) - 균형과 객관적 조망의 날';
      zodiacDailyNarrative =
          '상대방의 관점을 깊이 이해하고 조화로운 합의점을 찾을 수 있는 날입니다. 경청과 협력의 자세를 취할 때 모든 갈등이 상생으로 전환됩니다.';
    } else {
      zodiacAspectTitle = '🌿 잔잔한 조화의 흐름 - 안정과 내실을 다지는 날';
      zodiacDailyNarrative =
          '무리한 변화보다는 평소 루틴을 충실히 지킬 때 가장 큰 안정감이 주어집니다. 내면의 소리에 귀 기울이며 영혼의 활력을 충전하세요.';
    }

    if (region != SupportedRegion.korea) {
      zodiacAspectTitle = isTrine
          ? '🌟 120° Trine - Golden Resonance & Harmonic Fortune'
          : (isSextile
              ? '✨ 60° Sextile - Open Pathways of Cosmic Opportunity'
              : (isConjunction
                  ? '☀️ 0° Conjunction - Focused Peak Vitality & Alignment'
                  : '🌿 Harmonic Equilibrium - Centered Clarity & Peace'));
      zodiacDailyNarrative =
          'Cosmic alignments between your natal Sun (${userSunSign.en}) and today\'s celestial positioning highlight opportunities for creative breakthrough and authentic connection.';
    }

    // 4. Eastern Animal Daily Match
    final userAnimal = userPillars.yearPillar.branch.animal;
    final todayAnimal = todayBranch.animal;

    final userAnimalIdx = SajuEngine.branches.indexWhere((b) => b.animal == userAnimal);
    final todayAnimalIdx = todayBranch.branchIndex;

    final samhapGroups = [
      {8, 0, 4}, // 원숭이, 쥐, 용
      {5, 9, 1}, // 뱀, 닭, 소
      {2, 6, 10}, // 호랑이, 말, 개
      {11, 3, 7}, // 돼지, 토끼, 양
    ];
    final isSamhapAnimal = samhapGroups.any((g) => g.contains(userAnimalIdx) && g.contains(todayAnimalIdx) && userAnimalIdx != todayAnimalIdx);
    final isChungAnimal = (userAnimalIdx - todayAnimalIdx).abs() == 6;

    String animalDailyTitle;
    String animalDailyNarrative;

    if (isSamhapAnimal) {
      animalDailyTitle = '🐲 띠별 대길(大吉) 삼합운 - 귀인의 도움과 대도약';
      animalDailyNarrative =
          '오늘의 띠 동물($todayAnimal띠)과 당신의 띠($userAnimal띠)가 천생의 삼합(三合)을 이루어 천우신조의 기운이 깃듭니다. '
          '오후 시간대로 갈수록 풀리지 않던 일이 시원하게 해결되며, 주변 귀인의 든든한 지원을 받게 됩니다.';
    } else if (isChungAnimal) {
      animalDailyTitle = '🛡️ 신중함과 절제의 날 - 내실을 다져 위기를 기회로';
      animalDailyNarrative =
          '오늘의 기운이 당신의 띠 기운과 맞닿아 역동적인 변동성을 예고합니다. 언행을 신중히 하고 서두르지 않는다면 충돌을 피해 현명한 반등의 기회를 잡을 수 있습니다.';
    } else {
      animalDailyTitle = '🌸 평온과 화합의 날 - 성실한 노력이 꽃피는 흐름';
      animalDailyNarrative =
          '당신의 띠($userAnimal띠) 기운이 오늘의 지지와 부드럽게 상생합니다. 아침에 세운 계획을 성실하게 수행하면 저녁 무렵 보람찬 만족감과 기쁜 소식을 접하게 됩니다.';
    }

    if (region != SupportedRegion.korea) {
      animalDailyTitle = isSamhapAnimal
          ? '🐲 Auspicious Celestial Harmony with Today\'s Energy'
          : '🌸 Serene Rhythm & Favorable Momentum';
      animalDailyNarrative =
          'Your birth animal ($userAnimal) resonates harmoniously with today\'s earthly branch currents ($todayAnimal). Cultivating patience early in the day yields fruitful rewards by evening.';
    }

    // 5. Numerology Personal Day
    int universalDay = todayClean.year + todayClean.month + todayClean.day;
    while (universalDay > 9) {
      universalDay = universalDay.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    int personalDay = universalDay + birthDate.month + birthDate.day;
    while (personalDay > 9) {
      personalDay = personalDay.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }

    final numerologyTitles = {
      1: '수비학 1 - 새로운 시작과 개척의 진동수',
      2: '수비학 2 - 협력과 배려, 조화로운 교감의 날',
      3: '수비학 3 - 창의성과 사교, 즐거움의 파동',
      4: '수비학 4 - 질서와 토대, 성실한 완성의 날',
      5: '수비학 5 - 변화와 자유, 모험적 시도의 날',
      6: '수비학 6 - 사랑과 헌신, 가정과 치유의 날',
      7: '수비학 7 - 사색과 통찰, 영적 성장의 날',
      8: '수비학 8 - 권위와 번영, 현실적 성취의 날',
      9: '수비학 9 - 완성 후 정리, 자비와 나눔의 날',
    };
    final numerologyTitle = numerologyTitles[personalDay] ?? '수비학 조율의 날';
    final numerologyNarrative =
        '당신의 생년월일과 오늘 날짜가 엮어낸 고유 진동수는 "$personalDay번"입니다. '
        '이 파동을 온전히 수용하여 오늘 주어지는 소중한 영감에 집중하세요.';

    return DailyTransitData(
      todayDate: todayClean,
      birthDate: birthDate,
      todayDayPillar: todayPillars.dayPillar,
      userPillars: userPillars,
      userElementBalance: userBalance,
      sajuTenGodRelation: tenGodRelation,
      sajuDailyTitle: sajuDailyTitle,
      sajuDailyNarrative: sajuDailyNarrative,
      goldenHours: goldenHours,
      energyWarning: energyWarning,
      actionTip: actionTip,
      userSunSign: userSunSign,
      todaySunSign: todaySunSign,
      zodiacAspectTitle: zodiacAspectTitle,
      zodiacDailyNarrative: zodiacDailyNarrative,
      userAnimal: userAnimal,
      todayAnimal: todayAnimal,
      animalDailyTitle: animalDailyTitle,
      animalDailyNarrative: animalDailyNarrative,
      personalDayNumber: personalDay,
      numerologyTitle: numerologyTitle,
      numerologyNarrative: numerologyNarrative,
    );
  }

  static bool _isGenerating(FiveElement source, FiveElement target) {
    return (source == FiveElement.wood && target == FiveElement.fire) ||
        (source == FiveElement.fire && target == FiveElement.earth) ||
        (source == FiveElement.earth && target == FiveElement.metal) ||
        (source == FiveElement.metal && target == FiveElement.water) ||
        (source == FiveElement.water && target == FiveElement.wood);
  }

  static bool _isOvercoming(FiveElement source, FiveElement target) {
    return (source == FiveElement.wood && target == FiveElement.earth) ||
        (source == FiveElement.earth && target == FiveElement.water) ||
        (source == FiveElement.water && target == FiveElement.fire) ||
        (source == FiveElement.fire && target == FiveElement.metal) ||
        (source == FiveElement.metal && target == FiveElement.wood);
  }
}

extension EarthlyBranchExtension on EarthlyBranch {
  int get branchIndex {
    return SajuEngine.branches.indexOf(this);
  }
}

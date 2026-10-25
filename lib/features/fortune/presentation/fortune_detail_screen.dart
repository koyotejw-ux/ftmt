import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/astronomy/daily_transit_engine.dart';
import '../../../core/astronomy/ephemeris_math.dart';
import '../../../core/astronomy/saju_engine.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../domain/tarot_deck.dart';
import '../domain/tarot_reading_engine.dart';

class FortuneDetailScreen extends StatelessWidget {
  final String title;
  final String category;
  final FortuneSubMenu? menu;
  final List<TarotCard>? selectedTarotCards;
  final DateTime birthTime;
  final String selectedCity;
  final SupportedRegion region;
  final String? userName;

  const FortuneDetailScreen({
    super.key,
    required this.title,
    required this.category,
    this.menu,
    this.selectedTarotCards,
    required this.birthTime,
    this.selectedCity = '서울',
    this.region = SupportedRegion.korea,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveName = (userName != null && userName!.trim().isNotEmpty)
        ? userName!.trim()
        : AppI18n.tr('profile_default_self', region);

    final degreeStr = EphemerisMath.calculatePreciseDegree(birthTime);
    final transit = DailyTransitEngine.calculateDailyTransit(
      birthDate: birthTime,
      region: region,
    );

    return Scaffold(
      backgroundColor: SpaceNavyTheme.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: SpaceNavyTheme.goldChampagne, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$effectiveName · $title',
            style: const TextStyle(
              color: SpaceNavyTheme.goldChampagne,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white70),
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: '[$title] $effectiveName님의 ${AppI18n.tr('share_report_caption', region)} #FortuneMatch',
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trust Anchor Data Box (진태양시 및 천문 좌표 + 오늘 일진)
            GlassBox(
              backgroundColor: const Color(0xFF0D1224).withValues(alpha: 0.8),
              border: Border.all(color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified, color: SpaceNavyTheme.goldChampagne, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'ASTRONOMICAL VERIFIED DATA',
                        style: TextStyle(
                          color: SpaceNavyTheme.goldChampagne,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        selectedCity,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildDataColumn(AppI18n.tr('detail_coords_title', region), degreeStr)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildDataColumn(
                        region == SupportedRegion.korea ? '오늘의 일진 (日辰)' : 'Today\'s Transit Pillar',
                        transit.todayDayPillar.ganji,
                      )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      transit.zodiacAspectTitle,
                      style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // If Saju (만세력), show 4 Pillars Matrix & 5 Elements Radar
            if (menu == FortuneSubMenu.saju) ...[
              _buildFourPillarsSection(context, transit),
              const SizedBox(height: 20),
            ],

            // If Tarot Cards reading
            if (selectedTarotCards != null && selectedTarotCards!.isNotEmpty) ...[
              Text(
                AppI18n.tr('tarot_reading_title', region),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              ...selectedTarotCards!.asMap().entries.map((entry) {
                final idx = entry.key;
                final card = entry.value;
                final phase = [
                  AppI18n.tr('tarot_phase_past', region),
                  AppI18n.tr('tarot_phase_present', region),
                  AppI18n.tr('tarot_phase_future', region),
                ][idx];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF141B33),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: SpaceNavyTheme.goldChampagne),
                          ),
                          child: Center(
                            child: Text(
                              card.runeSymbol,
                              style: const TextStyle(fontSize: 24, color: SpaceNavyTheme.goldChampagne),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                phase,
                                style: const TextStyle(
                                  color: Color(0xFF00E5FF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                region == SupportedRegion.korea ? card.nameKo : card.nameEn,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card.localizedUprightMeaning(region),
                                style: const TextStyle(
                                  color: Color(0xFF9AA7C7),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              _buildTarotComprehensiveInterpretation(context),
            ] else ...[
              // Destiny Report
              Text(
                '$effectiveName님의 ${AppI18n.tr('detail_destiny_report', region)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              GlassBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: SpaceNavyTheme.goldChampagne, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getPersonalizedSectionTitle(transit),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getPersonalizedDestinyDesc(transit, effectiveName),
                      style: const TextStyle(color: Color(0xFFF0F4FC), fontSize: 14, height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_outlined, color: Color(0xFF00E5FF), size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _getPersonalizedRemedy(transit),
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFourPillarsSection(BuildContext context, DailyTransitData transit) {
    final pillars = transit.userPillars;
    final balance = transit.userElementBalance;

    return GlassBox(
      padding: const EdgeInsets.all(16),
      backgroundColor: const Color(0xFF0F1528).withValues(alpha: 0.85),
      border: Border.all(color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_stories, color: SpaceNavyTheme.goldChampagne, size: 18),
              const SizedBox(width: 8),
              const Text(
                '명리학 4주 8자 만세력 정밀 원국표',
                style: TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildPillarColumn('시주 (時柱)', pillars.hourPillar),
              _buildPillarColumn('일주 (日柱)', pillars.dayPillar, isDayMaster: true),
              _buildPillarColumn('월주 (月柱)', pillars.monthPillar),
              _buildPillarColumn('년주 (年柱)', pillars.yearPillar),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 14),
          const Text(
            '오행(五行: 목·화·토·금·수) 에너지 밸런스',
            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...FiveElement.values.map((elem) {
            final pct = balance[elem] ?? 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      elem.ko,
                      style: TextStyle(color: Color(elem.colorValue), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(elem.colorValue)),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(pct * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPillarColumn(String label, Pillar pillar, {bool isDayMaster = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isDayMaster ? SpaceNavyTheme.goldChampagne.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDayMaster ? SpaceNavyTheme.goldChampagne : Colors.white12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: isDayMaster ? SpaceNavyTheme.goldChampagne : Colors.white38, fontSize: 11, fontWeight: isDayMaster ? FontWeight.bold : FontWeight.normal),
            ),
            const SizedBox(height: 6),
            Text(
              pillar.stem.char,
              style: TextStyle(color: Color(pillar.stem.element.colorValue), fontSize: 18, fontWeight: FontWeight.w900),
            ),
            Text(
              '${pillar.stem.name} (${pillar.stem.element.ko.split('(').first})',
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
            const SizedBox(height: 6),
            Text(
              pillar.branch.char,
              style: TextStyle(color: Color(pillar.branch.element.colorValue), fontSize: 18, fontWeight: FontWeight.w900),
            ),
            Text(
              '${pillar.branch.name} (${pillar.branch.animal})',
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  String _getPersonalizedSectionTitle(DailyTransitData transit) {
    if (category == 'Dopamine Snack') {
      return '⚡ 오늘의 재물 골든타임 & 행동 가이드';
    }

    if (region == SupportedRegion.korea) {
      if (menu == FortuneSubMenu.saju) {
        return '✦ 정통 사주 명식과 오늘의 십신(十神) 상호작용';
      } else if (menu == FortuneSubMenu.tojeong) {
        return '📜 ${transit.todayDate.year}년 신년 토정비결 총운과 월별 비결';
      } else if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        return '${transit.userSunSign.symbol} ${transit.userSunSign.ko} 천문 트랜짓 심층 분석';
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return transit.animalDailyTitle;
      } else if (menu == FortuneSubMenu.numerology) {
        return transit.numerologyTitle;
      } else if (menu == FortuneSubMenu.celticRunes) {
        return '고대 켈틱 룬의 신성한 신탁';
      } else if (menu == FortuneSubMenu.rokusei) {
        return '롯세이센주츠(六星占術) 운명 주기 분석';
      } else if (menu == FortuneSubMenu.kigaku) {
        return '구성기학(九星気学) 본명성과 방위운';
      }
    } else {
      if (menu == FortuneSubMenu.saju) {
        return '✦ Traditional Bazi Blueprint & Daily Ten-God Transit';
      } else if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        return '${transit.userSunSign.symbol} ${transit.userSunSign.localizedName(region)} Astrological Synthesis';
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return transit.animalDailyTitle;
      } else if (menu == FortuneSubMenu.numerology) {
        return transit.numerologyTitle;
      }
    }
    return AppI18n.tr('detail_nature_flow', region);
  }

  String _getPersonalizedDestinyDesc(DailyTransitData transit, String name) {
    if (category == 'Dopamine Snack') {
      return '$name님의 오늘의 황금 재물 시간대는 [${transit.goldenHours}]입니다. '
          '이 시간에는 직관력과 추진력이 극대화되므로 중요한 업무, 미팅, 투자 및 제안을 집중적으로 배치하세요.\n\n'
          '${transit.actionTip}\n\n${transit.energyWarning}';
    }

    if (region == SupportedRegion.korea) {
      if (menu == FortuneSubMenu.saju) {
        final dayMaster = transit.userPillars.dayPillar.stem;
        return '$name님의 일간(日干)은 [${dayMaster.char} ${dayMaster.name}(${dayMaster.element.ko})]입니다. '
            '오늘의 일진(${transit.todayDayPillar.ganji})과 상호작용하여 "${transit.sajuTenGodRelation}"의 기운이 형성됩니다.\n\n'
            '${transit.sajuDailyNarrative}\n\n'
            '오행의 분포에 따르면, 스스로의 중심을 굳건히 지키고 실속을 차릴 때 가장 큰 성공운과 귀인의 조력이 함께합니다.';
      } else if (menu == FortuneSubMenu.tojeong) {
        return '$name님의 ${transit.todayDate.year}년 토정비결 괘상은 [상길(上吉) 화풍정 괘]의 평온한 기운을 띱니다. '
            '상반기에는 뿌리를 내리고 초석을 다지며, 가을철(8~10월)에 이르러 노력했던 프로젝트와 재물이 만개하는 형국입니다. '
            '가까운 사람과의 신의를 지키고 조급증을 멀리하면 일년 내내 만사형통의 복록이 깃듭니다.';
      } else if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        return '$name님의 태양 별자리 [${transit.userSunSign.ko}]와 오늘의 천체 배치가 다음과 같은 운을 형성합니다.\n\n'
            '${transit.zodiacDailyNarrative}\n\n'
            '내면의 나침반을 믿고 오늘 주어진 기회의 창을 적극적으로 활용하세요.';
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return transit.animalDailyNarrative;
      } else if (menu == FortuneSubMenu.numerology) {
        return transit.numerologyNarrative;
      } else if (menu == FortuneSubMenu.celticRunes) {
        return '고대 북유럽 룬의 신비로운 상징이 $name님의 수호 에너지를 감싸고 있습니다. 내면의 소리에 귀 기울이고 신념을 행동으로 옮길 때 우주의 지혜가 당신을 올바른 길로 인도합니다.';
      } else if (menu == FortuneSubMenu.rokusei) {
        return '롯세이센주츠(六星占術)의 대운 흐름에 따르면, $name님의 운명성은 현재 잠재된 씨앗이 단단한 뿌리를 내리는 안정기(安定期)에 머물고 있습니다. 무리한 확장보다 약속과 신용을 중시할 때 재물과 명예가 크게 번창합니다.';
      } else if (menu == FortuneSubMenu.kigaku) {
        return '구성기학(九星気学) 본명성과 월명성의 방위 기운이 조화롭게 작용하고 있습니다. 동남쪽의 활발한 생기(生氣)를 품고 있으므로 적극적인 교류와 활동을 펼칠 때 뜻밖의 큰 조력자를 만나게 됩니다.';
      }
    } else {
      if (menu == FortuneSubMenu.saju) {
        return 'Under the Four Pillars system, your Day Master resonates with ${transit.userPillars.dayPillar.stem.element.en}. '
            'Today\'s transit activates "${transit.sajuTenGodRelation}".\n\n${transit.sajuDailyNarrative}';
      } else if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        return transit.zodiacDailyNarrative;
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return transit.animalDailyNarrative;
      } else if (menu == FortuneSubMenu.numerology) {
        return transit.numerologyNarrative;
      }
    }
    return AppI18n.tr('detail_nature_flow_desc', region);
  }

  String _getPersonalizedRemedy(DailyTransitData transit) {
    if (region == SupportedRegion.korea) {
      if (menu == FortuneSubMenu.saju) {
        final elem = transit.userPillars.dayPillar.stem.element;
        switch (elem) {
          case FiveElement.wood:
            return '사주 개운 처방: 맑은 녹차와 오전 가벼운 산책으로 목(木) 기운의 생명력을 북돋우세요.';
          case FiveElement.fire:
            return '사주 개운 처방: 밝은 미소와 긍정적인 언어로 화(火) 기운의 카리스마를 온화하게 발휘하세요.';
          case FiveElement.earth:
            return '사주 개운 처방: 차분한 명상과 단정한 옷차림으로 토(土) 기운의 든든한 신뢰를 다지세요.';
          case FiveElement.metal:
            return '사주 개운 처방: 깔끔한 정리정돈과 명확한 우선순위 설정으로 금(金) 기운의 결단력을 높이세요.';
          case FiveElement.water:
            return '사주 개운 처방: 충분한 수분 섭취와 잔잔한 음악으로 수(水) 기운의 깊은 지혜를 순환시키세요.';
        }
      } else if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        return '별자리 개운 처방: 오늘 골든타임(${transit.goldenHours})에 맞추어 가장 중요한 한 가지 결정을 단호히 실행하세요.';
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return '12간지 개운 처방: 아침 기상 시 동쪽을 바라보며 심호흡 3회를 하고, 밝은 인사로 좋은 인연을 맞이하세요.';
      } else if (menu == FortuneSubMenu.numerology) {
        return '수비학 조율 처방: 당신의 오늘의 진동수(${transit.personalDayNumber}번)에 집중하며 목표를 금색이나 청색 펜으로 기록하세요.';
      }
    }
    return AppI18n.tr('detail_remedy_title', region);
  }

  Widget _buildTarotComprehensiveInterpretation(BuildContext context) {
    if (selectedTarotCards == null || selectedTarotCards!.isEmpty) {
      return const SizedBox.shrink();
    }

    final reading = TarotReadingEngine.analyzeThreeCards(
      selectedTarotCards!,
      region: region,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          region == SupportedRegion.korea
              ? '✦ 3-Card 시간 흐름 종합 운세 풀이'
              : '✦ 3-Card Comprehensive Destiny Synthesis',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GlassBox(
          backgroundColor: const Color(0xFF0F1528).withValues(alpha: 0.85),
          border: Border.all(color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.7)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: SpaceNavyTheme.goldChampagne, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reading.flowTitle,
                      style: const TextStyle(
                        color: SpaceNavyTheme.goldChampagne,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                reading.flowNarrative,
                style: const TextStyle(
                  color: Color(0xFFF0F4FC),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.favorite, color: Color(0xFFFF4081), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region == SupportedRegion.korea ? '애정 & 대인관계 흐름' : 'Love & Relationships',
                          style: const TextStyle(
                            color: Color(0xFFFF4081),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reading.loveAndRelationshipAdvice,
                          style: const TextStyle(color: Color(0xFFD6DFEF), fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.monetization_on, color: Color(0xFF00E5FF), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region == SupportedRegion.korea ? '직업 & 재물 비전' : 'Career & Wealth Vision',
                          style: const TextStyle(
                            color: Color(0xFF00E5FF),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reading.careerAndFinanceAdvice,
                          style: const TextStyle(color: Color(0xFFD6DFEF), fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.4)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb, color: SpaceNavyTheme.goldChampagne, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reading.coreActionTip,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

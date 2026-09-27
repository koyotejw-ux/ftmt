import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../../core/astronomy/ephemeris_math.dart';
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

  const FortuneDetailScreen({
    super.key,
    required this.title,
    required this.category,
    this.menu,
    this.selectedTarotCards,
    required this.birthTime,
    this.selectedCity = '서울',
    this.region = SupportedRegion.korea,
  });

  @override
  Widget build(BuildContext context) {
    final degreeStr = EphemerisMath.calculatePreciseDegree(birthTime);
    final aspectStr = EphemerisMath.detectMajorAspect(birthTime, region);

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
            title,
            style: const TextStyle(
              color: SpaceNavyTheme.goldChampagne,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white70),
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: '[$title] ${AppI18n.tr('share_report_caption', region)} #FortuneMatch',
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
            // Trust Anchor Data Box (진태양시 및 천문 좌표)
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
                      Expanded(child: _buildDataColumn(AppI18n.tr('detail_offset_title', region), AppI18n.tr('detail_time_offset', region))),
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
                      AppI18n.tr('detail_reference_label', region).replaceAll('{aspect}', aspectStr),
                      style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

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
              // 3-Card 시간 흐름 종합 운세 풀이 및 행동 가이드
              _buildTarotComprehensiveInterpretation(context),
            ] else ...[
              // Saju & Deep Destiny Report
              Text(
                AppI18n.tr('detail_destiny_report', region),
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
                            _getPersonalizedSectionTitle(),
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
                      _getPersonalizedDestinyDesc(),
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
                              _getPersonalizedRemedy(),
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

  String _getPersonalizedSectionTitle() {
    final sunSign = EphemerisMath.getSunSign(birthTime);
    if (region == SupportedRegion.korea) {
      if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        return '${sunSign.symbol} ${sunSign.ko}(${sunSign.en}) 천문 차트 심층 분석';
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return '12간지 태세운(太歲運)과 일일 길흉';
      } else if (menu == FortuneSubMenu.numerology) {
        return '수비학 운명수(Life Path) 영혼의 사명';
      } else if (menu == FortuneSubMenu.celticRunes) {
        return '고대 켈틱 룬의 신성한 신탁';
      } else if (menu == FortuneSubMenu.rokusei) {
        return '롯세이센주츠(六星占術) 운명 주기 분석';
      } else if (menu == FortuneSubMenu.kigaku) {
        return '구성기학(九星気学) 본명성과 방위운';
      }
    } else {
      if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        return '${sunSign.symbol} ${sunSign.localizedName(region)} Astrological Synthesis';
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return 'Celestial Animal Energy & Auspicious Hours';
      } else if (menu == FortuneSubMenu.numerology) {
        return 'Life Path Numerology & Soul Mission';
      } else if (menu == FortuneSubMenu.celticRunes) {
        return 'Sacred Celtic Rune Oracle';
      } else if (menu == FortuneSubMenu.rokusei) {
        return 'Rokusei Destiny Cycle Analysis';
      } else if (menu == FortuneSubMenu.kigaku) {
        return 'Nine Star Ki Directional Auspice';
      }
    }
    return AppI18n.tr('detail_nature_flow', region);
  }

  String _getPersonalizedDestinyDesc() {
    final sunSign = EphemerisMath.getSunSign(birthTime);
    if (region == SupportedRegion.korea) {
      if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        switch (sunSign) {
          case WesternZodiac.aries:
            return '양자리(Aries)의 불꽃 같은 에너지가 제1하우스를 비추고 있습니다. 정체되었던 흐름을 한 번에 뒤집는 강력한 추진력과 개척자적인 영감이 발휘되는 시기입니다. 당신의 직관을 믿고 첫 발을 내딛으세요.';
          case WesternZodiac.taurus:
            return '황소자리(Taurus)의 든든한 흙(Earth) 에너지가 물질적 풍요와 안정된 결실을 불러옵니다. 조급해하지 않고 한 걸음씩 다져나갈 때 주변의 신뢰와 큰 재물운이 함께 들어옵니다.';
          case WesternZodiac.gemini:
            return '쌍둥이자리(Gemini)의 기민한 바람(Air) 기운이 활발한 지적 탐구와 커뮤니케이션의 문을 엽니다. 뜻밖의 만남과 대화 속에서 인생의 새로운 비전과 프로젝트의 열쇠를 얻게 됩니다.';
          case WesternZodiac.cancer:
            return '게자리(Cancer)의 따뜻한 물(Water) 에너지가 깊은 공감력과 사람을 끌어당기는 자석 같은 매력을 발산합니다. 소중한 사람들과의 연대를 다질 때 마음의 평화와 성공이 함께 깃듭니다.';
          case WesternZodiac.leo:
            return '사자자리(Leo)의 황금빛 태양 에너지가 당신을 무대의 중심으로 이끕니다. 당당한 자신감과 품격 있는 카리스마로 주변을 이끌며, 스스로 빛을 낼 때 모든 일이 순조롭게 풀립니다.';
          case WesternZodiac.virgo:
            return '처녀자리(Virgo)의 섬세하고 명석한 분석력이 복잡한 난제를 깔끔하게 해결합니다. 작은 디테일까지 챙기는 당신의 성실함이 최고의 완성도를 만들어내며 두터운 인정을 받습니다.';
          case WesternZodiac.libra:
            return '천칭자리(Libra)의 조화와 미적 균형 감각이 대인관계에서 큰 행운을 가져다줍니다. 갈등을 부드럽게 조율하고 윈-윈(Win-Win) 관계를 형성하는 탁월한 외교력이 빛납니다.';
          case WesternZodiac.scorpio:
            return '전갈자리(Scorpio)의 응축된 심층 에너지가 불굴의 집중력과 통찰력을 부여합니다. 본질을 꿰뚫어보는 직관으로 핵심 기회를 포착하며, 강렬한 변혁을 이뤄낼 운명입니다.';
          case WesternZodiac.sagittarius:
            return '사수자리(Sagittarius)의 자유로운 이상과 모험심이 새로운 지평을 열어줍니다. 익숙한 틀을 벗어나 넓은 세상과 미래 지향적 지식을 받아들일 때 가장 큰 도약이 일어납니다.';
          case WesternZodiac.capricorn:
            return '염소자리(Capricorn)의 견고한 책임감과 인내력이 마침내 커다란 성취의 결실로 이어집니다. 차근차근 쌓아올린 실력이 권위와 명예를 가져다주는 안정된 운의 흐름입니다.';
          case WesternZodiac.aquarius:
            return '물병자리(Aquarius)의 독창적인 미래 통찰력과 진보적 아이디어가 시대를 앞서갑니다. 남들과 다른 독특한 시각을 두려워하지 않고 발휘할 때 커다란 변화와 혁신을 이끕니다.';
          case WesternZodiac.pisces:
            return '물고기자리(Pisces)의 풍부한 영적 감수성과 창의적 직관이 마르지 않는 영감을 공급합니다. 사람들의 마음을 치유하고 감동을 주는 따뜻한 흐름이 당신을 지켜줍니다.';
        }
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return '오늘 당신의 띠 기운은 천간과 지지가 부드럽게 상생하는 길한 형국입니다. 경솔한 판단을 피하고 내실을 다지면 오후 시간대에 뜻밖의 귀인이나 기쁜 소식을 접하게 됩니다.';
      } else if (menu == FortuneSubMenu.numerology) {
        return '당신의 생년월일에 깃든 수비학 운명수는 세상을 변화시키는 특별한 파동을 지니고 있습니다. 흔들리지 않는 자기 확신을 갖고 나아갈 때 숨겨진 잠재력과 영적 사명이 활짝 피어납니다.';
      } else if (menu == FortuneSubMenu.celticRunes) {
        return '고대 북유럽 룬의 신비로운 상징이 당신의 수호 에너지를 감싸고 있습니다. 내면의 소리에 귀 기울이고 신념을 행동으로 옮길 때 우주의 지혜가 당신을 올바른 길로 인도합니다.';
      } else if (menu == FortuneSubMenu.rokusei) {
        return '롯세이센주츠(六星占術)의 대운 흐름에 따르면, 당신의 운명성은 현재 잠재된 씨앗이 단단한 뿌리를 내리는 안정기(安定期)에 머물고 있습니다. 무리한 확장보다 약속과 신용을 중시할 때 재물과 명예가 크게 번창합니다.';
      } else if (menu == FortuneSubMenu.kigaku) {
        return '구성기학(九星気学) 본명성과 월명성의 방위 기운이 조화롭게 작용하고 있습니다. 동남쪽의 활발한 생기(生氣)를 품고 있으므로 적극적인 교류와 활동을 펼칠 때 뜻밖의 큰 조력자를 만나게 됩니다.';
      }
    } else {
      if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        switch (sunSign) {
          case WesternZodiac.aries:
            return 'Aries pioneer fire radiates through your 1st House of sovereignty. Breakthrough momentum shatters stagnant obstacles. Trust your instinctive leadership and initiate bold moves with confidence.';
          case WesternZodiac.taurus:
            return 'Taurus grounded Earth frequency anchors enduring abundance and physical well-being. Patient persistence and deliberate craftsmanship earn unshakeable trust and prosperous opportunities.';
          case WesternZodiac.gemini:
            return 'Gemini versatile Air currents unlock brilliant intellectual curiosity and vibrant dialogue. Serendipitous encounters and honest exchanges illuminate pivotal keys for creative projects.';
          case WesternZodiac.cancer:
            return 'Cancer nurturing Water resonance radiates deep emotional intelligence and protective warmth. Fortifying heartfelt bonds with loved ones creates unshakeable security and peace.';
          case WesternZodiac.leo:
            return 'Leo radiant Solar majesty illuminates your center stage. Leading with dignified generosity and authentic charisma naturally magnetizes respect and triumphant success.';
          case WesternZodiac.virgo:
            return 'Virgo refined discernment effortlessly untangles intricate challenges. Your devotion to meticulous quality and thoughtful service earns prestigious acclaim and lasting order.';
          case WesternZodiac.libra:
            return 'Libra aesthetic grace and harmonic balance attract auspicious synchronicity in relationships. Gentle diplomacy and fair-minded mediation turn friction into cooperative prosperity.';
          case WesternZodiac.scorpio:
            return 'Scorpio concentrated depth channels unwavering willpower and profound psychological insight. Piercing through surface noise unlocks transformative power and sovereign breakthroughs.';
          case WesternZodiac.sagittarius:
            return 'Sagittarius expansive optimism blazes trails toward visionary frontiers. Transcending conventional comfort zones to embrace higher wisdom catalyzes your highest evolution.';
          case WesternZodiac.capricorn:
            return 'Capricorn structured mastery and steadfast endurance crystallize into monumental accomplishment. Methodical discipline secures enduring authority and generational legacy.';
          case WesternZodiac.aquarius:
            return 'Aquarius progressive visionary frequency pioneers tomorrow\'s breakthroughs today. Unapologetic originality and humanitarian ideals spark revolutionary innovation.';
          case WesternZodiac.pisces:
            return 'Pisces boundless spiritual empathy and intuitive artistry channel continuous divine inspiration. Gentle compassion and quiet contemplation protect your sacred vitality.';
        }
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return 'Cosmic alignments between your birth animal and seasonal currents create favorable momentum. Mindful patience during early hours yields auspicious supporters by afternoon.';
      } else if (menu == FortuneSubMenu.numerology) {
        return 'Your sacred birth numbers resonate with a unique vibrational code destined to inspire others. Unwavering self-belief unlocks your latent spiritual mission.';
      } else if (menu == FortuneSubMenu.celticRunes) {
        return 'Sacred runic sigils cloak your energetic field with primordial wisdom. Listening deeply to your inner guidance navigates you effortlessly onto your true north.';
      } else if (menu == FortuneSubMenu.rokusei) {
        return 'Your destiny star currently navigates a stabilizing consolidation cycle. Prioritizing integrity and honoring commitments generates compounding long-term prosperity.';
      } else if (menu == FortuneSubMenu.kigaku) {
        return 'Harmonic directional currents amplify your vitality. Welcoming new social interactions brings valuable mentors and auspicious connections.';
      }
    }
    return AppI18n.tr('detail_nature_flow_desc', region);
  }

  String _getPersonalizedRemedy() {
    final sunSign = EphemerisMath.getSunSign(birthTime);
    if (region == SupportedRegion.korea) {
      if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        switch (sunSign) {
          case WesternZodiac.aries:
          case WesternZodiac.leo:
          case WesternZodiac.sagittarius:
            return '원소 개운 처방: 불(Fire)의 열정을 다스리기 위해 맑은 허브차와 햇빛 산책으로 활력을 순환시키세요.';
          case WesternZodiac.taurus:
          case WesternZodiac.virgo:
          case WesternZodiac.capricorn:
            return '원소 개운 처방: 흙(Earth)의 안정감을 위해 차분한 목재 소품이나 녹색 식물을 시야에 배치하세요.';
          case WesternZodiac.gemini:
          case WesternZodiac.libra:
          case WesternZodiac.aquarius:
            return '원소 개운 처방: 바람(Air)의 상쾌한 소통을 위해 은은한 시트러스 향과 환기로 생각을 맑게 하세요.';
          case WesternZodiac.cancer:
          case WesternZodiac.scorpio:
          case WesternZodiac.pisces:
            return '원소 개운 처방: 물(Water)의 깊은 정서를 위해 따뜻한 반신욕과 잔잔한 음악으로 에너지를 충전하세요.';
        }
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return '12간지 개운 처방: 아침 기상 시 동쪽을 바라보며 심호흡 3회를 하고, 밝은 미소로 첫 인사를 건네보세요.';
      } else if (menu == FortuneSubMenu.numerology) {
        return '수비학 조율 처방: 당신의 고유 수비학 진동수에 맞춰 중요한 메모나 숫자를 기록할 때 금색/청색 펜을 활용하세요.';
      } else if (menu == FortuneSubMenu.celticRunes) {
        return '룬 신탁 개운 처방: 자연의 소리(바람, 물소리)를 배경 삼아 5분간 명상하며 마음의 나침반을 정렬하세요.';
      } else if (menu == FortuneSubMenu.rokusei) {
        return '롯세이센주츠 처방: 감정의 기복을 조절하기 위해 책상 정리정돈과 정갈한 차 한 잔으로 운의 흐름을 정화하세요.';
      } else if (menu == FortuneSubMenu.kigaku) {
        return '구성기학 방위 처방: 출근 및 외출 시 환한 미소와 함께 동남쪽으로 가벼운 발걸음을 내딛으세요.';
      }
    } else {
      if (menu == FortuneSubMenu.dailyHoroscope || menu == FortuneSubMenu.natalChart) {
        switch (sunSign) {
          case WesternZodiac.aries:
          case WesternZodiac.leo:
          case WesternZodiac.sagittarius:
            return 'Elemental Remedy: Harmonize fiery drive with soothing herbal infusions and gentle morning walks in natural sunlight.';
          case WesternZodiac.taurus:
          case WesternZodiac.virgo:
          case WesternZodiac.capricorn:
            return 'Elemental Remedy: Ground Earth stability by placing tactile natural wood accessories or vibrant green plants in your sanctuary.';
          case WesternZodiac.gemini:
          case WesternZodiac.libra:
          case WesternZodiac.aquarius:
            return 'Elemental Remedy: Clarify Air thoughts with refreshing citrus aromas and regular ventilation of your living space.';
          case WesternZodiac.cancer:
          case WesternZodiac.scorpio:
          case WesternZodiac.pisces:
            return 'Elemental Remedy: Recharge Water intuition through warm restorative baths paired with serene ambient music.';
        }
      } else if (menu == FortuneSubMenu.dailyZodiacAnimal) {
        return 'Harmonic Practice: Take three deep mindful breaths facing East at sunrise, greeting the day with a warm, open smile.';
      } else if (menu == FortuneSubMenu.numerology) {
        return 'Vibrational Practice: Use a gold or royal blue pen when noting pivotal goals aligned with your Life Path vibration.';
      } else if (menu == FortuneSubMenu.celticRunes) {
        return 'Oracle Practice: Meditate for five minutes immersed in natural ambient sounds (wind, flowing water) to recalibrate your inner compass.';
      } else if (menu == FortuneSubMenu.rokusei) {
        return 'Destiny Practice: Calm emotional fluctuations with clean desktop organization and a quiet cup of ceremonial tea.';
      } else if (menu == FortuneSubMenu.kigaku) {
        return 'Directional Practice: Step forward with an optimistic posture and mindful awareness towards auspicious horizons.';
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
              // Flow Title
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
              // Narrative
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

              // Love & Relationship advice
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

              // Career & Finance advice
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

              // Core Action Tip Box
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

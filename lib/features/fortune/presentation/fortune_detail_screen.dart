import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../../core/astronomy/ephemeris_math.dart';
import '../domain/tarot_deck.dart';

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
    final aspectStr = EphemerisMath.detectMajorAspect(birthTime);

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
                  text: '[$title] 나의 고품격 심층 운세 리포트! #FortuneMatch',
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
                                card.uprightMeaning,
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
    return AppI18n.tr('detail_nature_flow', region);
  }

  String _getPersonalizedDestinyDesc() {
    final sunSign = EphemerisMath.getSunSign(birthTime);
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
    }
    return AppI18n.tr('detail_nature_flow_desc', region);
  }

  String _getPersonalizedRemedy() {
    final sunSign = EphemerisMath.getSunSign(birthTime);
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
    }
    return AppI18n.tr('detail_remedy_title', region);
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

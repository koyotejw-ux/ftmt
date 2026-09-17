import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../../core/astronomy/ephemeris_math.dart';
import '../domain/tarot_deck.dart';

class FortuneDetailScreen extends StatelessWidget {
  final String title;
  final String category;
  final List<TarotCard>? selectedTarotCards;
  final DateTime birthTime;
  final String selectedCity;

  const FortuneDetailScreen({
    super.key,
    required this.title,
    required this.category,
    this.selectedTarotCards,
    required this.birthTime,
    this.selectedCity = '서울',
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
        title: Text(
          title,
          style: const TextStyle(
            color: SpaceNavyTheme.goldChampagne,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
                      const SizedBox(width: 6),
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
                      _buildDataColumn('정밀 천문 좌표', degreeStr),
                      _buildDataColumn('표준시 오차', '동경 135° 기준 -32분 보정'),
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
                      '원전 레퍼런스: 적천수(滴天髓) 원리 및 $aspectStr',
                      style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // If Tarot Cards reading
            if (selectedTarotCards != null && selectedTarotCards!.isNotEmpty) ...[
              const Text(
                '3-Card 타로 심층 리딩 (과거 · 현재 · 미래)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              ...selectedTarotCards!.asMap().entries.map((entry) {
                final idx = entry.key;
                final card = entry.value;
                final phase = ['과거의 근원 (Past)', '현재의 운명 (Present)', '미래의 결실 (Future)'][idx];

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
                                card.nameKo,
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
              const Text(
                '심층 운명 분석 리포트',
                style: TextStyle(
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
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: SpaceNavyTheme.goldChampagne, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '타고난 천명과 현재 운의 흐름',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '당신의 일주는 깊은 지하수를 뚫고 솟아오르는 강력한 용출수의 기운을 품고 있습니다. '
                      '정체된 상황을 돌파하는 직관력과 기획력이 뛰어나며, 타인에게 의존하기보다 스스로 길을 개척할 때 가장 큰 성공운이 따릅니다.',
                      style: TextStyle(color: Color(0xFFF0F4FC), fontSize: 14, height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: Color(0xFF00E5FF), size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '황금빛 개운 처방: 서쪽 방향의 업무 공간에서 골드/화이트 계열의 소품을 가까이 두세요.',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
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

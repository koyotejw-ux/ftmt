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
  final List<TarotCard>? selectedTarotCards;
  final DateTime birthTime;
  final String selectedCity;
  final SupportedRegion region;

  const FortuneDetailScreen({
    super.key,
    required this.title,
    required this.category,
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
                      _buildDataColumn(AppI18n.tr('detail_coords_title', region), degreeStr),
                      _buildDataColumn(AppI18n.tr('detail_offset_title', region), AppI18n.tr('detail_time_offset', region)),
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
                            AppI18n.tr('detail_nature_flow', region),
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
                      AppI18n.tr('detail_nature_flow_desc', region),
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
                              AppI18n.tr('detail_remedy_title', region),
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

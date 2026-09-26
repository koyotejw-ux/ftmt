import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/space_navy_theme.dart';
import 'radar_chart_view.dart';

class StoryShareDialog extends StatelessWidget {
  final String title;
  final String personA;
  final String personB;
  final int score;
  final String headline;
  final Map<String, double> radarData;
  final SupportedRegion region;

  const StoryShareDialog({
    super.key,
    required this.title,
    required this.personA,
    required this.personB,
    required this.score,
    required this.headline,
    required this.radarData,
    this.region = SupportedRegion.korea,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String personA,
    required String personB,
    required int score,
    required String headline,
    required Map<String, double> radarData,
    SupportedRegion region = SupportedRegion.korea,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: StoryShareDialog(
          title: title,
          personA: personA,
          personB: personB,
          score: score,
          headline: headline,
          radarData: radarData,
          region: region,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxCardHeight = (screenHeight * 0.78).clamp(420.0, 700.0);

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Responsive Card
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxCardHeight,
                maxWidth: maxCardHeight * (9 / 16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF070A12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.6), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF8A2BE2).withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Watermark Branding
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: SpaceNavyTheme.goldChampagne,
                                    ),
                                    child: const Center(
                                      child: Text('✦', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'FortuneMatch',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'VERIFIED RESULT',
                                  style: TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),

                          // Match Pair Tags
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(child: _buildProfileBadge(personA)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.favorite, color: Colors.pinkAccent, size: 18),
                              ),
                              Flexible(child: _buildProfileBadge(personB)),
                            ],
                          ),

                          // Score
                          Column(
                            children: [
                              Text(
                                '$score',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: SpaceNavyTheme.goldChampagne,
                                  letterSpacing: -2,
                                ),
                              ),
                              const Text(
                                'CHEMISTRY SCORE',
                                style: TextStyle(
                                  color: SpaceNavyTheme.cyanNeon,
                                  fontSize: 9,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            headline,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),

                          // 5-Axis Radar Chart
                          FittedBox(
                            child: RadarChartView(
                              values: radarData,
                              size: 140,
                              polygonColor: SpaceNavyTheme.goldChampagne,
                            ),
                          ),

                          // Bottom Trust stamp
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Text(
                              AppI18n.tr('share_dialog_certified', region),
                              style: const TextStyle(color: Colors.white60, fontSize: 9),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Action Buttons: Instagram Story Share & Close
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5C07B),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text: AppI18n.tr('share_match_caption', region)
                            .replaceAll('{title}', title)
                            .replaceAll('{personA}', personA)
                            .replaceAll('{personB}', personB)
                            .replaceAll('{score}', score.toString()),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share, size: 16),
                  label: Text(
                    AppI18n.tr('share_dialog_story_btn', region),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white12,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBadge(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF141B33),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SpaceNavyTheme.goldBorder),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

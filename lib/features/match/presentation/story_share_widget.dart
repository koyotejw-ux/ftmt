import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/space_navy_theme.dart';
import 'radar_chart_view.dart';

class StoryShareDialog extends StatelessWidget {
  final String title;
  final String personA;
  final String personB;
  final int score;
  final String headline;
  final Map<String, double> radarData;

  const StoryShareDialog({
    super.key,
    required this.title,
    required this.personA,
    required this.personB,
    required this.score,
    required this.headline,
    required this.radarData,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String personA,
    required String personB,
    required int score,
    required String headline,
    required Map<String, double> radarData,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 9:16 Aspect Ratio Viral Card
        AspectRatio(
          aspectRatio: 9 / 16,
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
                // Mystical background star aura
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Watermark Branding
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SpaceNavyTheme.goldChampagne,
                                ),
                                child: const Center(
                                  child: Text('✦', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'FortuneMatch',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'VERIFIED RESULT',
                              style: TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Match Pair Tags
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildProfileBadge(personA),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.favorite, color: Colors.pinkAccent, size: 22),
                          ),
                          _buildProfileBadge(personB),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Score Circle
                      Text(
                        '$score',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: SpaceNavyTheme.goldChampagne,
                          letterSpacing: -2,
                        ),
                      ),
                      const Text(
                        'CHEMISTRY SCORE',
                        style: TextStyle(
                          color: SpaceNavyTheme.cyanNeon,
                          fontSize: 10,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        headline,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 5-Axis Radar Chart
                      RadarChartView(
                        values: radarData,
                        size: 160,
                        polygonColor: SpaceNavyTheme.goldChampagne,
                      ),

                      const Spacer(),

                      // Bottom Trust stamp
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: const Text(
                          '태양시 경도 보정 및 16 성격 다차원 매트릭스 공식 인증',
                          style: TextStyle(color: Colors.white60, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Action Buttons: Instagram Story Share & Close
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5C07B),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(
                    text: '[$title] $personA x $personB 궁합 지수는 무려 $score점! ✨\n#FortuneMatch #포춘매치 #운세궁합',
                  ),
                );
              },
              icon: const Icon(Icons.share, size: 18),
              label: const Text('스토리 공유하기', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
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
    );
  }

  Widget _buildProfileBadge(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141B33),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SpaceNavyTheme.goldBorder),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

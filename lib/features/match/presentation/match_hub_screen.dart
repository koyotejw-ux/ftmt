import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../domain/sixteen_type_matrix.dart';
import 'radar_chart_view.dart';
import 'story_share_widget.dart';

class MatchHubScreen extends StatefulWidget {
  final SupportedRegion currentRegion;

  const MatchHubScreen({super.key, required this.currentRegion});

  @override
  State<MatchHubScreen> createState() => _MatchHubScreenState();
}

class _MatchHubScreenState extends State<MatchHubScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sparkController;

  String _typeA = 'ENFP';
  String _typeB = 'INTJ';

  MatchResult? _matchResult;

  @override
  void initState() {
    super.initState();
    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _calculateMatch();
  }

  @override
  void dispose() {
    _sparkController.dispose();
    super.dispose();
  }

  void _calculateMatch() {
    setState(() {
      _matchResult = SixteenTypeMatrix.calculateChemistry(_typeA, _typeB);
    });
  }

  @override
  Widget build(BuildContext context) {
    final menus = GeoDetector.getMatchMenus(widget.currentRegion);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Regional Sub-menu category selector
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: menus.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == 0;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? SpaceNavyTheme.goldChampagne
                        : Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: isSelected ? SpaceNavyTheme.goldChampagne : SpaceNavyTheme.goldBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      menus[index].localizedTitle(widget.currentRegion),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          // 1. Dual Aura Collision & Spark Visual (Expanded area without clipping)
          GlassBox(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            backgroundColor: const Color(0xFF0D1224).withValues(alpha: 0.8),
            child: Column(
              children: [
                SizedBox(
                  height: 170,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Person A Aura (Neon Violet)
                      Positioned(
                        left: 45,
                        child: _buildAuraOrb(
                          color: const Color(0xFF8A2BE2),
                          label: _typeA,
                          subLabel: AppI18n.tr('me_label', widget.currentRegion),
                        ),
                      ),
                      // Person B Aura (Neon Cyan)
                      Positioned(
                        right: 45,
                        child: _buildAuraOrb(
                          color: const Color(0xFF00E5FF),
                          label: _typeB,
                          subLabel: AppI18n.tr('you_label', widget.currentRegion),
                        ),
                      ),
                      // Center Sparkle
                      AnimatedBuilder(
                        animation: _sparkController,
                        builder: (context, _) {
                          final scale = 1.0 + 0.22 * sin(_sparkController.value * 2 * pi);
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF070A12),
                                border: Border.all(color: SpaceNavyTheme.goldChampagne, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.6),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.flash_on, color: SpaceNavyTheme.goldChampagne, size: 26),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Match Type Selection Controls
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeDropdown(
                        label: AppI18n.tr('my_type', widget.currentRegion),
                        currentVal: _typeA,
                        onChanged: (val) {
                          setState(() {
                            _typeA = val!;
                          });
                          _calculateMatch();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTypeDropdown(
                        label: AppI18n.tr('partner_type', widget.currentRegion),
                        currentVal: _typeB,
                        onChanged: (val) {
                          setState(() {
                            _typeB = val!;
                          });
                          _calculateMatch();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Result Breakdown & Radar Chart
          if (_matchResult != null) ...[
            GlassBox(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppI18n.tr('chemistry_score', widget.currentRegion),
                            style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
                          ),
                          Text(
                            '${_matchResult!.score}',
                            style: const TextStyle(
                              color: SpaceNavyTheme.goldChampagne,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5C07B),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          StoryShareDialog.show(
                            context,
                            title: '16 Personalities Match',
                            personA: _typeA,
                            personB: _typeB,
                            score: _matchResult!.score,
                            headline: _matchResult!.headline,
                            radarData: {
                              '열정': _matchResult!.passion,
                              '신뢰': _matchResult!.trust,
                              '소통': _matchResult!.communication,
                              '가치관': _matchResult!.values,
                              '성장': _matchResult!.growth,
                            },
                          );
                        },
                        icon: const Icon(Icons.share, size: 16),
                        label: Text(
                          AppI18n.tr('share_story_btn', widget.currentRegion),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _matchResult!.headline,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _matchResult!.summary,
                          style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 5-Axis Radar Chart
                  RadarChartView(
                    values: {
                      '열정': _matchResult!.passion,
                      '신뢰': _matchResult!.trust,
                      '소통': _matchResult!.communication,
                      '가치관': _matchResult!.values,
                      '성장': _matchResult!.growth,
                    },
                    size: 200,
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildAuraOrb({required Color color, required String label, required String subLabel}) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0D1224),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(subLabel, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown({
    required String label,
    required String currentVal,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: currentVal,
          dropdownColor: const Color(0xFF141B33),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: SpaceNavyTheme.goldBorder),
            ),
          ),
          items: SixteenTypeMatrix.allTypes
              .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 13))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

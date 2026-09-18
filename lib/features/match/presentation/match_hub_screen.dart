import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../economy/data/heart_wallet_repository.dart';
import '../../economy/presentation/heart_shop_bottom_sheet.dart';
import '../domain/sixteen_type_matrix.dart';
import 'radar_chart_view.dart';
import 'story_share_widget.dart';

class MatchHubScreen extends StatefulWidget {
  final SupportedRegion currentRegion;
  final HeartWalletRepository wallet;

  const MatchHubScreen({
    super.key,
    required this.currentRegion,
    required this.wallet,
  });

  @override
  State<MatchHubScreen> createState() => _MatchHubScreenState();
}

class _MatchHubScreenState extends State<MatchHubScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sparkController;
  int _selectedTabIndex = 0;

  String _typeA = 'ENFP';
  String _typeB = 'INTJ';

  // Alternative options for other tabs
  String _pillarA = '갑자(甲子)';
  String _pillarB = '기축(己丑)';
  static const List<String> _commonPillars = [
    '갑자(甲子)', '을축(乙丑)', '병인(丙寅)', '정묘(丁卯)', '무진(戊辰)',
    '기사(己巳)', '경오(庚午)', '신미(辛未)', '임신(壬申)', '계유(癸酉)',
    '갑술(甲戌)', '을해(乙亥)', '병자(丙子)', '기축(己丑)', '임진(壬辰)'
  ];

  String _elementA = 'Fire (불/火)';
  String _elementB = 'Air (바람/風)';
  static const List<String> _elements = [
    'Fire (불/火)', 'Earth (흙/土)', 'Air (바람/風)', 'Water (물/水)'
  ];

  MatchResult? _matchResult;

  @override
  void initState() {
    super.initState();
    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _updateMatchPreview();
  }

  @override
  void dispose() {
    _sparkController.dispose();
    super.dispose();
  }

  void _updateMatchPreview() {
    setState(() {
      if (_selectedTabIndex == 0) {
        _matchResult = SixteenTypeMatrix.calculateChemistry(_typeA, _typeB);
      } else if (_selectedTabIndex == 1) {
        _matchResult = MatchResult(
          score: 95,
          headline: '천간합(甲己合)과 지지 육합의 길한 인연',
          summary: '두 사람의 일주(Day Pillar)가 서로의 부족한 오행을 완벽하게 채워주며 백년가약을 이루는 조화로운 궁합입니다.',
          passion: 92,
          trust: 96,
          communication: 88,
          values: 94,
          growth: 90,
        );
      } else {
        _matchResult = MatchResult(
          score: 89,
          headline: '불과 바람의 역동적인 시너지',
          summary: '서로를 빛나게 하는 에너지가 넘치며 함께 있을 때 끊임없이 새로운 영감과 도전을 나누는 조합입니다.',
          passion: 95,
          trust: 85,
          communication: 90,
          values: 82,
          growth: 92,
        );
      }
    });
  }

  Future<void> _unlockDeepMatchAnalysis() async {
    if (widget.wallet.hearts <= 0 && !widget.wallet.hasVipPass) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppI18n.tr('out_of_hearts_title', widget.currentRegion))),
        );
        HeartShopBottomSheet.show(context, widget.wallet);
      }
      return;
    }

    await widget.wallet.consumeHeart();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✨ 정밀 궁합 심층 분석이 언락되었습니다! (하트 1개 사용)')),
      );
    }
  }

  String get _currentLabelA {
    if (_selectedTabIndex == 0) return _typeA;
    if (_selectedTabIndex == 1) return _pillarA.split('(').first;
    return _elementA.split(' ').first;
  }

  String get _currentLabelB {
    if (_selectedTabIndex == 0) return _typeB;
    if (_selectedTabIndex == 1) return _pillarB.split('(').first;
    return _elementB.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final menus = GeoDetector.getMatchMenus(widget.currentRegion);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Regional Sub-menu category selector (Interactive Tabs)
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: menus.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedTabIndex;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedTabIndex = index;
                    });
                    _updateMatchPreview();
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? SpaceNavyTheme.goldChampagne
                          : Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(
                        color: isSelected
                            ? SpaceNavyTheme.goldChampagne
                            : SpaceNavyTheme.goldBorder.withValues(alpha: 0.4),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.35),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        menus[index].localizedTitle(widget.currentRegion),
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

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
                          label: _currentLabelA,
                          subLabel: AppI18n.tr('me_label', widget.currentRegion),
                        ),
                      ),
                      // Person B Aura (Neon Cyan)
                      Positioned(
                        right: 45,
                        child: _buildAuraOrb(
                          color: const Color(0xFF00E5FF),
                          label: _currentLabelB,
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

                // Match Selection Controls (Changes according to selected tab)
                if (_selectedTabIndex == 0)
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeDropdown(
                          label: AppI18n.tr('my_type', widget.currentRegion),
                          currentVal: _typeA,
                          items: SixteenTypeMatrix.allTypes,
                          onChanged: (val) {
                            setState(() => _typeA = val!);
                            _updateMatchPreview();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeDropdown(
                          label: AppI18n.tr('partner_type', widget.currentRegion),
                          currentVal: _typeB,
                          items: SixteenTypeMatrix.allTypes,
                          onChanged: (val) {
                            setState(() => _typeB = val!);
                            _updateMatchPreview();
                          },
                        ),
                      ),
                    ],
                  )
                else if (_selectedTabIndex == 1)
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeDropdown(
                          label: '나의 일주(日柱)',
                          currentVal: _pillarA,
                          items: _commonPillars,
                          onChanged: (val) {
                            setState(() => _pillarA = val!);
                            _updateMatchPreview();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeDropdown(
                          label: '상대방 일주(日柱)',
                          currentVal: _pillarB,
                          items: _commonPillars,
                          onChanged: (val) {
                            setState(() => _pillarB = val!);
                            _updateMatchPreview();
                          },
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeDropdown(
                          label: '나의 원소 / 기질',
                          currentVal: _elementA,
                          items: _elements,
                          onChanged: (val) {
                            setState(() => _elementA = val!);
                            _updateMatchPreview();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeDropdown(
                          label: '상대방 원소 / 기질',
                          currentVal: _elementB,
                          items: _elements,
                          onChanged: (val) {
                            setState(() => _elementB = val!);
                            _updateMatchPreview();
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

                  const SizedBox(height: 20),

                  // Deep Match Unlock Action
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SpaceNavyTheme.goldChampagne,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _unlockDeepMatchAnalysis,
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text(
                        '두 사람의 시크릿 심층 궁합 열람 (하트 1개)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
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
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: items.contains(currentVal) ? currentVal : items.first,
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
          items: items
              .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 13))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

}

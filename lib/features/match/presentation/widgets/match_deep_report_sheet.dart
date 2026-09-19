import 'package:flutter/material.dart';
import '../../../../core/localization/app_i18n.dart';
import '../../../../core/localization/geo_detector.dart';
import '../../../../core/theme/glass_box.dart';
import '../../../../core/theme/space_navy_theme.dart';
import '../../domain/match_item_engine.dart';
import '../../domain/sixteen_type_matrix.dart';

class MatchDeepReportSheet extends StatelessWidget {
  final MatchSubMenu menu;
  final String itemA;
  final String itemB;
  final MatchResult result;
  final SupportedRegion region;

  const MatchDeepReportSheet({
    super.key,
    required this.menu,
    required this.itemA,
    required this.itemB,
    required this.result,
    required this.region,
  });

  static void show(
    BuildContext context, {
    required MatchSubMenu menu,
    required String itemA,
    required String itemB,
    required MatchResult result,
    required SupportedRegion region,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MatchDeepReportSheet(
        menu: menu,
        itemA: itemA,
        itemB: itemB,
        result: result,
        region: region,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelA = MatchItemEngine.getAuraOrbLabel(menu, itemA);
    final labelB = MatchItemEngine.getAuraOrbLabel(menu, itemB);

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF090D1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: SpaceNavyTheme.goldChampagne, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        region == SupportedRegion.korea
                            ? '시크릿 케미 심층 감정 리포트'
                            : 'Secret Chemistry Deep Analysis',
                        style: const TextStyle(
                          color: SpaceNavyTheme.goldChampagne,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, height: 1),

              // Scrollable Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Top Couple Score Banner
                    GlassBox(
                      backgroundColor: const Color(0xFF141B33).withValues(alpha: 0.7),
                      border: Border.all(color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.6)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: SpaceNavyTheme.goldChampagne),
                                ),
                                child: Text(
                                  '$labelA  ×  $labelB',
                                  style: const TextStyle(
                                    color: SpaceNavyTheme.goldChampagne,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '/ 100점',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: SpaceNavyTheme.goldChampagne,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.headline,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF00E5FF),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.summary,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFB0B9D0),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 1. 영혼의 주파수 및 정밀 관계 풀이
                    _buildSectionHeader(
                      icon: Icons.psychology,
                      title: region == SupportedRegion.korea
                          ? '두 사람의 에너지 흐름과 상호작용'
                          : 'Energy Flow & Interaction Dynamics',
                    ),
                    const SizedBox(height: 10),
                    _buildInsightCard(
                      content: _generateRelationshipDynamics(),
                    ),

                    const SizedBox(height: 20),

                    // 2. 5대 지표별 정밀 진단
                    _buildSectionHeader(
                      icon: Icons.analytics_outlined,
                      title: region == SupportedRegion.korea
                          ? '5대 케미스트리 지표별 심층 진단'
                          : '5-Axis Deep Dimensional Breakdown',
                    ),
                    const SizedBox(height: 10),
                    _buildMetricTile(
                      title: AppI18n.tr('axis_passion', region),
                      score: result.passion,
                      icon: Icons.local_fire_department,
                      color: const Color(0xFFFF5252),
                      comment: _getAxisComment('passion', result.passion),
                    ),
                    _buildMetricTile(
                      title: AppI18n.tr('axis_trust', region),
                      score: result.trust,
                      icon: Icons.verified_user,
                      color: const Color(0xFF00E5FF),
                      comment: _getAxisComment('trust', result.trust),
                    ),
                    _buildMetricTile(
                      title: AppI18n.tr('axis_communication', region),
                      score: result.communication,
                      icon: Icons.forum,
                      color: const Color(0xFF69F0AE),
                      comment: _getAxisComment('comms', result.communication),
                    ),
                    _buildMetricTile(
                      title: AppI18n.tr('axis_values', region),
                      score: result.values,
                      icon: Icons.diamond,
                      color: SpaceNavyTheme.goldChampagne,
                      comment: _getAxisComment('values', result.values),
                    ),
                    _buildMetricTile(
                      title: AppI18n.tr('axis_growth', region),
                      score: result.growth,
                      icon: Icons.trending_up,
                      color: const Color(0xFFE040FB),
                      comment: _getAxisComment('growth', result.growth),
                    ),

                    const SizedBox(height: 20),

                    // 3. 주의할 충돌 지점 & 처방전
                    _buildSectionHeader(
                      icon: Icons.warning_amber_rounded,
                      title: region == SupportedRegion.korea
                          ? '잠재적 갈등 지점과 슬기로운 처방전'
                          : 'Potential Conflict Hotspots & Remedies',
                      iconColor: const Color(0xFFFFAB40),
                    ),
                    const SizedBox(height: 10),
                    _buildInsightCard(
                      borderColor: const Color(0xFFFFAB40).withValues(alpha: 0.4),
                      content: _generateConflictRemedy(),
                    ),

                    const SizedBox(height: 20),

                    // 4. 인연 발전 핵심 시크릿 가이드
                    _buildSectionHeader(
                      icon: Icons.favorite,
                      title: region == SupportedRegion.korea
                          ? '사랑과 신뢰를 깊게 만드는 황금 열쇠'
                          : 'The Golden Key to Deepen Bonds',
                      iconColor: const Color(0xFFFF4081),
                    ),
                    const SizedBox(height: 10),
                    _buildInsightCard(
                      borderColor: const Color(0xFFFF4081).withValues(alpha: 0.4),
                      content: _generateGoldenKey(),
                    ),

                    const SizedBox(height: 24),

                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: SpaceNavyTheme.goldChampagne,
                          side: const BorderSide(color: SpaceNavyTheme.goldChampagne),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          region == SupportedRegion.korea ? '확인 완료' : 'Done',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    Color iconColor = SpaceNavyTheme.goldChampagne,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard({required String content, Color? borderColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        content,
        style: const TextStyle(
          color: Color(0xFFD6DFEF),
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required double score,
    required IconData icon,
    required Color color,
    required String comment,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF10162B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const Spacer(),
                Text(
                  '점',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (score / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              comment,
              style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  String _generateRelationshipDynamics() {
    if (region == SupportedRegion.korea) {
      if (result.score >= 90) {
        return '두 분은 첫 만남부터 깊은 영혼의 친밀함을 느끼는 천생연분의 파동을 지니고 있습니다. '
            '서로가 가진 장점이 상대의 부족한 부분을 물 흐르듯 보완하며, 함께 있는 것만으로도 자연스러운 안정감과 무한한 시너지가 일어납니다. '
            '세속적인 조건을 뛰어넘어 서로의 영혼을 응원하고 지지하는 견고한 인연입니다.';
      } else if (result.score >= 80) {
        return '호기심과 지적인 자극이 넘쳐나는 역동적인 궁합입니다. '
            '서로 다른 관점과 개성을 지니고 있어 함께 대화를 나눌 때마다 새로운 시각과 배움을 얻습니다. '
            '초기에는 조율할 부분이 있을 수 있으나, 서로의 개성을 인정하고 존중할수록 관계의 깊이가 배로 성장합니다.';
      } else {
        return '서로에게 강렬한 인상과 신선한 자극을 주는 관계입니다. '
            '익숙하지 않은 방식에 가끔은 놀라거나 마찰이 생길 수 있으나, 이는 두 분이 서로를 통해 시야를 넓히고 성장할 수 있는 가장 훌륭한 기회가 됩니다.';
      }
    } else {
      if (result.score >= 90) {
        return 'You share a rare and profound harmonic resonance. Instinctual understanding flows between you effortlessly, complementing each other with organic synergy and lasting emotional safety.';
      } else {
        return 'An invigorating dynamic rich in intellectual novelty and catalytic growth. Embracing differences becomes your strongest bond as mutual respect deepens over time.';
      }
    }
  }

  String _getAxisComment(String type, double val) {
    if (region == SupportedRegion.korea) {
      switch (type) {
        case 'passion':
          return val >= 90
              ? '첫눈에 끌리는 강렬한 설렘과 식지 않는 매력이 유지됩니다.'
              : '은은하고 차분하게 달아오르는 온화한 열정의 형태입니다.';
        case 'trust':
          return val >= 90
              ? '비밀 없이 마음을 온전히 터놓을 수 있는 철통같은 신뢰가 형성됩니다.'
              : '시간을 들여 약속을 지켜나갈수록 단단해지는 신뢰의 관계입니다.';
        case 'comms':
          return val >= 90
              ? '말하지 않아도 눈빛만으로 서로의 생각과 감정을 직관적으로 읽어냅니다.'
              : '솔직하고 명확한 대화를 통해 오해를 풀 때 깊은 공감이 일어납니다.';
        case 'values':
          return val >= 90
              ? '인생의 목표와 재정관, 삶을 바라보는 철학이 놀랍도록 일치합니다.'
              : '서로 다른 취향과 가치관을 존중하며 균형을 찾아가는 지혜가 빛납니다.';
        case 'growth':
          return val >= 90
              ? '함께 있을 때 서로의 잠재력이 폭발적으로 깨어나며 동반 성공을 이룹니다.'
              : '서로에게 든든한 페이스메이커가 되어 한 걸음씩 성장하도록 이끕니다.';
      }
    }
    return 'Balanced and supportive dynamic fostering sustained connection.';
  }

  String _generateConflictRemedy() {
    if (region == SupportedRegion.korea) {
      return '• 잠재 갈등 요인: 의견이 부딪힐 때 상대방을 설득하려 하거나 내 방식의 정답을 강요할 때 거리감이 생길 수 있습니다.\n'
          '• 슬기로운 처방전:  너는 왜 그래? 대신 내 생각엔 이랬어라는 I-Message로 대화하세요. 화가 났을 때는 20분의 쿨링타임을 가진 후 차분한 상태에서 마음을 털어놓는 것이 최고의 처방입니다.';
    } else {
      return '• Potential Hotspot: Attempting to convince or impose one\'s own perspective during debates.\n'
          '• Remedial Practice: Use I feel statements instead of pointing fingers. Take a 20-minute pause before addressing emotionally sensitive subjects.';
    }
  }

  String _generateGoldenKey() {
    if (region == SupportedRegion.korea) {
      return '두 분의 인연을 황금처럼 빛나게 만드는 비결은 사소한 감사와 일상의 칭찬입니다. '
          '상대의 배려를 당연하게 여기지 않고 매일 작은 다정함을 표현할 때, 두 사람 사이의 오라(Aura)는 그 어떤 장애물도 뚫을 수 없는 영원한 사랑으로 완성됩니다.';
    } else {
      return 'The Golden Secret is consistent daily appreciation. Recognizing each other\'s subtle gestures of care creates an unbreakable aura of enduring love and devotion.';
    }
  }
}

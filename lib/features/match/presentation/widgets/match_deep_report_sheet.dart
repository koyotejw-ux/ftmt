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
                        AppI18n.tr('deep_report_title', region),
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
                                '${result.score}',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '/ 100${AppI18n.tr('score_points_suffix', region)}',
                                style: const TextStyle(
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
                      title: AppI18n.tr('deep_report_sec1', region),
                    ),
                    const SizedBox(height: 10),
                    _buildInsightCard(
                      content: _generateRelationshipDynamics(),
                    ),

                    const SizedBox(height: 20),

                    // 2. 5대 지표별 정밀 진단
                    _buildSectionHeader(
                      icon: Icons.analytics_outlined,
                      title: AppI18n.tr('deep_report_sec2', region),
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
                      title: AppI18n.tr('deep_report_sec3', region),
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
                      title: AppI18n.tr('deep_report_sec4', region),
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
                          AppI18n.tr('done_btn', region),
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
    switch (region.languageCode) {
      case 'ko':
        if (result.score >= 90) {
          return '두 분은 첫 만남부터 깊은 영혼의 친밀함을 느끼는 천생연분의 파동을 지니고 있습니다. '
              '서로가 가진 장점이 상대의 부족한 부분을 물 흐르듯 보완하며, 함께 있는 것만으로도 자연스러운 안정감과 무한한 시너지가 일어납니다.';
        } else if (result.score >= 80) {
          return '호기심과 지적인 자극이 넘쳐나는 역동적인 궁합입니다. '
              '서로 다른 관점과 개성을 지니고 있어 함께 대화를 나눌 때마다 새로운 시각과 배움을 얻습니다.';
        } else {
          return '서로에게 강렬한 인상과 신선한 자극을 주는 관계입니다. '
              '익숙하지 않은 방식에 가끔은 놀라거나 마찰이 생길 수 있으나 시야를 넓히는 훌륭한 성장의 기회가 됩니다.';
        }
      case 'ja':
        if (result.score >= 90) {
          return 'お二人は出会った瞬間から深い魂の親密さを感じる天生物の波動を持っています。'
              '互いの長所が自然に補い合い、ただ一緒にいるだけで絶対的な安心感と相乗効果が生まれます。';
        } else if (result.score >= 80) {
          return '知的な刺激と好奇心に満ちたダイナミックな相性です。'
              '異なる個性や視点が対話を深め、語り合うたびに新たな気づきと豊かな学びをもたらします。';
        } else {
          return '互いに鮮烈な印象と刺激を与え合うご縁です。'
              '個性の違いを認め合うことで、お互いの世界を大きく広げられる貴重なパートナーです。';
        }
      case 'de':
        if (result.score >= 90) {
          return 'Sie teilen eine seltene und tiefe seelische Resonanz. '
              'Ein instinktives Verständnis fließt mühelos zwischen Ihnen, das organische Synergie und beständige emotionale Geborgenheit schenkt.';
        } else if (result.score >= 80) {
          return 'Eine dynamische Verbindung voller intellektueller Impulse und lebendiger Inspiration. '
              'Unterschiedliche Sichtweisen bereichern jeden Dialog und lassen die Verbindung stetig wachsen.';
        } else {
          return 'Eine faszinierende Beziehung voller intensiver Eindrücke. '
              'Die Akzeptanz von Unterschieden wird zum Schlüssel für außergewöhnliches persönliches Wachstum.';
        }
      case 'fr':
        if (result.score >= 90) {
          return 'Vous partagez une résonance harmonique rare et profonde. '
              'Une compréhension instinctive fluide circule entre vous, complétant vos forces dans une sécurité émotionnelle absolue.';
        } else if (result.score >= 80) {
          return 'Une alchimie dynamique riche en stimulations intellectuelles et en inspiration. '
              'Vos perspectives distinctes ouvrent de nouveaux horizons à chaque échange.';
        } else {
          return 'Une rencontre magnétique et stimulante. '
              'Embrasser vos contrastes devient une source inestimable d\'élévation mutuelle et de complicité durable.';
        }
      case 'es':
        if (result.score >= 90) {
          return 'Comparten una resonancia armónica profunda y predestinada. '
              'Un entendimiento intuitivo fluye sin esfuerzo, complementándose con sinergia orgánica y seguridad emocional.';
        } else if (result.score >= 80) {
          return 'Una química dinámica llena de estímulo intelectual y curiosidad. '
              'Sus distintas perspectivas enriquecen cada conversación con nuevos aprendizajes.';
        } else {
          return 'Una conexión fascinante y estimulante. '
              'Aceptar sus diferencias se convierte en una oportunidad única de expansión y crecimiento mutuo.';
        }
      case 'it':
        if (result.score >= 90) {
          return 'Condividete una risonanza armonica rara e profonda. '
              'Una comprensione istintiva fluisce naturalmente tra voi, donandovi sicurezza emotiva e grande complicità.';
        } else if (result.score >= 80) {
          return 'Un\'affinità dinamica ricca di stimoli intellettuali e vivacità. '
              'Punti di vista diversi arricchiscono ogni dialogo con nuove prospettive di crescita.';
        } else {
          return 'Una relazione magnetica e ricca di stimoli. '
              'Riconoscere l\'unicità dell\'altro diventa il trampolino di lancio per un\'evoluzione straordinaria.';
        }
      default:
        if (result.score >= 90) {
          return 'You share a rare and profound harmonic resonance. '
              'Instinctual understanding flows between you effortlessly, complementing each other with organic synergy and lasting emotional safety.';
        } else if (result.score >= 80) {
          return 'An invigorating dynamic rich in intellectual novelty and catalytic growth. '
              'Embracing differences becomes your strongest bond as mutual respect deepens over time.';
        } else {
          return 'An intense, transformative dynamic. '
              'Novel contrasts challenge and expand your inner worlds, forging meaningful maturity through open dialogue.';
        }
    }
  }

  String _getAxisComment(String type, double val) {
    switch (region.languageCode) {
      case 'ko':
        switch (type) {
          case 'passion':
            return val >= 90 ? '첫눈에 끌리는 강렬한 설렘과 식지 않는 매력이 유지됩니다.' : '은은하고 차분하게 달아오르는 온화한 열정의 형태입니다.';
          case 'trust':
            return val >= 90 ? '비밀 없이 마음을 온전히 터놓을 수 있는 철통같은 신뢰가 형성됩니다.' : '시간을 들여 약속을 지켜나갈수록 단단해지는 신뢰의 관계입니다.';
          case 'comms':
            return val >= 90 ? '말하지 않아도 눈빛만으로 서로의 생각과 감정을 직관적으로 읽어냅니다.' : '솔직하고 명확한 대화를 통해 오해를 풀 때 깊은 공감이 일어납니다.';
          case 'values':
            return val >= 90 ? '인생의 목표와 재정관, 삶을 바라보는 철학이 놀랍도록 일치합니다.' : '서로 다른 취향과 가치관을 존중하며 균형을 찾아가는 지혜가 빛납니다.';
          case 'growth':
            return val >= 90 ? '함께 있을 때 서로의 잠재력이 폭발적으로 깨어나며 동반 성공을 이룹니다.' : '서로에게 든든한 페이스메이커가 되어 한 걸음씩 성장하도록 이끕니다.';
        }
        break;
      case 'ja':
        switch (type) {
          case 'passion':
            return val >= 90 ? '一目で惹かれ合う情熱と色褪せない魅力が続きます。' : '穏やかで温かく育まれる落ち着いた情熱です。';
          case 'trust':
            return val >= 90 ? '何でも打ち明けられる揺るぎない絶対的信頼です。' : '時間をかけて約束を重ねるほど強固になる絆です。';
          case 'comms':
            return val >= 90 ? '言葉がなくとも視線だけで意図が伝わる共鳴です。' : '素直な対話を重ねることで深い共感が芽生えます。';
          case 'values':
            return val >= 90 ? '人生の目標や価値観が驚くほど見事に一致します。' : '違いを尊重しながら調和を見出す知恵が光ります。';
          case 'growth':
            return val >= 90 ? '共にあることで潜在能力が引き出され成功へ導かれます。' : '良きパートナーとして一歩ずつ成長を支え合えます。';
        }
        break;
      case 'de':
        switch (type) {
          case 'passion':
            return val >= 90 ? 'Intensive Anziehungskraft und magnetische Faszination.' : 'Eine sanfte, wärmende und beständige Herzensleidenschaft.';
          case 'trust':
            return val >= 90 ? 'Unerschütterliches, tiefes Urvertrauen ohne Geheimnisse.' : 'Ein Vertrauen, das mit jeder gemeinsamen Erfahrung wächst.';
          case 'comms':
            return val >= 90 ? 'Intuitive Verständigung fast ohne Worte.' : 'Konstruktive Dialoge schaffen tiefes gegenseitiges Verständnis.';
          case 'values':
            return val >= 90 ? 'Werte und Lebensvisionen stimmen harmonisch überein.' : 'Gegenseitige Bereicherung durch unterschiedliche Ideale.';
          case 'growth':
            return val >= 90 ? 'Gegenseitiges Entfesseln verborgener Potenziale.' : 'Konstante Ermutigung und verlässliche Unterstützung.';
        }
        break;
      case 'fr':
        switch (type) {
          case 'passion':
            return val >= 90 ? 'Attraction magnétique immédiate et éclat durable.' : 'Une flamme douce, sereine et chaleureuse.';
          case 'trust':
            return val >= 90 ? 'Confiance absolue et totale transparence du cœur.' : 'Un lien solide qui se renforce avec le temps.';
          case 'comms':
            return val >= 90 ? 'Compréhension intuitive au premier regard.' : 'L\'écoute sincère dissout tout malentendu avec bienveillance.';
          case 'values':
            return val >= 90 ? 'Vision de la vie et idéaux en parfaite harmonie.' : 'Équilibre subtil et respect mutuel des différences.';
          case 'growth':
            return val >= 90 ? 'Émulation féconde et révélation des talents cachés.' : 'Soutien indéfectible vers l\'épanouissement personnel.';
        }
        break;
      case 'es':
        switch (type) {
          case 'passion':
            return val >= 90 ? 'Atracción magnética intensa y fascinación inagotable.' : 'Una pasión cálida, serena y constante.';
          case 'trust':
            return val >= 90 ? 'Confianza inquebrantable y transparencia del corazón.' : 'Una lealtad que se fortalece paso a paso.';
          case 'comms':
            return val >= 90 ? 'Conexión intuitiva que va más allá de las palabras.' : 'Diálogos abiertos que profundizan la empatía.';
          case 'values':
            return val >= 90 ? 'Metas y filosofías de vida en admirable sincronía.' : 'Respeto mutuo que encuentra el equilibrio perfecto.';
          case 'growth':
            return val >= 90 ? 'Despertar mutuo de talentos y éxito compartido.' : 'Compañeros leales que impulsan el crecimiento.';
        }
        break;
      case 'it':
        switch (type) {
          case 'passion':
            return val >= 90 ? 'Attrazione magnetica vibrante e fascino eterno.' : 'Una passione dolce, serena e profonda.';
          case 'trust':
            return val >= 90 ? 'Fiducia incrollabile e trasparenza totale d\'animo.' : 'Un legame solido che matura col tempo.';
          case 'comms':
            return val >= 90 ? 'Intesa intuitiva e telepatia emotiva.' : 'Il dialogo sincero genera empatia e affetto.';
          case 'values':
            return val >= 90 ? 'Ideali e progetti di vita in perfetta consonanza.' : 'Armonia sapiente nel rispetto reciproco.';
          case 'growth':
            return val >= 90 ? 'Ispirazione reciproca verso grandi traguardi.' : 'Sostegno costante per camminare insieme.';
        }
        break;
      default:
        switch (type) {
          case 'passion':
            return val >= 90 ? 'Instant magnetic spark and enduring charisma.' : 'A warm, gentle and deeply reassuring inner flame.';
          case 'trust':
            return val >= 90 ? 'Unshakable soul-level trust and transparent safety.' : 'Enduring reliability forged through shared milestones.';
          case 'comms':
            return val >= 90 ? 'Effortless intuitive telepathy and emotional clarity.' : 'Honest vulnerability unlocking profound empathy.';
          case 'values':
            return val >= 90 ? 'Miraculous synergy in core values and life visions.' : 'Graceful balance cultivating mutual respect.';
          case 'growth':
            return val >= 90 ? 'Catalytic partnership awakening latent brilliance.' : 'Faithful pacing companions inspiring steady evolution.';
        }
    }
    return 'Balanced and supportive dynamic fostering sustained connection.';
  }

  String _generateConflictRemedy() {
    switch (region.languageCode) {
      case 'ko':
        return '• 잠재 갈등 요인: 의견이 부딪힐 때 상대방을 설득하려 하거나 내 방식의 정답을 강요할 때 거리감이 생길 수 있습니다.\n'
            '• 슬기로운 처방전:  너는 왜 그래? 대신 내 생각엔 이랬어라는 I-Message로 대화하세요. 화가 났을 때는 20분의 쿨링타임을 가진 후 차분한 상태에서 마음을 털어놓는 것이 최고의 처방입니다.';
      case 'ja':
        return '• 潜在的な摩擦点: 意見が対立した際、自分の考えを押し付けたり相手を変えようとすると心の距離が生まれます。\n'
            '• 賢い処方箋: 相手を責めず「私はこう感じた」というI-メッセージで想いを伝えましょう。感情的になった時は20分間のクールダウンを設けることが最良の処方箋です。';
      case 'de':
        return '• Potenzielle Konfliktquelle: Der Versuch, den Partner in Debatten zu überzeugen oder die eigene Sichtweise aufzudrängen.\n'
            '• Harmonische Lösung: Nutzen Sie Ich-Botschaften statt Vorwürfen. Eine 20-minütige Ruhepause vor sensiblen Gesprächen bewirkt wahre Wunder.';
      case 'fr':
        return '• Point de Friction Potentiel: Vouloir convaincre à tout prix ou imposer sa perspective lors des désaccords.\n'
            '• Prescription Sage: Exprimez vos ressentis en disant Je ressens plutôt que de juger. Prendre 20 minutes de pause avant d\'aborder un sujet sensible préserve l\'harmonie.';
      case 'es':
        return '• Posible Punto de Conflicto: Intentar convencer al otro o imponer la propia razón en momentos de debate.\n'
            '• Solución Sabia: Habla desde el Yo siento en lugar de señalar. Una pausa de 20 minutos antes de dialogar con calma es la mejor medicina.';
      case 'it':
        return '• Potenziale Punto di Frizione: Voler convincere ad ogni costo o imporre il proprio punto di vista durante una discussione.\n'
            '• Prescrizione Saggia: Usate frasi che partono da Io sento invece di accusare. Una pausa di 20 minuti prima di chiarire con calma trasforma ogni ostacolo in amore.';
      default:
        return '• Potential Hotspot: Attempting to convince or impose one\'s own perspective during debates.\n'
            '• Remedial Practice: Use I feel statements instead of pointing fingers. Take a 20-minute pause before addressing emotionally sensitive subjects.';
    }
  }

  String _generateGoldenKey() {
    switch (region.languageCode) {
      case 'ko':
        return '두 분의 인연을 황금처럼 빛나게 만드는 비결은 사소한 감사와 일상의 칭찬입니다. '
            '상대의 배려를 당연하게 여기지 않고 매일 작은 다정함을 표현할 때, 두 사람 사이의 오라(Aura)는 그 어떤 장애물도 뚫을 수 없는 영원한 사랑으로 완성됩니다.';
      case 'ja':
        return 'お二人の絆を黄金のように輝かせる秘訣は、日々の些細な感謝と言葉の温もりです。'
            '相手の気遣いを当たり前と思わず、小さな優しさを言葉にして伝えることで、二人のオーラはいかなる困難も乗り越える永遠の愛へと昇華します。';
      case 'de':
        return 'Das goldene Geheimnis einer erfüllten Partnerschaft liegt in täglicher Wertschätzung und kleinen Gesten der Dankbarkeit. '
            'Wenn Zuwendung nie als selbstverständlich angesehen wird, erblüht ein unzerstörbares Band wahrer Verbundenheit.';
      case 'fr':
        return 'La clé d\'or pour faire rayonner votre lien est la gratitude quotidienne et la bienveillance des petits gestes. '
            'En ne tenant jamais l\'affection pour acquise et en exprimant votre tendresse chaque jour, votre aura d\'amour devient inaltérable.';
      case 'es':
        return 'El secreto de oro para hacer brillar su unión es la gratitud diaria y el aprecio en los pequeños detalles. '
            'Expresar ternura y reconocimiento cada día forja un aura de amor eterno capaz de superar cualquier desafío.';
      case 'it':
        return 'Il segreto d\'oro per far risplendere la vostra unione è la gratitudine quotidiana nei piccoli gesti d\'affetto. '
            'Non dare mai nulla per scontato e donarsi parole gentili ogni giorno rende la vostra aura d\'amore indistruttibile ed eterna.';
      default:
        return 'The Golden Secret is consistent daily appreciation. '
            'Recognizing each other\'s subtle gestures of care creates an unbreakable aura of enduring love and devotion.';
    }
  }
}

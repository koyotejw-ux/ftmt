import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../domain/tarot_deck.dart';

class TarotShuffleView extends StatefulWidget {
  final Function(List<TarotCard> selected) onCardsPicked;
  final SupportedRegion region;

  const TarotShuffleView({
    super.key,
    required this.onCardsPicked,
    this.region = SupportedRegion.korea,
  });

  @override
  State<TarotShuffleView> createState() => _TarotShuffleViewState();
}

class _TarotShuffleViewState extends State<TarotShuffleView> {
  final List<TarotCard> _deck = List.of(TarotDeck.majorArcana)..shuffle();
  final List<TarotCard> _selectedCards = [];
  double _cardSpreadOffset = 0.0;

  void _onCardTapped(TarotCard card) {
    if (_selectedCards.contains(card)) return;
    if (_selectedCards.length >= 3) return;

    // Haptic feedback for tactile mysticism
    HapticFeedback.mediumImpact();

    setState(() {
      _selectedCards.add(card);
    });

    if (_selectedCards.length == 3) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onCardsPicked(_selectedCards);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickPrompt = AppI18n.tr('tarot_pick_prompt', widget.region)
        .replaceAll('{count}', '${_selectedCards.length}');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pickPrompt,
                style: const TextStyle(
                  color: SpaceNavyTheme.goldChampagne,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              if (_selectedCards.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCards.clear();
                      _deck.shuffle();
                    });
                  },
                  child: Text(
                    AppI18n.tr('tarot_reshuffle', widget.region),
                    style: const TextStyle(color: Colors.white60),
                  ),
                ),
            ],
          ),
        ),

        // 3 Picked Cards Area (Tarot Golden Ratio 1:1.6, Perfectly Centered)
        Container(
          height: 130,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final hasCard = index < _selectedCards.length;
              final card = hasCard ? _selectedCards[index] : null;
              final phaseName = [
                AppI18n.tr('tarot_phase_past', widget.region),
                AppI18n.tr('tarot_phase_present', widget.region),
                AppI18n.tr('tarot_phase_future', widget.region),
              ][index];

              return Container(
                width: 82,
                height: 124,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasCard ? SpaceNavyTheme.goldChampagne : SpaceNavyTheme.goldBorder.withValues(alpha: 0.35),
                    width: hasCard ? 1.8 : 1.0,
                  ),
                  color: hasCard
                      ? const Color(0xFF141B33)
                      : const Color(0xFF0D1224).withValues(alpha: 0.6),
                  boxShadow: hasCard
                      ? [
                          BoxShadow(
                            color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: hasCard
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Stack(
                          children: [
                            // Golden inner border
                            Positioned.fill(
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.4),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Phase tag
                                    Text(
                                      phaseName.split(' ')[0],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF00E5FF),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Rune / Arcana Symbol
                                    Text(
                                      card!.runeSymbol,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        color: SpaceNavyTheme.goldChampagne,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Card Name
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        card.localizedName(widget.region).split('(').first.trim(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white24,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  phaseName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                '카드 선택',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF9AA7C7),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              );
            }),
          ),
        ),

        const SizedBox(height: 16),

        // Horizontal Tarot Spread Carousel
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _cardSpreadOffset = (_cardSpreadOffset + details.delta.dx).clamp(-400.0, 400.0);
              });
            },
            child: Center(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _deck.length,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemBuilder: (context, index) {
                    final card = _deck[index];
                    final isPicked = _selectedCards.contains(card);

                    return GestureDetector(
                      onTap: () => _onCardTapped(card),
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        transform: Matrix4.translationValues(0.0, isPicked ? -16.0 : 0.0, 0.0),
                        child: GlassBox(
                          padding: EdgeInsets.zero,
                          borderRadius: 12,
                          border: Border.all(
                            color: isPicked
                                ? SpaceNavyTheme.cyanNeon
                                : SpaceNavyTheme.goldBorder,
                            width: isPicked ? 2.0 : 1.0,
                          ),
                          backgroundColor: const Color(0xFF0D1224).withValues(alpha: 0.85),
                          child: Stack(
                            children: [
                              // Inner ornate border
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: SpaceNavyTheme.goldChampagne.withValues(alpha: isPicked ? 0.6 : 0.25),
                                      width: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                              // Mystical back design
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.auto_awesome,
                                      color: isPicked
                                          ? SpaceNavyTheme.cyanNeon
                                          : SpaceNavyTheme.goldChampagne.withValues(alpha: 0.75),
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '✦ TAROT ✦',
                                      style: TextStyle(
                                        color: isPicked
                                            ? SpaceNavyTheme.cyanNeon
                                            : SpaceNavyTheme.goldChampagne.withValues(alpha: 0.6),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isPicked)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: SpaceNavyTheme.cyanNeon,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(3),
                                    child: const Icon(Icons.check, size: 12, color: Colors.black),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}

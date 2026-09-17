import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../domain/tarot_deck.dart';

class TarotShuffleView extends StatefulWidget {
  final Function(List<TarotCard> selected) onCardsPicked;

  const TarotShuffleView({super.key, required this.onCardsPicked});

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '운명의 3장을 선택하세요 (${_selectedCards.length}/3)',
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
                  child: const Text('다시 섞기', style: TextStyle(color: Colors.white60)),
                ),
            ],
          ),
        ),

        // 3 Picked Cards Area
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              final hasCard = index < _selectedCards.length;
              final card = hasCard ? _selectedCards[index] : null;

              return Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 88, minWidth: 64),
                  height: 110,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: hasCard ? SpaceNavyTheme.goldChampagne : Colors.white24,
                      width: hasCard ? 1.5 : 1.0,
                    ),
                    color: hasCard
                        ? const Color(0xFF141B33)
                        : Colors.white.withValues(alpha: 0.04),
                    boxShadow: hasCard
                        ? [
                            BoxShadow(
                              color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.35),
                              blurRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: hasCard
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  card!.runeSymbol,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: SpaceNavyTheme.goldChampagne,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  card.nameKo.split(' ')[0],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            ['과거', '현재', '미래'][index],
                            style: const TextStyle(color: Colors.white38, fontSize: 12),
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
                              // Mystical back design
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.auto_awesome,
                                      color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.6),
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '✦ 78 ✦',
                                      style: TextStyle(
                                        color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.4),
                                        fontSize: 10,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isPicked)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: SpaceNavyTheme.cyanNeon,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(2),
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
      ],
    );
  }
}

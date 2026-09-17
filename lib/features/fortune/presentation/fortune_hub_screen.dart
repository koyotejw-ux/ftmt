import 'package:flutter/material.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../ads/ad_manager.dart';
import '../../economy/data/heart_wallet_repository.dart';
import '../../economy/presentation/heart_shop_bottom_sheet.dart';
import 'astral_wheel_widget.dart';
import 'snack_teaser_card.dart';
import 'calculating_hud_dialog.dart';
import 'tarot_shuffle_view.dart';
import 'fortune_detail_screen.dart';

class FortuneHubScreen extends StatefulWidget {
  final SupportedRegion currentRegion;
  final ValueChanged<SupportedRegion> onRegionChanged;
  final HeartWalletRepository wallet;

  const FortuneHubScreen({
    super.key,
    required this.currentRegion,
    required this.onRegionChanged,
    required this.wallet,
  });

  @override
  State<FortuneHubScreen> createState() => _FortuneHubScreenState();
}

class _FortuneHubScreenState extends State<FortuneHubScreen> {
  DateTime _selectedBirth = DateTime(1995, 8, 15, 14, 30);
  String _selectedCity = '서울';

  void _openTarotFlow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF070A12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: TarotShuffleView(
            onCardsPicked: (cards) {
              Navigator.of(ctx).pop();
              _analyzeFortuneWithAd(
                title: '신비의 3-Card 타로 심층 리포트',
                category: '타로',
                tarotCards: cards,
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _analyzeFortuneWithAd({
    required String title,
    required String category,
    List<dynamic>? tarotCards,
  }) async {
    // Check heart balance
    if (widget.wallet.hearts <= 0 && !widget.wallet.hasVipPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('복채(하트)가 부족합니다. 충전소에서 충전해주세요!')),
      );
      HeartShopBottomSheet.show(context, widget.wallet);
      return;
    }

    // Interstitial Ad with 3-minute cooldown
    await AdManager.instance.showInterstitialAd(
      context,
      isNoAds: widget.wallet.hasNoAds,
      onComplete: () {
        // Show 1.5s calculation HUD for trust anchor
        CalculatingHudDialog.show(
          context,
          onFinished: () async {
            await widget.wallet.consumeHeart();
            if (mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => FortuneDetailScreen(
                    title: title,
                    category: category,
                    birthTime: _selectedBirth,
                    selectedCity: _selectedCity,
                    selectedTarotCards: tarotCards?.cast(),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _showBirthInputSheet(FortuneSubMenu menu) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D1224),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    menu.localizedTitle(widget.currentRegion),
                    style: const TextStyle(
                      color: SpaceNavyTheme.goldChampagne,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '정밀 진태양시 오차 보정(-32분)과 원전 알고리즘을 적용합니다.',
                    style: TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  // City Selection (True solar time anchor)
                  const Text('출생 도시 (진태양시 경도 보정)', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCity,
                    dropdownColor: const Color(0xFF141B33),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: SpaceNavyTheme.goldBorder),
                      ),
                    ),
                    items: ['서울', '부산', '도쿄', '뉴욕', '런던', '파리']
                        .map((city) => DropdownMenuItem(value: city, child: Text(city, style: const TextStyle(color: Colors.white))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setSheetState(() => _selectedCity = val);
                        setState(() => _selectedCity = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Birth Date Picker
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: SpaceNavyTheme.goldBorder),
                    ),
                    tileColor: Colors.white.withValues(alpha: 0.04),
                    leading: const Icon(Icons.calendar_today, color: SpaceNavyTheme.goldChampagne),
                    title: const Text('생년월일 및 태어난 시간', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    subtitle: Text(
                      '${_selectedBirth.year}년 ${_selectedBirth.month}월 ${_selectedBirth.day}일 ${_selectedBirth.hour}:${_selectedBirth.minute}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedBirth,
                        firstDate: DateTime(1930),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        if (!context.mounted) return;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_selectedBirth),
                        );
                        if (time != null) {
                          setSheetState(() {
                            _selectedBirth = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
                          });
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SpaceNavyTheme.goldChampagne,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _analyzeFortuneWithAd(
                          title: menu.localizedTitle(widget.currentRegion),
                          category: '정통 사주',
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, size: 18),
                          SizedBox(width: 8),
                          Text('정밀 운명 분석 시작 (하트 1개)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final menus = GeoDetector.getFortuneMenus(widget.currentRegion);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar: Region Flag Selector & Heart Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Region Switcher Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: SpaceNavyTheme.goldBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SupportedRegion>(
                    value: widget.currentRegion,
                    dropdownColor: const Color(0xFF141B33),
                    icon: const Icon(Icons.expand_more, color: SpaceNavyTheme.goldChampagne, size: 16),
                    onChanged: (SupportedRegion? val) {
                      if (val != null) widget.onRegionChanged(val);
                    },
                    items: SupportedRegion.values.map((r) {
                      return DropdownMenuItem(
                        value: r,
                        child: Text(
                          '${r.countryCode} ${r.label}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Heart Balance Indicator
              GestureDetector(
                onTap: () => HeartShopBottomSheet.show(context, widget.wallet),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141B33),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: SpaceNavyTheme.goldBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.pinkAccent, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        widget.wallet.hasVipPass ? 'VIP' : '${widget.wallet.hearts}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.add_circle, color: SpaceNavyTheme.goldChampagne, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 1. Interactive 3D Astral Wheel
          const AstralWheelWidget(),

          const SizedBox(height: 12),

          // 2. Dopamine Snack Teaser Card
          SnackTeaserCard(
            onTap: () {
              _analyzeFortuneWithAd(
                title: '오늘의 최적 금전운 타임라인',
                category: '도파민 스낵',
              );
            },
          ),

          const SizedBox(height: 24),

          // 3. Dynamic Sub-Menu Grid (Auto-rearranged by Region)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.currentRegion.label} 맞춤 운세 큐레이션',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('AUTO ADAPT', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final menu = menus[index];
              final isTarot = menu == FortuneSubMenu.tarot ||
                  menu == FortuneSubMenu.threeCardTarot ||
                  menu == FortuneSubMenu.tarotMarseille;

              return GlassBox(
                onTap: () {
                  if (isTarot) {
                    _openTarotFlow();
                  } else {
                    _showBirthInputSheet(menu);
                  }
                },
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isTarot ? Icons.style : Icons.auto_awesome,
                      color: SpaceNavyTheme.goldChampagne,
                      size: 22,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      menu.localizedTitle(widget.currentRegion),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '심층 리포트 >',
                      style: TextStyle(color: Color(0xFF00E5FF), fontSize: 11),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

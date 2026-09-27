import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../economy/data/heart_wallet_repository.dart';
import '../../economy/presentation/heart_shop_bottom_sheet.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../profile/presentation/profile_edit_dialog.dart';
import '../domain/sixteen_type_matrix.dart';
import '../domain/match_item_engine.dart';
import 'radar_chart_view.dart';
import 'story_share_widget.dart';
import 'widgets/match_deep_report_sheet.dart';

class MatchHubScreen extends StatefulWidget {
  final SupportedRegion currentRegion;
  final HeartWalletRepository wallet;
  final UserProfileRepository profileRepo;

  const MatchHubScreen({
    super.key,
    required this.currentRegion,
    required this.wallet,
    required this.profileRepo,
  });

  @override
  State<MatchHubScreen> createState() => _MatchHubScreenState();
}

class _MatchHubScreenState extends State<MatchHubScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sparkController;
  int _selectedTabIndex = 0;

  // Selected item cache per match system to preserve user selections
  final Map<MatchSubMenu, String> _selectedItemsA = {};
  final Map<MatchSubMenu, String> _selectedItemsB = {};

  MatchResult? _matchResult;

  @override
  void initState() {
    super.initState();
    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _initDefaultSelections();
    _updateMatchPreview();
  }

  void _initDefaultSelections() {
    final my = widget.profileRepo.profile;
    final r = widget.currentRegion;

    // 16 Types default
    _selectedItemsA[MatchSubMenu.sixteenType] = my.mbti ?? 'ENFP';
    _selectedItemsB[MatchSubMenu.sixteenType] = 'INTJ';

    // 12 Western Zodiac default
    final zodiacList = MatchItemEngine.getAvailableItems(MatchSubMenu.westernZodiac, r);
    final myZodiac = my.localizedWesternZodiacItem(r);
    _selectedItemsA[MatchSubMenu.westernZodiac] = zodiacList.contains(myZodiac) ? myZodiac : (zodiacList.length > 4 ? zodiacList[4] : zodiacList.first);
    _selectedItemsB[MatchSubMenu.westernZodiac] = zodiacList.length > 8 ? zodiacList[8] : (zodiacList.length > 1 ? zodiacList[1] : zodiacList.first);

    // Saju Pillar default
    final sajuList = MatchItemEngine.getAvailableItems(MatchSubMenu.sajuIlju, r);
    final myIlju = my.localizedSajuIlju(r);
    _selectedItemsA[MatchSubMenu.sajuIlju] = sajuList.contains(myIlju) ? myIlju : sajuList.first;
    _selectedItemsB[MatchSubMenu.sajuIlju] = sajuList.length > 25 ? sajuList[25] : (sajuList.length > 1 ? sajuList[1] : sajuList.first);

    // Zodiac Animal default
    final animalList = MatchItemEngine.getAvailableItems(MatchSubMenu.zodiacAnimal, r);
    final myAnimal = my.localizedZodiacAnimal(r);
    _selectedItemsA[MatchSubMenu.zodiacAnimal] = animalList.contains(myAnimal) ? myAnimal : animalList.first;
    _selectedItemsB[MatchSubMenu.zodiacAnimal] = animalList.length > 4 ? animalList[4] : (animalList.length > 1 ? animalList[1] : animalList.first);

    // Blood Type default
    final bloodList = MatchItemEngine.getAvailableItems(MatchSubMenu.bloodType, r);
    final myBlood = my.localizedBloodType(r);
    _selectedItemsA[MatchSubMenu.bloodType] = bloodList.contains(myBlood) ? myBlood : bloodList.first;
    _selectedItemsB[MatchSubMenu.bloodType] = bloodList.length > 2 ? bloodList[2] : (bloodList.length > 1 ? bloodList[1] : bloodList.first);

    // Zodiac Element default
    final elemList = MatchItemEngine.getAvailableItems(MatchSubMenu.zodiacElement, r);
    final myElem = my.localizedZodiacElement(r);
    _selectedItemsA[MatchSubMenu.zodiacElement] = elemList.contains(myElem) ? myElem : elemList.first;
    _selectedItemsB[MatchSubMenu.zodiacElement] = elemList.length > 2 ? elemList[2] : (elemList.length > 1 ? elemList[1] : elemList.first);

    // Numerology Life Path
    final lpList = MatchItemEngine.getAvailableItems(MatchSubMenu.numerologyLifePath, r);
    final myLp = my.localizedLifePathNumber(r);
    _selectedItemsA[MatchSubMenu.numerologyLifePath] = lpList.contains(myLp) ? myLp : lpList.first;
    _selectedItemsB[MatchSubMenu.numerologyLifePath] = lpList.length > 1 ? lpList[1] : lpList.first;

    // Hybrid Blood x Zodiac
    final hybridList = MatchItemEngine.getAvailableItems(MatchSubMenu.bloodZodiacHybrid, r);
    _selectedItemsA[MatchSubMenu.bloodZodiacHybrid] = hybridList.first;
    _selectedItemsB[MatchSubMenu.bloodZodiacHybrid] = hybridList.length > 4 ? hybridList[4] : (hybridList.length > 1 ? hybridList[1] : hybridList.first);

    // Rokusei
    final rokuseiList = MatchItemEngine.getAvailableItems(MatchSubMenu.rokuseiMatch, r);
    _selectedItemsA[MatchSubMenu.rokuseiMatch] = rokuseiList.first;
    _selectedItemsB[MatchSubMenu.rokuseiMatch] = rokuseiList.length > 1 ? rokuseiList[1] : rokuseiList.first;

    // Synastry House
    final houseList = MatchItemEngine.getAvailableItems(MatchSubMenu.zodiacHouse, r);
    _selectedItemsA[MatchSubMenu.zodiacHouse] = houseList.first;
    _selectedItemsB[MatchSubMenu.zodiacHouse] = houseList.length > 3 ? houseList[3] : (houseList.length > 1 ? houseList[1] : houseList.first);

    // Celtic Runes
    final runeList = MatchItemEngine.getAvailableItems(MatchSubMenu.celticRuneMatch, r);
    _selectedItemsA[MatchSubMenu.celticRuneMatch] = runeList.first;
    _selectedItemsB[MatchSubMenu.celticRuneMatch] = runeList.length > 6 ? runeList[6] : (runeList.length > 1 ? runeList[1] : runeList.first);
  }

  String _getItemA(MatchSubMenu menu) {
    final available = MatchItemEngine.getAvailableItems(menu, widget.currentRegion);
    final saved = _selectedItemsA[menu];
    if (saved != null && available.contains(saved)) return saved;
    return available.first;
  }

  String _getItemB(MatchSubMenu menu) {
    final available = MatchItemEngine.getAvailableItems(menu, widget.currentRegion);
    final saved = _selectedItemsB[menu];
    if (saved != null && available.contains(saved)) return saved;
    return available.length > 1 ? available[1] : available.first;
  }

  @override
  void didUpdateWidget(covariant MatchHubScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRegion != widget.currentRegion) {
      _initDefaultSelections();
      final menus = GeoDetector.getMatchMenus(widget.currentRegion);
      if (_selectedTabIndex >= menus.length) {
        _selectedTabIndex = 0;
      }
      _updateMatchPreview();
    }
  }

  @override
  void dispose() {
    _sparkController.dispose();
    super.dispose();
  }

  void _updateMatchPreview() {
    setState(() {
      final menus = GeoDetector.getMatchMenus(widget.currentRegion);
      final currentMenu = menus[_selectedTabIndex.clamp(0, menus.length - 1)];
      final a = _getItemA(currentMenu);
      final b = _getItemB(currentMenu);

      _matchResult = MatchItemEngine.calculateMatch(
        menu: currentMenu,
        itemA: a,
        itemB: b,
        region: widget.currentRegion,
      );
    });
  }

  Future<void> _unlockDeepMatchAnalysis() async {
    if (widget.wallet.hearts <= 0 && !widget.wallet.hasVipPass) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppI18n.tr('out_of_hearts_title', widget.currentRegion))),
        );
        HeartShopBottomSheet.show(context, widget.wallet, currentRegion: widget.currentRegion);
      }
      return;
    }

    await widget.wallet.consumeHeart();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppI18n.tr('match_unlocked_snack', widget.currentRegion)),
          duration: const Duration(seconds: 1),
        ),
      );

      final menus = GeoDetector.getMatchMenus(widget.currentRegion);
      final currentMenu = menus[_selectedTabIndex.clamp(0, menus.length - 1)];
      final a = _getItemA(currentMenu);
      final b = _getItemB(currentMenu);

      if (_matchResult != null) {
        MatchDeepReportSheet.show(
          context,
          menu: currentMenu,
          itemA: a,
          itemB: b,
          result: _matchResult!,
          region: widget.currentRegion,
        );
      }
    }
  }

  String get _currentLabelA {
    final menus = GeoDetector.getMatchMenus(widget.currentRegion);
    final currentMenu = menus[_selectedTabIndex.clamp(0, menus.length - 1)];
    return MatchItemEngine.getAuraOrbLabel(currentMenu, _getItemA(currentMenu));
  }

  String get _currentLabelB {
    final menus = GeoDetector.getMatchMenus(widget.currentRegion);
    final currentMenu = menus[_selectedTabIndex.clamp(0, menus.length - 1)];
    return MatchItemEngine.getAuraOrbLabel(currentMenu, _getItemB(currentMenu));
  }

  @override
  Widget build(BuildContext context) {
    final menus = GeoDetector.getMatchMenus(widget.currentRegion);
    final currentMenu = menus[_selectedTabIndex.clamp(0, menus.length - 1)];

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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final totalW = constraints.maxWidth;
                      // Keep orbs nicely spaced even on narrow screens (e.g. 320px)
                      final orbOffset = (totalW * 0.12).clamp(16.0, 60.0);
                      return Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Person A Aura (Neon Violet)
                          Positioned(
                            left: orbOffset,
                            child: _buildAuraOrb(
                              color: const Color(0xFF8A2BE2),
                              label: _currentLabelA,
                              subLabel: AppI18n.tr('me_label', widget.currentRegion),
                            ),
                          ),
                          // Person B Aura (Neon Cyan)
                          Positioned(
                            right: orbOffset,
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
                  );
                },
              ),
            ),

                const SizedBox(height: 16),

                // Match Selection Controls (Dynamically rendered for current menu - Responsive layout)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 560;
                    final dropdownA = _buildTypeDropdown(
                      label: MatchItemEngine.getPickerLabelA(currentMenu, widget.currentRegion),
                      currentVal: _getItemA(currentMenu),
                      items: MatchItemEngine.getAvailableItems(currentMenu, widget.currentRegion),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedItemsA[currentMenu] = val);
                          _updateMatchPreview();
                        }
                      },
                    );

                    final dropdownB = _buildTypeDropdown(
                      label: MatchItemEngine.getPickerLabelB(currentMenu, widget.currentRegion),
                      currentVal: _getItemB(currentMenu),
                      items: MatchItemEngine.getAvailableItems(currentMenu, widget.currentRegion),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedItemsB[currentMenu] = val);
                          _updateMatchPreview();
                        }
                      },
                    );

                    if (isNarrow) {
                      return Column(
                        children: [
                          dropdownA,
                          const SizedBox(height: 12),
                          dropdownB,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: dropdownA),
                        const SizedBox(width: 12),
                        Expanded(child: dropdownB),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Helper Action Buttons: Calculate from Birth & Pick from Vault (Responsive)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 440;
                    final btnCalc = OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.6)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      onPressed: () {
                        ProfileEditDialog.show(
                          context,
                          initialProfile: UserProfile(
                            name: AppI18n.tr('profile_default_other', widget.currentRegion),
                            birthDateTime: DateTime(1996, 5, 10, 12, 0),
                            city: 'Seoul',
                          ),
                          region: widget.currentRegion,
                          isForSelf: false,
                          onSaved: (personB) {
                            setState(() {
                              _selectedItemsB[MatchSubMenu.westernZodiac] = personB.localizedWesternZodiacItem(widget.currentRegion);
                              _selectedItemsB[MatchSubMenu.sajuIlju] = personB.localizedSajuIlju(widget.currentRegion);
                              _selectedItemsB[MatchSubMenu.zodiacAnimal] = personB.localizedZodiacAnimal(widget.currentRegion);
                              _selectedItemsB[MatchSubMenu.bloodType] = personB.localizedBloodType(widget.currentRegion);
                              _selectedItemsB[MatchSubMenu.zodiacElement] = personB.localizedZodiacElement(widget.currentRegion);
                              _selectedItemsB[MatchSubMenu.numerologyLifePath] = personB.localizedLifePathNumber(widget.currentRegion);
                              if (personB.mbti != null) {
                                _selectedItemsB[MatchSubMenu.sixteenType] = personB.mbti!;
                              }
                            });
                            _updateMatchPreview();
                          },
                        );
                      },
                      icon: const Icon(Icons.cake, color: SpaceNavyTheme.goldChampagne, size: 16),
                      label: Text(
                        AppI18n.tr('match_calc_from_birth', widget.currentRegion),
                        style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );

                    final btnVault = OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: const Color(0xFF00E5FF).withValues(alpha: 0.6)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      onPressed: () {
                        final vault = widget.profileRepo.getSavedVaultProfiles();
                        if (vault.isNotEmpty) {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xFF0D1224),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            builder: (sheetCtx) => SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppI18n.tr('match_pick_from_vault', widget.currentRegion),
                                      style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 14),
                                    ...vault.map((p) => ListTile(
                                          tileColor: Colors.white.withValues(alpha: 0.05),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          leading: const Icon(Icons.favorite, color: Colors.pinkAccent),
                                          title: Text(p.localizedName(widget.currentRegion), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                            widget.currentRegion == SupportedRegion.korea
                                                ? '${p.localizedWesternZodiacItem(widget.currentRegion).split('(').first} · ${p.localizedSajuIlju(widget.currentRegion).split('(').first} · ${p.localizedBloodType(widget.currentRegion)}'
                                                : '${p.localizedWesternZodiacItem(widget.currentRegion).split('(').first} · ${p.localizedZodiacElement(widget.currentRegion).split('(').first} · ${p.localizedBloodType(widget.currentRegion)}',
                                            style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
                                          ),
                                          onTap: () {
                                            Navigator.of(sheetCtx).pop();
                                            setState(() {
                                              _selectedItemsB[MatchSubMenu.westernZodiac] = p.localizedWesternZodiacItem(widget.currentRegion);
                                              _selectedItemsB[MatchSubMenu.sajuIlju] = p.localizedSajuIlju(widget.currentRegion);
                                              _selectedItemsB[MatchSubMenu.zodiacAnimal] = p.localizedZodiacAnimal(widget.currentRegion);
                                              _selectedItemsB[MatchSubMenu.bloodType] = p.localizedBloodType(widget.currentRegion);
                                              _selectedItemsB[MatchSubMenu.zodiacElement] = p.localizedZodiacElement(widget.currentRegion);
                                              _selectedItemsB[MatchSubMenu.numerologyLifePath] = p.localizedLifePathNumber(widget.currentRegion);
                                              if (p.mbti != null) {
                                                _selectedItemsB[MatchSubMenu.sixteenType] = p.mbti!;
                                              }
                                            });
                                            _updateMatchPreview();
                                          },
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppI18n.tr('vault_empty_notice', widget.currentRegion))),
                          );
                        }
                      },
                      icon: const Icon(Icons.people_alt, color: Color(0xFF00E5FF), size: 16),
                      label: Text(
                        AppI18n.tr('match_pick_from_vault', widget.currentRegion),
                        style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          btnCalc,
                          const SizedBox(height: 8),
                          btnVault,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: btnCalc),
                        const SizedBox(width: 10),
                        Expanded(child: btnVault),
                      ],
                    );
                  },
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
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
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE5C07B),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onPressed: () {
                            StoryShareDialog.show(
                              context,
                              title: currentMenu.localizedTitle(widget.currentRegion),
                              personA: _currentLabelA,
                              personB: _currentLabelB,
                              score: _matchResult!.score,
                              headline: _matchResult!.headline,
                              radarData: {
                                AppI18n.tr('axis_passion', widget.currentRegion): _matchResult!.passion,
                                AppI18n.tr('axis_trust', widget.currentRegion): _matchResult!.trust,
                                AppI18n.tr('axis_communication', widget.currentRegion): _matchResult!.communication,
                                AppI18n.tr('axis_values', widget.currentRegion): _matchResult!.values,
                                AppI18n.tr('axis_growth', widget.currentRegion): _matchResult!.growth,
                              },
                              region: widget.currentRegion,
                            );
                          },
                          icon: const Icon(Icons.share, size: 16),
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppI18n.tr('share_story_btn', widget.currentRegion),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
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
                      AppI18n.tr('axis_passion', widget.currentRegion): _matchResult!.passion,
                      AppI18n.tr('axis_trust', widget.currentRegion): _matchResult!.trust,
                      AppI18n.tr('axis_communication', widget.currentRegion): _matchResult!.communication,
                      AppI18n.tr('axis_values', widget.currentRegion): _matchResult!.values,
                      AppI18n.tr('axis_growth', widget.currentRegion): _matchResult!.growth,
                    },
                    size: 200,
                  ),

                  const SizedBox(height: 20),

                  // Deep Match Unlock Action
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SpaceNavyTheme.goldChampagne,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      onPressed: _unlockDeepMatchAnalysis,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, size: 18),
                          const SizedBox(width: 8),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppI18n.tr('unlock_match_btn', widget.currentRegion),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
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
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: items.contains(currentVal) ? currentVal : items.first,
          dropdownColor: const Color(0xFF141B33),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: SpaceNavyTheme.goldBorder),
            ),
          ),
          items: items
              .map((t) => DropdownMenuItem(
                    value: t,
                    child: Text(
                      t,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

}

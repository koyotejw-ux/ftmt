import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../ads/ad_manager.dart';
import '../../economy/data/heart_wallet_repository.dart';
import '../../economy/presentation/heart_shop_bottom_sheet.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../profile/presentation/profile_edit_dialog.dart';
import 'astral_wheel_widget.dart';
import 'snack_teaser_card.dart';
import 'calculating_hud_dialog.dart';
import 'tarot_shuffle_view.dart';
import 'fortune_detail_screen.dart';

class FortuneHubScreen extends StatefulWidget {
  final SupportedRegion currentRegion;
  final ValueChanged<SupportedRegion> onRegionChanged;
  final HeartWalletRepository wallet;
  final UserProfileRepository profileRepo;

  const FortuneHubScreen({
    super.key,
    required this.currentRegion,
    required this.onRegionChanged,
    required this.wallet,
    required this.profileRepo,
  });

  @override
  State<FortuneHubScreen> createState() => _FortuneHubScreenState();
}

class _FortuneHubScreenState extends State<FortuneHubScreen> {
  late DateTime _selectedBirth;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    final profile = widget.profileRepo.profile;
    _selectedBirth = profile.birthDateTime;
    _selectedCity = profile.city;
  }

  List<String> _getCitiesForRegion(SupportedRegion region) {
    switch (region) {
      case SupportedRegion.korea:
        return ['서울 (Seoul)', '부산 (Busan)', '대구 (Daegu)', '인천 (Incheon)', '광주 (Gwangju)', '대전 (Daejeon)'];
      case SupportedRegion.unitedStates:
        return ['New York (EST)', 'Los Angeles (PST)', 'Chicago (CST)', 'Houston (CST)', 'San Francisco (PST)'];
      case SupportedRegion.japan:
        return ['東京 (Tokyo)', '大阪 (Osaka)', '京都 (Kyoto)', '福岡 (Fukuoka)', '札幌 (Sapporo)'];
      case SupportedRegion.unitedKingdom:
        return ['London (GMT)', 'Manchester (GMT)', 'Edinburgh (GMT)', 'Birmingham (GMT)', 'Glasgow (GMT)'];
      case SupportedRegion.germany:
        return ['Berlin (CET)', 'München (CET)', 'Frankfurt (CET)', 'Hamburg (CET)', 'Köln (CET)'];
      case SupportedRegion.france:
        return ['Paris (CET)', 'Lyon (CET)', 'Marseille (CET)', 'Bordeaux (CET)', 'Nice (CET)'];
      case SupportedRegion.spain:
        return ['Madrid (CET)', 'Barcelona (CET)', 'Valencia (CET)', 'Sevilla (CET)', 'Bilbao (CET)'];
      case SupportedRegion.italy:
        return ['Roma (CET)', 'Milano (CET)', 'Firenze (CET)', 'Napoli (CET)', 'Venezia (CET)'];
    }
  }

  String get _currentCity {
    final cities = _getCitiesForRegion(widget.currentRegion);
    if (_selectedCity != null && cities.contains(_selectedCity)) {
      return _selectedCity!;
    }
    return cities.first;
  }

  void _openTarotFlow() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF070A12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.78,
          child: TarotShuffleView(
            region: widget.currentRegion,
            onCardsPicked: (cards) {
              Navigator.of(ctx).pop();
              _analyzeFortuneWithAd(
                title: AppI18n.tr('tarot_title', widget.currentRegion),
                category: 'Tarot',
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
    FortuneSubMenu? menu,
    List<dynamic>? tarotCards,
  }) async {
    // Check heart balance
    if (widget.wallet.hearts <= 0 && !widget.wallet.hasVipPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppI18n.tr('out_of_hearts_title', widget.currentRegion))),
      );
      HeartShopBottomSheet.show(context, widget.wallet, currentRegion: widget.currentRegion);
      return;
    }

    // Interstitial Ad with 3-minute cooldown
    await AdManager.instance.showInterstitialAd(
      context,
      isNoAds: widget.wallet.hasNoAds,
      region: widget.currentRegion,
      onComplete: () {
        // Show 1.5s calculation HUD for trust anchor
        CalculatingHudDialog.show(
          context,
          region: widget.currentRegion,
          onFinished: () async {
            await widget.wallet.consumeHeart();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppI18n.tr('heart_consumed_snack', widget.currentRegion)),
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => FortuneDetailScreen(
                    title: title,
                    category: category,
                    menu: menu,
                    birthTime: _selectedBirth,
                    selectedCity: _currentCity,
                    selectedTarotCards: tarotCards?.cast(),
                    region: widget.currentRegion,
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
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D1224),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final bottomPadding = MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 32.0;
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: bottomPadding,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          menu.localizedTitle(widget.currentRegion),
                          style: const TextStyle(
                            color: SpaceNavyTheme.goldChampagne,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ProfileEditDialog.show(
                              context,
                              initialProfile: widget.profileRepo.profile,
                              region: widget.currentRegion,
                              onSaved: (p) async {
                                await widget.profileRepo.saveProfile(p);
                                setSheetState(() {
                                  _selectedBirth = p.birthDateTime;
                                  _selectedCity = p.city;
                                });
                                setState(() {
                                  _selectedBirth = p.birthDateTime;
                                  _selectedCity = p.city;
                                });
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: SpaceNavyTheme.goldBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.tune, color: SpaceNavyTheme.goldChampagne, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  AppI18n.tr('profile_edit_title', widget.currentRegion),
                                  style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppI18n.tr('birth_modal_desc', widget.currentRegion),
                      style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
                    ),
                    const SizedBox(height: 14),

                    // Quick Toggle / Mode Pill
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              final my = widget.profileRepo.profile;
                              setSheetState(() {
                                _selectedBirth = my.birthDateTime;
                                _selectedCity = my.city;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: (_selectedBirth == widget.profileRepo.profile.birthDateTime)
                                    ? SpaceNavyTheme.goldChampagne.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: (_selectedBirth == widget.profileRepo.profile.birthDateTime)
                                      ? SpaceNavyTheme.goldChampagne
                                      : Colors.white12,
                                ),
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '👤 ${widget.profileRepo.profile.localizedName(widget.currentRegion)} (${AppI18n.tr('view_mode_my', widget.currentRegion)})',
                                    style: TextStyle(
                                      color: (_selectedBirth == widget.profileRepo.profile.birthDateTime)
                                          ? SpaceNavyTheme.goldChampagne
                                          : Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            final vault = widget.profileRepo.getSavedVaultProfiles();
                            if (vault.isNotEmpty) {
                              final first = vault.first;
                              setSheetState(() {
                                _selectedBirth = first.birthDateTime;
                                _selectedCity = first.city;
                              });
                            } else {
                              ProfileEditDialog.show(
                                context,
                                initialProfile: UserProfile(
                                  name: AppI18n.tr('profile_default_other', widget.currentRegion),
                                  birthDateTime: DateTime(1996, 5, 10, 12, 0),
                                  city: 'Seoul',
                                ),
                                region: widget.currentRegion,
                                isForSelf: false,
                                onSaved: (p) async {
                                  await widget.profileRepo.addVaultProfile(p);
                                  setSheetState(() {
                                    _selectedBirth = p.birthDateTime;
                                    _selectedCity = p.city;
                                  });
                                },
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.group, color: Color(0xFF00E5FF), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  AppI18n.tr('view_mode_other', widget.currentRegion),
                                  style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // City Selection (True solar time anchor)
                    Text(
                      AppI18n.tr('birth_city_label', widget.currentRegion),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _currentCity,
                      dropdownColor: const Color(0xFF141B33),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: SpaceNavyTheme.goldBorder),
                        ),
                      ),
                      items: _getCitiesForRegion(widget.currentRegion)
                          .map((city) => DropdownMenuItem(
                                value: city,
                                child: Text(city, style: const TextStyle(color: Colors.white, fontSize: 13)),
                              ))
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
                      title: Text(
                        AppI18n.tr('birth_datetime_label', widget.currentRegion),
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      subtitle: Text(
                        '${_selectedBirth.year}-${_selectedBirth.month.toString().padLeft(2, '0')}-${_selectedBirth.day.toString().padLeft(2, '0')} ${_selectedBirth.hour.toString().padLeft(2, '0')}:${_selectedBirth.minute.toString().padLeft(2, '0')}',
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
                            category: 'Ephemeris Analysis',
                            menu: menu,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.auto_awesome, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              AppI18n.tr('start_analysis_btn', widget.currentRegion),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 0. User Profile Quick Badge & Edit Trigger
          StreamBuilder<UserProfile?>(
            stream: widget.profileRepo.profileStream,
            initialData: widget.profileRepo.profile,
            builder: (context, snapshot) {
              final profile = snapshot.data ?? widget.profileRepo.profile;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassBox(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  backgroundColor: const Color(0xFF141B33).withValues(alpha: 0.7),
                  border: Border.all(color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.3)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: SpaceNavyTheme.goldChampagne, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppI18n.tr('user_cosmic_coords', widget.currentRegion).replaceAll('{name}', profile.localizedName(widget.currentRegion)),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.currentRegion == SupportedRegion.korea
                                  ? '${profile.sajuIlju.split('(').first} · ${profile.zodiacAnimal.split('(')[1].replaceAll(')', '')} · ${profile.sunSign} · ${profile.localizedBloodType(widget.currentRegion)}'
                                  : '${profile.localizedSunSign(widget.currentRegion)} · ${profile.localizedZodiacElement(widget.currentRegion).split('(').first.trim()} · ${profile.localizedLifePathNumber(widget.currentRegion).split('(').first.trim()} · ${profile.localizedBloodType(widget.currentRegion)}',
                              style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ProfileEditDialog.show(
                            context,
                            initialProfile: profile,
                            region: widget.currentRegion,
                            onSaved: (updated) async {
                              await widget.profileRepo.saveProfile(updated);
                              setState(() {
                                _selectedBirth = updated.birthDateTime;
                                _selectedCity = updated.city;
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: SpaceNavyTheme.goldBorder),
                          ),
                          child: Text(
                            AppI18n.tr('edit_btn', widget.currentRegion),
                            style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 1. Interactive 3D Culturally-Adaptive Astral Wheel
          AstralWheelWidget(
            currentRegion: widget.currentRegion,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '✦ ${AppI18n.tr('key_visual_${widget.currentRegion.countryCode.toLowerCase()}', widget.currentRegion)}',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // 2. Dopamine Snack Teaser Card
          SnackTeaserCard(
            currentRegion: widget.currentRegion,
            onTap: () {
              _analyzeFortuneWithAd(
                title: AppI18n.tr('wealth_golden_time', widget.currentRegion),
                category: 'Dopamine Snack',
              );
            },
          ),

          const SizedBox(height: 16),

          // 2.5 Daily Retention Check-in Reward Card (BM & Retention Driver)
          GlassBox(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            backgroundColor: const Color(0xFF141B33).withValues(alpha: 0.75),
            border: Border.all(color: SpaceNavyTheme.goldBorder.withValues(alpha: 0.6)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.calendar_month, color: Colors.pinkAccent, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppI18n.tr('daily_checkin_title', widget.currentRegion),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        AppI18n.tr('daily_checkin_desc', widget.currentRegion),
                        style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 11, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                widget.wallet.canClaimDailyFree()
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          await widget.wallet.consumeDailyFree();
                          await widget.wallet.addHearts(1);
                          setState(() {});
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppI18n.tr('daily_claimed_snack', widget.currentRegion)),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            AppI18n.tr('daily_checkin_claim', widget.currentRegion),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, size: 14, color: Color(0xFF00E5FF)),
                            const SizedBox(width: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppI18n.tr('daily_checkin_done', widget.currentRegion),
                                style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. Dynamic Sub-Menu Grid (Auto-rearranged by Region)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${widget.currentRegion.label} ${AppI18n.tr('curated_fortune_title', widget.currentRegion)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
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

          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width > 750 ? 4 : (width > 480 ? 3 : 2);
              final childAspectRatio = width > 750 ? 1.5 : (width < 360 ? 1.15 : 1.35);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: childAspectRatio,
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isTarot ? Icons.style : Icons.auto_awesome,
                          color: SpaceNavyTheme.goldChampagne,
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            menu.localizedTitle(widget.currentRegion),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              height: 1.25,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppI18n.tr('deep_report_btn', widget.currentRegion),
                          style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 10, fontWeight: FontWeight.w500),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

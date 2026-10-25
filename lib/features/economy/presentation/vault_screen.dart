import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../profile/presentation/profile_edit_dialog.dart';
import '../data/heart_wallet_repository.dart';
import 'heart_shop_bottom_sheet.dart';

class VaultScreen extends StatefulWidget {
  final HeartWalletRepository wallet;
  final UserProfileRepository profileRepo;
  final SupportedRegion currentRegion;

  const VaultScreen({
    super.key,
    required this.wallet,
    required this.profileRepo,
    this.currentRegion = SupportedRegion.korea,
  });

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  void _addNewProfile() {
    ProfileEditDialog.show(
      context,
      initialProfile: UserProfile(
        name: '',
        birthDateTime: DateTime(2000, 1, 1, 12, 0),
        city: 'Seoul',
      ),
      region: widget.currentRegion,
      isForSelf: false,
      title: widget.currentRegion == SupportedRegion.korea
          ? '✦ 인연(상대방) 정보 등록 가이드'
          : '✦ Register Partner Info',
      onSaved: (person) async {
        await widget.profileRepo.addVaultProfile(person);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final myProfile = widget.profileRepo.profile;
    final vaultContacts = widget.profileRepo.getSavedVaultProfiles();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. My Cosmic Profile Master Card
          Text(
            '✦ ${AppI18n.tr('profile_edit_title', widget.currentRegion)}',
            style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GlassBox(
            padding: const EdgeInsets.all(18),
            backgroundColor: const Color(0xFF141B33).withValues(alpha: 0.8),
            border: Border.all(color: SpaceNavyTheme.goldChampagne, width: 1.5),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.15),
                        border: Border.all(color: SpaceNavyTheme.goldChampagne),
                      ),
                      child: const Center(
                        child: Icon(Icons.star, color: SpaceNavyTheme.goldChampagne, size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.profileRepo.hasProfile
                                      ? myProfile.localizedName(widget.currentRegion)
                                      : (widget.currentRegion == SupportedRegion.korea ? '우주 좌표(프로필) 미등록' : 'Unregistered Profile'),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: widget.profileRepo.hasProfile ? SpaceNavyTheme.goldChampagne : const Color(0xFF00E5FF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(widget.profileRepo.hasProfile ? 'ME' : 'GUIDE', style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.profileRepo.hasProfile
                                ? '${myProfile.birthDateTime.year}.${myProfile.birthDateTime.month.toString().padLeft(2, '0')}.${myProfile.birthDateTime.day.toString().padLeft(2, '0')} ${myProfile.birthDateTime.hour.toString().padLeft(2, '0')}:${myProfile.birthDateTime.minute.toString().padLeft(2, '0')}'
                                : (widget.currentRegion == SupportedRegion.korea ? '가이드를 눌러 생년월일시와 출생지를 직접 등록하세요' : 'Tap to register your birth time & city with guide'),
                            style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ProfileEditDialog.show(
                          context,
                          initialProfile: widget.profileRepo.hasProfile
                              ? myProfile
                              : UserProfile(
                                  name: '',
                                  birthDateTime: DateTime(2000, 1, 1, 12, 0),
                                  city: 'Seoul',
                                ),
                          region: widget.currentRegion,
                          isForSelf: true,
                          title: widget.currentRegion == SupportedRegion.korea
                              ? '✦ 우주 좌표(프로필) 등록 가이드'
                              : '✦ Setup Cosmic Coordinates',
                          onSaved: (p) async {
                            await widget.profileRepo.saveProfile(p);
                            setState(() {});
                          },
                        );
                      },
                      icon: Icon(widget.profileRepo.hasProfile ? Icons.edit : Icons.add_circle, color: SpaceNavyTheme.goldChampagne, size: 22),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPill(
                      widget.currentRegion == SupportedRegion.korea
                          ? AppI18n.tr('pill_saju_ilju', widget.currentRegion)
                          : AppI18n.tr('my_element_label', widget.currentRegion),
                      widget.currentRegion == SupportedRegion.korea
                          ? myProfile.sajuIlju.split('(').first
                          : myProfile.localizedZodiacElement(widget.currentRegion).split('(').first.trim(),
                    ),
                    _buildPill(
                      widget.currentRegion == SupportedRegion.korea
                          ? AppI18n.tr('pill_zodiac_animal', widget.currentRegion)
                          : AppI18n.tr('my_lifepath_label', widget.currentRegion),
                      widget.currentRegion == SupportedRegion.korea
                          ? (myProfile.zodiacAnimal.contains('(') ? myProfile.zodiacAnimal.split('(')[1].replaceAll(')', '') : myProfile.zodiacAnimal)
                          : myProfile.localizedLifePathNumber(widget.currentRegion).split('(').first.trim(),
                    ),
                    _buildPill(AppI18n.tr('pill_sun_sign', widget.currentRegion), myProfile.localizedSunSign(widget.currentRegion)),
                    _buildPill(AppI18n.tr('pill_blood_type', widget.currentRegion), myProfile.localizedBloodType(widget.currentRegion)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Heart & Pass Status Card
          GlassBox(
            padding: const EdgeInsets.all(20),
            backgroundColor: const Color(0xFF141B33).withValues(alpha: 0.7),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pinkAccent.withValues(alpha: 0.15),
                  ),
                  child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.wallet.hasVipPass
                            ? AppI18n.tr('vault_vip_title', widget.currentRegion)
                            : AppI18n.tr('vault_wallet_title', widget.currentRegion),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.wallet.hasVipPass
                              ? AppI18n.tr('vault_vip_desc', widget.currentRegion)
                              : AppI18n.tr('vault_hearts_desc', widget.currentRegion)
                                  .replaceAll('{count}', '${widget.wallet.hearts}'),
                          maxLines: 1,
                          style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SpaceNavyTheme.goldChampagne,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => HeartShopBottomSheet.show(
                    context,
                    widget.wallet,
                    currentRegion: widget.currentRegion,
                  ),
                  child: Text(
                    AppI18n.tr('nav_shop', widget.currentRegion),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. Saved Contacts & Soulmates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppI18n.tr('vault_title', widget.currentRegion),
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: _addNewProfile,
                icon: const Icon(Icons.person_add_alt_1, color: Color(0xFF00E5FF), size: 16),
                label: Text(
                  AppI18n.tr('add_person_btn', widget.currentRegion),
                  style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 13),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (vaultContacts.isEmpty)
            GlassBox(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(color: SpaceNavyTheme.goldBorder),
                      ),
                      child: const Icon(Icons.people_outline, color: SpaceNavyTheme.goldChampagne, size: 28),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.currentRegion == SupportedRegion.korea
                          ? '보관함에 등록된 인연이 없습니다'
                          : 'No Contacts Saved in Vault',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.currentRegion == SupportedRegion.korea
                          ? '가이드를 통해 연인, 친구, 가족의 생년월일을 등록하여\n정밀 사주·별자리 및 궁합을 실시간으로 확인해보세요.'
                          : 'Register partner, friend, or family birth data via guide\nto explore tailored compatibility and destiny readings.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SpaceNavyTheme.goldChampagne,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _addNewProfile,
                      icon: const Icon(Icons.person_add_alt_1, size: 16),
                      label: Text(
                        widget.currentRegion == SupportedRegion.korea
                            ? '가이드로 새 인연 등록하기'
                            : 'Register New Person with Guide',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...vaultContacts.asMap().entries.map((entry) {
              final idx = entry.key;
              final p = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassBox(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                          border: Border.all(color: SpaceNavyTheme.goldBorder),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: SpaceNavyTheme.goldChampagne, size: 22),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.localizedName(widget.currentRegion), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 3),
                            Text(
                              '${p.birthDateTime.year}.${p.birthDateTime.month.toString().padLeft(2, '0')}.${p.birthDateTime.day.toString().padLeft(2, '0')} · ${p.localizedSunSign(widget.currentRegion)}',
                              style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.currentRegion == SupportedRegion.korea
                              ? p.localizedSajuIlju(widget.currentRegion).split('(').first
                              : p.localizedWesternZodiacItem(widget.currentRegion).split('(').first,
                          style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.white30, size: 18),
                        onPressed: () async {
                          await widget.profileRepo.deleteVaultProfile(idx);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

          const SizedBox(height: 24),

          // Compliance & Legal Notices (GDPR / Terms)
          GlassBox(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white.withValues(alpha: 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.gavel, color: Colors.white60, size: 16),
                    const SizedBox(width: 10),
                    Text(
                      AppI18n.tr('vault_legal_title', widget.currentRegion),
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppI18n.tr('vault_legal_desc', widget.currentRegion),
                  style: const TextStyle(color: Colors.white38, fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildPill(String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: const TextStyle(color: Colors.white38, fontSize: 10),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 12, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

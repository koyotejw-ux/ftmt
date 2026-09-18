import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../economy/data/heart_wallet_repository.dart';
import '../../economy/presentation/heart_shop_bottom_sheet.dart';

class VaultScreen extends StatefulWidget {
  final HeartWalletRepository wallet;
  final SupportedRegion currentRegion;

  const VaultScreen({
    super.key,
    required this.wallet,
    this.currentRegion = SupportedRegion.korea,
  });

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final List<SavedPerson> _profiles = [
    SavedPerson(name: '나 (본인)', birth: '1995.08.15 14:30', sign: '사자자리', saju: '을유(乙酉)일주'),
    SavedPerson(name: '김서연 (연인)', birth: '1997.03.22 09:15', sign: '양자리', saju: '갑오(甲午)일주'),
    SavedPerson(name: '이민호 (친구)', birth: '1994.11.05 18:00', sign: '전갈자리', saju: '병진(丙辰)일주'),
  ];

  void _addNewProfile() {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1224),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: SpaceNavyTheme.goldChampagne),
        ),
        title: Text(
          AppI18n.tr('vault_add_dialog_title', widget.currentRegion),
          style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 16),
        ),
        content: TextField(
          controller: nameCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppI18n.tr('vault_name_hint', widget.currentRegion),
            hintStyle: const TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppI18n.tr('vault_cancel', widget.currentRegion),
              style: const TextStyle(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: SpaceNavyTheme.goldChampagne),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _profiles.add(
                    SavedPerson(
                      name: nameCtrl.text,
                      birth: '1996.05.10 12:00',
                      sign: '황소자리',
                      saju: '정묘(丁卯)일주',
                    ),
                  );
                });
                Navigator.of(ctx).pop();
              }
            },
            child: Text(
              AppI18n.tr('vault_add', widget.currentRegion),
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heart & Pass Status Card
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
                      Text(
                        widget.wallet.hasVipPass
                            ? AppI18n.tr('vault_vip_desc', widget.currentRegion)
                            : AppI18n.tr('vault_hearts_desc', widget.currentRegion)
                                .replaceAll('{count}', '${widget.wallet.hearts}'),
                        style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 13),
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

          // Saved Profiles
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

          ..._profiles.map((p) => Padding(
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
                            Text(p.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 3),
                            Text('${p.birth} · ${p.sign}', style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(p.saju, style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              )),

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
}

class SavedPerson {
  final String name;
  final String birth;
  final String sign;
  final String saju;

  SavedPerson({required this.name, required this.birth, required this.sign, required this.saju});
}

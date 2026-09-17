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
        title: const Text('새 인연 프로필 추가', style: TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 16)),
        content: TextField(
          controller: nameCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: '이름 또는 별칭',
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소', style: TextStyle(color: Colors.white60)),
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
            child: const Text('추가', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                        widget.wallet.hasVipPass ? 'VIP 마스터 멤버십' : '복채(하트) 지갑',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.wallet.hasVipPass ? '모든 심층 풀이 무제한 패스 적용' : '현재 보유 하트: ${widget.wallet.hearts}개',
                        style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SpaceNavyTheme.goldChampagne,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => HeartShopBottomSheet.show(context, widget.wallet),
                  child: const Text('충전소', style: TextStyle(fontWeight: FontWeight.bold)),
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
                const Row(
                  children: [
                    Icon(Icons.gavel, color: Colors.white60, size: 16),
                    SizedBox(width: 8),
                    Text('법률 준수 및 개인정보 정책', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '본 앱은 100% Local-First 아키텍처로 작동하며, 입력하신 모든 생년월일 및 프로필 데이터는 외부 서버로 전송되지 않고 기기 내 로컬 저장소에만 안전하게 보관됩니다. (GDPR/CCPA 규격 준수)',
                  style: TextStyle(color: Colors.white38, fontSize: 11, height: 1.4),
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

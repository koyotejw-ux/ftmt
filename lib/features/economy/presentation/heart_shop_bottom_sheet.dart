import 'package:flutter/material.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../ads/ad_manager.dart';
import '../data/heart_wallet_repository.dart';

class HeartShopBottomSheet extends StatelessWidget {
  final HeartWalletRepository wallet;

  const HeartShopBottomSheet({super.key, required this.wallet});

  static void show(BuildContext context, HeartWalletRepository wallet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HeartShopBottomSheet(wallet: wallet),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1224),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: SpaceNavyTheme.goldChampagne, width: 1.5),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '복채(하트) 충전소 & 상점',
                style: TextStyle(
                  color: SpaceNavyTheme.goldChampagne,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: SpaceNavyTheme.goldBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.pinkAccent, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      wallet.hasVipPass ? 'VIP 무제한' : '${wallet.hearts}개 보유',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '심화 운세 리포트 및 상세 궁합 열람 시 복채(하트 1개)가 소모됩니다.',
            style: TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
          ),
          const SizedBox(height: 20),

          // 1. Free Rewarded Ad Heart Charger
          GlassBox(
            padding: const EdgeInsets.all(16),
            backgroundColor: const Color(0xFF00E5FF).withValues(alpha: 0.08),
            border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.4)),
            child: Row(
              children: [
                const Icon(Icons.play_circle_fill, color: Color(0xFF00E5FF), size: 36),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '광고 보고 무료 충전',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '30초 스폰서 영상 시청 시 하트 2개 즉시 지급',
                        style: TextStyle(color: Color(0xFF9AA7C7), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final rewarded = await AdManager.instance.showRewardedAd(context);
                    if (rewarded) {
                      await wallet.addHearts(2);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('✨ 하트 2개가 충전되었습니다!')),
                        );
                      }
                    }
                  },
                  child: const Text('충전 +2', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2. IAP Heart Packs
          Row(
            children: [
              Expanded(
                child: _buildIapCard(
                  title: '하트 10개',
                  price: '₩1,500 (\$0.99)',
                  isPopular: false,
                  onBuy: () async {
                    await wallet.addHearts(10);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🎉 하트 10개 충전 완료!')),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildIapCard(
                  title: '하트 30개',
                  price: '₩3,300 (\$2.49)',
                  isPopular: true,
                  onBuy: () async {
                    await wallet.addHearts(30);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🎉 하트 30개 충전 완료!')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 3. Lifetime VIP Master Pass
          GlassBox(
            padding: const EdgeInsets.all(16),
            backgroundColor: const Color(0xFFE5C07B).withValues(alpha: 0.12),
            border: Border.all(color: SpaceNavyTheme.goldChampagne, width: 1.5),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium, color: SpaceNavyTheme.goldChampagne, size: 36),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VIP 마스터 패스 (영구)',
                        style: TextStyle(color: SpaceNavyTheme.goldChampagne, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        '모든 광고 영구 제거 + 무제한 하트 & 프로필',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SpaceNavyTheme.goldChampagne,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    await wallet.unlockVipMasterPass();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('👑 VIP 마스터 패스가 활성화되었습니다!')),
                      );
                    }
                  },
                  child: const Text('₩14,000', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      ),
    );
  }

  Widget _buildIapCard({
    required String title,
    required String price,
    required bool isPopular,
    required VoidCallback onBuy,
  }) {
    return GlassBox(
      padding: const EdgeInsets.all(14),
      border: isPopular ? Border.all(color: SpaceNavyTheme.goldChampagne) : null,
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: SpaceNavyTheme.goldChampagne,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('BEST VALUE', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 11)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: SpaceNavyTheme.goldChampagne),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: onBuy,
              child: const Text('구매', style: TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

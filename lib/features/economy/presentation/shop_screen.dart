import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../ads/ad_manager.dart';
import '../data/heart_wallet_repository.dart';

class ShopScreen extends StatelessWidget {
  final HeartWalletRepository wallet;
  final SupportedRegion currentRegion;

  const ShopScreen({super.key, required this.wallet, required this.currentRegion});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Balance Header Card
          GlassBox(
            padding: const EdgeInsets.all(20),
            backgroundColor: const Color(0xFF141B33).withValues(alpha: 0.8),
            child: StreamBuilder<int>(
              stream: wallet.heartStream,
              initialData: wallet.hearts,
              builder: (context, snapshot) {
                final currentHearts = snapshot.data ?? wallet.hearts;
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pinkAccent.withValues(alpha: 0.15),
                        border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wallet.hasVipPass
                                ? AppI18n.tr('vip_unlimited', currentRegion)
                                : AppI18n.tr('current_hearts', currentRegion),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wallet.hasVipPass
                                ? AppI18n.tr('vip_master_desc', currentRegion)
                                : '$currentHearts Hearts Available',
                            style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          Text(
            AppI18n.tr('shop_subtitle', currentRegion),
            style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppI18n.tr('watch_ad_free', currentRegion),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '+2 Hearts Instantly',
                        style: TextStyle(color: Color(0xFF9AA7C7), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  onPressed: () async {
                    final rewarded = await AdManager.instance.showRewardedAd(context, region: currentRegion);
                    if (rewarded) {
                      await wallet.addHearts(2);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppI18n.tr('hearts_charged_snack', currentRegion).replaceAll('{count}', '2'),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('+2', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. IAP Heart Packs
          Row(
            children: [
              Expanded(
                child: _buildIapCard(
                  title: AppI18n.tr('heart_pack_10', currentRegion),
                  price: '${currentRegion.currencySymbol} 1.5K (\$0.99)',
                  isPopular: false,
                  currentRegion: currentRegion,
                  onBuy: () async {
                    await wallet.addHearts(10);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppI18n.tr('hearts_charged_snack', currentRegion).replaceAll('{count}', '10'),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildIapCard(
                  title: AppI18n.tr('heart_pack_30', currentRegion),
                  price: '${currentRegion.currencySymbol} 3.3K (\$2.49)',
                  isPopular: true,
                  currentRegion: currentRegion,
                  onBuy: () async {
                    await wallet.addHearts(30);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppI18n.tr('hearts_charged_snack', currentRegion).replaceAll('{count}', '30'),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 3. Lifetime VIP Master Pass
          GlassBox(
            padding: const EdgeInsets.all(18),
            backgroundColor: const Color(0xFFE5C07B).withValues(alpha: 0.12),
            border: Border.all(color: SpaceNavyTheme.goldChampagne, width: 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.workspace_premium, color: SpaceNavyTheme.goldChampagne, size: 32),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppI18n.tr('vip_master_title', currentRegion),
                        style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppI18n.tr('vip_master_desc', currentRegion),
                  style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SpaceNavyTheme.goldChampagne,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await wallet.unlockVipMasterPass();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('👑 VIP Master Pass Activated!')),
                        );
                      }
                    },
                    child: Text(
                      '${AppI18n.tr('buy_button', currentRegion)} (${currentRegion.currencySymbol} 9.99)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildIapCard({
    required String title,
    required String price,
    required bool isPopular,
    required SupportedRegion currentRegion,
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 11)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: SpaceNavyTheme.goldChampagne),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onPressed: onBuy,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AppI18n.tr('buy_button', currentRegion),
                  style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

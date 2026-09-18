import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../../ads/ad_manager.dart';
import '../data/heart_wallet_repository.dart';

class HeartShopBottomSheet extends StatelessWidget {
  final HeartWalletRepository wallet;
  final SupportedRegion currentRegion;

  const HeartShopBottomSheet({
    super.key,
    required this.wallet,
    this.currentRegion = SupportedRegion.korea,
  });

  static void show(
    BuildContext context,
    HeartWalletRepository wallet, {
    SupportedRegion currentRegion = SupportedRegion.korea,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HeartShopBottomSheet(wallet: wallet, currentRegion: currentRegion),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 32.0;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: bottomPadding,
      ),
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
              children: [
                Expanded(
                  child: Text(
                    AppI18n.tr('shop_title', currentRegion),
                    style: const TextStyle(
                      color: SpaceNavyTheme.goldChampagne,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
                      const SizedBox(width: 8),
                      Text(
                        wallet.hasVipPass ? 'VIP' : '${wallet.hearts} ❤️',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E5FF),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final rewarded = await AdManager.instance.showRewardedAd(context);
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

            const SizedBox(height: 14),

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
                        Navigator.of(context).pop();
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
                        Navigator.of(context).pop();
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

            const SizedBox(height: 14),

            // 3. Lifetime VIP Master Pass
            GlassBox(
              padding: const EdgeInsets.all(16),
              backgroundColor: const Color(0xFFE5C07B).withValues(alpha: 0.12),
              border: Border.all(color: SpaceNavyTheme.goldChampagne, width: 1.5),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium, color: SpaceNavyTheme.goldChampagne, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppI18n.tr('vip_master_title', currentRegion),
                          style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppI18n.tr('vip_master_desc', currentRegion),
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SpaceNavyTheme.goldChampagne,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    onPressed: () async {
                      await wallet.unlockVipMasterPass();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('👑 VIP Master Pass Activated!')),
                        );
                      }
                    },
                    child: Text(AppI18n.tr('buy_button', currentRegion), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
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
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: SpaceNavyTheme.goldChampagne),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: onBuy,
              child: Text(
                AppI18n.tr('buy_button', currentRegion),
                style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

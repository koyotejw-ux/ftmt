import 'package:flutter/material.dart';
import '../../core/localization/app_i18n.dart';
import '../../core/localization/geo_detector.dart';
import '../../core/theme/space_navy_theme.dart';
import '../economy/data/heart_wallet_repository.dart';
import '../economy/presentation/heart_shop_bottom_sheet.dart';

/// High-End AdMob Banner Widget with graceful native sponsored layout and VIP Pass CTA
class AdBannerWidget extends StatelessWidget {
  final HeartWalletRepository wallet;
  final SupportedRegion currentRegion;
  final EdgeInsetsGeometry margin;

  const AdBannerWidget({
    super.key,
    required this.wallet,
    this.currentRegion = SupportedRegion.korea,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    if (wallet.hasNoAds) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: margin,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1528),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SpaceNavyTheme.goldBorder.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HeartShopBottomSheet.show(context, wallet, currentRegion: currentRegion);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5C07B).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE5C07B).withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    AppI18n.tr('admob_sponsored_badge', currentRegion),
                    style: const TextStyle(
                      color: Color(0xFFE5C07B),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppI18n.tr('admob_banner_tagline', currentRegion),
                    style: const TextStyle(
                      color: Color(0xFFD6DFEF),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE5C07B), Color(0xFFFFB300)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'VIP',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

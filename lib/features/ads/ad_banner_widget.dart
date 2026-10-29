import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/ad_constants.dart';
import '../../core/localization/app_i18n.dart';
import '../../core/localization/geo_detector.dart';
import '../../core/theme/space_navy_theme.dart';
import '../economy/data/heart_wallet_repository.dart';
import '../economy/presentation/heart_shop_bottom_sheet.dart';

/// High-End AdMob Banner Widget:
/// Displays real Google AdMob Banner when available,
/// with instant native sponsored VIP fallback and auto-hide when ad-free.
class AdBannerWidget extends StatefulWidget {
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
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (widget.wallet.hasNoAds) return;

    try {
      _bannerAd = BannerAd(
        adUnitId: AdConstants.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() => _isAdLoaded = true);
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            _bannerAd = null;
            debugPrint('[AdBannerWidget] Banner failed to load: $error. Showing VIP fallback.');
          },
        ),
      )..load();
    } catch (e) {
      debugPrint('[AdBannerWidget] Banner load error: $e');
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.wallet.hasNoAds) {
      return const SizedBox.shrink();
    }

    // 1. When real Google AdMob banner is ready
    if (_isAdLoaded && _bannerAd != null) {
      return Container(
        margin: widget.margin,
        alignment: Alignment.center,
        height: _bannerAd!.size.height.toDouble(),
        width: _bannerAd!.size.width.toDouble(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    // 2. High-converting native sponsored layout (fallback while loading or offline)
    return Container(
      margin: widget.margin,
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
            HeartShopBottomSheet.show(context, widget.wallet, currentRegion: widget.currentRegion);
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
                    AppI18n.tr('admob_sponsored_badge', widget.currentRegion),
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
                    AppI18n.tr('admob_banner_tagline', widget.currentRegion),
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

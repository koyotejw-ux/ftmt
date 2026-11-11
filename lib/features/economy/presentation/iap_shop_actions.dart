import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../data/iap_service.dart';

/// Shared In-App Purchase actions and Restore Purchases button for shop views.
class IapShopActions {
  static Future<void> launchPurchase(
    BuildContext context, {
    required String productId,
    required SupportedRegion currentRegion,
  }) async {
    final launched = await IapService.instance.buyProduct(productId);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppI18n.tr('iap_unavailable_snack', currentRegion)),
        ),
      );
    }
  }

  static Future<void> restorePurchases(
    BuildContext context, {
    required SupportedRegion currentRegion,
  }) async {
    final ok = await IapService.instance.restorePurchases();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppI18n.tr(
            ok ? 'restore_purchases_snack' : 'iap_unavailable_snack',
            currentRegion,
          ),
        ),
      ),
    );
  }

  static Widget buildRestoreButton(
    BuildContext context, {
    required SupportedRegion currentRegion,
  }) {
    return Center(
      child: TextButton.icon(
        onPressed: () => restorePurchases(context, currentRegion: currentRegion),
        icon: const Icon(Icons.restore, size: 16, color: SpaceNavyTheme.goldChampagne),
        label: Text(
          AppI18n.tr('restore_purchases', currentRegion),
          style: const TextStyle(
            color: SpaceNavyTheme.goldChampagne,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


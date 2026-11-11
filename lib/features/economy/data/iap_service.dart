import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'heart_wallet_repository.dart';

/// Pre-configured In-App Purchase item definitions matching Google Play Store Console
class IapProductCatalog {
  // 1. 소모성 아이템: 하트 10개 팩 ($0.99 / ₩1,500)
  static const String heartPack10 = 'heart_pack_10';

  // 2. 소모성 아이템: 하트 30개 팩 ($2.49 / ₩3,300, 인기 상품)
  static const String heartPack30 = 'heart_pack_30';

  // 3. 비소모성 아이템: 평생 광고 제거 ($2.99 / ₩4,400)
  static const String noAdsLifetime = 'no_ads_lifetime';

  // 4. 비소모성 아이템: 평생 VIP 마스터 패스 ($9.99 / ₩14,000, 무제한 하트 + 무제한 궁합 + 평생 광고 제거)
  static const String lifetimeVipMaster = 'lifetime_vip_master';

  static const Set<String> allProductIds = {
    heartPack10,
    heartPack30,
    noAdsLifetime,
    lifetimeVipMaster,
  };
}

/// Production Google Play In-App Billing Service
class IapService {
  static final IapService instance = IapService._();
  IapService._();

  InAppPurchase? _iapInstance;
  InAppPurchase get _iap => _iapInstance ??= InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  HeartWalletRepository? _wallet;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  final Map<String, ProductDetails> _products = {};
  Map<String, ProductDetails> get products => _products;

  final _deliveredController = StreamController<String>.broadcast();
  Stream<String> get onProductDelivered => _deliveredController.stream;

  bool _isInitialized = false;

  /// Return localized Google Play store price if loaded, otherwise fallback label
  String getDisplayPrice(String productId, String fallbackPrice) {
    return _products[productId]?.price ?? fallbackPrice;
  }

  /// Initialize Google Play Billing and setup purchase listener
  Future<void> initialize(HeartWalletRepository wallet) async {
    if (_isInitialized) return;
    _wallet = wallet;

    try {
      _isAvailable = await _iap.isAvailable();
      if (_isAvailable) {
        _subscription = _iap.purchaseStream.listen(
          _handlePurchaseUpdates,
          onDone: () => _subscription?.cancel(),
          onError: (error) => debugPrint('[IapService] Purchase stream error: $error'),
        );
        await queryProducts();
      }
    } catch (e) {
      debugPrint('[IapService] Initialize error: $e');
    }

    _isInitialized = true;
  }

  /// Query registered products from Google Play Console
  Future<void> queryProducts() async {
    try {
      final response = await _iap.queryProductDetails(IapProductCatalog.allProductIds);
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('[IapService] Not found product IDs in Play Console: ${response.notFoundIDs}');
      }
      for (final p in response.productDetails) {
        _products[p.id] = p;
      }
    } catch (e) {
      debugPrint('[IapService] Query products failed: $e');
    }
  }

  /// Process purchase events from Google Play Store
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Pending transaction (e.g. parental approval)
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint('[IapService] Purchase error: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          await _deliverProduct(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// Deliver purchased in-app goods directly to local wallet
  Future<void> _deliverProduct(PurchaseDetails purchase) async {
    if (_wallet == null) return;
    final productId = purchase.productID;

    switch (productId) {
      case IapProductCatalog.heartPack10:
        await _wallet!.addHearts(10);
        _deliveredController.add(productId);
        break;
      case IapProductCatalog.heartPack30:
        await _wallet!.addHearts(30);
        _deliveredController.add(productId);
        break;
      case IapProductCatalog.noAdsLifetime:
        await _wallet!.unlockNoAds();
        _deliveredController.add(productId);
        break;
      case IapProductCatalog.lifetimeVipMaster:
        await _wallet!.unlockVipMasterPass();
        _deliveredController.add(productId);
        break;
    }
  }

  /// Initiate in-app purchase flow (debug-only fallback when products are not yet active)
  Future<bool> buyProduct(String productId) async {
    if (_wallet == null) return false;

    if (_products.isEmpty && _isAvailable) {
      await queryProducts();
    }

    // 1. If Google Play Store product is loaded
    if (_products.containsKey(productId)) {
      final productDetails = _products[productId]!;
      final purchaseParam = PurchaseParam(productDetails: productDetails);

      if (productId == IapProductCatalog.heartPack10 || productId == IapProductCatalog.heartPack30) {
        return await _iap.buyConsumable(purchaseParam: purchaseParam);
      } else {
        return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }
    }

    // 2. Never grant free IAP items in release builds when store catalog is unavailable
    if (!kDebugMode) {
      debugPrint('[IapService] Product $productId unavailable in Play Console.');
      return false;
    }

    // 3. Debug-only fallback for local development testing
    debugPrint('[IapService] Product $productId not yet active in Console. Using debug fallback.');
    switch (productId) {
      case IapProductCatalog.heartPack10:
        await _wallet!.addHearts(10);
        _deliveredController.add(productId);
        return true;
      case IapProductCatalog.heartPack30:
        await _wallet!.addHearts(30);
        _deliveredController.add(productId);
        return true;
      case IapProductCatalog.noAdsLifetime:
        await _wallet!.unlockNoAds();
        _deliveredController.add(productId);
        return true;
      case IapProductCatalog.lifetimeVipMaster:
        await _wallet!.unlockVipMasterPass();
        _deliveredController.add(productId);
        return true;
      default:
        return false;
    }
  }

  /// Restore purchases for non-consumable items (Google Play requirement)
  Future<bool> restorePurchases() async {
    if (_isAvailable) {
      await _iap.restorePurchases();
      return true;
    }
    return false;
  }

  void dispose() {
    _subscription?.cancel();
  }
}

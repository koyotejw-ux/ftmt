import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/localization/app_i18n.dart';
import 'core/localization/geo_detector.dart';
import 'core/theme/aura_painter.dart';
import 'core/theme/space_navy_theme.dart';
import 'features/economy/data/heart_wallet_repository.dart';
import 'features/fortune/presentation/fortune_hub_screen.dart';
import 'features/match/presentation/match_hub_screen.dart';
import 'features/economy/presentation/shop_screen.dart';
import 'features/economy/presentation/vault_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final wallet = await HeartWalletRepository.create();
  runApp(FortuneMatchApp(wallet: wallet));
}

class FortuneMatchApp extends StatefulWidget {
  final HeartWalletRepository wallet;

  const FortuneMatchApp({super.key, required this.wallet});

  @override
  State<FortuneMatchApp> createState() => _FortuneMatchAppState();
}

class _FortuneMatchAppState extends State<FortuneMatchApp> {
  late SupportedRegion _currentRegion;

  @override
  void initState() {
    super.initState();
    // Auto-detect country based on device locale
    _currentRegion = GeoDetector.detectRegion();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FortuneMatch: Zodiac & Tarot',
      debugShowCheckedModeBanner: false,
      theme: SpaceNavyTheme.darkTheme,
      home: FortuneMatchMainScaffold(
        wallet: widget.wallet,
        currentRegion: _currentRegion,
        onRegionChanged: (newRegion) {
          setState(() => _currentRegion = newRegion);
        },
      ),
    );
  }
}

class FortuneMatchMainScaffold extends StatefulWidget {
  final HeartWalletRepository wallet;
  final SupportedRegion currentRegion;
  final ValueChanged<SupportedRegion> onRegionChanged;

  const FortuneMatchMainScaffold({
    super.key,
    required this.wallet,
    required this.currentRegion,
    required this.onRegionChanged,
  });

  @override
  State<FortuneMatchMainScaffold> createState() => _FortuneMatchMainScaffoldState();
}

class _FortuneMatchMainScaffoldState extends State<FortuneMatchMainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      FortuneHubScreen(
        currentRegion: widget.currentRegion,
        onRegionChanged: widget.onRegionChanged,
        wallet: widget.wallet,
      ),
      MatchHubScreen(
        currentRegion: widget.currentRegion,
      ),
      ShopScreen(
        wallet: widget.wallet,
        currentRegion: widget.currentRegion,
      ),
      VaultScreen(
        wallet: widget.wallet,
        currentRegion: widget.currentRegion,
      ),
      SettingsScreen(
        currentRegion: widget.currentRegion,
        onRegionChanged: widget.onRegionChanged,
      ),
    ];

    return AuraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              const Text(
                '✦ FortuneMatch',
                style: TextStyle(
                  color: SpaceNavyTheme.goldChampagne,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.currentRegion.countryCode,
                  style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF070A12).withValues(alpha: 0.95),
            border: const Border(
              top: BorderSide(color: SpaceNavyTheme.goldBorder, width: 1.0),
            ),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            selectedIndex: _currentIndex,
            indicatorColor: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.2),
            onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.auto_awesome_outlined, color: Colors.white60),
                selectedIcon: const Icon(Icons.auto_awesome, color: SpaceNavyTheme.goldChampagne),
                label: AppI18n.tr('nav_fortune', widget.currentRegion),
              ),
              NavigationDestination(
                icon: const Icon(Icons.favorite_border, color: Colors.white60),
                selectedIcon: const Icon(Icons.favorite, color: Colors.pinkAccent),
                label: AppI18n.tr('nav_match', widget.currentRegion),
              ),
              NavigationDestination(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white60),
                selectedIcon: const Icon(Icons.shopping_bag, color: SpaceNavyTheme.goldChampagne),
                label: AppI18n.tr('nav_shop', widget.currentRegion),
              ),
              NavigationDestination(
                icon: const Icon(Icons.folder_shared_outlined, color: Colors.white60),
                selectedIcon: const Icon(Icons.folder_shared, color: Color(0xFF00E5FF)),
                label: AppI18n.tr('nav_vault', widget.currentRegion),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined, color: Colors.white60),
                selectedIcon: const Icon(Icons.settings, color: Colors.white),
                label: AppI18n.tr('nav_settings', widget.currentRegion),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

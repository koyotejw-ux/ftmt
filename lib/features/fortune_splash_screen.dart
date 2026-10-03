import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/space_navy_theme.dart';

class FortuneSplashScreen extends StatefulWidget {
  final Widget child;

  const FortuneSplashScreen({super.key, required this.child});

  @override
  State<FortuneSplashScreen> createState() => _FortuneSplashScreenState();
}

class _FortuneSplashScreenState extends State<FortuneSplashScreen> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1450), () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showSplash) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: SpaceNavyTheme.backgroundDeep,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: SpaceNavyTheme.violetAurora.withValues(alpha: 0.35),
                    blurRadius: 36,
                    spreadRadius: 8,
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/icon/splash_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            )
                .animate()
                .fade(duration: 600.ms)
                .scale(begin: const Offset(0.85, 0.85), end: const Offset(1.0, 1.0), curve: Curves.easeOutCubic),
            const SizedBox(height: 24),
            const Text(
              '✦ FortuneMatch',
              style: TextStyle(
                color: SpaceNavyTheme.goldChampagne,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            )
                .animate()
                .fade(delay: 200.ms, duration: 600.ms),
            const SizedBox(height: 8),
            const Text(
              'Zodiac & Tarot',
              style: TextStyle(
                color: SpaceNavyTheme.textSecondary,
                fontSize: 13,
                letterSpacing: 3.0,
              ),
            )
                .animate()
                .fade(delay: 400.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}

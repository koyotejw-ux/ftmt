import 'package:flutter/material.dart';
import '../core/theme/space_navy_theme.dart';

class FortuneSplashScreen extends StatefulWidget {
  final Widget child;

  const FortuneSplashScreen({super.key, required this.child});

  @override
  State<FortuneSplashScreen> createState() => _FortuneSplashScreenState();
}

class _FortuneSplashScreenState extends State<FortuneSplashScreen> {
  bool _splashVisible = true;
  bool _splashRemoved = false;

  @override
  void initState() {
    super.initState();
    // Seamless unified splash: hold for brief moment then smoothly cross-fade into main app
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() => _splashVisible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_splashRemoved) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        AnimatedOpacity(
          opacity: _splashVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          onEnd: () {
            if (!_splashVisible && mounted) {
              setState(() => _splashRemoved = true);
            }
          },
          child: Scaffold(
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
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '✦ FortuneMatch',
                    style: TextStyle(
                      color: SpaceNavyTheme.goldChampagne,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Zodiac & Tarot',
                    style: TextStyle(
                      color: SpaceNavyTheme.textSecondary,
                      fontSize: 13,
                      letterSpacing: 3.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

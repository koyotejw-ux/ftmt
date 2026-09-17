import 'dart:math';
import 'package:flutter/material.dart';

class AuraBackground extends StatefulWidget {
  final Widget child;

  const AuraBackground({super.key, required this.child});

  @override
  State<AuraBackground> createState() => _AuraBackgroundState();
}

class _AuraBackgroundState extends State<AuraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Solid deep space foundation
        const Positioned.fill(
          child: ColoredBox(color: Color(0xFF070A12)),
        ),
        // Dynamic Aura and Stardust canvas
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: AuraStardustPainter(progress: _controller.value),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class AuraStardustPainter extends CustomPainter {
  final double progress;
  static final List<Point<double>> _stars = List.generate(45, (index) {
    final rand = Random(index * 997);
    return Point(rand.nextDouble(), rand.nextDouble());
  });

  AuraStardustPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Aurora gradients (Violet & Cyan nebula)
    final center1 = Offset(
      size.width * (0.3 + 0.15 * sin(progress * 2 * pi)),
      size.height * (0.2 + 0.1 * cos(progress * 2 * pi)),
    );
    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF8A2BE2).withValues(alpha: 0.18),
          Colors.transparent,
        ],
        radius: 0.8,
      ).createShader(Rect.fromCircle(center: center1, radius: size.width * 0.7));

    canvas.drawCircle(center1, size.width * 0.7, paint1);

    final center2 = Offset(
      size.width * (0.7 - 0.15 * cos(progress * 2 * pi)),
      size.height * (0.65 + 0.1 * sin(progress * 2 * pi)),
    );
    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00E5FF).withValues(alpha: 0.12),
          Colors.transparent,
        ],
        radius: 0.7,
      ).createShader(Rect.fromCircle(center: center2, radius: size.width * 0.65));

    canvas.drawCircle(center2, size.width * 0.65, paint2);

    // Warm Gold Stardust Glow at bottom center
    final center3 = Offset(size.width * 0.5, size.height * 0.95);
    final paint3 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFE5C07B).withValues(alpha: 0.10),
          Colors.transparent,
        ],
        radius: 0.6,
      ).createShader(Rect.fromCircle(center: center3, radius: size.width * 0.6));

    canvas.drawCircle(center3, size.width * 0.6, paint3);

    // 2. Stardust Particles twinkling
    final starPaint = Paint();
    for (int i = 0; i < _stars.length; i++) {
      final star = _stars[i];
      final px = star.x * size.width;
      final py = star.y * size.height;
      final twinkle = sin((progress * 2 * pi) + (i * 0.8));
      final opacity = (0.25 + 0.65 * ((twinkle + 1) / 2)).clamp(0.0, 1.0);
      final radius = (i % 3 == 0) ? 1.4 : 0.9;

      starPaint.color = (i % 5 == 0)
          ? const Color(0xFFE5C07B).withValues(alpha: opacity)
          : Colors.white.withValues(alpha: opacity);

      canvas.drawCircle(Offset(px, py), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AuraStardustPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

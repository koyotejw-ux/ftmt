import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../core/theme/space_navy_theme.dart';

class AstralWheelWidget extends StatefulWidget {
  final VoidCallback? onTap;

  const AstralWheelWidget({super.key, this.onTap});

  @override
  State<AstralWheelWidget> createState() => _AstralWheelWidgetState();
}

class _AstralWheelWidgetState extends State<AstralWheelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  double _sensorAngleOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    // Listen to device gyroscope to subtly tilt the astral wheel
    try {
      gyroscopeEventStream().listen((GyroscopeEvent event) {
        if (mounted) {
          setState(() {
            _sensorAngleOffset += event.z * 0.015;
          });
        }
      });
    } catch (_) {
      // Graceful fallback if device sensor is not present
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 220,
        child: Center(
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, _) {
              final angle = (_rotationController.value * 2 * pi) + _sensorAngleOffset;
              return CustomPaint(
                size: const Size(220, 220),
                painter: AstralWheelPainter(angle: angle),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AstralWheelPainter extends CustomPainter {
  final double angle;

  static const List<String> zodiacGlyphs = [
    '♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'
  ];
  static const List<String> stemGlyphs = [
    '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'
  ];

  AstralWheelPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Radiant Glow ring
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          SpaceNavyTheme.goldChampagne.withValues(alpha: 0.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);

    // 2. Outer golden boundary ring
    final outerRingPaint = Paint()
      ..color = SpaceNavyTheme.goldChampagne.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.95, outerRingPaint);

    // 3. Inner middle ring
    final midRingPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius * 0.68, midRingPaint);

    // 4. Center Celestial Core
    final corePaint = Paint()
      ..color = const Color(0xFF0D1224)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.38, corePaint);

    final coreBorderPaint = Paint()
      ..color = SpaceNavyTheme.goldChampagne
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.38, coreBorderPaint);

    // Center icon text (Sun / Harmony)
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '✦',
        style: TextStyle(
          color: SpaceNavyTheme.goldChampagne,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );

    // 5. Draw rotating 12 Zodiac segments on outer circle
    for (int i = 0; i < 12; i++) {
      final currentAngle = angle + (i * 2 * pi / 12);
      final x = center.dx + (radius * 0.82) * cos(currentAngle);
      final y = center.dy + (radius * 0.82) * sin(currentAngle);

      final glyphPainter = TextPainter(
        text: TextSpan(
          text: zodiacGlyphs[i],
          style: TextStyle(
            color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.85),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      glyphPainter.paint(
        canvas,
        Offset(x - glyphPainter.width / 2, y - glyphPainter.height / 2),
      );
    }

    // 6. Draw counter-rotating 10 Stems on inner ring
    for (int i = 0; i < 10; i++) {
      final currentAngle = -angle + (i * 2 * pi / 10);
      final x = center.dx + (radius * 0.52) * cos(currentAngle);
      final y = center.dy + (radius * 0.52) * sin(currentAngle);

      final stemPainter = TextPainter(
        text: TextSpan(
          text: stemGlyphs[i],
          style: TextStyle(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.75),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      stemPainter.paint(
        canvas,
        Offset(x - stemPainter.width / 2, y - stemPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant AstralWheelPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/space_navy_theme.dart';

class AstralWheelWidget extends StatefulWidget {
  final SupportedRegion currentRegion;
  final VoidCallback? onTap;

  const AstralWheelWidget({
    super.key,
    required this.currentRegion,
    this.onTap,
  });

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
                painter: AstralWheelPainter(
                  angle: angle,
                  region: widget.currentRegion,
                ),
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
  final SupportedRegion region;

  // Western Zodiac
  static const List<String> zodiacGlyphs = [
    '♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'
  ];
  static const List<String> zodiacConstellationNames = [
    'ARI', 'TAU', 'GEM', 'CAN', 'LEO', 'VIR', 'LIB', 'SCO', 'SAG', 'CAP', 'AQU', 'PIS'
  ];

  // Korean Bazi (10 Heavenly Stems & 12 Earthly Branches)
  static const List<String> stemGlyphs = [
    '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'
  ];
  static const List<String> branchGlyphs = [
    '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'
  ];

  // Japanese Nine Star Ki & Bagua
  static const List<String> nineStarGlyphs = [
    '一白', '二黒', '三碧', '四緑', '五黄', '六白', '七赤', '八白', '九紫'
  ];
  static const List<String> baguaTrigrams = [
    '☰', '☱', '☲', '☳', '☴', '☵', '☶', '☷'
  ];

  // Celtic / European Runes (Elder Futhark selection)
  static const List<String> celticRunes = [
    'ᚠ', 'ᚢ', 'ᚦ', 'ᚨ', 'ᚱ', 'ᚲ', 'ᚷ', 'ᚹ', 'ᚺ', 'ᚾ', 'ᛁ', 'ᛃ'
  ];
  static const List<String> runeMeanings = [
    'FEHU', 'URUZ', 'THUR', 'ANSU', 'RAID', 'KEN', 'GEBO', 'WUN', 'HAGL', 'NAUD', 'ISA', 'JERA'
  ];

  AstralWheelPainter({required this.angle, required this.region});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    switch (region) {
      case SupportedRegion.korea:
        _paintKoreaBaziWheel(canvas, center, radius);
        break;
      case SupportedRegion.unitedStates:
      case SupportedRegion.unitedKingdom:
        _paintWesternNatalWheel(canvas, center, radius);
        break;
      case SupportedRegion.japan:
        _paintJapanNineStarWheel(canvas, center, radius);
        break;
      case SupportedRegion.germany:
      case SupportedRegion.france:
      case SupportedRegion.spain:
      case SupportedRegion.italy:
        _paintCelticRunicWheel(canvas, center, radius);
        break;
    }
  }

  // 1. KR: Korean Bazi & Cheongan-Jiji Wheel
  void _paintKoreaBaziWheel(Canvas canvas, Offset center, double radius) {
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          SpaceNavyTheme.goldChampagne.withValues(alpha: 0.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);

    // Outer ring with golden dash
    final outerRing = Paint()
      ..color = SpaceNavyTheme.goldChampagne.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.95, outerRing);

    // Mid ring
    final midRing = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius * 0.68, midRing);

    // Center Yin-Yang Core
    final corePaint = Paint()
      ..color = const Color(0xFF0D1224)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.38, corePaint);

    final coreBorder = Paint()
      ..color = SpaceNavyTheme.goldChampagne
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.38, coreBorder);

    _drawText(canvas, center, '陰陽', const TextStyle(
      color: SpaceNavyTheme.goldChampagne,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ));

    // Outer 12 Earthly Branches (지지)
    for (int i = 0; i < 12; i++) {
      final curAngle = angle + (i * 2 * pi / 12);
      final x = center.dx + (radius * 0.82) * cos(curAngle);
      final y = center.dy + (radius * 0.82) * sin(curAngle);
      _drawText(canvas, Offset(x, y), branchGlyphs[i], TextStyle(
        color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.9),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ));
    }

    // Inner 10 Heavenly Stems (천간)
    for (int i = 0; i < 10; i++) {
      final curAngle = -angle + (i * 2 * pi / 10);
      final x = center.dx + (radius * 0.52) * cos(curAngle);
      final y = center.dy + (radius * 0.52) * sin(curAngle);
      _drawText(canvas, Offset(x, y), stemGlyphs[i], const TextStyle(
        color: Color(0xFF00E5FF),
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ));
    }
  }

  // 2. US: Western Zodiac Natal Wheel (Chords, Degrees, 12 Constellations)
  void _paintWesternNatalWheel(Canvas canvas, Offset center, double radius) {
    // Mystic violet glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF8A2BE2).withValues(alpha: 0.22),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);

    final outerRing = Paint()
      ..color = const Color(0xFFE5C07B).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawCircle(center, radius * 0.96, outerRing);

    final innerRing = Paint()
      ..color = const Color(0xFF8A2BE2).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius * 0.65, innerRing);

    // Aspect lines (Trines & Sextiles chords)
    final aspectPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.0;
    for (int i = 0; i < 4; i++) {
      final a1 = angle + (i * pi / 2);
      final a2 = a1 + (2 * pi / 3);
      canvas.drawLine(
        Offset(center.dx + (radius * 0.65) * cos(a1), center.dy + (radius * 0.65) * sin(a1)),
        Offset(center.dx + (radius * 0.65) * cos(a2), center.dy + (radius * 0.65) * sin(a2)),
        aspectPaint,
      );
    }

    // Center Sun/Ascendant Core
    final corePaint = Paint()
      ..color = const Color(0xFF0B0F1F)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.36, corePaint);

    final coreBorder = Paint()
      ..color = const Color(0xFFE5C07B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.36, coreBorder);

    _drawText(canvas, center, '☉ ☽', const TextStyle(
      color: Color(0xFFE5C07B),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ));

    // Outer 12 Zodiac Glyphs
    for (int i = 0; i < 12; i++) {
      final curAngle = angle + (i * 2 * pi / 12);
      final x = center.dx + (radius * 0.82) * cos(curAngle);
      final y = center.dy + (radius * 0.82) * sin(curAngle);
      _drawText(canvas, Offset(x, y), zodiacGlyphs[i], const TextStyle(
        color: Color(0xFFE5C07B),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ));
    }

    // Inner Constellation Codes (ARI, TAU, GEM...)
    for (int i = 0; i < 12; i++) {
      final curAngle = -angle + (i * 2 * pi / 12);
      final x = center.dx + (radius * 0.50) * cos(curAngle);
      final y = center.dy + (radius * 0.50) * sin(curAngle);
      _drawText(canvas, Offset(x, y), zodiacConstellationNames[i], TextStyle(
        color: Colors.white.withValues(alpha: 0.65),
        fontSize: 8,
        fontWeight: FontWeight.w600,
      ));
    }
  }

  // 3. JP: Nine Star Ki & Bagua Wheel (九星気学 & 八卦)
  void _paintJapanNineStarWheel(Canvas canvas, Offset center, double radius) {
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF4081).withValues(alpha: 0.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);

    final outerRing = Paint()
      ..color = const Color(0xFFE5C07B).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.95, outerRing);

    final midRing = Paint()
      ..color = const Color(0xFFFF5252).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius * 0.66, midRing);

    // Center Sacred Core
    final corePaint = Paint()
      ..color = const Color(0xFF140D18)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.36, corePaint);

    final coreBorder = Paint()
      ..color = const Color(0xFFE5C07B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.36, coreBorder);

    _drawText(canvas, center, '気学', const TextStyle(
      color: Color(0xFFE5C07B),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ));

    // Outer 9 Star Ki (一白, 二黒, 三碧...)
    for (int i = 0; i < 9; i++) {
      final curAngle = angle + (i * 2 * pi / 9);
      final x = center.dx + (radius * 0.82) * cos(curAngle);
      final y = center.dy + (radius * 0.82) * sin(curAngle);
      _drawText(canvas, Offset(x, y), nineStarGlyphs[i], const TextStyle(
        color: Color(0xFFFFD54F),
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ));
    }

    // Inner 8 Bagua Trigrams (☰ ☱ ☲...)
    for (int i = 0; i < 8; i++) {
      final curAngle = -angle + (i * 2 * pi / 8);
      final x = center.dx + (radius * 0.50) * cos(curAngle);
      final y = center.dy + (radius * 0.50) * sin(curAngle);
      _drawText(canvas, Offset(x, y), baguaTrigrams[i], const TextStyle(
        color: Color(0xFFFF80AB),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ));
    }
  }

  // 4. EU: Celtic Runic Compass (Elder Futhark)
  void _paintCelticRunicWheel(Canvas canvas, Offset center, double radius) {
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00E676).withValues(alpha: 0.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);

    final outerRing = Paint()
      ..color = const Color(0xFF69F0AE).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.95, outerRing);

    final midRing = Paint()
      ..color = const Color(0xFFE5C07B).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius * 0.66, midRing);

    // Compass Cross lines
    final crossPaint = Paint()
      ..color = const Color(0xFF69F0AE).withValues(alpha: 0.2)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(center.dx - radius * 0.95, center.dy), Offset(center.dx + radius * 0.95, center.dy), crossPaint);
    canvas.drawLine(Offset(center.dx, center.dy - radius * 0.95), Offset(center.dx, center.dy + radius * 0.95), crossPaint);

    // Center Core (Vegvisir / Celtic Knot Anchor)
    final corePaint = Paint()
      ..color = const Color(0xFF081813)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.36, corePaint);

    final coreBorder = Paint()
      ..color = const Color(0xFF69F0AE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.36, coreBorder);

    _drawText(canvas, center, 'ᚩ', const TextStyle(
      color: Color(0xFF69F0AE),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ));

    // Outer 12 Runes
    for (int i = 0; i < 12; i++) {
      final curAngle = angle + (i * 2 * pi / 12);
      final x = center.dx + (radius * 0.82) * cos(curAngle);
      final y = center.dy + (radius * 0.82) * sin(curAngle);
      _drawText(canvas, Offset(x, y), celticRunes[i], const TextStyle(
        color: Color(0xFFE5C07B),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ));
    }

    // Inner Rune Names
    for (int i = 0; i < 12; i++) {
      final curAngle = -angle + (i * 2 * pi / 12);
      final x = center.dx + (radius * 0.50) * cos(curAngle);
      final y = center.dy + (radius * 0.50) * sin(curAngle);
      _drawText(canvas, Offset(x, y), runeMeanings[i], TextStyle(
        color: Colors.white.withValues(alpha: 0.6),
        fontSize: 7,
        fontWeight: FontWeight.bold,
      ));
    }
  }

  void _drawText(Canvas canvas, Offset center, String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant AstralWheelPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.region != region;
  }
}


import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/space_navy_theme.dart';

class RadarChartView extends StatelessWidget {
  final Map<String, double> values; // Key: Label, Value: 0.0 ~ 100.0
  final Color polygonColor;
  final double size;

  const RadarChartView({
    super.key,
    required this.values,
    this.polygonColor = SpaceNavyTheme.goldChampagne,
    this.size = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadarChartPainter(
          values: values,
          polygonColor: polygonColor,
        ),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final Map<String, double> values;
  final Color polygonColor;

  _RadarChartPainter({required this.values, required this.polygonColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * 0.72;
    final keys = values.keys.toList();
    final count = keys.length;

    if (count < 3) return;

    // 1. Draw web grid rings (25%, 50%, 75%, 100%)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int step = 1; step <= 4; step++) {
      final ringRadius = radius * (step / 4);
      final ringPath = Path();
      for (int i = 0; i < count; i++) {
        final angle = (i * 2 * pi / count) - (pi / 2);
        final x = center.dx + ringRadius * cos(angle);
        final y = center.dy + ringRadius * sin(angle);
        if (i == 0) {
          ringPath.moveTo(x, y);
        } else {
          ringPath.lineTo(x, y);
        }
      }
      ringPath.close();
      canvas.drawPath(ringPath, gridPaint);
    }

    // 2. Draw axes and label text
    final axisPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * pi / count) - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), axisPaint);

      // Label positioning slightly outside radius
      final labelX = center.dx + (radius + 20) * cos(angle);
      final labelY = center.dy + (radius + 20) * sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: keys[i],
          style: const TextStyle(
            color: SpaceNavyTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );
    }

    // 3. Draw filled polygon for values
    final polygonPath = Path();
    final pointOffsets = <Offset>[];

    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * pi / count) - (pi / 2);
      final val = (values[keys[i]] ?? 50.0).clamp(0.0, 100.0) / 100.0;
      final x = center.dx + (radius * val) * cos(angle);
      final y = center.dy + (radius * val) * sin(angle);
      pointOffsets.add(Offset(x, y));

      if (i == 0) {
        polygonPath.moveTo(x, y);
      } else {
        polygonPath.lineTo(x, y);
      }
    }
    polygonPath.close();

    final fillPaint = Paint()
      ..color = polygonColor.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;
    canvas.drawPath(polygonPath, fillPaint);

    final borderPaint = Paint()
      ..color = polygonColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(polygonPath, borderPaint);

    // Draw small dot on each point
    final dotPaint = Paint()..color = Colors.white;
    for (final pt in pointOffsets) {
      canvas.drawCircle(pt, 3.5, dotPaint);
      canvas.drawCircle(pt, 3.5, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.polygonColor != polygonColor;
  }
}

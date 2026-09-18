import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/space_navy_theme.dart';

class CalculatingHudDialog extends StatefulWidget {
  final VoidCallback onComplete;
  final SupportedRegion region;

  const CalculatingHudDialog({
    super.key,
    required this.onComplete,
    this.region = SupportedRegion.korea,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onFinished,
    SupportedRegion region = SupportedRegion.korea,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CalculatingHudDialog(
        region: region,
        onComplete: () {
          Navigator.of(ctx).pop();
          onFinished();
        },
      ),
    );
  }

  @override
  State<CalculatingHudDialog> createState() => _CalculatingHudDialogState();
}

class _CalculatingHudDialogState extends State<CalculatingHudDialog> {
  int _logIndex = 0;
  Timer? _timer;

  List<String> _getLogs() {
    return [
      AppI18n.tr('hud_log_1', widget.region),
      AppI18n.tr('hud_log_2', widget.region),
      AppI18n.tr('hud_log_3', widget.region),
      AppI18n.tr('hud_log_4', widget.region),
      AppI18n.tr('hud_log_5', widget.region),
    ];
  }

  @override
  void initState() {
    super.initState();
    final logs = _getLogs();
    // Progress through logs in ~1.5 - 1.8 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 360), (timer) {
      if (_logIndex < logs.length - 1) {
        setState(() => _logIndex++);
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) widget.onComplete();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF070A12).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.7),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(SpaceNavyTheme.goldChampagne),
                  strokeWidth: 2.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'ASTRONOMICAL CALCULATION',
                style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _getLogs()[_logIndex],
                  key: ValueKey<int>(_logIndex),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: (_logIndex + 1) / _getLogs().length,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E5FF)),
                minHeight: 3,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

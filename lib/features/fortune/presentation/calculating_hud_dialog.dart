import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/space_navy_theme.dart';

class CalculatingHudDialog extends StatefulWidget {
  final VoidCallback onComplete;

  const CalculatingHudDialog({super.key, required this.onComplete});

  static Future<void> show(BuildContext context, {required VoidCallback onFinished}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CalculatingHudDialog(
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

  static const List<String> hudLogs = [
    '동경 135도 표준시 기준 진태양시(-32분) 오차 보정 중...',
    '적천수(滴天髓) 및 궁통보감 원전 알고리즘 대조...',
    '태양-목성 간 각도(Aspect) 120도 트라인(Trine) 검출...',
    '개인 오행(목화토금수) 에너지 밀도 헥사곤 산출 중...',
    '최종 운명 데이터 매트릭스 렌더링 완료!',
  ];

  @override
  void initState() {
    super.initState();
    // Progress through logs in ~1.5 - 1.8 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 360), (timer) {
      if (_logIndex < hudLogs.length - 1) {
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
                  hudLogs[_logIndex],
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
                value: (_logIndex + 1) / hudLogs.length,
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

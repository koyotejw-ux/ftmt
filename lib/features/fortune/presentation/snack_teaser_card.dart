import 'package:flutter/material.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';

class SnackTeaserCard extends StatelessWidget {
  final VoidCallback onTap;

  const SnackTeaserCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      backgroundColor: const Color(0xFF141B33).withValues(alpha: 0.65),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [SpaceNavyTheme.goldChampagne, Color(0xFFFFA000)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, color: Colors.black, size: 14),
                    SizedBox(width: 2),
                    Text(
                      '오늘의 도파민 시크릿',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.lock_open, color: SpaceNavyTheme.goldChampagne, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '오늘 당신에게 금전운이 터지는 최적 시간',
            style: TextStyle(
              color: SpaceNavyTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                '14:30 ~ 16:00',
                style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '상세 행동 요령 열기 >',
                  style: TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white10),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFFF5252), size: 14),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '주의: 오늘 당신의 에너지를 뺏는 사람: 목(木) 기운이 강한 인물',
                  style: TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

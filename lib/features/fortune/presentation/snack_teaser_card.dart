import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';

class SnackTeaserCard extends StatelessWidget {
  final VoidCallback onTap;
  final SupportedRegion currentRegion;

  const SnackTeaserCard({
    super.key,
    required this.onTap,
    this.currentRegion = SupportedRegion.korea,
  });

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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, color: Colors.black, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      AppI18n.tr('today_dopamine_secret', currentRegion),
                      style: const TextStyle(
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
          Text(
            AppI18n.tr('wealth_golden_time', currentRegion),
            style: const TextStyle(
              color: SpaceNavyTheme.textPrimary,
              fontSize: 15,
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
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    AppI18n.tr('open_action_guide', currentRegion),
                    style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white10),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.warning_amber_rounded, color: Color(0xFFFF5252), size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppI18n.tr('energy_warning_snack', currentRegion),
                  style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12, height: 1.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

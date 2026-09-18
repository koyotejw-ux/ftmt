import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/glass_box.dart';
import '../../../core/theme/space_navy_theme.dart';

class SettingsScreen extends StatefulWidget {
  final SupportedRegion currentRegion;
  final ValueChanged<SupportedRegion> onRegionChanged;

  const SettingsScreen({
    super.key,
    required this.currentRegion,
    required this.onRegionChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _trueSolarTimeEnabled = true;
  bool _hapticEnabled = true;
  bool _ambientSoundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Language & Region Switcher Section
          GlassBox(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.language, color: SpaceNavyTheme.goldChampagne, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      AppI18n.tr('language_region_setting', widget.currentRegion),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppI18n.tr('language_region_desc', widget.currentRegion),
                  style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF0D1224),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (modalCtx) {
                        return SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom: MediaQuery.of(modalCtx).padding.bottom + 24,
                            ),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.public, color: SpaceNavyTheme.goldChampagne, size: 22),
                                      const SizedBox(width: 10),
                                      Text(
                                        AppI18n.tr('language_region_setting', widget.currentRegion),
                                        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ...SupportedRegion.values.map((r) {
                                    final isSelected = r == widget.currentRegion;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(14),
                                          onTap: () {
                                            Navigator.of(modalCtx).pop();
                                            widget.onRegionChanged(r);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? SpaceNavyTheme.goldChampagne.withValues(alpha: 0.15)
                                                  : Colors.white.withValues(alpha: 0.04),
                                              borderRadius: BorderRadius.circular(14),
                                              border: Border.all(
                                                color: isSelected
                                                    ? SpaceNavyTheme.goldChampagne
                                                    : SpaceNavyTheme.goldBorder.withValues(alpha: 0.5),
                                                width: isSelected ? 1.5 : 1.0,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? SpaceNavyTheme.goldChampagne
                                                        : Colors.white.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    r.countryCode,
                                                    style: TextStyle(
                                                      color: isSelected ? Colors.black : Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Text(
                                                    r.label,
                                                    style: TextStyle(
                                                      color: isSelected ? SpaceNavyTheme.goldChampagne : Colors.white,
                                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                if (isSelected)
                                                  const Icon(Icons.check_circle, color: SpaceNavyTheme.goldChampagne, size: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: SpaceNavyTheme.goldBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.currentRegion.countryCode,
                            style: const TextStyle(
                              color: SpaceNavyTheme.goldChampagne,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${widget.currentRegion.countryCode} - ${widget.currentRegion.label}',
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: SpaceNavyTheme.goldChampagne, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Astrological Calculations & Precision Switches
          GlassBox(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: SpaceNavyTheme.goldChampagne,
                  activeThumbColor: Colors.black,
                  title: Text(
                    AppI18n.tr('solar_time_correction', widget.currentRegion),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    AppI18n.tr('solar_time_desc', widget.currentRegion),
                    style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 11),
                  ),
                  value: _trueSolarTimeEnabled,
                  onChanged: (val) => setState(() => _trueSolarTimeEnabled = val),
                ),
                const Divider(color: Colors.white10),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: const Color(0xFF00E5FF),
                  activeThumbColor: Colors.black,
                  title: Text(
                    AppI18n.tr('haptic_feedback', widget.currentRegion),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  value: _hapticEnabled,
                  onChanged: (val) => setState(() => _hapticEnabled = val),
                ),
                const Divider(color: Colors.white10),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: const Color(0xFF8A2BE2),
                  activeThumbColor: Colors.white,
                  title: Text(
                    AppI18n.tr('sound_fx', widget.currentRegion),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  value: _ambientSoundEnabled,
                  onChanged: (val) => setState(() => _ambientSoundEnabled = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Privacy & Legal Compliance
          GlassBox(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: SpaceNavyTheme.goldChampagne, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppI18n.tr('privacy_legal', widget.currentRegion),
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppI18n.tr('privacy_desc', widget.currentRegion),
                  style: const TextStyle(color: Color(0xFF9AA7C7), fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppI18n.tr('app_version', widget.currentRegion),
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    const Text(
                      'v1.0.0+1 (Local-First Pro)',
                      style: TextStyle(color: SpaceNavyTheme.cyanNeon, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

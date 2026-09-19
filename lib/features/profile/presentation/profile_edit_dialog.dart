import 'package:flutter/material.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../../core/theme/space_navy_theme.dart';
import '../data/user_profile_repository.dart';

class ProfileEditDialog extends StatefulWidget {
  final UserProfile initialProfile;
  final SupportedRegion region;
  final String title;
  final bool isForSelf;
  final ValueChanged<UserProfile> onSaved;

  const ProfileEditDialog({
    super.key,
    required this.initialProfile,
    required this.region,
    required this.onSaved,
    this.title = '',
    this.isForSelf = true,
  });

  static Future<void> show(
    BuildContext context, {
    required UserProfile initialProfile,
    required SupportedRegion region,
    required ValueChanged<UserProfile> onSaved,
    String? title,
    bool isForSelf = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D1224),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => ProfileEditDialog(
        initialProfile: initialProfile,
        region: region,
        title: title ?? (isForSelf ? AppI18n.tr('profile_edit_title', region) : AppI18n.tr('profile_other_title', region)),
        isForSelf: isForSelf,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  late TextEditingController _nameCtrl;
  late DateTime _birthDateTime;
  late String _city;
  late String _bloodType;
  late String _mbti;
  late String _gender;

  final List<String> _bloodTypes = ['A형', 'B형', 'O형', 'AB형'];
  final List<String> _mbtis = [
    'ENFP', 'ENFJ', 'ENTP', 'ENTJ',
    'ESFP', 'ESFJ', 'ESTP', 'ESTJ',
    'INFP', 'INFJ', 'INTP', 'INTJ',
    'ISFP', 'ISFJ', 'ISTP', 'ISTJ',
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialProfile.name);
    _birthDateTime = widget.initialProfile.birthDateTime;
    _city = widget.initialProfile.city;
    _bloodType = widget.initialProfile.bloodType;
    _mbti = widget.initialProfile.mbti ?? 'ENFP';
    _gender = widget.initialProfile.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  UserProfile _buildCurrentProfile() {
    return UserProfile(
      name: _nameCtrl.text.trim().isEmpty ? (widget.isForSelf ? '나 (본인)' : '상대방') : _nameCtrl.text.trim(),
      birthDateTime: _birthDateTime,
      city: _city,
      bloodType: _bloodType,
      mbti: _mbti,
      gender: _gender,
    );
  }

  @override
  Widget build(BuildContext context) {
    final preview = _buildCurrentProfile();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 24.0;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: SpaceNavyTheme.goldChampagne,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '100% On-Device Local',
                    style: TextStyle(color: Color(0xFF00E5FF), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Live Calculated Preview Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SpaceNavyTheme.goldChampagne.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPreviewPill('사주 일주', preview.sajuIlju.split('(').first),
                  _buildPreviewPill('12간지 띠', preview.zodiacAnimal.split('(')[1].replaceAll(')', '')),
                  _buildPreviewPill('황도 12궁', preview.sunSign),
                  _buildPreviewPill('혈액형', preview.bloodType),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Name
            Text(AppI18n.tr('profile_name_label', widget.region), style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.isForSelf ? '예: 나 (본인)' : '예: 홍길동 (친구/연인)',
                hintStyle: const TextStyle(color: Colors.white30),
                isDense: true,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: SpaceNavyTheme.goldBorder)),
              ),
            ),

            const SizedBox(height: 14),

            // Birth Date & Time Picker
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: SpaceNavyTheme.goldBorder),
              ),
              tileColor: Colors.white.withValues(alpha: 0.04),
              leading: const Icon(Icons.calendar_month, color: SpaceNavyTheme.goldChampagne),
              title: Text(
                AppI18n.tr('birth_datetime_label', widget.region),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              subtitle: Text(
                '${_birthDateTime.year}-${_birthDateTime.month.toString().padLeft(2, '0')}-${_birthDateTime.day.toString().padLeft(2, '0')} ${_birthDateTime.hour.toString().padLeft(2, '0')}:${_birthDateTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              trailing: const Icon(Icons.edit_calendar, size: 18, color: SpaceNavyTheme.goldChampagne),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _birthDateTime,
                  firstDate: DateTime(1930),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  if (!context.mounted) return;
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_birthDateTime),
                  );
                  if (time != null) {
                    setState(() {
                      _birthDateTime = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
                    });
                  }
                }
              },
            ),

            const SizedBox(height: 14),

            // Blood Type & MBTI Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppI18n.tr('profile_blood_label', widget.region), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _bloodType,
                        dropdownColor: const Color(0xFF141B33),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: SpaceNavyTheme.goldBorder)),
                        ),
                        items: _bloodTypes
                            .map((bt) => DropdownMenuItem(value: bt, child: Text(bt, style: const TextStyle(color: Colors.white, fontSize: 13))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _bloodType = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MBTI (선택)', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _mbti,
                        dropdownColor: const Color(0xFF141B33),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: SpaceNavyTheme.goldBorder)),
                        ),
                        items: _mbtis
                            .map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(color: Colors.white, fontSize: 13))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _mbti = val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // On-Device Privacy Notice (GDPR / Compliance Anchor)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security, color: Color(0xFF00E5FF), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppI18n.tr('profile_privacy_notice', widget.region),
                      style: const TextStyle(color: Colors.white60, fontSize: 11, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Save / Confirm Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: SpaceNavyTheme.goldChampagne,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final saved = _buildCurrentProfile();
                  widget.onSaved(saved);
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppI18n.tr('profile_save_btn', widget.region),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewPill(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(color: SpaceNavyTheme.goldChampagne, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

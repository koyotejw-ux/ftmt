import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/astronomy/ephemeris_math.dart';
import '../../../core/astronomy/saju_engine.dart';

class UserProfile {
  final String name;
  final DateTime birthDateTime;
  final String city;
  final String bloodType; // 'A형', 'B형', 'O형', 'AB형'
  final String? mbti; // e.g. 'ENFP'
  final String gender; // 'male', 'female', 'other'

  UserProfile({
    required this.name,
    required this.birthDateTime,
    required this.city,
    this.bloodType = 'A형',
    this.mbti = 'ENFP',
    this.gender = 'female',
  });

  /// Calculate Saju Ilju (e.g. '갑자(甲子)')
  String get sajuIlju {
    final pillars = SajuEngine.calculatePillars(birthDateTime);
    return '${pillars.dayPillar.stem.name}${pillars.dayPillar.branch.name}(${pillars.dayPillar.stem.char}${pillars.dayPillar.branch.char})';
  }

  /// Calculate 12 Zodiac Animal (e.g. '자(쥐띠 🐭)')
  String get zodiacAnimal {
    final pillars = SajuEngine.calculatePillars(birthDateTime);
    final animalName = pillars.yearPillar.branch.animal;
    final branchName = pillars.yearPillar.branch.name;
    final emojiMap = {
      '쥐': '🐭', '소': '🐮', '호랑이': '🐯', '토끼': '🐰',
      '용': '🐲', '뱀': '🐍', '말': '🐴', '양': '🐑',
      '원숭이': '🐵', '닭': '🐔', '개': '🐶', '돼지': '🐷',
    };
    final emoji = emojiMap[animalName] ?? '✨';
    return '$branchName($animalName띠 $emoji)';
  }

  /// Calculate Sun Sign (e.g. '사자자리')
  String get sunSign {
    final sign = EphemerisMath.getSunSign(birthDateTime);
    return sign.ko;
  }

  /// Calculate Western Zodiac Item formatted (e.g. '사자자리 (♌ Leo)')
  String get westernZodiacItem {
    final sign = EphemerisMath.getSunSign(birthDateTime);
    return '${sign.ko} (${sign.symbol} ${sign.en})';
  }

  /// Calculate Western Zodiac 4 Elements
  String get zodiacElement {
    final sign = EphemerisMath.getSunSign(birthDateTime);
    switch (sign) {
      case WesternZodiac.aries:
      case WesternZodiac.leo:
      case WesternZodiac.sagittarius:
        return 'Fire (불/火 - 양/사자/사수)';
      case WesternZodiac.taurus:
      case WesternZodiac.virgo:
      case WesternZodiac.capricorn:
        return 'Earth (흙/土 - 황소/처녀/염소)';
      case WesternZodiac.gemini:
      case WesternZodiac.libra:
      case WesternZodiac.aquarius:
        return 'Air (바람/風 - 쌍둥이/천칭/물병)';
      case WesternZodiac.cancer:
      case WesternZodiac.scorpio:
      case WesternZodiac.pisces:
        return 'Water (물/水 - 게/전갈/물고기)';
    }
  }

  /// Calculate Life Path Number
  String get lifePathNumber {
    int sum = birthDateTime.year + birthDateTime.month + birthDateTime.day;
    while (sum > 9 && sum != 11 && sum != 22) {
      int next = 0;
      for (final digit in sum.toString().split('')) {
        next += int.parse(digit);
      }
      sum = next;
    }
    if (sum == 11) return 'Master 11 (영적 직관자/Intuitive)';
    if (sum == 22) return 'Master 22 (마스터 빌더/Architect)';
    final titles = {
      1: 'Life Path 1 (개척자/Leader)',
      2: 'Life Path 2 (조화자/Peacemaker)',
      3: 'Life Path 3 (표현자/Creator)',
      4: 'Life Path 4 (건설자/Builder)',
      5: 'Life Path 5 (모험가/Free Spirit)',
      6: 'Life Path 6 (수호자/Caregiver)',
      7: 'Life Path 7 (탐구자/Philosopher)',
      8: 'Life Path 8 (성취자/Visionary)',
      9: 'Life Path 9 (인도자/Humanitarian)',
    };
    return titles[sum] ?? 'Life Path 1 (개척자/Leader)';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'birthDateTime': birthDateTime.toIso8601String(),
        'city': city,
        'bloodType': bloodType,
        'mbti': mbti,
        'gender': gender,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? '나 (본인)',
        birthDateTime: DateTime.tryParse(json['birthDateTime'] as String? ?? '') ?? DateTime(1995, 8, 15, 14, 30),
        city: json['city'] as String? ?? 'Seoul',
        bloodType: json['bloodType'] as String? ?? 'A형',
        mbti: json['mbti'] as String? ?? 'ENFP',
        gender: json['gender'] as String? ?? 'female',
      );

  UserProfile copyWith({
    String? name,
    DateTime? birthDateTime,
    String? city,
    String? bloodType,
    String? mbti,
    String? gender,
  }) {
    return UserProfile(
      name: name ?? this.name,
      birthDateTime: birthDateTime ?? this.birthDateTime,
      city: city ?? this.city,
      bloodType: bloodType ?? this.bloodType,
      mbti: mbti ?? this.mbti,
      gender: gender ?? this.gender,
    );
  }
}

class UserProfileRepository {
  static const String _keyProfile = 'fm_user_main_profile';
  static const String _keyVaultProfiles = 'fm_vault_saved_persons';

  final SharedPreferences _prefs;
  final _profileStreamController = StreamController<UserProfile?>.broadcast();

  UserProfileRepository(this._prefs);

  static Future<UserProfileRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return UserProfileRepository(prefs);
  }

  Stream<UserProfile?> get profileStream => _profileStreamController.stream;

  /// Check if user has initialized their profile
  bool get hasProfile => _prefs.containsKey(_keyProfile);

  /// Get current user profile, or default fallback profile
  UserProfile get profile {
    final raw = _prefs.getString(_keyProfile);
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return UserProfile.fromJson(map);
      } catch (_) {}
    }
    // Default initial profile
    return UserProfile(
      name: '나 (본인)',
      birthDateTime: DateTime(1995, 8, 15, 14, 30),
      city: 'Seoul',
      bloodType: 'A형',
      mbti: 'ENFP',
    );
  }

  /// Save or update user profile
  Future<void> saveProfile(UserProfile userProfile) async {
    final raw = jsonEncode(userProfile.toJson());
    await _prefs.setString(_keyProfile, raw);
    _profileStreamController.add(userProfile);
  }

  /// Get saved people from vault
  List<UserProfile> getSavedVaultProfiles() {
    final rawList = _prefs.getStringList(_keyVaultProfiles);
    if (rawList != null && rawList.isNotEmpty) {
      try {
        return rawList
            .map((item) => UserProfile.fromJson(jsonDecode(item) as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    // Default preset contacts in vault
    return [
      UserProfile(
        name: '김서연 (연인)',
        birthDateTime: DateTime(1997, 3, 22, 9, 15),
        city: 'Seoul',
        bloodType: 'B형',
        mbti: 'INTJ',
      ),
      UserProfile(
        name: '이민호 (친구)',
        birthDateTime: DateTime(1994, 11, 5, 18, 0),
        city: 'Seoul',
        bloodType: 'O형',
        mbti: 'INFJ',
      ),
    ];
  }

  /// Add a person to vault
  Future<void> addVaultProfile(UserProfile person) async {
    final current = getSavedVaultProfiles();
    current.add(person);
    final rawList = current.map((p) => jsonEncode(p.toJson())).toList();
    await _prefs.setStringList(_keyVaultProfiles, rawList);
  }

  /// Delete person from vault
  Future<void> deleteVaultProfile(int index) async {
    final current = getSavedVaultProfiles();
    if (index >= 0 && index < current.length) {
      current.removeAt(index);
      final rawList = current.map((p) => jsonEncode(p.toJson())).toList();
      await _prefs.setStringList(_keyVaultProfiles, rawList);
    }
  }

  /// Reset all personal data (GDPR / Right to be Forgotten)
  Future<void> resetAllUserData() async {
    await _prefs.remove(_keyProfile);
    await _prefs.remove(_keyVaultProfiles);
    _profileStreamController.add(null);
  }
}

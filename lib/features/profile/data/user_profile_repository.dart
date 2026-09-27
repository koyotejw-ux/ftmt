import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/astronomy/ephemeris_math.dart';
import '../../../core/astronomy/saju_engine.dart';
import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import '../../match/domain/match_item_engine.dart';

class UserProfile {
  final String name;
  final DateTime birthDateTime;
  final String city;
  final String bloodType; // 'A', 'B', 'O', 'AB' or 'A형'
  final String? mbti; // e.g. 'ENFP'
  final String gender; // 'male', 'female', 'other'

  UserProfile({
    required this.name,
    required this.birthDateTime,
    required this.city,
    this.bloodType = 'A',
    this.mbti = 'ENFP',
    this.gender = 'female',
  });

  /// Localized user display name
  String localizedName(SupportedRegion region) {
    if (name.isEmpty || name == '나 (본인)' || name == '나' || name == 'Me' || name.contains('본인')) {
      return AppI18n.tr('profile_default_me', region);
    }
    if (name.contains('김서연') || name.contains('연인') || name.contains('Partner') || name.contains('Lover')) {
      switch (region.languageCode) {
        case 'ko': return '김서연 (연인)';
        case 'ja': return 'ソヨン (恋人)';
        case 'de': return 'Sophia (Partner)';
        case 'fr': return 'Sophia (Partenaire)';
        case 'es': return 'Sofía (Pareja)';
        case 'it': return 'Sofia (Partner)';
        default: return 'Sophia (Partner)';
      }
    }
    if (name.contains('이민호') || name.contains('친구') || name.contains('Friend')) {
      switch (region.languageCode) {
        case 'ko': return '이민호 (친구)';
        case 'ja': return 'ミホ (友達)';
        case 'de': return 'Lucas (Freund)';
        case 'fr': return 'Lucas (Ami)';
        case 'es': return 'Lucas (Amigo)';
        case 'it': return 'Luca (Amico)';
        default: return 'Lucas (Friend)';
      }
    }
    return name;
  }

  /// Calculate Saju Ilju (e.g. '갑자(甲子)')
  String get sajuIlju {
    final pillars = SajuEngine.calculatePillars(birthDateTime);
    return '${pillars.dayPillar.stem.name}${pillars.dayPillar.branch.name}(${pillars.dayPillar.stem.char}${pillars.dayPillar.branch.char})';
  }

  String localizedSajuIlju(SupportedRegion region) {
    final pillars = SajuEngine.calculatePillars(birthDateTime);
    if (region.languageCode == 'ko') {
      return '${pillars.dayPillar.stem.name}${pillars.dayPillar.branch.name}(${pillars.dayPillar.stem.char}${pillars.dayPillar.branch.char})';
    }
    return '${pillars.dayPillar.stem.char}${pillars.dayPillar.branch.char} Pillar';
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

  String localizedZodiacAnimal(SupportedRegion region) {
    final pillars = SajuEngine.calculatePillars(birthDateTime);
    final animalName = pillars.yearPillar.branch.animal;
    final animals = MatchItemEngine.getZodiacAnimals(region);
    final indexMap = {
      '쥐': 0, '소': 1, '호랑이': 2, '토끼': 3,
      '용': 4, '뱀': 5, '말': 6, '양': 7,
      '원숭이': 8, '닭': 9, '개': 10, '돼지': 11,
    };
    final idx = indexMap[animalName] ?? 0;
    return animals[idx];
  }

  /// Calculate Sun Sign (e.g. '사자자리')
  String get sunSign {
    final sign = EphemerisMath.getSunSign(birthDateTime);
    return sign.ko;
  }

  /// Localized Sun Sign according to active region
  String localizedSunSign(SupportedRegion region) {
    final sign = EphemerisMath.getSunSign(birthDateTime);
    return sign.localizedName(region);
  }

  /// Calculate Western Zodiac Item formatted (e.g. '사자자리 (♌ Leo)')
  String get westernZodiacItem {
    final sign = EphemerisMath.getSunSign(birthDateTime);
    return '${sign.ko} (${sign.symbol} ${sign.en})';
  }

  String localizedWesternZodiacItem(SupportedRegion region) {
    final sign = EphemerisMath.getSunSign(birthDateTime);
    return '${sign.localizedName(region)} (${sign.symbol} ${sign.en})';
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

  String localizedZodiacElement(SupportedRegion region) {
    final sign = EphemerisMath.getSunSign(birthDateTime);
    final elements = MatchItemEngine.getZodiacElements(region);
    switch (sign) {
      case WesternZodiac.aries:
      case WesternZodiac.leo:
      case WesternZodiac.sagittarius:
        return elements[0];
      case WesternZodiac.taurus:
      case WesternZodiac.virgo:
      case WesternZodiac.capricorn:
        return elements[1];
      case WesternZodiac.gemini:
      case WesternZodiac.libra:
      case WesternZodiac.aquarius:
        return elements[2];
      case WesternZodiac.cancer:
      case WesternZodiac.scorpio:
      case WesternZodiac.pisces:
        return elements[3];
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

  String localizedLifePathNumber(SupportedRegion region) {
    int sum = birthDateTime.year + birthDateTime.month + birthDateTime.day;
    while (sum > 9 && sum != 11 && sum != 22) {
      int next = 0;
      for (final digit in sum.toString().split('')) {
        next += int.parse(digit);
      }
      sum = next;
    }
    final list = MatchItemEngine.getLifePathNumbers(region);
    if (sum == 11 && list.length > 9) return list[9];
    if (sum == 22 && list.length > 10) return list[10];
    if (sum >= 1 && sum <= 9 && list.length >= sum) return list[sum - 1];
    return list.first;
  }

  String localizedBloodType(SupportedRegion region) {
    final types = MatchItemEngine.getBloodTypes(region);
    final clean = bloodType.toUpperCase();
    if (clean.contains('AB')) return types[3];
    if (clean.contains('A')) return types[0];
    if (clean.contains('B')) return types[1];
    if (clean.contains('O') || clean.contains('0')) return types[2];
    return types[0];
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
        bloodType: json['bloodType'] as String? ?? 'A',
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
      bloodType: 'A',
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
        bloodType: 'B',
        mbti: 'INTJ',
      ),
      UserProfile(
        name: '이민호 (친구)',
        birthDateTime: DateTime(1994, 11, 5, 18, 0),
        city: 'Seoul',
        bloodType: 'O',
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

/// Solar Time Correction and Astronomical Coordinates
/// Standard time in Korea/Japan is based on 135°E.
/// Real solar noon in Seoul (126°59'E) is ~32 minutes later than 135°E standard clock.
class SolarTimeFixer {
  /// City registry with longitude, latitude, and standard meridian
  static final List<CitySolarProfile> supportedCities = [
    CitySolarProfile(
      nameKo: '서울',
      nameEn: 'Seoul',
      longitude: 126.9780,
      standardMeridian: 135.0,
      correctionMinutes: -32,
    ),
    CitySolarProfile(
      nameKo: '부산',
      nameEn: 'Busan',
      longitude: 129.0756,
      standardMeridian: 135.0,
      correctionMinutes: -24,
    ),
    CitySolarProfile(
      nameKo: '도쿄',
      nameEn: 'Tokyo',
      longitude: 139.6917,
      standardMeridian: 135.0,
      correctionMinutes: 19,
    ),
    CitySolarProfile(
      nameKo: '뉴욕',
      nameEn: 'New York',
      longitude: -74.0060,
      standardMeridian: -75.0,
      correctionMinutes: 4,
    ),
    CitySolarProfile(
      nameKo: '런던',
      nameEn: 'London',
      longitude: -0.1278,
      standardMeridian: 0.0,
      correctionMinutes: -1,
    ),
    CitySolarProfile(
      nameKo: '파리',
      nameEn: 'Paris',
      longitude: 2.3522,
      standardMeridian: 15.0, // CET is UTC+1 (15°E)
      correctionMinutes: -51,
    ),
  ];

  /// Calculates real solar time adjustment in minutes: 4 minutes per 1 degree of longitude diff
  static int calculateOffsetMinutes(double longitude, double standardMeridian) {
    final diffDegrees = longitude - standardMeridian;
    return (diffDegrees * 4).round();
  }

  /// Corrects a given local clock DateTime to the True Solar Time (진태양시)
  static DateTime getTrueSolarTime(DateTime clockTime, int offsetMinutes) {
    return clockTime.add(Duration(minutes: offsetMinutes));
  }
}

class CitySolarProfile {
  final String nameKo;
  final String nameEn;
  final double longitude;
  final double standardMeridian;
  final int correctionMinutes;

  const CitySolarProfile({
    required this.nameKo,
    required this.nameEn,
    required this.longitude,
    required this.standardMeridian,
    required this.correctionMinutes,
  });
}

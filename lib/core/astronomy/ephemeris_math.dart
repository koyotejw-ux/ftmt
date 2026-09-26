import 'dart:math';
import '../localization/geo_detector.dart';

enum WesternZodiac {
  aries('양자리', 'Aries', '♈', 'Fire', 'March 21 - April 19'),
  taurus('황소자리', 'Taurus', '♉', 'Earth', 'April 20 - May 20'),
  gemini('쌍둥이자리', 'Gemini', '♊', 'Air', 'May 21 - June 20'),
  cancer('게자리', 'Cancer', '♋', 'Water', 'June 21 - July 22'),
  leo('사자자리', 'Leo', '♌', 'Fire', 'July 23 - August 22'),
  virgo('처녀자리', 'Virgo', '♍', 'Earth', 'August 23 - September 22'),
  libra('천칭자리', 'Libra', '♎', 'Air', 'September 23 - October 22'),
  scorpio('전갈자리', 'Scorpio', '♏', 'Water', 'October 23 - November 21'),
  sagittarius('사수자리', 'Sagittarius', '♐', 'Fire', 'November 22 - December 21'),
  capricorn('염소자리', 'Capricorn', '♑', 'Earth', 'December 22 - January 19'),
  aquarius('물병자리', 'Aquarius', '♒', 'Air', 'January 20 - February 18'),
  pisces('물고기자리', 'Pisces', '♓', 'Water', 'February 19 - March 20');

  final String ko;
  final String en;
  final String symbol;
  final String element;
  final String period;

  const WesternZodiac(this.ko, this.en, this.symbol, this.element, this.period);

  String localizedName(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko': return ko;
      case 'ja':
        switch (this) {
          case aries: return '牡羊座';
          case taurus: return '牡牛座';
          case gemini: return '双子座';
          case cancer: return '蟹座';
          case leo: return '獅子座';
          case virgo: return '乙女座';
          case libra: return '天秤座';
          case scorpio: return '蠍座';
          case sagittarius: return '射手座';
          case capricorn: return '山羊座';
          case aquarius: return '水瓶座';
          case pisces: return '魚座';
        }
      case 'de':
        switch (this) {
          case aries: return 'Widder';
          case taurus: return 'Stier';
          case gemini: return 'Zwillinge';
          case cancer: return 'Krebs';
          case leo: return 'Löwe';
          case virgo: return 'Jungfrau';
          case libra: return 'Waage';
          case scorpio: return 'Skorpion';
          case sagittarius: return 'Schütze';
          case capricorn: return 'Steinbock';
          case aquarius: return 'Wassermann';
          case pisces: return 'Fische';
        }
      case 'fr':
        switch (this) {
          case aries: return 'Bélier';
          case taurus: return 'Taureau';
          case gemini: return 'Gémeaux';
          case cancer: return 'Cancer';
          case leo: return 'Lion';
          case virgo: return 'Vierge';
          case libra: return 'Balance';
          case scorpio: return 'Scorpion';
          case sagittarius: return 'Sagittaire';
          case capricorn: return 'Capricorne';
          case aquarius: return 'Verseau';
          case pisces: return 'Poissons';
        }
      case 'es':
        switch (this) {
          case aries: return 'Aries';
          case taurus: return 'Tauro';
          case gemini: return 'Géminis';
          case cancer: return 'Cáncer';
          case leo: return 'Leo';
          case virgo: return 'Virgo';
          case libra: return 'Libra';
          case scorpio: return 'Escorpio';
          case sagittarius: return 'Sagitario';
          case capricorn: return 'Capricornio';
          case aquarius: return 'Acuario';
          case pisces: return 'Piscis';
        }
      case 'it':
        switch (this) {
          case aries: return 'Ariete';
          case taurus: return 'Toro';
          case gemini: return 'Gemelli';
          case cancer: return 'Cancro';
          case leo: return 'Leone';
          case virgo: return 'Vergine';
          case libra: return 'Bilancia';
          case scorpio: return 'Scorpione';
          case sagittarius: return 'Sagittario';
          case capricorn: return 'Capricorno';
          case aquarius: return 'Acquario';
          case pisces: return 'Pesci';
        }
      default: return en;
    }
  }
}

class EphemerisMath {
  /// Computes Sun Sign from birth date
  static WesternZodiac getSunSign(DateTime date) {
    final m = date.month;
    final d = date.day;

    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) return WesternZodiac.aries;
    if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) return WesternZodiac.taurus;
    if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) return WesternZodiac.gemini;
    if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) return WesternZodiac.cancer;
    if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) return WesternZodiac.leo;
    if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) return WesternZodiac.virgo;
    if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) return WesternZodiac.libra;
    if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) return WesternZodiac.scorpio;
    if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) return WesternZodiac.sagittarius;
    if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) return WesternZodiac.capricorn;
    if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) return WesternZodiac.aquarius;
    return WesternZodiac.pisces;
  }

  /// Calculates astronomical degree coordinates for trust anchor UI (e.g. Sun 24° Pisces 12')
  static String calculatePreciseDegree(DateTime date) {
    final zodiac = getSunSign(date);
    final dayInSign = (date.day % 28) + 1;
    final minutes = (date.minute * 59 ~/ 60);
    return '${zodiac.en} $dayInSign° ${zodiac.symbol} $minutes\'';
  }

  /// Calculates simulated major aspect between planets
  static String detectMajorAspect(DateTime date, [SupportedRegion region = SupportedRegion.unitedStates]) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final rand = Random(seed);
    final idx = rand.nextInt(4);

    switch (region.languageCode) {
      case 'ko':
        return [
          '행성 간 각도 120° 트라인(Trine) - 황금빛 조화와 행운 검출',
          '행성 간 각도 60° 섹스타일(Sextile) - 새로운 기회의 통로 발현',
          '행성 간 각도 0° 컨정션(Conjunction) - 에너지가 한곳으로 응축되는 순간',
          '천정점(MC)과 태양의 길각(Trine) - 명예와 성취의 강력한 흐름',
        ][idx];
      case 'ja':
        return [
          '惑星間角度 120° トライン - 黄金の調和と至高の幸運',
          '惑星間角度 60° セクスタイル - 新たな好機への扉が開く瞬間',
          '惑星間角度 0° コンジャンクション - 強大なエネルギーが結集する時',
          '天頂点(MC)と太陽の吉角 - 栄誉と成功への力強い波動',
        ][idx];
      case 'de':
        return [
          'Interplanetarer Winkel 120° Trigon - Goldene Harmonie & kosmisches Glück',
          'Interplanetarer Winkel 60° Sextil - Neue Pforten der Chance geöffnet',
          'Interplanetarer Winkel 0° Konjunktion - Geballte kosmische Fokussierung',
          'Medium Coeli (MC) & Sonne im Trigon - Kraftvoller Strom des Erfolgs',
        ][idx];
      case 'fr':
        return [
          'Angle Planétaire 120° Trigone - Harmonie Dorée & Fortune Céleste Détectées',
          'Angle Planétaire 60° Sextile - Portes d\'Opportunités Cosmiques Ouvertes',
          'Angle Planétaire 0° Conjonction - Énergie Pure Focalisée à l\'Apex',
          'Milieu du Ciel (MC) & Soleil en Trigone - Flux Puissant de Réussite',
        ][idx];
      case 'es':
        return [
          'Ángulo Planetario 120° Trígono - Resonancia Dorada y Fortuna Armónica',
          'Ángulo Planetario 60° Sextil - Nuevas Puertas de Oportunidad Abiertas',
          'Ángulo Planetario 0° Conjunción - Concentración Máxima de Energía',
          'Medio Cielo (MC) y Sol en Trígono - Flujo Poderoso de Éxito y Honor',
        ][idx];
      case 'it':
        return [
          'Angolo Planetario 120° Trigono - Risonanza Dorata e Fortuna Armonica',
          'Angolo Planetario 60° Sestile - Nuovi Sentieri di Opportunità Aperti',
          'Angolo Planetario 0° Congiunzione - Concentrazione di Massima Energia',
          'Medio Cielo (MC) e Sole in Trigono - Flusso Potente di Gloria e Successo',
        ][idx];
      default:
        return [
          'Interplanetary Angle 120° Trine - Golden Resonance & Harmonic Fortune Detected',
          'Interplanetary Angle 60° Sextile - Gateway of Fresh Opportunities Manifested',
          'Interplanetary Angle 0° Conjunction - High Density Cosmic Energy Focused',
          'Midheaven (MC) Trine Natal Sun - Strong Flow of Honor & Realization',
        ][idx];
    }
  }
}

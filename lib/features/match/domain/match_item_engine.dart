import '../../../core/localization/app_i18n.dart';
import '../../../core/localization/geo_detector.dart';
import 'sixteen_type_matrix.dart';

class MatchItemEngine {
  // 0. Global: 12 Western Zodiac Signs (황도 12궁)
  static const List<String> westernZodiacSigns = [
    '양자리 (♈ Aries)',
    '황소자리 (♉ Taurus)',
    '쌍둥이자리 (♊ Gemini)',
    '게자리 (♋ Cancer)',
    '사자자리 (♌ Leo)',
    '처녀자리 (♍ Virgo)',
    '천칭자리 (♎ Libra)',
    '전갈자리 (♏ Scorpio)',
    '사수자리 (♐ Sagittarius)',
    '염소자리 (♑ Capricorn)',
    '물병자리 (♒ Aquarius)',
    '물고기자리 (♓ Pisces)',
  ];

  // 1. Korea: Saju Ilju (60 甲子 일주)
  static const List<String> sajuPillars = [
    '갑자(甲子)', '을축(乙丑)', '병인(丙寅)', '정묘(丁卯)', '무진(戊辰)',
    '기사(己巳)', '경오(庚午)', '신미(辛未)', '임신(壬申)', '계유(癸酉)',
    '갑술(甲戌)', '을해(乙亥)', '병자(丙子)', '정축(丁丑)', '무인(戊寅)',
    '기묘(己卯)', '경진(庚辰)', '신사(辛巳)', '임오(壬午)', '계미(癸未)',
    '갑신(甲申)', '을유(乙酉)', '병술(丙戌)', '정해(丁亥)', '무자(戊子)',
    '기축(己丑)', '경인(庚寅)', '신묘(辛卯)', '임진(壬辰)', '계사(癸巳)',
  ];

  // 2. Korea: 12 간지 띠 (Zodiac Animals)
  static const List<String> zodiacAnimals = [
    '자(쥐띠 🐭)', '축(소띠 🐮)', '인(호랑이띠 🐯)', '묘(토끼띠 🐰)',
    '진(용띠 🐲)', '사(뱀띠 🐍)', '오(말띠 🐴)', '미(양띠 🐑)',
    '신(원숭이띠 🐵)', '유(닭띠 🐔)', '술(개띠 🐶)', '해(돼지띠 🐷)',
  ];

  // 3. Korea / Japan: Real Blood Types
  static const List<String> bloodTypes = ['A형', 'B형', 'O형', 'AB형'];

  // 4. US: 12 Zodiac 4 Elements
  static const List<String> zodiacElements = [
    'Fire (불/火 - 양/사자/사수)',
    'Earth (흙/土 - 황소/처녀/염소)',
    'Air (바람/風 - 쌍둥이/천칭/물병)',
    'Water (물/水 - 게/전갈/물고기)',
  ];

  // 5. US / Europe: Numerology Life Path Numbers (1~9, Master 11, 22)
  static const List<String> lifePathNumbers = [
    'Life Path 1 (개척자/Leader)',
    'Life Path 2 (조화자/Peacemaker)',
    'Life Path 3 (표현자/Creator)',
    'Life Path 4 (건설자/Builder)',
    'Life Path 5 (모험가/Free Spirit)',
    'Life Path 6 (수호자/Caregiver)',
    'Life Path 7 (탐구자/Philosopher)',
    'Life Path 8 (성취자/Visionary)',
    'Life Path 9 (인도자/Humanitarian)',
    'Master 11 (영적 직관자/Intuitive)',
    'Master 22 (마스터 빌더/Architect)',
  ];

  // 6. Japan: Blood Type x Zodiac Hybrid (血液型 x 星座)
  static const List<String> bloodZodiacHybrids = [
    'A형 x 양자리 (정의로운 열정파)',
    'A형 x 처녀자리 (완벽주의 배려가)',
    'B형 x 사자자리 (매혹적인 무대체질)',
    'B형 x 사수자리 (자유로운 탐험가)',
    'O형 x 황소자리 (신뢰의 든든한 바위)',
    'O형 x 천칭자리 (원만한 사교 챔피언)',
    'AB형 x 쌍둥이자리 (번뜩이는 다재다능)',
    'AB형 x 물병자리 (신비로운 천재성)',
    'A형 x 전갈자리 (깊은 헌신과 집중)',
    'B형 x 물고기자리 (풍부한 감성과 예술)',
    'O형 x 게자리 (따스한 패밀리 리더)',
    'AB형 x 염소자리 (냉철한 전략가)',
  ];

  // 7. Japan: Rokusei (六星占術 運命星)
  static const List<String> rokuseiStars = [
    '수성인 (水星人 - 지혜와 명예)',
    '금성인 (金星人 - 행동력과 사교)',
    '화성인 (火星人 - 예술성과 직관)',
    '목성인 (木星人 - 인내와 대기만성)',
    '천왕성인 (天王星人 - 이상주의와 온화)',
    '토성인 (土星人 - 엄격함과 도덕심)',
  ];

  // 8. Europe: Synastry Houses (별자리 하우스 궁합)
  static const List<String> synastryHouses = [
    '1st House (동일한 자아/자연스러운 교감)',
    '4th House (가정/영혼의 깊은 안식처)',
    '5th House (로맨스와 창조적 열정)',
    '7th House (운명적 동반자/결혼의 집)',
    '8th House (영적 변형/강렬한 마력적 결합)',
    '10th House (사회적 성공/성장 파트너)',
  ];

  // 9. Europe: Celtic Runes (룬스톤 커플 점괘)
  static const List<String> celticRunes = [
    'Fehu ᚠ (풍요와 번영의 결합)',
    'Uruz ᚢ (야생의 활력과 회복력)',
    'Thurisaz ᚦ (수호와 강인한 결의)',
    'Ansuz ᚨ (신성한 지혜와 영적 교류)',
    'Raidho ᚱ (함께 떠나는 운명의 여정)',
    'Kenaz ᚲ (빛나는 통찰과 사랑의 불꽃)',
    'Gebo ᚷ (상호 헌신과 신성한 선물)',
    'Wunjo ᚹ (기쁨과 조화로운 평화)',
  ];

  /// Regional Zodiac Signs
  static List<String> getWesternZodiacSigns(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko':
        return westernZodiacSigns;
      case 'ja':
        return [
          '牡羊座 (♈ Aries)', '牡牛座 (♉ Taurus)', '双子座 (♊ Gemini)', '蟹座 (♋ Cancer)',
          '獅子座 (♌ Leo)', '乙女座 (♍ Virgo)', '天秤座 (♎ Libra)', '蠍座 (♏ Scorpio)',
          '射手座 (♐ Sagittarius)', '山羊座 (♑ Capricorn)', '水瓶座 (♒ Aquarius)', '魚座 (♓ Pisces)'
        ];
      case 'de':
        return [
          'Widder (♈ Aries)', 'Stier (♉ Taurus)', 'Zwillinge (♊ Gemini)', 'Krebs (♋ Cancer)',
          'Löwe (♌ Leo)', 'Jungfrau (♍ Virgo)', 'Waage (♎ Libra)', 'Skorpion (♏ Scorpio)',
          'Schütze (♐ Sagittarius)', 'Steinbock (♑ Capricorn)', 'Wassermann (♒ Aquarius)', 'Fische (♓ Pisces)'
        ];
      case 'fr':
        return [
          'Bélier (♈ Aries)', 'Taureau (♉ Taurus)', 'Gémeaux (♊ Gemini)', 'Cancer (♋ Cancer)',
          'Lion (♌ Leo)', 'Vierge (♍ Virgo)', 'Balance (♎ Libra)', 'Scorpion (♏ Scorpio)',
          'Sagittaire (♐ Sagittarius)', 'Capricorne (♑ Capricorn)', 'Verseau (♒ Aquarius)', 'Poissons (♓ Pisces)'
        ];
      case 'es':
        return [
          'Aries (♈ Aries)', 'Tauro (♉ Taurus)', 'Géminis (♊ Gemini)', 'Cáncer (♋ Cancer)',
          'Leo (♌ Leo)', 'Virgo (♍ Virgo)', 'Libra (♎ Libra)', 'Escorpio (♏ Scorpio)',
          'Sagitario (♐ Sagittarius)', 'Capricornio (♑ Capricorn)', 'Acuario (♒ Aquarius)', 'Piscis (♓ Pisces)'
        ];
      case 'it':
        return [
          'Ariete (♈ Aries)', 'Toro (♉ Taurus)', 'Gemelli (♊ Gemini)', 'Cancro (♋ Cancer)',
          'Leone (♌ Leo)', 'Vergine (♍ Virgo)', 'Bilancia (♎ Libra)', 'Scorpione (♏ Scorpio)',
          'Sagittario (♐ Sagittarius)', 'Capricorno (♑ Capricorn)', 'Acquario (♒ Aquarius)', 'Pesci (♓ Pisces)'
        ];
      default:
        return [
          'Aries (♈ Fire)', 'Taurus (♉ Earth)', 'Gemini (♊ Air)', 'Cancer (♋ Water)',
          'Leo (♌ Fire)', 'Virgo (♍ Earth)', 'Libra (♎ Air)', 'Scorpio (♏ Water)',
          'Sagittarius (♐ Fire)', 'Capricorn (♑ Earth)', 'Aquarius (♒ Air)', 'Pisces (♓ Water)'
        ];
    }
  }

  static List<String> getBloodTypes(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko': return ['A형', 'B형', 'O형', 'AB형'];
      case 'ja': return ['A型', 'B型', 'O型', 'AB型'];
      case 'de': return ['Blutgruppe A', 'Blutgruppe B', 'Blutgruppe O', 'Blutgruppe AB'];
      case 'fr': return ['Groupe A', 'Groupe B', 'Groupe O', 'Groupe AB'];
      case 'es': return ['Grupo A', 'Grupo B', 'Grupo O', 'Grupo AB'];
      case 'it': return ['Gruppo A', 'Gruppo B', 'Gruppo O', 'Gruppo AB'];
      default: return ['Type A', 'Type B', 'Type O', 'Type AB'];
    }
  }

  static List<String> getZodiacElements(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko':
        return zodiacElements;
      case 'ja':
        return [
          'Fire (火 - 牡羊/獅子/射手)',
          'Earth (地 - 牡牛/乙女/山羊)',
          'Air (風 - 双子/天秤/水瓶)',
          'Water (水 - 蟹/蠍/魚)',
        ];
      case 'de':
        return [
          'Feuer (Widder / Löwe / Schütze)',
          'Erde (Stier / Jungfrau / Steinbock)',
          'Luft (Zwillinge / Waage / Wassermann)',
          'Wasser (Krebs / Skorpion / Fische)',
        ];
      case 'fr':
        return [
          'Feu (Bélier / Lion / Sagittaire)',
          'Terre (Taureau / Vierge / Capricorne)',
          'Air (Gémeaux / Balance / Verseau)',
          'Eau (Cancer / Scorpion / Poissons)',
        ];
      case 'es':
        return [
          'Fuego (Aries / Leo / Sagitario)',
          'Tierra (Tauro / Virgo / Capricornio)',
          'Aire (Géminis / Libra / Acuario)',
          'Agua (Cáncer / Escorpio / Piscis)',
        ];
      case 'it':
        return [
          'Fuoco (Ariete / Leone / Sagittario)',
          'Terra (Toro / Vergine / Capricorno)',
          'Aria (Gemelli / Bilancia / Acquario)',
          'Acqua (Cancro / Scorpione / Pesci)',
        ];
      default:
        return [
          'Fire (Aries / Leo / Sagittarius)',
          'Earth (Taurus / Virgo / Capricorn)',
          'Air (Gemini / Libra / Aquarius)',
          'Water (Cancer / Scorpio / Pisces)',
        ];
    }
  }

  static List<String> getLifePathNumbers(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko':
        return lifePathNumbers;
      case 'ja':
        return [
          '運命数 1 (先駆者/Leader)', '運命数 2 (調和者/Peacemaker)', '運命数 3 (創造者/Creator)',
          '運命数 4 (建設者/Builder)', '運命数 5 (冒険者/Free Spirit)', '運命数 6 (守護者/Caregiver)',
          '運命数 7 (探求者/Philosopher)', '運命数 8 (達成者/Visionary)', '運命数 9 (導き手/Humanitarian)',
          'マスター 11 (直感者/Intuitive)', 'マスター 22 (大建築家/Architect)'
        ];
      case 'de':
        return [
          'Lebenszahl 1 (Pionier & Anführer)', 'Lebenszahl 2 (Diplomat & Friedensstifter)',
          'Lebenszahl 3 (Schöpfer & Kommunikator)', 'Lebenszahl 4 (Meisterbauer & Fundament)',
          'Lebenszahl 5 (Freigeist & Entdecker)', 'Lebenszahl 6 (Beschützer & Herz)',
          'Lebenszahl 7 (Philosoph & Suchender)', 'Lebenszahl 8 (Visionär & Macher)',
          'Lebenszahl 9 (Humanist & Heiler)', 'Master 11 (Spirituelle Intuition)',
          'Master 22 (Meisterarchitekt)'
        ];
      case 'fr':
        return [
          'Chemin de Vie 1 (Pionnier & Leader)', 'Chemin de Vie 2 (Médiateur & Harmonie)',
          'Chemin de Vie 3 (Créateur & Expression)', 'Chemin de Vie 4 (Bâtisseur & Ordre)',
          'Chemin de Vie 5 (Esprit Libre & Voyageur)', 'Chemin de Vie 6 (Bienveillant & Guide)',
          'Chemin de Vie 7 (Philosophe & Sage)', 'Chemin de Vie 8 (Visionnaire & Succès)',
          'Chemin de Vie 9 (Humaniste Céleste)', 'Maître 11 (Catalyseur Intuitif)',
          'Maître 22 (Maître Bâtisseur)'
        ];
      case 'es':
        return [
          'Camino de Vida 1 (Pionero & Líder)', 'Camino de Vida 2 (Pacificador & Armonía)',
          'Camino de Vida 3 (Creador & Comunicador)', 'Camino de Vida 4 (Constructor & Base)',
          'Camino de Vida 5 (Espíritu Libre)', 'Camino de Vida 6 (Protector & Amor)',
          'Camino de Vida 7 (Filósofo & Sabio)', 'Camino de Vida 8 (Visionario & Logro)',
          'Camino de Vida 9 (Humanitario)', 'Maestro 11 (Intuitivo Espiritual)',
          'Maestro 22 (Maestro Constructor)'
        ];
      case 'it':
        return [
          'Sentiero di Vita 1 (Pioniere & Leader)', 'Sentiero di Vita 2 (Pacificatore)',
          'Sentiero di Vita 3 (Creatore & Espressione)', 'Sentiero di Vita 4 (Costruttore)',
          'Sentiero di Vita 5 (Spirito Libero)', 'Sentiero di Vita 6 (Custode & Amore)',
          'Sentiero di Vita 7 (Filosofo & Cercatore)', 'Sentiero di Vita 8 (Visionario)',
          'Sentiero di Vita 9 (Umanitario)', 'Maestro 11 (Intuitivo Cosmico)',
          'Maestro 22 (Maestro Architetto)'
        ];
      default:
        return [
          'Life Path 1 (Pioneer & Leader)', 'Life Path 2 (Peacemaker & Diplomat)',
          'Life Path 3 (Creator & Communicator)', 'Life Path 4 (Master Builder & Solid)',
          'Life Path 5 (Free Spirit & Adventurer)', 'Life Path 6 (Loving Caregiver)',
          'Life Path 7 (Seeker & Philosopher)', 'Life Path 8 (Visionary & Achiever)',
          'Life Path 9 (Humanitarian & Healer)', 'Master 11 (Intuitive Catalyst)',
          'Master 22 (Master Architect)'
        ];
    }
  }

  static List<String> getCelticRunes(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko': return celticRunes;
      case 'ja':
        return [
          'Fehu ᚠ (豊かさと繁栄の結合)', 'Uruz ᚢ (野生の活力と回復力)', 'Thurisaz ᚦ (守護と強固な決意)',
          'Ansuz ᚨ (神聖な英知と対話)', 'Raidho ᚱ (運命の旅路と共鳴)', 'Kenaz ᚲ (洞察と情熱の炎)',
          'Gebo ᚷ (神聖な絆と無償の愛)', 'Wunjo ᚹ (歓喜と調和の至福)'
        ];
      case 'de':
        return [
          'Fehu ᚠ (Wohlstand & Neuanfang)', 'Uruz ᚢ (Ureigene Vitalität & Kraft)', 'Thurisaz ᚦ (Schutz & Entschlossenheit)',
          'Ansuz ᚨ (Göttliche Weisheit)', 'Raidho ᚱ (Schicksalsreise & Einklang)', 'Kenaz ᚲ (Flamme der Erkenntnis)',
          'Gebo ᚷ (Heiliges Bündnis & Gabe)', 'Wunjo ᚹ (Glückselige Harmonie & Freude)'
        ];
      case 'fr':
        return [
          'Fehu ᚠ (Prospérité & Nouveaux Départs)', 'Uruz ᚢ (Vitalité Sauvage & Puissance)', 'Thurisaz ᚦ (Protection & Force)',
          'Ansuz ᚨ (Sagesse Divine & Dialogue)', 'Raidho ᚱ (Voyage Destiné & Élan)', 'Kenaz ᚲ (Lumière de l\'Amour)',
          'Gebo ᚷ (Union Sacrée & Don Mutuel)', 'Wunjo ᚹ (Joie Lumineuse & Harmonie)'
        ];
      case 'es':
        return [
          'Fehu ᚠ (Prosperidad y Nuevos Comienzos)', 'Uruz ᚢ (Fuerza y Vitalidad Pura)', 'Thurisaz ᚦ (Protección y Coraje)',
          'Ansuz ᚨ (Sabiduría Divina)', 'Raidho ᚱ (Viaje del Destino y Unión)', 'Kenaz ᚲ (Fuego del Conocimiento)',
          'Gebo ᚷ (Pacto Sagrado y Entrega)', 'Wunjo ᚹ (Alegría Armoniosa y Paz)'
        ];
      case 'it':
        return [
          'Fehu ᚠ (Prosperità e Nuovi Inizi)', 'Uruz ᚢ (Vitalità Primordiale)', 'Thurisaz ᚦ (Protezione e Risolutezza)',
          'Ansuz ᚨ (Saggezza Sacra e Dialogo)', 'Raidho ᚱ (Viaggio del Destino)', 'Kenaz ᚲ (Fiamma della Passione)',
          'Gebo ᚷ (Unione Sacra e Dono)', 'Wunjo ᚹ (Armonia Radiosa e Gioia)'
        ];
      default:
        return [
          'Fehu ᚠ (Prosperity & Abundance)', 'Uruz ᚢ (Untamed Vitality & Strength)', 'Thurisaz ᚦ (Protection & Willpower)',
          'Ansuz ᚨ (Divine Wisdom & Communion)', 'Raidho ᚱ (Destined Journey & Rhythm)', 'Kenaz ᚲ (Illumination & Passion)',
          'Gebo ᚷ (Sacred Gift & Devotion)', 'Wunjo ᚹ (Joy & Blissful Harmony)'
        ];
    }
  }

  static List<String> getSynastryHouses(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko': return synastryHouses;
      case 'ja':
        return [
          '1st House (自己の共鳴・自然な親和)', '4th House (心の安らぎ・魂の故郷)',
          '5th House (ロマンスと創造的情熱)', '7th House (運命の伴侶・契約の絆)',
          '8th House (魂の変容・強烈な引力)', '10th House (社会的成功・人生の同志)'
        ];
      case 'de':
        return [
          '1. Haus (Einklang des Selbst)', '4. Haus (Seelische Geborgenheit)',
          '5. Haus (Romantik & Leidenschaft)', '7. Haus (Seelengefährte & Partnerschaft)',
          '8. Haus (Tiefe seelische Transformation)', '10. Haus (Gemeinsamer Erfolg & Status)'
        ];
      case 'fr':
        return [
          '1ère Maison (Résonance du Soi)', '4ème Maison (Havre de Paix de l\'Âme)',
          '5ème Maison (Romance & Flamme Créative)', '7ème Maison (Partenaire de Destin)',
          '8ème Maison (Alchimie & Métamorphose)', '10ème Maison (Succès & Évolution)'
        ];
      case 'es':
        return [
          'Casa 1 (Afinidad del Ser)', 'Casa 4 (Refugio del Alma y Hogar)',
          'Casa 5 (Romance y Pasión Creativa)', 'Casa 7 (Compañero del Destino)',
          'Casa 8 (Transformación Espiritual)', 'Casa 10 (Éxito Social y Crecimiento)'
        ];
      case 'it':
        return [
          '1ª Casa (Risonanza del Sé)', '4ª Casa (Rifugio dell\'Anima e Radici)',
          '5ª Casa (Passione Creativa & Amore)', '7ª Casa (Compagno del Destino)',
          '8ª Casa (Trasformazione Profonda)', '10ª Casa (Successo & Destino Comune)'
        ];
      default:
        return [
          '1st House (Core Self Resonance)', '4th House (Soul Sanctuary & Comfort)',
          '5th House (Romance & Creative Passion)', '7th House (Destined Sacred Partner)',
          '8th House (Spiritual Transformation)', '10th House (Social Elevation & Success)'
        ];
    }
  }

  static List<String> getZodiacAnimals(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko':
        return zodiacAnimals;
      case 'ja':
        return [
          '子 (ねずみ 🐭)', '丑 (うし 🐮)', '寅 (とら 🐯)', '卯 (うさぎ 🐰)',
          '辰 (たつ 🐲)', '巳 (へび 🐍)', '午 (うま 🐴)', '未 (ひつじ 🐑)',
          '申 (さる 🐵)', '酉 (とり 🐔)', '戌 (いぬ 🐶)', '亥 (いのしし 🐗)'
        ];
      case 'de':
        return [
          'Ratte 🐭 (Water)', 'Büffel 🐮 (Earth)', 'Tiger 🐯 (Wood)', 'Hase 🐰 (Wood)',
          'Drache 🐲 (Earth)', 'Schlange 🐍 (Fire)', 'Pferd 🐴 (Fire)', 'Ziege 🐑 (Earth)',
          'Affe 🐵 (Metal)', 'Hahn 🐔 (Metal)', 'Hund 🐶 (Earth)', 'Schwein 🐷 (Water)'
        ];
      case 'fr':
        return [
          'Rat 🐭 (Eau)', 'Buffle 🐮 (Terre)', 'Tigre 🐯 (Bois)', 'Lapin 🐰 (Bois)',
          'Dragon 🐲 (Terre)', 'Serpent 🐍 (Feu)', 'Cheval 🐴 (Feu)', 'Chèvre 🐑 (Terre)',
          'Singe 🐵 (Métal)', 'Coq 🐔 (Métal)', 'Chien 🐶 (Terre)', 'Cochon 🐷 (Eau)'
        ];
      case 'es':
        return [
          'Rata 🐭 (Agua)', 'Buey 🐮 (Tierra)', 'Tigre 🐯 (Madera)', 'Conejo 🐰 (Madera)',
          'Dragón 🐲 (Tierra)', 'Serpiente 🐍 (Fuego)', 'Caballo 🐴 (Fuego)', 'Cabra 🐑 (Tierra)',
          'Mono 🐵 (Metal)', 'Gallo 🐔 (Metal)', 'Perro 🐶 (Tierra)', 'Cerdo 🐷 (Agua)'
        ];
      case 'it':
        return [
          'Topo 🐭 (Acqua)', 'Bue 🐮 (Terra)', 'Tigre 🐯 (Legno)', 'Coniglio 🐰 (Legno)',
          'Drago 🐲 (Terra)', 'Serpente 🐍 (Fuoco)', 'Cavallo 🐴 (Fuoco)', 'Capra 🐑 (Terra)',
          'Scimmia 🐵 (Metallo)', 'Gallo 🐔 (Metallo)', 'Cane 🐶 (Terra)', 'Maiale 🐷 (Acqua)'
        ];
      default:
        return [
          'Rat 🐭 (Water)', 'Ox 🐮 (Earth)', 'Tiger 🐯 (Wood)', 'Rabbit 🐰 (Wood)',
          'Dragon 🐲 (Earth)', 'Snake 🐍 (Fire)', 'Horse 🐴 (Fire)', 'Goat 🐑 (Earth)',
          'Monkey 🐵 (Metal)', 'Rooster 🐔 (Metal)', 'Dog 🐶 (Earth)', 'Pig 🐷 (Water)'
        ];
    }
  }

  static List<String> getSajuPillars(SupportedRegion region) {
    if (region.languageCode == 'ko') {
      return sajuPillars;
    }
    return [
      'Jia-Zi (甲子)', 'Yi-Chou (乙丑)', 'Bing-Yin (丙寅)', 'Ding-Mao (丁卯)', 'Wu-Chen (戊辰)',
      'Ji-Si (己巳)', 'Geng-Wu (庚午)', 'Xin-Wei (辛未)', 'Ren-Shen (壬申)', 'Gui-You (癸酉)',
      'Jia-Xu (甲戌)', 'Yi-Hai (乙亥)', 'Bing-Zi (丙子)', 'Ding-Chou (丁丑)', 'Wu-Yin (戊寅)',
      'Ji-Mao (己卯)', 'Geng-Chen (庚辰)', 'Xin-Si (辛巳)', 'Ren-Wu (壬午)', 'Gui-Wei (癸未)',
      'Jia-Shen (甲申)', 'Yi-You (乙酉)', 'Bing-Xu (丙戌)', 'Ding-Hai (丁亥)', 'Wu-Zi (戊子)',
      'Ji-Chou (己丑)', 'Geng-Yin (庚寅)', 'Xin-Mao (辛卯)', 'Ren-Chen (壬辰)', 'Gui-Si (癸巳)',
    ];
  }

  static List<String> getBloodZodiacHybrids(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko':
        return bloodZodiacHybrids;
      case 'ja':
        return [
          'A型 x 牡羊座 (正義の情熱派)', 'A型 x 乙女座 (完璧主義と配慮)',
          'B型 x 獅子座 (魅惑のステージ気質)', 'B型 x 射手座 (自由な探検家)',
          'O型 x 牡牛座 (信頼の頼れる岩)', 'O型 x 天秤座 (円満な社交チャンピオン)',
          'AB型 x 双子座 (閃きの多才)', 'AB型 x 水瓶座 (神秘の天才性)',
          'A型 x 蠍座 (深い献身と集中)', 'B型 x 魚座 (豊かな感性と芸術)',
          'O型 x 蟹座 (温かいファミリーリーダー)', 'AB型 x 山羊座 (冷静沈着な戦略家)'
        ];
      default:
        return [
          'Type A x Aries (Passionate Leader)', 'Type A x Virgo (Meticulous Caregiver)',
          'Type B x Leo (Magnetic Charisma)', 'Type B x Sagittarius (Free Spirit Explorer)',
          'Type O x Taurus (Steadfast Anchor)', 'Type O x Libra (Harmonious Diplomat)',
          'Type AB x Gemini (Sparkling Versatility)', 'Type AB x Aquarius (Mystic Genius)',
          'Type A x Scorpio (Devoted Focus)', 'Type B x Pisces (Artistic Sensitivity)',
          'Type O x Cancer (Warm Protector)', 'Type AB x Capricorn (Cool Strategist)'
        ];
    }
  }

  static List<String> getRokuseiStars(SupportedRegion region) {
    switch (region.languageCode) {
      case 'ko':
        return rokuseiStars;
      case 'ja':
        return [
          '水星人 (水星 - 知恵と名誉)', '金星人 (金星 - 行動力と社交)',
          '火星人 (火星 - 芸術性と直感)', '木星人 (木星 - 忍耐と大器晩成)',
          '天王星人 (天王星 - 理想主義と温和)', '土星人 (土星 - 厳格さと道徳心)'
        ];
      default:
        return [
          'Mercury Star / 水星 (Wisdom & Honor)', 'Venus Star / 金星 (Action & Charisma)',
          'Mars Star / 火星 (Art & Intuition)', 'Jupiter Star / 木星 (Patience & Growth)',
          'Uranus Star / 天王星 (Idealism & Peace)', 'Saturn Star / 土星 (Morality & Integrity)'
        ];
    }
  }

  /// Returns available items for selected menu
  static List<String> getAvailableItems(MatchSubMenu menu, [SupportedRegion region = SupportedRegion.unitedStates]) {
    switch (menu) {
      case MatchSubMenu.westernZodiac:
        return getWesternZodiacSigns(region);
      case MatchSubMenu.sixteenType:
        return SixteenTypeMatrix.allTypes;
      case MatchSubMenu.sajuIlju:
        return getSajuPillars(region);
      case MatchSubMenu.zodiacAnimal:
        return getZodiacAnimals(region);
      case MatchSubMenu.bloodType:
        return getBloodTypes(region);
      case MatchSubMenu.zodiacElement:
        return getZodiacElements(region);
      case MatchSubMenu.numerologyLifePath:
        return getLifePathNumbers(region);
      case MatchSubMenu.bloodZodiacHybrid:
        return getBloodZodiacHybrids(region);
      case MatchSubMenu.rokuseiMatch:
        return getRokuseiStars(region);
      case MatchSubMenu.zodiacHouse:
        return getSynastryHouses(region);
      case MatchSubMenu.celticRuneMatch:
        return getCelticRunes(region);
    }
  }

  /// Get localized short aura label for display inside the glowing orbs
  static String getAuraOrbLabel(MatchSubMenu menu, String value) {
    switch (menu) {
      case MatchSubMenu.westernZodiac:
        if (value.contains('(') && value.contains(')')) {
          final signName = value.split('(').first.trim();
          final inside = value.substring(value.indexOf('(') + 1, value.indexOf(')'));
          final symbol = inside.contains(' ') ? inside.split(' ').first : inside;
          if (symbol.isNotEmpty && symbol != signName) {
            return '$symbol $signName';
          }
          return signName;
        }
        return value;
      case MatchSubMenu.sixteenType:
        return value;
      case MatchSubMenu.sajuIlju:
        return value.split('(').first.trim();
      case MatchSubMenu.zodiacAnimal:
        if (value.contains('(') && value.contains(')')) {
          final prefix = value.split('(').first.trim();
          final inside = value.substring(value.indexOf('(') + 1, value.indexOf(')'));
          if (prefix.length > 1 && !value.startsWith('자(') && !value.startsWith('축(')) {
            return prefix;
          }
          return inside.replaceAll(' ', '');
        }
        return value;
      case MatchSubMenu.bloodType:
        return value;
      case MatchSubMenu.zodiacElement:
        return value.split(' ').first;
      case MatchSubMenu.numerologyLifePath:
        if (value.startsWith('Life Path ')) {
          return 'Path ${value.split(' ')[2]}';
        } else if (value.startsWith('Master ')) {
          return 'M${value.split(' ')[1]}';
        }
        return value.split(' ').first;
      case MatchSubMenu.bloodZodiacHybrid:
        return value.split(' ')[0];
      case MatchSubMenu.rokuseiMatch:
        return value.split(' ')[0];
      case MatchSubMenu.zodiacHouse:
        return value.split(' ')[0];
      case MatchSubMenu.celticRuneMatch:
        return value.split(' ')[0];
    }
  }

  /// Localized labels for Me and Partner input pickers
  static String getPickerLabelA(MatchSubMenu menu, SupportedRegion region) {
    switch (menu) {
      case MatchSubMenu.westernZodiac:
        return AppI18n.tr('my_zodiac_sign_label', region);
      case MatchSubMenu.sixteenType:
        return AppI18n.tr('my_type', region);
      case MatchSubMenu.sajuIlju:
        return AppI18n.tr('my_pillar_label', region);
      case MatchSubMenu.zodiacAnimal:
        return AppI18n.tr('my_animal_label', region);
      case MatchSubMenu.bloodType:
        return AppI18n.tr('my_blood_label', region);
      case MatchSubMenu.zodiacElement:
        return AppI18n.tr('my_element_label', region);
      case MatchSubMenu.numerologyLifePath:
        return AppI18n.tr('my_lifepath_label', region);
      case MatchSubMenu.bloodZodiacHybrid:
        return AppI18n.tr('my_hybrid_label', region);
      case MatchSubMenu.rokuseiMatch:
        return AppI18n.tr('my_rokusei_label', region);
      case MatchSubMenu.zodiacHouse:
        return AppI18n.tr('my_house_label', region);
      case MatchSubMenu.celticRuneMatch:
        return AppI18n.tr('my_rune_label', region);
    }
  }

  static String getPickerLabelB(MatchSubMenu menu, SupportedRegion region) {
    switch (menu) {
      case MatchSubMenu.westernZodiac:
        return AppI18n.tr('partner_zodiac_sign_label', region);
      case MatchSubMenu.sixteenType:
        return AppI18n.tr('partner_type', region);
      case MatchSubMenu.sajuIlju:
        return AppI18n.tr('partner_pillar_label', region);
      case MatchSubMenu.zodiacAnimal:
        return AppI18n.tr('partner_animal_label', region);
      case MatchSubMenu.bloodType:
        return AppI18n.tr('partner_blood_label', region);
      case MatchSubMenu.zodiacElement:
        return AppI18n.tr('partner_element_label', region);
      case MatchSubMenu.numerologyLifePath:
        return AppI18n.tr('partner_lifepath_label', region);
      case MatchSubMenu.bloodZodiacHybrid:
        return AppI18n.tr('partner_hybrid_label', region);
      case MatchSubMenu.rokuseiMatch:
        return AppI18n.tr('partner_rokusei_label', region);
      case MatchSubMenu.zodiacHouse:
        return AppI18n.tr('partner_house_label', region);
      case MatchSubMenu.celticRuneMatch:
        return AppI18n.tr('partner_rune_label', region);
    }
  }

  /// Main calculation method routing to specific system dynamics
  static MatchResult calculateMatch({
    required MatchSubMenu menu,
    required String itemA,
    required String itemB,
    required SupportedRegion region,
  }) {
    switch (menu) {
      case MatchSubMenu.westernZodiac:
        return _calculateWesternZodiac(itemA, itemB, region);

      case MatchSubMenu.sixteenType:
        return SixteenTypeMatrix.calculateChemistry(itemA, itemB, region: region);

      case MatchSubMenu.sajuIlju:
        return _calculateSajuIlju(itemA, itemB, region);

      case MatchSubMenu.zodiacAnimal:
        return _calculateZodiacAnimal(itemA, itemB, region);

      case MatchSubMenu.bloodType:
        return _calculateBloodType(itemA, itemB, region);

      case MatchSubMenu.zodiacElement:
        return _calculateZodiacElement(itemA, itemB, region);

      case MatchSubMenu.numerologyLifePath:
        return _calculateLifePath(itemA, itemB, region);

      case MatchSubMenu.bloodZodiacHybrid:
        return _calculateBloodZodiacHybrid(itemA, itemB, region);

      case MatchSubMenu.rokuseiMatch:
        return _calculateRokusei(itemA, itemB, region);

      case MatchSubMenu.zodiacHouse:
        return _calculateSynastryHouse(itemA, itemB, region);

      case MatchSubMenu.celticRuneMatch:
        return _calculateCelticRune(itemA, itemB, region);
    }
  }

  // 1) 사주 일주 궁합 계산 (천간합, 지지육합, 삼합)
  static MatchResult _calculateSajuIlju(String a, String b, SupportedRegion region) {
    // Extract Hanzi characters inside parenthesis if present (e.g. 甲子 from 'Jia-Zi (甲子)' or '갑자(甲子)')
    String extractHanziStem(String s) {
      if (s.contains('(') && s.contains(')')) {
        final inside = s.substring(s.indexOf('(') + 1, s.indexOf(')'));
        if (inside.isNotEmpty) return inside[0];
      }
      final clean = s.split('(').first.trim().toLowerCase();
      // Hanzi or Korean or Pinyin
      if (clean.startsWith('갑') || clean.startsWith('jia') || s.contains('甲')) return '甲';
      if (clean.startsWith('을') || clean.startsWith('yi') || s.contains('乙')) return '乙';
      if (clean.startsWith('병') || clean.startsWith('bing') || s.contains('丙')) return '丙';
      if (clean.startsWith('정') || clean.startsWith('ding') || s.contains('丁')) return '丁';
      if (clean.startsWith('무') || clean.startsWith('wu') || s.contains('戊')) return '戊';
      if (clean.startsWith('기') || clean.startsWith('ji') || s.contains('己')) return '己';
      if (clean.startsWith('경') || clean.startsWith('geng') || s.contains('庚')) return '庚';
      if (clean.startsWith('신') || clean.startsWith('xin') || s.contains('辛')) return '辛';
      if (clean.startsWith('임') || clean.startsWith('ren') || s.contains('壬')) return '壬';
      if (clean.startsWith('계') || clean.startsWith('gui') || s.contains('癸')) return '癸';
      return clean.isNotEmpty ? clean[0] : '';
    }

    final stemA = extractHanziStem(a);
    final stemB = extractHanziStem(b);

    final stemHarmonies = {
      '甲': '己', '己': '甲',
      '乙': '庚', '庚': '乙',
      '丙': '辛', '辛': '丙',
      '丁': '壬', '壬': '丁',
      '戊': '癸', '癸': '戊',
    };

    final isStemHarmony = stemHarmonies[stemA] == stemB;
    final seed = (a.hashCode ^ b.hashCode).abs();

    int score = isStemHarmony ? 97 : (75 + (seed % 20));
    String headline = isStemHarmony
        ? AppI18n.tr('match_saju_stem_harmony_title', region)
        : AppI18n.tr('match_headline_pillar', region);
    String summary = isStemHarmony
        ? AppI18n.tr('match_saju_stem_harmony_desc', region)
        : AppI18n.tr('match_summary_pillar', region);

    return MatchResult(
      score: score,
      headline: headline,
      summary: summary,
      passion: (80 + (seed % 18)).toDouble(),
      trust: (isStemHarmony ? 98 : 82 + (seed % 15)).toDouble(),
      communication: (75 + ((seed ~/ 2) % 22)).toDouble(),
      values: (isStemHarmony ? 96 : 80 + ((seed ~/ 3) % 18)).toDouble(),
      growth: (85 + ((seed ~/ 5) % 14)).toDouble(),
    );
  }

  // 2) 12간지 띠 궁합 계산 (삼합 4그룹, 육합, 상충) - 언어 무관 인덱스 매칭
  static MatchResult _calculateZodiacAnimal(String a, String b, SupportedRegion region) {
    int findAnimalIndex(String s) {
      final lower = s.toLowerCase();
      if (s.contains('🐭') || lower.contains('rat') || s.contains('쥐') || s.contains('자') || s.contains('ねずみ')) return 0;
      if (s.contains('🐮') || lower.contains('ox') || lower.contains('bue') || lower.contains('büffel') || s.contains('소') || s.contains('축') || s.contains('うし')) return 1;
      if (s.contains('🐯') || lower.contains('tiger') || lower.contains('tigre') || s.contains('호랑이') || s.contains('인') || s.contains('とら')) return 2;
      if (s.contains('🐰') || lower.contains('rabbit') || lower.contains('hase') || lower.contains('lapin') || lower.contains('conejo') || s.contains('토끼') || s.contains('묘') || s.contains('うさぎ')) return 3;
      if (s.contains('🐲') || lower.contains('dragon') || lower.contains('drache') || lower.contains('dragón') || lower.contains('drago') || s.contains('용') || s.contains('진') || s.contains('たつ')) return 4;
      if (s.contains('🐍') || lower.contains('snake') || lower.contains('schlange') || lower.contains('serpent') || lower.contains('serpiente') || s.contains('뱀') || s.contains('사') || s.contains('へび')) return 5;
      if (s.contains('🐴') || lower.contains('horse') || lower.contains('pferd') || lower.contains('cheval') || lower.contains('caballo') || lower.contains('cavallo') || s.contains('말') || s.contains('오') || s.contains('うま')) return 6;
      if (s.contains('🐑') || lower.contains('goat') || lower.contains('sheep') || lower.contains('ziege') || lower.contains('chèvre') || lower.contains('cabra') || s.contains('양') || s.contains('미') || s.contains('ひつじ')) return 7;
      if (s.contains('🐵') || lower.contains('monkey') || lower.contains('affe') || lower.contains('singe') || lower.contains('mono') || lower.contains('scimmia') || s.contains('원숭이') || s.contains('신') || s.contains('さる')) return 8;
      if (s.contains('🐔') || lower.contains('rooster') || lower.contains('hahn') || lower.contains('coq') || lower.contains('gallo') || s.contains('닭') || s.contains('유') || s.contains('とり')) return 9;
      if (s.contains('🐶') || lower.contains('dog') || lower.contains('hund') || lower.contains('chien') || lower.contains('perro') || lower.contains('cane') || s.contains('개') || s.contains('술') || s.contains('いぬ')) return 10;
      if (s.contains('🐷') || s.contains('🐗') || lower.contains('pig') || lower.contains('boar') || lower.contains('schwein') || lower.contains('cochon') || lower.contains('cerdo') || lower.contains('maiale') || s.contains('돼지') || s.contains('해') || s.contains('いのしし')) return 11;
      return 0;
    }

    final idxA = findAnimalIndex(a);
    final idxB = findAnimalIndex(b);

    final samhapGroups = [
      {8, 0, 4},   // 원숭이(8), 쥐(0), 용(4)
      {5, 9, 1},   // 뱀(5), 닭(9), 소(1)
      {2, 6, 10},  // 호랑이(2), 말(6), 개(10)
      {11, 3, 7},  // 돼지(11), 토끼(3), 양(7)
    ];

    final yukhap = {
      0: 1, 1: 0,
      2: 11, 11: 2,
      3: 10, 10: 3,
      4: 9, 9: 4,
      5: 8, 8: 5,
      6: 7, 7: 6,
    };

    final isSamhap = samhapGroups.any((g) => g.contains(idxA) && g.contains(idxB) && idxA != idxB);
    final isYukhap = yukhap[idxA] == idxB;

    int score = 76;
    String headline = AppI18n.tr('match_animal_general_title', region);
    String summary = AppI18n.tr('match_animal_general_desc', region);

    if (isSamhap) {
      score = 99;
      headline = AppI18n.tr('match_animal_samhap_title', region);
      summary = AppI18n.tr('match_animal_samhap_desc', region);
    } else if (isYukhap) {
      score = 96;
      headline = AppI18n.tr('match_animal_yukhap_title', region);
      summary = AppI18n.tr('match_animal_yukhap_desc', region);
    } else if (idxA == idxB) {
      score = 88;
      headline = AppI18n.tr('match_animal_same_title', region);
      summary = AppI18n.tr('match_animal_same_desc', region);
    }

    final seed = (a.hashCode ^ b.hashCode).abs();
    return MatchResult(
      score: score,
      headline: headline,
      summary: summary,
      passion: (isSamhap ? 95 : 75 + (seed % 20)).toDouble(),
      trust: (isYukhap ? 98 : 80 + (seed % 17)).toDouble(),
      communication: (82 + ((seed ~/ 2) % 16)).toDouble(),
      values: (isSamhap ? 97 : 78 + ((seed ~/ 3) % 19)).toDouble(),
      growth: (86 + ((seed ~/ 4) % 13)).toDouble(),
    );
  }

  // 3) 혈액형 궁합 (A, B, O, AB)
  static MatchResult _calculateBloodType(String a, String b, SupportedRegion region) {
    String cleanType(String s) {
      if (s.contains('AB')) return 'AB';
      if (s.contains('A')) return 'A';
      if (s.contains('B')) return 'B';
      if (s.contains('O')) return 'O';
      return 'A';
    }
    final typeA = cleanType(a);
    final typeB = cleanType(b);

    int score = 80;
    String headline = AppI18n.tr('match_blood_balance_title', region);
    String summary = AppI18n.tr('match_blood_balance_desc', region);

    if ((typeA == 'A' && typeB == 'O') || (typeA == 'O' && typeB == 'A')) {
      score = 96;
      headline = AppI18n.tr('match_blood_ao_title', region);
      summary = AppI18n.tr('match_blood_ao_desc', region);
    } else if ((typeA == 'B' && typeB == 'O') || (typeA == 'O' && typeB == 'B')) {
      score = 94;
      headline = AppI18n.tr('match_blood_bo_title', region);
      summary = AppI18n.tr('match_blood_bo_desc', region);
    } else if ((typeA == 'AB' && typeB == 'B') || (typeA == 'B' && typeB == 'AB')) {
      score = 90;
      headline = AppI18n.tr('match_blood_abb_title', region);
      summary = AppI18n.tr('match_blood_abb_desc', region);
    } else if (typeA == typeB) {
      score = 86;
      headline = AppI18n.tr('match_blood_same_title', region);
      summary = AppI18n.tr('match_blood_same_desc', region);
    } else if ((typeA == 'A' && typeB == 'B') || (typeA == 'B' && typeB == 'A')) {
      score = 75;
      headline = AppI18n.tr('match_blood_ab_title', region);
      summary = AppI18n.tr('match_blood_ab_desc', region);
    }

    final seed = (a.hashCode ^ b.hashCode).abs();
    return MatchResult(
      score: score,
      headline: headline,
      summary: summary,
      passion: (70 + (seed % 28)).toDouble(),
      trust: (score >= 90 ? 94 : 76 + (seed % 18)).toDouble(),
      communication: (78 + ((seed ~/ 2) % 20)).toDouble(),
      values: (score >= 90 ? 92 : 74 + ((seed ~/ 3) % 22)).toDouble(),
      growth: (80 + ((seed ~/ 4) % 18)).toDouble(),
    );
  }

  // 4) 서양 점성술 4대 원소 (Fire, Earth, Air, Water)
  static MatchResult _calculateZodiacElement(String a, String b, SupportedRegion region) {
    String cleanElem(String s) {
      final lower = s.toLowerCase();
      if (lower.contains('fire') || lower.contains('불') || lower.contains('火') || lower.contains('feuer') || lower.contains('feu') || lower.contains('fuego') || lower.contains('fuoco')) return 'Fire';
      if (lower.contains('earth') || lower.contains('흙') || lower.contains('土') || lower.contains('erde') || lower.contains('terre') || lower.contains('tierra') || lower.contains('terra')) return 'Earth';
      if (lower.contains('air') || lower.contains('바람') || lower.contains('風') || lower.contains('luft') || lower.contains('aire') || lower.contains('aria')) return 'Air';
      if (lower.contains('water') || lower.contains('물') || lower.contains('水') || lower.contains('wasser') || lower.contains('eau') || lower.contains('agua') || lower.contains('acqua')) return 'Water';
      return 'Fire';
    }
    final elemA = cleanElem(a);
    final elemB = cleanElem(b);

    int score = 78;
    String headline = AppI18n.tr('match_headline_element', region);
    String summary = AppI18n.tr('match_summary_element', region);

    if ((elemA == 'Fire' && elemB == 'Air') || (elemA == 'Air' && elemB == 'Fire')) {
      score = 96;
      headline = AppI18n.tr('match_elem_fire_air_title', region);
      summary = AppI18n.tr('match_elem_fire_air_desc', region);
    } else if ((elemA == 'Earth' && elemB == 'Water') || (elemA == 'Water' && elemB == 'Earth')) {
      score = 95;
      headline = AppI18n.tr('match_elem_earth_water_title', region);
      summary = AppI18n.tr('match_elem_earth_water_desc', region);
    } else if (elemA == elemB) {
      score = 88;
      headline = AppI18n.tr('match_elem_same_title', region);
      summary = AppI18n.tr('match_elem_same_desc', region);
    }

    final seed = (a.hashCode ^ b.hashCode).abs();
    return MatchResult(
      score: score,
      headline: headline,
      summary: summary,
      passion: ((elemA == 'Fire' || elemB == 'Fire') ? 96 : 80 + (seed % 16)).toDouble(),
      trust: ((elemA == 'Earth' || elemB == 'Earth') ? 95 : 82 + (seed % 14)).toDouble(),
      communication: ((elemA == 'Air' || elemB == 'Air') ? 94 : 78 + ((seed ~/ 2) % 18)).toDouble(),
      values: ((elemA == 'Water' || elemB == 'Water') ? 94 : 76 + ((seed ~/ 3) % 20)).toDouble(),
      growth: (86 + ((seed ~/ 5) % 12)).toDouble(),
    );
  }

  // 5) 수비학 Life Path
  static MatchResult _calculateLifePath(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 80 + (seed % 19);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_numerology_title', region),
      summary: AppI18n.tr('match_numerology_desc', region),
      passion: (78 + (seed % 20)).toDouble(),
      trust: (85 + ((seed ~/ 2) % 14)).toDouble(),
      communication: (80 + ((seed ~/ 3) % 18)).toDouble(),
      values: (88 + ((seed ~/ 4) % 11)).toDouble(),
      growth: (92 + ((seed ~/ 5) % 8)).toDouble(),
    );
  }

  // 6) 일본 血液型 x 星座
  static MatchResult _calculateBloodZodiacHybrid(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 84 + (seed % 15);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_hybrid_title', region),
      summary: AppI18n.tr('match_hybrid_desc', region),
      passion: (82 + (seed % 16)).toDouble(),
      trust: (88 + ((seed ~/ 2) % 11)).toDouble(),
      communication: (84 + ((seed ~/ 3) % 14)).toDouble(),
      values: (86 + ((seed ~/ 4) % 12)).toDouble(),
      growth: (89 + ((seed ~/ 5) % 10)).toDouble(),
    );
  }

  // 7) 일본 육성점술 Rokusei
  static MatchResult _calculateRokusei(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 82 + (seed % 17);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_rokusei_title', region),
      summary: AppI18n.tr('match_rokusei_desc', region),
      passion: (80 + (seed % 18)).toDouble(),
      trust: (86 + ((seed ~/ 2) % 13)).toDouble(),
      communication: (83 + ((seed ~/ 3) % 15)).toDouble(),
      values: (90 + ((seed ~/ 4) % 9)).toDouble(),
      growth: (87 + ((seed ~/ 5) % 11)).toDouble(),
    );
  }

  // 8) 유럽 시나스트리 하우스
  static MatchResult _calculateSynastryHouse(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 87 + (seed % 12);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_house_title', region),
      summary: AppI18n.tr('match_house_desc', region),
      passion: (88 + (seed % 11)).toDouble(),
      trust: (91 + ((seed ~/ 2) % 8)).toDouble(),
      communication: (85 + ((seed ~/ 3) % 13)).toDouble(),
      values: (89 + ((seed ~/ 4) % 10)).toDouble(),
      growth: (94 + ((seed ~/ 5) % 6)).toDouble(),
    );
  }

  // 9) 유럽 켈틱 룬
  static MatchResult _calculateCelticRune(String a, String b, SupportedRegion region) {
    final seed = (a.hashCode ^ b.hashCode).abs();
    final score = 85 + (seed % 14);

    return MatchResult(
      score: score,
      headline: AppI18n.tr('match_celtic_rune_title', region),
      summary: AppI18n.tr('match_celtic_rune_desc', region),
      passion: (86 + (seed % 13)).toDouble(),
      trust: (89 + ((seed ~/ 2) % 10)).toDouble(),
      communication: (82 + ((seed ~/ 3) % 16)).toDouble(),
      values: (92 + ((seed ~/ 4) % 8)).toDouble(),
      growth: (90 + ((seed ~/ 5) % 9)).toDouble(),
    );
  }

  // 10) 12 서양 별자리 (Sun Signs) 정밀 각도(Aspect) 및 원소 궁합
  static MatchResult _calculateWesternZodiac(String a, String b, SupportedRegion region) {
    final symbols = ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'];
    int findSignIndex(String s) {
      for (int i = 0; i < symbols.length; i++) {
        if (s.contains(symbols[i])) return i;
      }
      final lower = s.toLowerCase();
      final enSigns = [
        'aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo',
        'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'
      ];
      for (int i = 0; i < enSigns.length; i++) {
        if (lower.contains(enSigns[i])) return i;
      }
      final koSigns = [
        '양', '황소', '쌍둥이', '게', '사자', '처녀',
        '천칭', '전갈', '사수', '염소', '물병', '물고기'
      ];
      for (int i = 0; i < koSigns.length; i++) {
        if (s.contains(koSigns[i])) return i;
      }
      return 0;
    }

    final validA = findSignIndex(a);
    final validB = findSignIndex(b);

    final diff = ((validA - validB).abs()) % 12;
    final step = diff > 6 ? 12 - diff : diff;

    int score = 82;
    String headline = AppI18n.tr('match_zodiac_semi_title', region);
    String summary = AppI18n.tr('match_zodiac_semi_desc', region);

    double passion = 82;
    double trust = 84;
    double comms = 82;
    double values = 85;
    double growth = 88;

    if (step == 0) {
      // 동일한 별자리 (Conjunction 0°)
      score = 92;
      headline = AppI18n.tr('mirror_pair_title', region);
      summary = AppI18n.tr('mirror_pair_desc', region);
      passion = 90;
      trust = 95;
      comms = 92;
      values = 96;
      growth = 88;
    } else if (step == 4) {
      // 120° 트라인 (Trine) - 동일 4대 원소 (Fire-Fire, Earth-Earth, Air-Air, Water-Water)
      score = 98;
      headline = AppI18n.tr('match_zodiac_trine_title', region);
      summary = AppI18n.tr('match_zodiac_trine_desc', region);
      passion = 96;
      trust = 98;
      comms = 95;
      values = 97;
      growth = 94;
    } else if (step == 2) {
      // 60° 섹스타일 (Sextile) - 상생 원소 (Fire-Air, Earth-Water)
      score = 95;
      headline = AppI18n.tr('match_zodiac_sextile_title', region);
      summary = AppI18n.tr('match_zodiac_sextile_desc', region);
      passion = 94;
      trust = 93;
      comms = 97;
      values = 92;
      growth = 96;
    } else if (step == 6) {
      // 180° 대향궁 (Opposition) - 정반대의 강렬한 자석 같은 끌림
      score = 90;
      headline = AppI18n.tr('match_zodiac_opposite_title', region);
      summary = AppI18n.tr('match_zodiac_opposite_desc', region);
      passion = 98;
      trust = 85;
      comms = 88;
      values = 86;
      growth = 99;
    } else if (step == 3) {
      // 90° 스퀘어 (Square) - 역동적 도전과 긴장감
      score = 84;
      headline = AppI18n.tr('match_zodiac_square_title', region);
      summary = AppI18n.tr('match_zodiac_square_desc', region);
      passion = 92;
      trust = 80;
      comms = 83;
      values = 82;
      growth = 95;
    } else if (step == 5) {
      // 150° 퀸컹크스 (Quincunx) - 신비로운 이끌림과 영적 조율
      score = 86;
      headline = AppI18n.tr('match_zodiac_quincunx_title', region);
      summary = AppI18n.tr('match_zodiac_quincunx_desc', region);
      passion = 87;
      trust = 86;
      comms = 84;
      values = 88;
      growth = 92;
    }

    final seed = (a.hashCode ^ b.hashCode).abs();
    return MatchResult(
      score: score,
      headline: headline,
      summary: summary,
      passion: passion + (seed % 3),
      trust: trust + ((seed ~/ 2) % 3),
      communication: comms + ((seed ~/ 3) % 3),
      values: values + ((seed ~/ 4) % 3),
      growth: growth + ((seed ~/ 5) % 3),
    );
  }
}

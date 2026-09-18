import 'geo_detector.dart';

class AppI18n {
  static String tr(String key, SupportedRegion region) {
    final map = _translations[key];
    if (map == null) return key;
    return map[region] ?? map[SupportedRegion.unitedStates] ?? key;
  }

  static const Map<String, Map<SupportedRegion, String>> _translations = {
    // Navigation
    'nav_fortune': {
      SupportedRegion.korea: '운세',
      SupportedRegion.unitedStates: 'Fortune',
      SupportedRegion.japan: '占い',
      SupportedRegion.europe: 'Destin',
    },
    'nav_match': {
      SupportedRegion.korea: '궁합',
      SupportedRegion.unitedStates: 'Match',
      SupportedRegion.japan: '相性',
      SupportedRegion.europe: 'Chimie',
    },
    'nav_shop': {
      SupportedRegion.korea: '상점',
      SupportedRegion.unitedStates: 'Shop',
      SupportedRegion.japan: 'ショップ',
      SupportedRegion.europe: 'Boutique',
    },
    'nav_vault': {
      SupportedRegion.korea: '보관함',
      SupportedRegion.unitedStates: 'Vault',
      SupportedRegion.japan: '保管庫',
      SupportedRegion.europe: 'Coffre',
    },
    'nav_settings': {
      SupportedRegion.korea: '설정',
      SupportedRegion.unitedStates: 'Settings',
      SupportedRegion.japan: '設定',
      SupportedRegion.europe: 'Paramètres',
    },

    // Fortune Hub
    'today_dopamine_secret': {
      SupportedRegion.korea: '오늘의 도파민 시크릿',
      SupportedRegion.unitedStates: 'Today\'s Dopamine Secret',
      SupportedRegion.japan: '今日のドーパミンシークレット',
      SupportedRegion.europe: 'Secret Céleste du Jour',
    },
    'wealth_golden_time': {
      SupportedRegion.korea: '오늘 당신에게 금전운이 터지는 최적 시간',
      SupportedRegion.unitedStates: 'Your Best Golden Wealth Hours Today',
      SupportedRegion.japan: '本日、金運が急上昇するベストタイム',
      SupportedRegion.europe: 'Heures d\'Or de Prospérité d\'Aujourd\'hui',
    },
    'open_action_guide': {
      SupportedRegion.korea: '상세 행동 요령 열기 >',
      SupportedRegion.unitedStates: 'Open Action Guide >',
      SupportedRegion.japan: '行動指針を開く >',
      SupportedRegion.europe: 'Guide d\'action >',
    },
    'energy_warning_snack': {
      SupportedRegion.korea: '주의: 오늘 당신의 에너지를 뺏는 사람: 목(木) 기운이 강한 인물',
      SupportedRegion.unitedStates: 'Caution: Energy vampire today: Heavy Wood element personality',
      SupportedRegion.japan: '注意: 今日のエネルギーを奪う人: 木の気が強いタイプ',
      SupportedRegion.europe: 'Attention: Personne drainant l\'énergie: Élément Bois dominant',
    },
    'curated_fortune_title': {
      SupportedRegion.korea: '맞춤 운세 큐레이션',
      SupportedRegion.unitedStates: 'Curated Readings',
      SupportedRegion.japan: '厳選占いキュレーション',
      SupportedRegion.europe: 'Lectures Astrologiques',
    },
    'deep_report_btn': {
      SupportedRegion.korea: '심층 리포트 >',
      SupportedRegion.unitedStates: 'Deep Report >',
      SupportedRegion.japan: '深層鑑定 >',
      SupportedRegion.europe: 'Rapport Détaillé >',
    },

    // Match Hub
    'my_type': {
      SupportedRegion.korea: '내 성격유형',
      SupportedRegion.unitedStates: 'My Personality',
      SupportedRegion.japan: '自分のタイプ',
      SupportedRegion.europe: 'Mon Profil',
    },
    'partner_type': {
      SupportedRegion.korea: '상대방 유형',
      SupportedRegion.unitedStates: 'Partner\'s Type',
      SupportedRegion.japan: '相手のタイプ',
      SupportedRegion.europe: 'Profil Partenaire',
    },
    'me_label': {
      SupportedRegion.korea: '나',
      SupportedRegion.unitedStates: 'ME',
      SupportedRegion.japan: '自分',
      SupportedRegion.europe: 'MOI',
    },
    'you_label': {
      SupportedRegion.korea: '상대',
      SupportedRegion.unitedStates: 'YOU',
      SupportedRegion.japan: '相手',
      SupportedRegion.europe: 'TOI',
    },
    'chemistry_score': {
      SupportedRegion.korea: '케미스트리 지수',
      SupportedRegion.unitedStates: 'Chemistry Score',
      SupportedRegion.japan: 'ケミストリー指数',
      SupportedRegion.europe: 'Indice de Chimie',
    },
    'share_story_btn': {
      SupportedRegion.korea: '9:16 인스타 공유',
      SupportedRegion.unitedStates: '9:16 Story Share',
      SupportedRegion.japan: '9:16 ストーリー共有',
      SupportedRegion.europe: 'Partager Story 9:16',
    },

    // Shop
    'shop_title': {
      SupportedRegion.korea: '복채(하트) 충전소 & 프리미엄 상점',
      SupportedRegion.unitedStates: 'Heart Wallet & Luxury Shop',
      SupportedRegion.japan: 'ハートチャージ＆ショップ',
      SupportedRegion.europe: 'Boutique Céleste & Cœurs',
    },
    'shop_subtitle': {
      SupportedRegion.korea: '심화 운세 리포트 및 상세 궁합 열람 시 복채(하트 1개)가 소모됩니다.',
      SupportedRegion.unitedStates: 'Deep readings and full compatibility reports require 1 Heart.',
      SupportedRegion.japan: '詳細な占い・相性鑑定にはハート1個が必要です。',
      SupportedRegion.europe: 'Chaque lecture approfondie requiert 1 Cœur.',
    },
    'current_hearts': {
      SupportedRegion.korea: '보유 하트',
      SupportedRegion.unitedStates: 'Hearts Balance',
      SupportedRegion.japan: '保有ハート',
      SupportedRegion.europe: 'Solde de Cœurs',
    },
    'vip_unlimited': {
      SupportedRegion.korea: 'VIP 무제한 패스',
      SupportedRegion.unitedStates: 'VIP Unlimited Pass',
      SupportedRegion.japan: 'VIP無制限パス',
      SupportedRegion.europe: 'Pass VIP Illimité',
    },
    'watch_ad_free': {
      SupportedRegion.korea: '광고 보고 무료 충전 (+2개)',
      SupportedRegion.unitedStates: 'Watch Sponsor Video (+2 Hearts)',
      SupportedRegion.japan: '動画広告で無料チャージ (+2個)',
      SupportedRegion.europe: 'Regarder Vidéo (+2 Cœurs)',
    },
    'heart_pack_10': {
      SupportedRegion.korea: '하트 10개 패키지',
      SupportedRegion.unitedStates: '10 Hearts Pack',
      SupportedRegion.japan: 'ハート10個セット',
      SupportedRegion.europe: 'Pack 10 Cœurs',
    },
    'heart_pack_30': {
      SupportedRegion.korea: '하트 30개 패키지',
      SupportedRegion.unitedStates: '30 Hearts Pack',
      SupportedRegion.japan: 'ハート30個セット',
      SupportedRegion.europe: 'Pack 30 Cœurs',
    },
    'vip_master_title': {
      SupportedRegion.korea: 'VIP 마스터 패스 (영구 소장)',
      SupportedRegion.unitedStates: 'VIP Master Pass (Lifetime)',
      SupportedRegion.japan: 'VIPマスターパス (永久)',
      SupportedRegion.europe: 'Pass Maître VIP (À Vie)',
    },
    'vip_master_desc': {
      SupportedRegion.korea: '모든 광고 영구 제거 + 무제한 하트 & 전 기능 무제한 언락',
      SupportedRegion.unitedStates: 'Permanent ad removal + unlimited hearts & full features',
      SupportedRegion.japan: '全広告の永久解除＋無制限ハート＆全機能アンロック',
      SupportedRegion.europe: 'Sans publicité à vie + Cœurs illimités & tout débloqué',
    },
    'buy_button': {
      SupportedRegion.korea: '구매',
      SupportedRegion.unitedStates: 'Buy',
      SupportedRegion.japan: '購入',
      SupportedRegion.europe: 'Acheter',
    },

    // Settings
    'settings_title': {
      SupportedRegion.korea: '환경 설정',
      SupportedRegion.unitedStates: 'Preferences',
      SupportedRegion.japan: '設定',
      SupportedRegion.europe: 'Paramètres',
    },
    'language_region_setting': {
      SupportedRegion.korea: '언어 및 타깃 권역 설정',
      SupportedRegion.unitedStates: 'Language & Target Region',
      SupportedRegion.japan: '言語と対象地域の設定',
      SupportedRegion.europe: 'Langue & Région Cible',
    },
    'language_region_desc': {
      SupportedRegion.korea: '접속 국가에 맞춰 1면 큐레이션 및 모든 번역이 자동 재구성됩니다.',
      SupportedRegion.unitedStates: 'The 1st page curation and entire translations adapt immediately.',
      SupportedRegion.japan: '選択した国に合わせて、トップ画面の占術と全言語が再構成されます。',
      SupportedRegion.europe: 'L\'interface et la curation céleste s\'adaptent instantanément.',
    },
    'solar_time_correction': {
      SupportedRegion.korea: '진태양시 경도 자동 보정',
      SupportedRegion.unitedStates: 'True Solar Time Correction',
      SupportedRegion.japan: '真太陽時・経度自動補正',
      SupportedRegion.europe: 'Correction du Temps Solaire Vrai',
    },
    'solar_time_desc': {
      SupportedRegion.korea: '표준시(135°E)와 출생지 간 경도 오차를 자동 계산하여 반영합니다.',
      SupportedRegion.unitedStates: 'Automatically compensates longitude offsets against standard meridians.',
      SupportedRegion.japan: '標準時子午線と出生地の経度誤差を自動計算して反映します。',
      SupportedRegion.europe: 'Calcule automatiquement le décalage de longitude astronomique.',
    },
    'haptic_feedback': {
      SupportedRegion.korea: '햅틱 피드백 진동',
      SupportedRegion.unitedStates: 'Haptic Touch Vibrations',
      SupportedRegion.japan: '触覚ハプティック振動',
      SupportedRegion.europe: 'Vibrations Haptiques',
    },
    'sound_fx': {
      SupportedRegion.korea: '신비로운 앰비언트 효과음',
      SupportedRegion.unitedStates: 'Mystic Soundscapes',
      SupportedRegion.japan: '神秘的な環境効果音',
      SupportedRegion.europe: 'Effets Sonores Célestes',
    },
    'privacy_legal': {
      SupportedRegion.korea: '개인정보 보호 및 법률 고지',
      SupportedRegion.unitedStates: 'Privacy & Legal Notice',
      SupportedRegion.japan: 'プライバシーと法的通知',
      SupportedRegion.europe: 'Confidentialité & Mentions Légales',
    },
    'privacy_desc': {
      SupportedRegion.korea: '100% Local-First 아키텍처로 외부 서버에 어떤 개인정보도 저장되지 않습니다.',
      SupportedRegion.unitedStates: '100% Local-First. No personal or birth data is ever sent to cloud servers.',
      SupportedRegion.japan: '100%ローカル動作。個人情報や生年月日データは外部サーバーに送信されません。',
      SupportedRegion.europe: '100% Local. Aucune donnée personnelle n\'est transmise à un serveur.',
    },
    'out_of_hearts_title': {
      SupportedRegion.korea: '복채(하트)가 부족합니다',
      SupportedRegion.unitedStates: 'Out of Hearts',
      SupportedRegion.japan: 'ハートが不足しています',
      SupportedRegion.europe: 'Cœurs Insuffisants',
    },
    'out_of_hearts_desc': {
      SupportedRegion.korea: '심층 운세 및 정밀 궁합을 열람하려면 하트 1개가 필요합니다. 무료 광고 시청으로 즉시 충전하세요!',
      SupportedRegion.unitedStates: '1 Heart is required to unlock full readings. Watch a quick sponsor ad to get +2 Hearts free!',
      SupportedRegion.japan: '詳細な鑑定にはハート1個が必要です。無料広告の視聴でハート+2個を今すぐ獲得！',
      SupportedRegion.europe: '1 Cœur est requis pour débloquer la lecture. Regardez une vidéo pour obtenir +2 Cœurs !',
    },
    'charge_free_now': {
      SupportedRegion.korea: '광고 보고 무료 충전 (+2개)',
      SupportedRegion.unitedStates: 'Watch Ad for Free (+2 Hearts)',
      SupportedRegion.japan: '広告を見て無料チャージ (+2個)',
      SupportedRegion.europe: 'Regarder la Pub (+2 Cœurs)',
    },
    'go_to_shop': {
      SupportedRegion.korea: '상점 바로가기',
      SupportedRegion.unitedStates: 'Go to Shop',
      SupportedRegion.japan: 'ショップへ移動',
      SupportedRegion.europe: 'Aller à la Boutique',
    },
    'key_visual_kr': {
      SupportedRegion.korea: '전통 음양오행 천문 원반',
      SupportedRegion.unitedStates: 'Bazi Celestial Ring',
      SupportedRegion.japan: '陰陽五行 天文円盤',
      SupportedRegion.europe: 'Disque Céleste Bazi',
    },
    'key_visual_us': {
      SupportedRegion.korea: '12별자리 서양 점성술 천궁도',
      SupportedRegion.unitedStates: 'Western Natal Horoscope Chart',
      SupportedRegion.japan: '西洋占星術 ネイタルホロスコープ',
      SupportedRegion.europe: 'Thème Astral Occidental',
    },
    'key_visual_jp': {
      SupportedRegion.korea: '구성기학 & 팔괘 방위 나침반',
      SupportedRegion.unitedStates: 'Nine Star Ki & Bagua Compass',
      SupportedRegion.japan: '九星気学 八卦方位羅針盤',
      SupportedRegion.europe: 'Boussole Bagua & Ki',
    },
    'key_visual_eu': {
      SupportedRegion.korea: '고대 켈틱 룬ส톤 천체 나침반',
      SupportedRegion.unitedStates: 'Celtic Rune Mystic Compass',
      SupportedRegion.japan: '古代ケルト ルーン天体羅針盤',
      SupportedRegion.europe: 'Compas Runique Celtique',
    },
    'app_version': {
      SupportedRegion.korea: '앱 버전',
      SupportedRegion.unitedStates: 'App Version',
      SupportedRegion.japan: 'アプリバージョン',
      SupportedRegion.europe: 'Version',
    },

    // Vault
    'vault_title': {
      SupportedRegion.korea: '저장된 인연 보관함 (Vault)',
      SupportedRegion.unitedStates: 'Saved Profiles Vault',
      SupportedRegion.japan: '保存されたご縁（保管庫）',
      SupportedRegion.europe: 'Coffre des Destins Enregistrés',
    },
    'add_person_btn': {
      SupportedRegion.korea: '인연 등록',
      SupportedRegion.unitedStates: 'Add Profile',
      SupportedRegion.japan: '新規登録',
      SupportedRegion.europe: 'Ajouter',
    },
    'vault_wallet_title': {
      SupportedRegion.korea: '복채(하트) 지갑',
      SupportedRegion.unitedStates: 'Heart Wallet',
      SupportedRegion.japan: 'ハート残高ウォレット',
      SupportedRegion.europe: 'Portefeuille Céleste',
    },
    'vault_vip_title': {
      SupportedRegion.korea: 'VIP 마스터 멤버십',
      SupportedRegion.unitedStates: 'VIP Master Membership',
      SupportedRegion.japan: 'VIPマスターメンバーシップ',
      SupportedRegion.europe: 'Membre Maître VIP',
    },
    'vault_vip_desc': {
      SupportedRegion.korea: '모든 심층 풀이 무제한 패스 적용',
      SupportedRegion.unitedStates: 'Unlimited Access to All Deep Readings',
      SupportedRegion.japan: '全深層鑑定への無制限パス適用中',
      SupportedRegion.europe: 'Accès Illimité à Toutes les Lectures',
    },
    'vault_hearts_desc': {
      SupportedRegion.korea: '현재 보유 하트: {count}개',
      SupportedRegion.unitedStates: 'Current Hearts: {count}',
      SupportedRegion.japan: '現在のハート残高: {count}個',
      SupportedRegion.europe: 'Cœurs Disponibles: {count}',
    },
    'vault_legal_title': {
      SupportedRegion.korea: '법률 준수 및 개인정보 정책',
      SupportedRegion.unitedStates: 'Privacy & Legal Compliance',
      SupportedRegion.japan: '法的遵守とプライバシーポリシー',
      SupportedRegion.europe: 'Conformité Légale & Confidentialité',
    },
    'vault_legal_desc': {
      SupportedRegion.korea: '본 앱은 100% Local-First 아키텍처로 작동하며, 입력하신 모든 생년월일 및 프로필 데이터는 외부 서버로 전송되지 않고 기기 내 로컬 저장소에만 안전하게 보관됩니다. (GDPR/CCPA 규격 준수)',
      SupportedRegion.unitedStates: 'Operating on 100% Local-First architecture. All personal birth details and profiles remain exclusively in private device storage with zero server uploads. (GDPR/CCPA Compliant)',
      SupportedRegion.japan: '100%ローカル動作。入力された生年月日やプロフィールは外部サーバーへ送信されず、端末内でのみ暗号化保護されます。(GDPR/CCPA準拠)',
      SupportedRegion.europe: 'Architecture 100% locale. Vos dates et profils restent strictement confinés sur votre appareil sans aucune transmission vers des serveurs externes. (Conforme RGPD/CCPA)',
    },

    // Daily Retention & Check-in
    'daily_checkin_title': {
      SupportedRegion.korea: '오늘의 무료 복채 출석 보상',
      SupportedRegion.unitedStates: 'Daily Celestial Check-in Reward',
      SupportedRegion.japan: '本日の無料デイリー出席ボーナス',
      SupportedRegion.europe: 'Récompense Céleste Quotidienne',
    },
    'daily_checkin_desc': {
      SupportedRegion.korea: '매일 1회 무료 하트 지급! 연속 출석으로 행운의 기운을 모아보세요.',
      SupportedRegion.unitedStates: 'Claim 1 free Heart every day! Gather celestial fortune.',
      SupportedRegion.japan: '毎日1回無料ハート進呈！幸運のエネルギーを受け取りましょう。',
      SupportedRegion.europe: '1 Cœur offert chaque jour ! Récoltez votre bonne étoile.',
    },
    'daily_checkin_claim': {
      SupportedRegion.korea: '무료 하트 받기 (+1❤️)',
      SupportedRegion.unitedStates: 'Claim Free Heart (+1❤️)',
      SupportedRegion.japan: '無料ハートを受け取る (+1❤️)',
      SupportedRegion.europe: 'Recevoir Mon Cœur (+1❤️)',
    },
    'daily_checkin_done': {
      SupportedRegion.korea: '오늘 수령 완료',
      SupportedRegion.unitedStates: 'Claimed Today',
      SupportedRegion.japan: '本日受取済み',
      SupportedRegion.europe: 'Déjà Reçu Aujourd\'hui',
    },
    'daily_claimed_snack': {
      SupportedRegion.korea: '✨ 오늘의 무료 하트 1개가 지급되었습니다!',
      SupportedRegion.unitedStates: '✨ +1 Free Daily Heart Claimed!',
      SupportedRegion.japan: '✨ 本日のデイリー無料ハート1個を獲得しました！',
      SupportedRegion.europe: '✨ +1 Cœur Quotidien Reçu avec Succès !',
    },

    // Birth Input Modal
    'birth_modal_title': {
      SupportedRegion.korea: '출생 정보 및 진태양시 정밀 보정',
      SupportedRegion.unitedStates: 'Birth Time & Solar Ephemeris',
      SupportedRegion.japan: '出生日時＆真太陽時精密補正',
      SupportedRegion.europe: 'Heure de Naissance & Temps Solaire',
    },
    'birth_modal_desc': {
      SupportedRegion.korea: '정밀 진태양시 오차 보정(-32분)과 고대 원전 알고리즘을 적용합니다.',
      SupportedRegion.unitedStates: 'Applies true solar time correction (-32m) and ancient ephemeris algorithms.',
      SupportedRegion.japan: '真太陽時補正(-32分)と原典アルゴリズムを忠実に適用します。',
      SupportedRegion.europe: 'Applique la correction du temps solaire vrai (-32 min) et les tables éphémérides.',
    },
    'birth_city_label': {
      SupportedRegion.korea: '출생 도시 (진태양시 경도 보정)',
      SupportedRegion.unitedStates: 'Birth City (Longitude Calibration)',
      SupportedRegion.japan: '出生都市 (経度による太陽時補正)',
      SupportedRegion.europe: 'Ville de Naissance (Calibration Longitude)',
    },
    'birth_datetime_label': {
      SupportedRegion.korea: '생년월일 및 태어난 시간',
      SupportedRegion.unitedStates: 'Birth Date & Accurate Time',
      SupportedRegion.japan: '生年月日および出生時刻',
      SupportedRegion.europe: 'Date et Heure Précise de Naissance',
    },
    'start_analysis_btn': {
      SupportedRegion.korea: '정밀 운명 분석 시작 (하트 1개 소모)',
      SupportedRegion.unitedStates: 'Start Deep Reading (1 Heart)',
      SupportedRegion.japan: '深層鑑定を開始 (ハート1個消費)',
      SupportedRegion.europe: 'Commencer l\'Analyse (1 Cœur)',
    },

    // Tarot
    'tarot_title': {
      SupportedRegion.korea: '신비의 3-Card 타로 심층 리포트',
      SupportedRegion.unitedStates: 'Mystic 3-Card Deep Tarot Reading',
      SupportedRegion.japan: '神秘の3カード深層タロット鑑定',
      SupportedRegion.europe: 'Lecture Approfondie du Tarot en 3 Cartes',
    },
    'tarot_pick_prompt': {
      SupportedRegion.korea: '운명의 3장을 선택하세요 ({count}/3)',
      SupportedRegion.unitedStates: 'Select 3 Cards of Destiny ({count}/3)',
      SupportedRegion.japan: '運命の3枚を選択してください ({count}/3)',
      SupportedRegion.europe: 'Choisissez 3 Cartes du Destin ({count}/3)',
    },
    'tarot_reshuffle': {
      SupportedRegion.korea: '다시 섞기',
      SupportedRegion.unitedStates: 'Reshuffle',
      SupportedRegion.japan: 'シャッフルし直す',
      SupportedRegion.europe: 'Rebattre',
    },

    // Match Unlock
    'unlock_match_btn': {
      SupportedRegion.korea: '두 사람의 시크릿 심층 궁합 열람 (하트 1개)',
      SupportedRegion.unitedStates: 'Unlock Secret Chemistry Deep Report (1 Heart)',
      SupportedRegion.japan: '2人のシークレット深層相性を解禁 (ハート1個)',
      SupportedRegion.europe: 'Débloquer l\'Analyse Secrète de Chimie (1 Cœur)',
    },
    'match_unlocked_snack': {
      SupportedRegion.korea: '✨ 정밀 궁합 심층 분석이 언락되었습니다! (하트 1개 사용)',
      SupportedRegion.unitedStates: '✨ Deep Chemistry Report Unlocked! (-1 Heart)',
      SupportedRegion.japan: '✨ 深層相性レポートが解禁されました！(ハート1個消費)',
      SupportedRegion.europe: '✨ Rapport de Chimie Débloqué ! (-1 Cœur)',
    },
    'match_headline_mbti': {
      SupportedRegion.korea: '상호 보완적인 호기심과 성장의 시너지',
      SupportedRegion.unitedStates: 'Complementary Curiosity & Growth Synergy',
      SupportedRegion.japan: '相互補完の知的好奇心と成長シナジー',
      SupportedRegion.europe: 'Synergie de Curiosité Complémentaire et Croissance',
    },
    'match_summary_mbti': {
      SupportedRegion.korea: '서로 다른 시각에서 배울 점이 풍부하며 자극과 성장을 함께 추구하는 최적의 콤비입니다.',
      SupportedRegion.unitedStates: 'Rich learning perspectives from distinct angles, inspiring mutual growth.',
      SupportedRegion.japan: '異なる視点から学び合い、互いを高め合える理想のパートナーシップです。',
      SupportedRegion.europe: 'Perspectives enrichissantes sous différents angles stimulant une élévation mutuelle.',
    },
    'match_headline_pillar': {
      SupportedRegion.korea: '천간합(甲己合)과 지지 육합의 길한 인연',
      SupportedRegion.unitedStates: 'Auspicious Celestial Stem Harmony & Earthly Union',
      SupportedRegion.japan: '天干合と地支六合による吉兆の結びつき',
      SupportedRegion.europe: 'Harmonie Céleste Favorable et Union Terrestre',
    },
    'match_summary_pillar': {
      SupportedRegion.korea: '두 사람의 일주(Day Pillar)가 서로의 부족한 기운을 완벽하게 채워주는 조화로운 궁합입니다.',
      SupportedRegion.unitedStates: 'Day Pillars balance each other\'s elemental energies in perfect cosmic equilibrium.',
      SupportedRegion.japan: '2人の日柱がお互いに足りないエネルギーを満たし合う調和の取れた相性です。',
      SupportedRegion.europe: 'Les piliers de naissance équilibrent harmonieusement les énergies de chacun.',
    },
    'match_headline_element': {
      SupportedRegion.korea: '불과 바람의 역동적인 도파민 시너지',
      SupportedRegion.unitedStates: 'Dynamic Synergy of Fire & Wind Energies',
      SupportedRegion.japan: '火と風が織りなす情熱のダイナミックシナジー',
      SupportedRegion.europe: 'Synergie Dynamique des Éléments Feu et Vent',
    },
    'match_summary_element': {
      SupportedRegion.korea: '서로를 빛나게 하는 에너지가 넘치며 함께 있을 때 끊임없이 새로운 영감과 도전을 나눕니다.',
      SupportedRegion.unitedStates: 'Radiating vibrant energy that sparks ceaseless inspiration and creative thrill.',
      SupportedRegion.japan: 'お互いを輝かせる情熱に満ち、常に新しい刺激とひらめきをもたらします。',
      SupportedRegion.europe: 'Une énergie rayonnante apportant une inspiration continue et un élan partagé.',
    },

    // Radar Axis
    'axis_passion': {
      SupportedRegion.korea: '열정',
      SupportedRegion.unitedStates: 'Passion',
      SupportedRegion.japan: '情熱',
      SupportedRegion.europe: 'Passion',
    },
    'axis_trust': {
      SupportedRegion.korea: '신뢰',
      SupportedRegion.unitedStates: 'Trust',
      SupportedRegion.japan: '信頼',
      SupportedRegion.europe: 'Confiance',
    },
    'axis_communication': {
      SupportedRegion.korea: '소통',
      SupportedRegion.unitedStates: 'Comms',
      SupportedRegion.japan: '対話',
      SupportedRegion.europe: 'Échange',
    },
    'axis_values': {
      SupportedRegion.korea: '가치관',
      SupportedRegion.unitedStates: 'Values',
      SupportedRegion.japan: '価値観',
      SupportedRegion.europe: 'Valeurs',
    },
    'axis_growth': {
      SupportedRegion.korea: '성장',
      SupportedRegion.unitedStates: 'Growth',
      SupportedRegion.japan: '成長',
      SupportedRegion.europe: 'Croissance',
    },

    // HUD Dialog Logs
    'hud_log_1': {
      SupportedRegion.korea: '경도 기준 진태양시 오차 정밀 보정 중',
      SupportedRegion.unitedStates: 'Calibrating true solar time against local meridian',
      SupportedRegion.japan: '経度基準の真太陽時誤差を精密補正中',
      SupportedRegion.europe: 'Calibration du temps solaire vrai selon le méridien',
    },
    'hud_log_2': {
      SupportedRegion.korea: '고대 천문 원전 및 행성 궤도 알고리즘 정밀 대조',
      SupportedRegion.unitedStates: 'Cross-referencing ancient ephemeris and orbital data',
      SupportedRegion.japan: '古代天文原典および惑星軌道データと照合中',
      SupportedRegion.europe: 'Vérification des éphémérides et tables planétaires',
    },
    'hud_log_3': {
      SupportedRegion.korea: '주요 천체 각도(Aspect) 120° 트라인 구조 검출',
      SupportedRegion.unitedStates: 'Detecting 120° trine celestial aspect configurations',
      SupportedRegion.japan: '主要天体間の120°トラインアスペクトを検出',
      SupportedRegion.europe: 'Détection de l\'aspect trigone 120° des astres majeurs',
    },
    'hud_log_4': {
      SupportedRegion.korea: '개인 에너지 밀도 5축 매트릭스 렌더링 진행',
      SupportedRegion.unitedStates: 'Rendering personal 5-axis energetic density matrix',
      SupportedRegion.japan: '個人エネルギー密度5軸マトリクスをレンダリング中',
      SupportedRegion.europe: 'Génération de la matrice d\'énergie à 5 axes',
    },
    'hud_log_5': {
      SupportedRegion.korea: '최종 운명 데이터 매트릭스 계산 완료!',
      SupportedRegion.unitedStates: 'Cosmic destiny calculations successfully finalized!',
      SupportedRegion.japan: '最終運命データマトリクスの計算が完了しました！',
      SupportedRegion.europe: 'Calculs célestes finalisés avec succès !',
    },

    // SnackBar notices
    'heart_consumed_snack': {
      SupportedRegion.korea: '✨ 심층 리포트가 열렸습니다 (복채 1개 사용)',
      SupportedRegion.unitedStates: '✨ Deep Report Unlocked (-1 Heart Used)',
      SupportedRegion.japan: '✨ 深層レポートを解禁しました (ハート1個消費)',
      SupportedRegion.europe: '✨ Rapport Débloqué (-1 Cœur Utilisé)',
    },
    'hearts_charged_snack': {
      SupportedRegion.korea: '✨ 하트 {count}개가 충전되었습니다!',
      SupportedRegion.unitedStates: '✨ +{count} Hearts Added to Wallet!',
      SupportedRegion.japan: '✨ ハート{count}個がチャージされました！',
      SupportedRegion.europe: '✨ +{count} Cœurs Ajoutés au Portefeuille !',
    },

    // Golden Pairs & MBTI dynamic titles
    'golden_pair_title': {
      SupportedRegion.korea: '우주가 맺어준 천생연분 (Golden Pair)',
      SupportedRegion.unitedStates: 'Cosmic Golden Pair (Destined Match)',
      SupportedRegion.japan: '宇宙が結んだ天生物 (Golden Pair)',
      SupportedRegion.europe: 'Union Céleste Parfaite (Couple d\'Or)',
    },
    'golden_pair_desc': {
      SupportedRegion.korea: '서로의 약점을 완벽하게 보완하며, 함께 있을 때 가장 나다워지는 최상의 시너지 케미입니다.',
      SupportedRegion.unitedStates: 'Complementing weaknesses seamlessly, bringing out your truest and brightest selves.',
      SupportedRegion.japan: 'お互いの弱点を補い合い、一緒にいる時に最も自分らしく輝ける最高の相性です。',
      SupportedRegion.europe: 'Complémentarité parfaite magnifiant la véritable nature de chacun dans une harmonie totale.',
    },
    'mirror_pair_title': {
      SupportedRegion.korea: '거울을 마주한 듯한 깊은 공감',
      SupportedRegion.unitedStates: 'Deep Mirror-like Intuitive Empathy',
      SupportedRegion.japan: '鏡を前にしたような深い共感',
      SupportedRegion.europe: 'Empathie Intuitive comme un Miroir',
    },
    'mirror_pair_desc': {
      SupportedRegion.korea: '말하지 않아도 서로의 심리와 스트레스 지점을 정확히 꿰뚫어 보는 소울메이트입니다.',
      SupportedRegion.unitedStates: 'Soulmates reading emotional beats without words, understanding core nuances.',
      SupportedRegion.japan: '言葉がなくとも互いの心理やストレスを正確に察知できるソウルメイトです。',
      SupportedRegion.europe: 'Âmes sœurs percevant les émotions sans paroles avec une justesse limpide.',
    },

    // Fortune Detail Screen Texts
    'detail_destiny_report': {
      SupportedRegion.korea: '심층 운명 분석 리포트',
      SupportedRegion.unitedStates: 'Deep Cosmic Destiny Reading',
      SupportedRegion.japan: '深層運命分析レポート',
      SupportedRegion.europe: 'Rapport Approfondi du Destin Céleste',
    },
    'detail_nature_flow': {
      SupportedRegion.korea: '타고난 천명과 현재 운의 흐름',
      SupportedRegion.unitedStates: 'Innate Calling & Current Life Energies',
      SupportedRegion.japan: '生まれ持った天命と現在の運気',
      SupportedRegion.europe: 'Vocation Innée & Courants de Vie Actuels',
    },
    'detail_nature_flow_desc': {
      SupportedRegion.korea: '당신의 일주는 깊은 지하수를 뚫고 솟아오르는 강력한 용출수의 기운을 품고 있습니다. 정체된 상황을 돌파하는 직관력과 기획력이 뛰어나며, 타인에게 의존하기보다 스스로 길을 개척할 때 가장 큰 성공운이 따릅니다.',
      SupportedRegion.unitedStates: 'Your astrological core radiates resilient spring waters bursting through deep earth. Blessed with breakthrough insight, your highest success blooms when trailblazing independent paths.',
      SupportedRegion.japan: 'あなたの命式は、大地の底から湧き出る力強い湧水のエネルギーを秘めています。直感力と先見性に恵まれ、自ら道を切り拓くことで最も大きな成功運を引き寄せます。',
      SupportedRegion.europe: 'Votre empreinte astrale abrite l\'élan vif des sources jaillissantes. Doué d\'une intuition pénétrante, votre plein accomplissement s\'épanouit lorsque vous tracez votre propre voie.',
    },
    'detail_remedy_title': {
      SupportedRegion.korea: '황금빛 개운 처방: 서쪽 방향의 업무 공간에서 골드/화이트 계열의 소품을 가까이 두세요.',
      SupportedRegion.unitedStates: 'Cosmic Fortune Remedy: Place gold or crisp white accents in your westward workspace.',
      SupportedRegion.japan: '開運の秘訣: 西向きのワークスペースにゴールド・ホワイト系のアイテムを配置しましょう。',
      SupportedRegion.europe: 'Remède de Bonne Étoile: Disposez des touches or ou blanches dans votre espace de travail orienté à l\'Ouest.',
    },
    'detail_reference_label': {
      SupportedRegion.korea: '원전 레퍼런스: 적천수(滴天髓) 원리 및 {aspect}',
      SupportedRegion.unitedStates: 'Ephemeris Source: Classical Principles & {aspect}',
      SupportedRegion.japan: '原典リファレンス: 滴天髄の理および{aspect}',
      SupportedRegion.europe: 'Source Éphéméride: Principes Classiques et {aspect}',
    },
    'detail_time_offset': {
      SupportedRegion.korea: '동경 135° 기준 -32분 보정',
      SupportedRegion.unitedStates: '135°E Meridian -32m Offset',
      SupportedRegion.japan: '東経135°基準 -32分補正',
      SupportedRegion.europe: 'Méridien 135°E Correction -32m',
    },
    'detail_coords_title': {
      SupportedRegion.korea: '정밀 천문 좌표',
      SupportedRegion.unitedStates: 'Precise Celestial Coordinates',
      SupportedRegion.japan: '精密天文座標',
      SupportedRegion.europe: 'Coordonnées Célestes Précises',
    },
    'detail_offset_title': {
      SupportedRegion.korea: '표준시 오차',
      SupportedRegion.unitedStates: 'Standard Time Offset',
      SupportedRegion.japan: '標準時誤差',
      SupportedRegion.europe: 'Décalage Temps Standard',
    },

    // Tarot Phases
    'tarot_phase_past': {
      SupportedRegion.korea: '과거의 근원 (Past)',
      SupportedRegion.unitedStates: 'Root Origin (Past)',
      SupportedRegion.japan: '過去の根源 (Past)',
      SupportedRegion.europe: 'Origines & Passé (Past)',
    },
    'tarot_phase_present': {
      SupportedRegion.korea: '현재의 운명 (Present)',
      SupportedRegion.unitedStates: 'Present Destiny (Present)',
      SupportedRegion.japan: '現在の運命 (Present)',
      SupportedRegion.europe: 'Destin Actuel (Present)',
    },
    'tarot_phase_future': {
      SupportedRegion.korea: '미래의 결실 (Future)',
      SupportedRegion.unitedStates: 'Future Harvest (Future)',
      SupportedRegion.japan: '未来の結実 (Future)',
      SupportedRegion.europe: 'Fruits du Futur (Future)',
    },
    'tarot_reading_title': {
      SupportedRegion.korea: '3-Card 타로 심층 리딩 (과거 · 현재 · 미래)',
      SupportedRegion.unitedStates: '3-Card Tarot Deep Reading (Past · Present · Future)',
      SupportedRegion.japan: '3枚タロット深層リーディング (過去・現在・未来)',
      SupportedRegion.europe: 'Tirage Tarot 3-Cartes (Passé · Présent · Futur)',
    },

    // Match Dropdown & Pair Labels
    'my_pillar_label': {
      SupportedRegion.korea: '나의 일주(日柱)',
      SupportedRegion.unitedStates: 'My Day Master (Pillar)',
      SupportedRegion.japan: '自分の日柱(日干支)',
      SupportedRegion.europe: 'Mon Pilier du Jour',
    },
    'partner_pillar_label': {
      SupportedRegion.korea: '상대방 일주(日柱)',
      SupportedRegion.unitedStates: 'Partner Day Master',
      SupportedRegion.japan: '相手の日柱(日干支)',
      SupportedRegion.europe: 'Pilier du Partenaire',
    },
    'my_element_label': {
      SupportedRegion.korea: '나의 원소 / 기질',
      SupportedRegion.unitedStates: 'My Element / Temperament',
      SupportedRegion.japan: '自分のエレメント / 気質',
      SupportedRegion.europe: 'Mon Élément Astral',
    },
    'partner_element_label': {
      SupportedRegion.korea: '상대방 원소 / 기질',
      SupportedRegion.unitedStates: 'Partner Element / Temperament',
      SupportedRegion.japan: '相手のエレメント / 気質',
      SupportedRegion.europe: 'Élément du Partenaire',
    },
    'match_complementary_title': {
      SupportedRegion.korea: '상호 보완적인 호기심의 관계',
      SupportedRegion.unitedStates: 'Complementary Dynamics & Curiosity',
      SupportedRegion.japan: '相互補完と好奇心のシナジー',
      SupportedRegion.europe: 'Synergie Complémentaire & Curiosité',
    },
    'match_complementary_desc': {
      SupportedRegion.korea: '서로 다른 시각에서 배울 점이 많으며 자극과 성장을 함께 추구하는 조합입니다.',
      SupportedRegion.unitedStates: 'Abundant growth and mutual learning drawn from unique vantage points.',
      SupportedRegion.japan: '異なる視点から刺激を受け合い、共に成長していける前向きな相性です。',
      SupportedRegion.europe: 'Une émulation mutuelle enrichissante qui favorise l\'évolution conjointe.',
    },
    'match_harmonious_title': {
      SupportedRegion.korea: '편안함과 안정감이 가득한 안식처',
      SupportedRegion.unitedStates: 'Comfortable Haven & Enduring Harmony',
      SupportedRegion.japan: '心地よさと安心感に満ちた安らぎ',
      SupportedRegion.europe: 'Havre de Sérénité & Accord Parfait',
    },
    'match_harmonious_desc': {
      SupportedRegion.korea: '가치관과 생활 방식의 일치도가 높아 갈등 없이 오랫동안 평온함을 공유할 수 있습니다.',
      SupportedRegion.unitedStates: 'Shared values and rhythms ensuring lasting peace with effortless resonance.',
      SupportedRegion.japan: '価値観と生活様式の一致度が高く、穏やかに長い絆を育めます。',
      SupportedRegion.europe: 'Une grande concordance des valeurs permettant une harmonie douce et durable.',
    },
    'match_spark_title': {
      SupportedRegion.korea: '강렬한 호기심과 긴장감의 스파크',
      SupportedRegion.unitedStates: 'Magnetic Sparks & Intense Fascination',
      SupportedRegion.japan: '強烈な好奇心と緊張感のスパーク',
      SupportedRegion.europe: 'Étincelle Magnétique & Passion Vive',
    },
    'match_spark_desc': {
      SupportedRegion.korea: '서로 완전히 다른 별에서 온 듯한 신선한 매력에 이끌리며, 배려를 통해 가장 큰 성장을 이룹니다.',
      SupportedRegion.unitedStates: 'Deeply attracted to each other\'s contrasting charms; conscious empathy yields great growth.',
      SupportedRegion.japan: '異なる星から来たような新鮮な魅力に惹かれ合い、思いやりを通じて大きく成長できます。',
      SupportedRegion.europe: 'Une attirance vive née de contrastes fascinants ouvrant un formidable champ d\'évolution.',
    },

    // Additional Match Picker & System Localization
    'my_animal_label': {
      SupportedRegion.korea: '나의 띠 (12간지)',
      SupportedRegion.unitedStates: 'My Zodiac Animal',
      SupportedRegion.japan: '自分の生まれ年(干支)',
      SupportedRegion.europe: 'Mon Animal Zodiacal',
    },
    'partner_animal_label': {
      SupportedRegion.korea: '상대방 띠 (12간지)',
      SupportedRegion.unitedStates: 'Partner Zodiac Animal',
      SupportedRegion.japan: '相手の生まれ年(干支)',
      SupportedRegion.europe: 'Animal du Partenaire',
    },
    'my_blood_label': {
      SupportedRegion.korea: '나의 혈액형',
      SupportedRegion.unitedStates: 'My Blood Type',
      SupportedRegion.japan: '自分の血液型',
      SupportedRegion.europe: 'Mon Groupe Sanguin',
    },
    'partner_blood_label': {
      SupportedRegion.korea: '상대방 혈액형',
      SupportedRegion.unitedStates: 'Partner Blood Type',
      SupportedRegion.japan: '相手の血液型',
      SupportedRegion.europe: 'Groupe du Partenaire',
    },
    'my_lifepath_label': {
      SupportedRegion.korea: '나의 운명수 (Life Path)',
      SupportedRegion.unitedStates: 'My Life Path Number',
      SupportedRegion.japan: '自分の運命数',
      SupportedRegion.europe: 'Mon Chemin de Vie',
    },
    'partner_lifepath_label': {
      SupportedRegion.korea: '상대방 운명수 (Life Path)',
      SupportedRegion.unitedStates: 'Partner Life Path',
      SupportedRegion.japan: '相手の運命数',
      SupportedRegion.europe: 'Chemin du Partenaire',
    },
    'my_hybrid_label': {
      SupportedRegion.korea: '나의 혈액형 x 별자리',
      SupportedRegion.unitedStates: 'My Blood x Zodiac',
      SupportedRegion.japan: '自分の血液型×星座',
      SupportedRegion.europe: 'Mon Profil Sang x Zodiaque',
    },
    'partner_hybrid_label': {
      SupportedRegion.korea: '상대방 혈액형 x 별자리',
      SupportedRegion.unitedStates: 'Partner Blood x Zodiac',
      SupportedRegion.japan: '相手の血液型×星座',
      SupportedRegion.europe: 'Profil du Partenaire',
    },
    'my_rokusei_label': {
      SupportedRegion.korea: '나의 운명성 (六星)',
      SupportedRegion.unitedStates: 'My Rokusei Star',
      SupportedRegion.japan: '自分の運命星 (六星)',
      SupportedRegion.europe: 'Mon Étoile Rokusei',
    },
    'partner_rokusei_label': {
      SupportedRegion.korea: '상대방 운명성 (六星)',
      SupportedRegion.unitedStates: 'Partner Rokusei Star',
      SupportedRegion.japan: '相手の運命星 (六星)',
      SupportedRegion.europe: 'Étoile du Partenaire',
    },
    'my_house_label': {
      SupportedRegion.korea: '나의 시나스트리 하우스',
      SupportedRegion.unitedStates: 'My Synastry House',
      SupportedRegion.japan: '自分のシナストリーハウス',
      SupportedRegion.europe: 'Ma Maison Céleste',
    },
    'partner_house_label': {
      SupportedRegion.korea: '상대방 하우스 포지션',
      SupportedRegion.unitedStates: 'Partner House Position',
      SupportedRegion.japan: '相手のハウス位置',
      SupportedRegion.europe: 'Maison du Partenaire',
    },
    'my_rune_label': {
      SupportedRegion.korea: '나의 수호 룬스톤',
      SupportedRegion.unitedStates: 'My Guardian Rune',
      SupportedRegion.japan: '自分の守護ルーン',
      SupportedRegion.europe: 'Ma Rune Tutélaire',
    },
    'partner_rune_label': {
      SupportedRegion.korea: '상대방 수호 룬스톤',
      SupportedRegion.unitedStates: 'Partner Guardian Rune',
      SupportedRegion.japan: '相手の守護ルーン',
      SupportedRegion.europe: 'Rune du Partenaire',
    },

    // Cultural Match Specific Headlines and Descriptions
    'match_saju_stem_harmony_title': {
      SupportedRegion.korea: '천간합(天干合)과 지지화합의 천생연분',
      SupportedRegion.unitedStates: 'Celestial Stem Union (Destined Harmony)',
      SupportedRegion.japan: '天干合・地支和合の天生物',
      SupportedRegion.europe: 'Harmonie Suprême des Troncs Célestes',
    },
    'match_saju_stem_harmony_desc': {
      SupportedRegion.korea: '두 사람의 천간이 강력하게 결합하여 음양의 균형을 완성하고 오행의 기운이 막힘없이 순환하는 최상급 사주 궁합입니다.',
      SupportedRegion.unitedStates: 'Stems interlock to achieve absolute Yin-Yang balance, unlocking ceaseless flow of cosmic vitality.',
      SupportedRegion.japan: '2人の天干が強く結びつき陰陽の調和を完成させ、五行の循環が淀みなく巡る最高の命式相性です。',
      SupportedRegion.europe: 'L\'union profonde des troncs célestes parachève l\'équilibre du Yin et du Yang dans une fluidité absolue.',
    },
    'match_animal_samhap_title': {
      SupportedRegion.korea: '12간지 삼합(三合) 대길(大吉)의 인연',
      SupportedRegion.unitedStates: 'Sacred Triad (Samhap) Supreme Match',
      SupportedRegion.japan: '十二支 三合大吉の素晴らしいご縁',
      SupportedRegion.europe: 'Trilogie Céleste (Samhap) Faste Absolu',
    },
    'match_animal_samhap_desc': {
      SupportedRegion.korea: '네 살 터울을 뜻하는 전설적인 삼합 조합으로, 마주하기만 해도 서로에게 행운과 사업·재물운을 불러일으킵니다.',
      SupportedRegion.unitedStates: 'Legendary 4-year harmonic cycle naturally multiplying prosperity, happiness, and deep fortune together.',
      SupportedRegion.japan: '4歳差に代表される伝説の三合。共にいるだけで幸運と発展を引き寄せ合える最高の組み合わせです。',
      SupportedRegion.europe: 'Harmonie légendaire de la triade multipliant naturellement la prospérité, la chance et l\'élan vital.',
    },
    'match_animal_yukhap_title': {
      SupportedRegion.korea: '마음이 통하는 육합(六合)의 조화',
      SupportedRegion.unitedStates: 'Intimate Yukhap Soul Resonance',
      SupportedRegion.japan: '心が通じ合う六合の絆',
      SupportedRegion.europe: 'Résonance Émotionnelle Yukhap',
    },
    'match_animal_yukhap_desc': {
      SupportedRegion.korea: '서로를 아끼고 지지하는 기운이 넘쳐 다툼이 적고 시간이 지날수록 정이 깊어지는 안정적인 궁합입니다.',
      SupportedRegion.unitedStates: 'Enduring affection and deep support shielding against disputes while deepening bonds over time.',
      SupportedRegion.japan: '互いを慈しみ支え合う気に満ち、時が経つほどに情愛が深まる安定のご縁です。',
      SupportedRegion.europe: 'Affection protectrice et soutien inconditionnel scellant une complicité croissante avec le temps.',
    },
    'match_animal_same_title': {
      SupportedRegion.korea: '동질감과 편안함이 공존하는 동갑내기 케미',
      SupportedRegion.unitedStates: 'Kindred Spirit Companionship',
      SupportedRegion.japan: '同質性と心地よさの同い年ケミ',
      SupportedRegion.europe: 'Complicité Naturelle d\'Âmes Sœurs',
    },
    'match_animal_same_desc': {
      SupportedRegion.korea: '같은 띠로서 공통의 관심사와 라이프스타일을 자연스럽게 공유하며 친구처럼 즐거운 사랑을 키워갑니다.',
      SupportedRegion.unitedStates: 'Sharing identical rhythms, building joyful love with effortless friendship and mutual understanding.',
      SupportedRegion.japan: '同じ干支として共通の関心やテンポを共有し、親友のような楽しい愛を育みます。',
      SupportedRegion.europe: 'Partage spontané des mêmes rythmes construisant un amour chaleureux et complice.',
    },
    'match_animal_general_title': {
      SupportedRegion.korea: '서로의 개성을 존중하는 지혜로운 관계',
      SupportedRegion.unitedStates: 'Respectful Companionship & Unique Synergy',
      SupportedRegion.japan: '個性を尊重し合う聡明な関係',
      SupportedRegion.europe: 'Respect Mutuel & Singularité Partagée',
    },
    'match_animal_general_desc': {
      SupportedRegion.korea: '성격의 차이를 이해하고 배려할 때 각자의 장점이 더욱 빛을 발하며 단단한 파트너십을 완성합니다.',
      SupportedRegion.unitedStates: 'Mutual respect for differences illuminates individual strengths, cementing enduring partnerships.',
      SupportedRegion.japan: '違いを認め思いやることで互いの長所が輝き、強いパートナーシップを築けます。',
      SupportedRegion.europe: 'La reconnaissance attentive des différences magnifie les qualités de chacun dans un partenariat solide.',
    },
    'match_blood_ao_title': {
      SupportedRegion.korea: 'A형 x O형: 든든함과 세심함의 황금 밸런스',
      SupportedRegion.unitedStates: 'Type A x O: Golden Emotional Balance',
      SupportedRegion.japan: 'A型×O型: 頼もしさと細やかさの黄金バランス',
      SupportedRegion.europe: 'Groupe A x O: Harmonie Dorée des Cœurs',
    },
    'match_blood_ao_desc': {
      SupportedRegion.korea: 'O형의 대범하고 따뜻한 리더십과 A형의 섬세하고 진실한 배려가 어우러져 가장 이상적인 안도감을 주는 콤비입니다.',
      SupportedRegion.unitedStates: 'O\'s generous warmth combined with A\'s mindful devotion creates the most comforting, reassuring haven.',
      SupportedRegion.japan: 'O型の大らかで温かい包容力とA型の細やかな誠実さが調和し、最も安心感に満ちた理想の関係です。',
      SupportedRegion.europe: 'La générosité chaleureuse du groupe O alliée à la délicate sincérité du groupe A offre un havre de paix.',
    },
    'match_blood_bo_title': {
      SupportedRegion.korea: 'B형 x O형: 활력과 자유로움의 즐거운 동행',
      SupportedRegion.unitedStates: 'Type B x O: Joyful Energy & Freedom',
      SupportedRegion.japan: 'B型×O型: 活気と自由の楽しい道連れ',
      SupportedRegion.europe: 'Groupe B x O: Énergie Joyeuse & Liberté',
    },
    'match_blood_bo_desc': {
      SupportedRegion.korea: 'B형의 유쾌한 매력과 창의성을 O형이 넉넉한 마음으로 받아주어 언제나 웃음과 도파민이 넘치는 케미입니다.',
      SupportedRegion.unitedStates: 'O enthusiastically embraces B\'s creative spark, sparking continuous laughter and energetic joy.',
      SupportedRegion.japan: 'B型の魅力的な個性と発想力をO型が温かく包み込み、常に笑顔と楽しさが満ち溢れます。',
      SupportedRegion.europe: 'Le groupe O accueille avec ferveur l\'étincelle créative du groupe B dans un tourbillon d\'allégresse.',
    },
    'match_blood_abb_title': {
      SupportedRegion.korea: 'AB형 x B형: 지적 호기심과 쿨한 시너지',
      SupportedRegion.unitedStates: 'Type AB x B: Intellectual Spark & Chemistry',
      SupportedRegion.japan: 'AB型×B型: 知的好奇心と心地よい距離感',
      SupportedRegion.europe: 'Groupe AB x B: Curiosité Intellectuelle & Alchimie',
    },
    'match_blood_abb_desc': {
      SupportedRegion.korea: '서로의 독창적인 세계를 누구보다 잘 이해하며 구속하지 않는 자유로운 소통 속에서 끈끈함을 유지합니다.',
      SupportedRegion.unitedStates: 'Mutual respect for originality fosters an unshakable bond through refreshing, unconstrained dialogue.',
      SupportedRegion.japan: '互いの独自の世界を深く理解し合い、干渉しすぎない心地よい距離感で強い絆を保ちます。',
      SupportedRegion.europe: 'Une admiration complice pour l\'originalité de chacun garantit un lien vibrant empreint de liberté.',
    },
    'match_blood_same_title': {
      SupportedRegion.korea: '같은 혈액형: 말하지 않아도 통하는 일심동체',
      SupportedRegion.unitedStates: 'Identical Blood Type: Unspoken Resonance',
      SupportedRegion.japan: '同血液型: 言葉がなくとも通じ合える以心伝心',
      SupportedRegion.europe: 'Même Groupe: Télépathie du Cœur',
    },
    'match_blood_same_desc': {
      SupportedRegion.korea: '기분 변화와 감정의 결이 비슷하여 불필요한 오해 없이 편안하고 자연스러운 유대감을 형성합니다.',
      SupportedRegion.unitedStates: 'Harmonized emotional rhythms create effortless bonds free from misunderstanding.',
      SupportedRegion.japan: '感情の波やテンポが似ているため、誤解なく自然体でいられる心強い関係です。',
      SupportedRegion.europe: 'Les oscillations émotionnelles synchronisées tissent un attachement limpide et naturel.',
    },
    'match_blood_ab_title': {
      SupportedRegion.korea: 'A형 x B형: 반대 매력에 끌리는 긴장감',
      SupportedRegion.unitedStates: 'Type A x B: Intriguing Contrast & Attraction',
      SupportedRegion.japan: 'A型×B型: 正反対の魅力に惹かれ合うスパーク',
      SupportedRegion.europe: 'Groupe A x B: Attraction des Opposés',
    },
    'match_blood_ab_desc': {
      SupportedRegion.korea: '완전히 다른 성향이 신선한 자극이 되며, 대화를 통해 서로의 차이를 인정할 때 특별한 사랑으로 완성됩니다.',
      SupportedRegion.unitedStates: 'Opposite traits bring continuous fresh excitement, blossoming into deeply rewarding growth.',
      SupportedRegion.japan: '正反対の性質が新鮮な刺激をもたらし、歩み寄ることで唯一無二の深い愛へと昇華します。',
      SupportedRegion.europe: 'Des traits opposés suscitent un intérêt perpétuel s\'épanouissant dans une découverte enrichissante.',
    },
    'match_blood_balance_title': {
      SupportedRegion.korea: '감성과 조화의 섬세한 밸런스',
      SupportedRegion.unitedStates: 'Delicate Balance of Empathy & Harmony',
      SupportedRegion.japan: '感性と調和の繊細なバランス',
      SupportedRegion.europe: 'Équilibre Subtil d\'Empathie & d\'Accord',
    },
    'match_blood_balance_desc': {
      SupportedRegion.korea: '혈액형 고유의 기질이 균형을 이루며 상대의 기분을 세심하게 살피는 따뜻한 소통이 강점입니다.',
      SupportedRegion.unitedStates: 'Balancing innate temperaments with warm, thoughtful communication and caring presence.',
      SupportedRegion.japan: 'それぞれの気質が調和を保ち、相手の気持ちに寄り添う温かなコミュニケーションが魅力です。',
      SupportedRegion.europe: 'Les tempéraments s\'accordent en douceur grâce à une écoute bienveillante et attentionnée.',
    },
    'match_elem_fire_air_title': {
      SupportedRegion.korea: '불과 바람: 꺼지지 않는 열정과 영감의 확산',
      SupportedRegion.unitedStates: 'Fire & Air: Radiant Inspiration & Passion',
      SupportedRegion.japan: '火と風: 燃え盛る情熱とひらめきの拡大',
      SupportedRegion.europe: 'Feu & Vent: Passion Inépuisable & Inspiration',
    },
    'match_elem_fire_air_desc': {
      SupportedRegion.korea: '바람이 불을 더욱 타오르게 하듯, 서로의 아이디어와 추진력이 만나 최고의 도파민과 시너지를 창출합니다.',
      SupportedRegion.unitedStates: 'Just as wind stokes flame, your combined visions ignite unmatched dopamine and creative mastery.',
      SupportedRegion.japan: '風が火を煽るように、2人のアイデアと行動力が重なり最高の情熱とシナジーを生み出します。',
      SupportedRegion.europe: 'Comme le vent attise le feu, vos intuitions conjuguées créent une dynamique créatrice extraordinaire.',
    },
    'match_elem_earth_water_title': {
      SupportedRegion.korea: '흙과 물: 비옥한 결실과 깊은 정서적 안식처',
      SupportedRegion.unitedStates: 'Earth & Water: Fertile Growth & Deep Haven',
      SupportedRegion.japan: '土と水: 豊かな実りと深い情緒の安らぎ',
      SupportedRegion.europe: 'Terre & Eau: Fécondité & Sérénité Émotionnelle',
    },
    'match_elem_earth_water_desc': {
      SupportedRegion.korea: '흙이 물을 품고 물이 흙을 윤택하게 하듯, 서로의 현실적 안정감과 깊은 공감이 어우러진 완벽한 둥지입니다.',
      SupportedRegion.unitedStates: 'Earth grounds water while water nourishes soil; creating a flourishing sanctuary of stability and devotion.',
      SupportedRegion.japan: '大地が水を蓄え水が大地を潤すように、現実的な安定と深い情緒が融合した最高の安らぎです。',
      SupportedRegion.europe: 'La terre accueille l\'eau et l\'eau nourrit la terre, érigeant un sanctuaire d\'harmonie indéfectible.',
    },
    'match_elem_same_title': {
      SupportedRegion.korea: '동일 원소의 강력한 공명과 안정감',
      SupportedRegion.unitedStates: 'Elemental Kinship & Powerful Resonance',
      SupportedRegion.japan: '同質エレメントの強力な共鳴と安心感',
      SupportedRegion.europe: 'Résonance Élémentaire & Solidité',
    },
    'match_elem_same_desc': {
      SupportedRegion.korea: '같은 원소 에너지를 공유하여 행동 방식과 감정 표현의 결이 완벽하게 일치하는 안락한 조합입니다.',
      SupportedRegion.unitedStates: 'Sharing identical elemental energies ensures seamless harmony in action, values, and expression.',
      SupportedRegion.japan: '同じエレメントの波長を持つため、価値観や表現のテンポが完璧に一致する心地よい関係です。',
      SupportedRegion.europe: 'Partageant la même matrice élémentaire, vos manières d\'agir et d\'aimer s\'harmonisent sans effort.',
    },
    'match_numerology_title': {
      SupportedRegion.korea: '수비학 운명수(Life Path)의 영적 조화',
      SupportedRegion.unitedStates: 'Numerology Life Path Spiritual Harmonic',
      SupportedRegion.japan: '数秘術 運命数のスピリチュアルな調和',
      SupportedRegion.europe: 'Harmonie Spirituelle des Chemins de Vie',
    },
    'match_numerology_desc': {
      SupportedRegion.korea: '두 영혼의 숫자가 결합하여 잠재된 목적 의식을 일깨우고 성장의 여정을 함께 이끄는 운명적 파트너입니다.',
      SupportedRegion.unitedStates: 'Combined sacred vibrations awaken dormant soul purposes, guiding each other along fateful paths.',
      SupportedRegion.japan: '魂の数字が重なり合い、潜在する使命を呼び覚まして共に人生を高め合う運命の絆です。',
      SupportedRegion.europe: 'Les vibrations sacrées conjuguées éveillent le dessein de l\'âme pour guider le destin commun.',
    },
    'match_hybrid_title': {
      SupportedRegion.korea: '혈액형 x 별자리: 다차원 성향의 완벽한 융합',
      SupportedRegion.unitedStates: 'Blood x Zodiac Multi-Dimensional Fusion',
      SupportedRegion.japan: '血液型×星座: 多次元性格の美しい融合',
      SupportedRegion.europe: 'Fusion Multidimensionnelle Sang x Zodiaque',
    },
    'match_hybrid_desc': {
      SupportedRegion.korea: '별자리의 타고난 기질과 혈액형의 사회적 반응이 조화를 이루어 서로의 미세한 심리를 따스하게 보듬습니다.',
      SupportedRegion.unitedStates: 'Zodiac core traits seamlessly blend with blood-type chemistry to tenderly nurture subtle nuances.',
      SupportedRegion.japan: '星座の星回りと血液型の行動様式が調和し、相手の繊細な心情を温かく包み込みます。',
      SupportedRegion.europe: 'Les essences astrales et sanguines fusionnent pour envelopper tendrement chaque nuance intime.',
    },
    'match_rokusei_title': {
      SupportedRegion.korea: '육성점술(六星占術) 운명성의 상생 케미',
      SupportedRegion.unitedStates: 'Rokusei Destiny Star Mutual Prosperity',
      SupportedRegion.japan: '六星占術 運命星の相生と隆盛のご縁',
      SupportedRegion.europe: 'Prospérité Mutuelle des Étoiles Rokusei',
    },
    'match_rokusei_desc': {
      SupportedRegion.korea: '운명의 주기와 에너지가 상호 보완되어 시련을 이겨내고 장기적인 번영을 함께 일구어가는 길한 궁합입니다.',
      SupportedRegion.unitedStates: 'Fate cycles complement one another, turning hardships into shared triumphs and lasting elevation.',
      SupportedRegion.japan: '運気のサイクルが互いを補い合い、試練を乗り越えて長期的な繁栄を築ける吉相です。',
      SupportedRegion.europe: 'Les cycles de vie se complètent pour transcender les obstacles vers un épanouissement durable.',
    },
    'match_house_title': {
      SupportedRegion.korea: '시나스트리 천궁도 하우스의 운명적 결합',
      SupportedRegion.unitedStates: 'Synastry House Astrological Alignment',
      SupportedRegion.japan: 'シナストリー出生図ハウスの運命的結合',
      SupportedRegion.europe: 'Alignement Astral des Maisons de Synastrie',
    },
    'match_house_desc': {
      SupportedRegion.korea: '상대방의 천체가 당신의 주요 하우스에 안착하여 인생의 새로운 비전과 안정된 사랑을 꽃피웁니다.',
      SupportedRegion.unitedStates: 'Celestial placements illuminate critical houses, unfurling expansive vision and anchoring love.',
      SupportedRegion.japan: '相手の天体があなたの主要ハウスに光を灯し、新たな人生の視野と揺るぎない愛を咲かせます。',
      SupportedRegion.europe: 'Les luminaires célestes du partenaire illuminent vos maisons-clés, déployant une vision radieuse.',
    },
    'match_celtic_rune_title': {
      SupportedRegion.korea: '고대 켈틱 룬스톤의 신성한 언약',
      SupportedRegion.unitedStates: 'Ancient Celtic Rune Sacred Covenant',
      SupportedRegion.japan: '古代ケルト ルーンストーンの神聖な誓約',
      SupportedRegion.europe: 'Alliance Sacrée des Runes Celtiques',
    },
    'match_celtic_rune_desc': {
      SupportedRegion.korea: '두 개의 룬 문자가 지닌 원초적 자연의 지혜가 결합하여 영혼의 깊은 신뢰와 흔들림 없는 안녕을 지켜줍니다.',
      SupportedRegion.unitedStates: 'Primordial runic wisdom safeguards profound soul trust and unshakable tranquility across time.',
      SupportedRegion.japan: 'ルーン文字に宿る原始の英知が重なり、魂の深い信頼と揺るぎない安らぎを守り抜きます。',
      SupportedRegion.europe: 'La sagesse runique ancestrale veille sur la confiance sacrée des âmes dans une paix inaltérable.',
    },

    // Vault Screen Localizations
    'vault_add_dialog_title': {
      SupportedRegion.korea: '새 인연 프로필 추가',
      SupportedRegion.unitedStates: 'Add New Profile',
      SupportedRegion.japan: '新しいご縁の登録',
      SupportedRegion.europe: 'Ajouter un Profil',
    },
    'vault_name_hint': {
      SupportedRegion.korea: '이름 또는 별칭',
      SupportedRegion.unitedStates: 'Name or Nickname',
      SupportedRegion.japan: 'お名前またはニックネーム',
      SupportedRegion.europe: 'Nom ou Prénom',
    },
    'vault_cancel': {
      SupportedRegion.korea: '취소',
      SupportedRegion.unitedStates: 'Cancel',
      SupportedRegion.japan: 'キャンセル',
      SupportedRegion.europe: 'Annuler',
    },
    'vault_add': {
      SupportedRegion.korea: '추가',
      SupportedRegion.unitedStates: 'Add',
      SupportedRegion.japan: '追加',
      SupportedRegion.europe: 'Ajouter',
    },

    // Story Share Dialog Localizations
    'share_dialog_certified': {
      SupportedRegion.korea: '진태양시 경도 보정 및 다차원 매트릭스 인증',
      SupportedRegion.unitedStates: 'Verified Solar Ephemeris & Multi-Dimensional Matrix',
      SupportedRegion.japan: '真太陽時経度補正＆多次元マトリクス公式認証',
      SupportedRegion.europe: 'Certifié Temps Solaire Vrai & Matrice Multidimensionnelle',
    },
    'share_dialog_story_btn': {
      SupportedRegion.korea: '스토리 공유하기',
      SupportedRegion.unitedStates: 'Share to Story',
      SupportedRegion.japan: 'ストーリーに共有',
      SupportedRegion.europe: 'Partager la Story',
    },
  };
}




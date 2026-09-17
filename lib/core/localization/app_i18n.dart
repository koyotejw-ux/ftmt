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
  };
}

import '../../../core/localization/geo_detector.dart';
import 'tarot_deck.dart';

class TarotReadingResult {
  final String flowTitle;
  final String flowNarrative;
  final String loveAndRelationshipAdvice;
  final String careerAndFinanceAdvice;
  final String coreActionTip;

  const TarotReadingResult({
    required this.flowTitle,
    required this.flowNarrative,
    required this.loveAndRelationshipAdvice,
    required this.careerAndFinanceAdvice,
    required this.coreActionTip,
  });
}

class TarotReadingEngine {
  /// 과거, 현재, 미래 3장의 카드를 종합 분석하여 심층 운세 풀이를 생성
  static TarotReadingResult analyzeThreeCards(
    List<TarotCard> cards, {
    SupportedRegion region = SupportedRegion.korea,
  }) {
    if (cards.isEmpty) {
      return TarotReadingResult(
        flowTitle: region == SupportedRegion.korea
            ? '운명의 카드가 선택되지 않았습니다'
            : 'No Destiny Cards Selected',
        flowNarrative: region == SupportedRegion.korea
            ? '신비의 타로 덱에서 3장의 카드를 선택해 주세요.'
            : 'Please pick 3 cards from the sacred Tarot deck.',
        loveAndRelationshipAdvice: '',
        careerAndFinanceAdvice: '',
        coreActionTip: '',
      );
    }

    final past = cards[0];
    final present = cards.length > 1 ? cards[1] : cards[0];
    final future = cards.length > 2 ? cards[2] : cards[0];

    final pastName = past.localizedName(region);
    final presentName = present.localizedName(region);
    final futureName = future.localizedName(region);

    // 흐름 테마 도출
    final isTransformative = future.id == 10 || future.id == 21 || future.id == 19;
    final isInitiative = past.id == 0 || past.id == 1 || present.id == 1 || present.id == 7;

    String flowTitle;
    if (isTransformative) {
      flowTitle = region == SupportedRegion.korea
          ? '🌟 커다란 운명의 도약과 완성의 서막'
          : '🌟 Great Leap of Destiny & Dawn of Realization';
    } else if (isInitiative) {
      flowTitle = region == SupportedRegion.korea
          ? '⚡ 주도적 결단이 미래의 결실을 여는 형국'
          : '⚡ Sovereign Decisions Opening Future Fruits';
    } else {
      flowTitle = region == SupportedRegion.korea
          ? '🌿 깊은 내면의 성찰을 거쳐 밝아오는 행운'
          : '🌿 Awakening Fortune through Inner Clarity';
    }

    // 시간의 흐름에 따른 종합 내러티브 생성
    final String narrative;
    if (region == SupportedRegion.korea) {
      narrative =
          '과거에 머물렀던 [$pastName]의 기운은 당신에게 "${past.uprightMeaning}"의 토대를 놓아주었습니다. '
          '현재 당신은 [$presentName]의 국면에 서 있으며, 이는 "${present.uprightMeaning}"의 역동적인 순간임을 암시합니다. '
          '다가올 미래는 [$futureName]의 빛으로 향하고 있어, 마침내 "${future.uprightMeaning}"라는 결실과 보상이 준비되고 있습니다. '
          '현재의 혼란이나 정체감은 더 큰 비상을 위한 도움닫기이며, 과거의 경험들이 헛되지 않고 미래의 강력한 나침반이 될 것입니다.';
    } else {
      narrative =
          'The energy of [$pastName] laid the foundation of "${past.localizedUprightMeaning(region)}". '
          'Currently standing under [$presentName], you are navigating "${present.localizedUprightMeaning(region)}". '
          'The horizon ahead leads to [$futureName], heralding "${future.localizedUprightMeaning(region)}". '
          'Trust the sequence of divine timing; what you have anchored in the past is transforming into your greatest asset.';
    }

    // 연애/인간관계 조언
    final String loveAdvice;
    if (region == SupportedRegion.korea) {
      if (present.id == 6 || future.id == 6 || past.id == 6) {
        loveAdvice = '영혼의 주파수가 통하는 깊은 교감이 찾아옵니다. 자존심을 내려놓고 진솔한 감정을 전할 때 강력한 인연의 끈이 맺어집니다.';
      } else if (future.id == 19 || future.id == 3) {
        loveAdvice = '따뜻하고 밝은 기운이 가득합니다. 상대방에게 당신의 매력이 가장 매혹적으로 전달되는 시기이니 자신감을 가지세요.';
      } else {
        loveAdvice = '과거의 서운함이나 집착을 흘려보내세요. 상대방의 내면을 있는 그대로 존중할 때 오해가 풀리고 새로운 신뢰가 싹틉니다.';
      }
    } else {
      if (present.id == 6 || future.id == 6 || past.id == 6) {
        loveAdvice = 'A profound harmonic resonance is opening. Express your heartfelt feelings with vulnerability to solidify an eternal soul bond.';
      } else if (future.id == 19 || future.id == 3) {
        loveAdvice = 'Warmth, charisma and magnetic joy radiate through you. Step into your natural glow and attract genuine companionship.';
      } else {
        loveAdvice = 'Release lingering misunderstandings from the past. Honoring each other\'s inner truth allows enduring trust to flourish naturally.';
      }
    }

    // 커리어/재물 조언
    final String careerAdvice;
    if (region == SupportedRegion.korea) {
      if (future.id == 21 || future.id == 1 || future.id == 4 || future.id == 7) {
        careerAdvice = '계획했던 일이나 프로젝트에서 결정적인 돌파구가 열립니다. 망설이지 말고 주도권을 잡고 밀어붙일 때 큰 성과를 거둡니다.';
      } else if (future.id == 10) {
        careerAdvice = '뜻밖의 제안이나 시장 환경의 변화가 찾아옵니다. 유연하게 흐름을 타고 기회를 잡으면 기대 이상의 재물운이 따릅니다.';
      } else {
        careerAdvice = '단기적 이익보다는 시스템과 신뢰 기반을 튼튼히 할 때입니다. 디테일을 점검하고 내실을 다지면 흔들리지 않는 기반이 구축됩니다.';
      }
    } else {
      if (future.id == 21 || future.id == 1 || future.id == 4 || future.id == 7) {
        careerAdvice = 'A decisive breakthrough is crystallizing in your ventures. Take bold ownership and steer ahead with strategic mastery.';
      } else if (future.id == 10) {
        careerAdvice = 'A dynamic shift in opportunities is unfolding. Remain agile and ride the wave to capture unexpected prosperity.';
      } else {
        careerAdvice = 'Fortify your foundations and systems rather than chasing fleeting gains. Thorough diligence will yield an unshakeable empire.';
      }
    }

    // 핵심 행동 수칙 (Action Tip)
    final String tip;
    if (region == SupportedRegion.korea) {
      tip = '우주의 조언: 과거의 후회에 얽매이지 말고, [$presentName]의 에너지를 살려 오늘 할 수 있는 가장 명확한 한 가지 행동에 집중하세요.';
    } else {
      tip = 'Cosmic Guideline: Anchor yourself in the present power of [$presentName]. Take one unambiguous, purposeful action today.';
    }

    return TarotReadingResult(
      flowTitle: flowTitle,
      flowNarrative: narrative,
      loveAndRelationshipAdvice: loveAdvice,
      careerAndFinanceAdvice: careerAdvice,
      coreActionTip: tip,
    );
  }
}

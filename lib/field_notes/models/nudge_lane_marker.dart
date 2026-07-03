import '../../shared/markings/squad_color_token.dart';

class NudgeLaneMarker {
  const NudgeLaneMarker({
    required this.laneKey,
    required this.menuLabel,
    required this.sendTone,
    required this.audienceHint,
    required this.draftedLine,
    required this.cooldownPhrase,
    required this.buttonCaption,
    required this.laneTint,
  });

  final String laneKey;
  final String menuLabel;
  final String sendTone;
  final String audienceHint;
  final String draftedLine;
  final String cooldownPhrase;
  final String buttonCaption;
  final SquadColorToken laneTint;
}

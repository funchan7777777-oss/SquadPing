import '../../shared/markings/squad_color_token.dart';

class TeammateSignalNote {
  const TeammateSignalNote({
    required this.signalId,
    required this.displayCallsign,
    required this.currentDriftLine,
    required this.responseTempo,
    required this.nearbyAnchor,
    required this.trustRibbon,
    required this.lastReplyAge,
    required this.checkInTrail,
    required this.readinessScore,
    required this.preferredNudge,
    required this.laneTint,
  });

  final String signalId;
  final String displayCallsign;
  final String currentDriftLine;
  final String responseTempo;
  final String nearbyAnchor;
  final String trustRibbon;
  final String lastReplyAge;
  final List<String> checkInTrail;
  final int readinessScore;
  final String preferredNudge;
  final SquadColorToken laneTint;
}

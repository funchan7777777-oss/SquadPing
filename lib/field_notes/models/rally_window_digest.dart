import '../../shared/markings/squad_color_token.dart';

class RallyWindowDigest {
  const RallyWindowDigest({
    required this.rallyShortcode,
    required this.anchoredAround,
    required this.hostCallout,
    required this.timeboxLabel,
    required this.settlementCue,
    required this.headcountTrace,
    required this.decisionPressure,
    required this.commitmentLines,
    required this.laneTint,
  });

  final String rallyShortcode;
  final String anchoredAround;
  final String hostCallout;
  final String timeboxLabel;
  final String settlementCue;
  final String headcountTrace;
  final double decisionPressure;
  final List<String> commitmentLines;
  final SquadColorToken laneTint;
}

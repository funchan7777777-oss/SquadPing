import '../../shared/markings/squad_color_token.dart';

class CrewPulseBrief {
  const CrewPulseBrief({
    required this.pulseCode,
    required this.roomTone,
    required this.openLoopLine,
    required this.replyCadenceLabel,
    required this.readinessPercent,
    required this.lastSignalStamp,
    required this.microAgenda,
    required this.laneTint,
  });

  final String pulseCode;
  final String roomTone;
  final String openLoopLine;
  final String replyCadenceLabel;
  final int readinessPercent;
  final String lastSignalStamp;
  final List<String> microAgenda;
  final SquadColorToken laneTint;
}

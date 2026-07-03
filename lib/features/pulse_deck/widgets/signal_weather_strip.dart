import 'package:flutter/material.dart';

import '../../../app/theme/squad_ping_colors.dart';
import '../../../field_notes/models/crew_pulse_brief.dart';
import '../../../field_notes/models/rally_window_digest.dart';
import '../../../field_notes/models/teammate_signal_note.dart';
import '../../../shared/widgets/squad_metric_pill.dart';

class SignalWeatherStrip extends StatelessWidget {
  const SignalWeatherStrip({
    super.key,
    required this.crewPulses,
    required this.rallyWindows,
    required this.squadSignals,
  });

  final List<CrewPulseBrief> crewPulses;
  final List<RallyWindowDigest> rallyWindows;
  final List<TeammateSignalNote> squadSignals;

  @override
  Widget build(BuildContext context) {
    final readiness = crewPulses.isEmpty
        ? 0
        : crewPulses
                  .map((pulse) => pulse.readinessPercent)
                  .reduce((left, right) => left + right) ~/
              crewPulses.length;
    final lateReplyCount = squadSignals
        .where((signal) => signal.readinessScore < 75)
        .length;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SquadMetricPill(
          pulseGlyph: Icons.speed_rounded,
          metricReading: '$readiness%',
          metricContext: 'group readiness',
          inkColor: SquadPingColors.cedarSignal,
          washColor: SquadPingColors.cedarSignal.withValues(alpha: 0.1),
        ),
        SquadMetricPill(
          pulseGlyph: Icons.schedule_rounded,
          metricReading: '${rallyWindows.length}',
          metricContext: 'open windows',
          inkColor: SquadPingColors.tidepoolSignal,
          washColor: SquadPingColors.tidepoolSignal.withValues(alpha: 0.1),
        ),
        SquadMetricPill(
          pulseGlyph: Icons.notifications_active_rounded,
          metricReading: '$lateReplyCount',
          metricContext: 'need a nudge',
          inkColor: SquadPingColors.emberSignal,
          washColor: SquadPingColors.emberSignal.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}

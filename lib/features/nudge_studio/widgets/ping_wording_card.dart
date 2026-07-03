import 'package:flutter/material.dart';

import '../../../app/theme/squad_ping_colors.dart';
import '../../../field_notes/models/nudge_lane_marker.dart';
import '../../../field_notes/models/teammate_signal_note.dart';
import '../../../shared/widgets/soft_squad_panel.dart';

class PingWordingCard extends StatelessWidget {
  const PingWordingCard({
    super.key,
    required this.nudgeLane,
    required this.spotlightSignal,
  });

  final NudgeLaneMarker nudgeLane;
  final TeammateSignalNote spotlightSignal;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accentInk = SquadPingColors.laneInk(nudgeLane.laneTint);

    return SoftSquadPanel(
      panelTint: SquadPingColors.raisedSurface,
      borderTint: accentInk.withValues(alpha: 0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: accentInk.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.mark_chat_unread_rounded, color: accentInk),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nudgeLane.menuLabel, style: textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      '${nudgeLane.sendTone} · ${nudgeLane.audienceHint}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: SquadPingColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'To ${spotlightSignal.displayCallsign}',
            style: textTheme.labelLarge?.copyWith(color: accentInk),
          ),
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: SquadPingColors.canvasMist,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                nudgeLane.draftedLine,
                style: textTheme.bodyLarge?.copyWith(
                  color: SquadPingColors.inkHeavy,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            nudgeLane.cooldownPhrase,
            style: textTheme.bodyMedium?.copyWith(
              color: SquadPingColors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}

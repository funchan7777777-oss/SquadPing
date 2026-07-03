import 'package:flutter/material.dart';

import '../../../app/theme/squad_ping_colors.dart';
import '../../../field_notes/models/teammate_signal_note.dart';
import '../../../shared/widgets/soft_squad_panel.dart';
import 'availability_meter.dart';

class TeammateSignalCard extends StatelessWidget {
  const TeammateSignalCard({
    super.key,
    required this.signalNote,
    required this.rosterOrdinal,
  });

  final TeammateSignalNote signalNote;
  final int rosterOrdinal;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accentInk = SquadPingColors.laneInk(signalNote.laneTint);

    return SoftSquadPanel(
      borderTint: accentInk.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: accentInk.withValues(alpha: 0.13),
                child: Text(
                  signalNote.displayCallsign.substring(0, 1),
                  style: textTheme.titleMedium?.copyWith(color: accentInk),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signalNote.displayCallsign,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      signalNote.currentDriftLine,
                      style: textTheme.bodyMedium?.copyWith(
                        color: SquadPingColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '#${rosterOrdinal + 1}',
                style: textTheme.labelLarge?.copyWith(color: accentInk),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AvailabilityMeter(
            signalScore: signalNote.readinessScore,
            accentInk: accentInk,
            rhythmCaption: signalNote.responseTempo,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SignalChip(
                icon: Icons.place_rounded,
                label: signalNote.nearbyAnchor,
                accentInk: accentInk,
              ),
              _SignalChip(
                icon: Icons.verified_rounded,
                label: signalNote.trustRibbon,
                accentInk: accentInk,
              ),
              _SignalChip(
                icon: Icons.access_time_filled_rounded,
                label: signalNote.lastReplyAge,
                accentInk: accentInk,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Best nudge: ${signalNote.preferredNudge}',
            style: textTheme.labelLarge?.copyWith(
              color: SquadPingColors.inkHeavy,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final trailItem in signalNote.checkInTrail)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: SquadPingColors.canvasMist,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 7,
                    ),
                    child: Text(
                      trailItem,
                      style: textTheme.labelMedium?.copyWith(
                        color: SquadPingColors.inkSoft,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({
    required this.icon,
    required this.label,
    required this.accentInk,
  });

  final IconData icon;
  final String label;
  final Color accentInk;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accentInk.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: accentInk),
            const SizedBox(width: 5),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: accentInk),
            ),
          ],
        ),
      ),
    );
  }
}

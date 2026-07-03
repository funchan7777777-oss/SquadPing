import 'package:flutter/material.dart';

import '../../../app/theme/squad_ping_colors.dart';
import '../../../field_notes/models/crew_pulse_brief.dart';
import '../../../shared/widgets/soft_squad_panel.dart';

class CrewPulseTile extends StatelessWidget {
  const CrewPulseTile({
    super.key,
    required this.pulseBrief,
    required this.onNudgeRequested,
  });

  final CrewPulseBrief pulseBrief;
  final VoidCallback onNudgeRequested;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accentInk = SquadPingColors.laneInk(pulseBrief.laneTint);

    return SoftSquadPanel(
      borderTint: accentInk.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pulseBrief.pulseCode, style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      pulseBrief.openLoopLine,
                      style: textTheme.bodyMedium?.copyWith(
                        color: SquadPingColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _ReadinessBadge(
                readinessPercent: pulseBrief.readinessPercent,
                accentInk: accentInk,
              ),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: pulseBrief.readinessPercent / 100,
            minHeight: 7,
            color: accentInk,
            backgroundColor: accentInk.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final agendaItem in pulseBrief.microAgenda)
                _AgendaTag(label: agendaItem, accentInk: accentInk),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  pulseBrief.replyCadenceLabel,
                  style: textTheme.labelMedium?.copyWith(
                    color: SquadPingColors.inkSoft,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onNudgeRequested,
                icon: const Icon(Icons.near_me_rounded, size: 18),
                label: const Text('Nudge'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadinessBadge extends StatelessWidget {
  const _ReadinessBadge({
    required this.readinessPercent,
    required this.accentInk,
  });

  final int readinessPercent;
  final Color accentInk;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: accentInk.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$readinessPercent',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: accentInk,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'ready',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: accentInk),
          ),
        ],
      ),
    );
  }
}

class _AgendaTag extends StatelessWidget {
  const _AgendaTag({required this.label, required this.accentInk});

  final String label;
  final Color accentInk;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accentInk.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: accentInk),
        ),
      ),
    );
  }
}

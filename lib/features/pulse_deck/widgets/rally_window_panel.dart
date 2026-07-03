import 'package:flutter/material.dart';

import '../../../app/theme/squad_ping_colors.dart';
import '../../../field_notes/models/rally_window_digest.dart';
import '../../../shared/widgets/soft_squad_panel.dart';

class RallyWindowPanel extends StatelessWidget {
  const RallyWindowPanel({super.key, required this.rallyWindow});

  final RallyWindowDigest rallyWindow;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accentInk = SquadPingColors.laneInk(rallyWindow.laneTint);

    return SoftSquadPanel(
      panelTint: SquadPingColors.raisedSurface,
      borderTint: accentInk.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: accentInk.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  rallyWindow.rallyShortcode,
                  style: textTheme.labelLarge?.copyWith(color: accentInk),
                ),
              ),
              const Spacer(),
              Icon(Icons.flag_rounded, size: 18, color: accentInk),
            ],
          ),
          const SizedBox(height: 12),
          Text(rallyWindow.anchoredAround, style: textTheme.titleMedium),
          const SizedBox(height: 5),
          Text(
            rallyWindow.hostCallout,
            style: textTheme.bodyMedium?.copyWith(
              color: SquadPingColors.inkSoft,
            ),
          ),
          const SizedBox(height: 13),
          LinearProgressIndicator(
            value: rallyWindow.decisionPressure.clamp(0.0, 1.0).toDouble(),
            minHeight: 7,
            color: accentInk,
            backgroundColor: accentInk.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 12),
          Text(
            rallyWindow.settlementCue,
            style: textTheme.bodyMedium?.copyWith(
              color: SquadPingColors.inkHeavy,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _WindowNote(label: rallyWindow.headcountTrace),
              _WindowNote(label: rallyWindow.timeboxLabel),
              for (final line in rallyWindow.commitmentLines)
                _WindowNote(label: line),
            ],
          ),
        ],
      ),
    );
  }
}

class _WindowNote extends StatelessWidget {
  const _WindowNote({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: SquadPingColors.borderTrace),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

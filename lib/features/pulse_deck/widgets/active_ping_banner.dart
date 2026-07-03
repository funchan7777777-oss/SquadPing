import 'package:flutter/material.dart';

import '../../../app/theme/squad_ping_colors.dart';
import '../../../field_notes/models/crew_pulse_brief.dart';
import '../../../shared/widgets/soft_squad_panel.dart';

class ActivePingBanner extends StatelessWidget {
  const ActivePingBanner({
    super.key,
    required this.featuredPulse,
    required this.liveSignalCount,
    required this.rallyWindowCount,
  });

  final CrewPulseBrief featuredPulse;
  final int liveSignalCount;
  final int rallyWindowCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accentInk = SquadPingColors.laneInk(featuredPulse.laneTint);

    return SoftSquadPanel(
      panelTint: accentInk.withValues(alpha: 0.09),
      borderTint: accentInk.withValues(alpha: 0.22),
      panelPadding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentInk,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.wifi_tethering_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SquadPing', style: textTheme.headlineMedium),
                    const SizedBox(height: 3),
                    Text(
                      '$liveSignalCount live signals · $rallyWindowCount rally windows',
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
          Text(featuredPulse.pulseCode, style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            featuredPulse.openLoopLine,
            style: textTheme.bodyLarge?.copyWith(
              color: SquadPingColors.inkHeavy,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BannerChip(label: featuredPulse.roomTone, accentInk: accentInk),
              _BannerChip(
                label: featuredPulse.replyCadenceLabel,
                accentInk: accentInk,
              ),
              _BannerChip(
                label: featuredPulse.lastSignalStamp,
                accentInk: accentInk,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerChip extends StatelessWidget {
  const _BannerChip({required this.label, required this.accentInk});

  final String label;
  final Color accentInk;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accentInk.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: SquadPingColors.inkHeavy),
        ),
      ),
    );
  }
}

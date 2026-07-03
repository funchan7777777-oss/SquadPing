import 'package:flutter/material.dart';

import '../../app/theme/squad_ping_colors.dart';

class SectionCaptionBar extends StatelessWidget {
  const SectionCaptionBar({
    super.key,
    required this.laneLabel,
    required this.signalHeadline,
    this.endcapAction,
  });

  final String laneLabel;
  final String signalHeadline;
  final Widget? endcapAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                laneLabel.toUpperCase(),
                style: textTheme.labelMedium?.copyWith(
                  color: SquadPingColors.cedarSignal,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(signalHeadline, style: textTheme.titleLarge),
            ],
          ),
        ),
        if (endcapAction != null) ...[const SizedBox(width: 12), endcapAction!],
      ],
    );
  }
}

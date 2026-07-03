import 'package:flutter/material.dart';

class SquadMetricPill extends StatelessWidget {
  const SquadMetricPill({
    super.key,
    required this.pulseGlyph,
    required this.metricReading,
    required this.metricContext,
    required this.inkColor,
    required this.washColor,
  });

  final IconData pulseGlyph;
  final String metricReading;
  final String metricContext;
  final Color inkColor;
  final Color washColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 118),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: washColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(pulseGlyph, color: inkColor, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  metricReading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelLarge?.copyWith(color: inkColor),
                ),
                Text(
                  metricContext,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium?.copyWith(color: inkColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

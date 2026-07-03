import 'package:flutter/material.dart';

class AvailabilityMeter extends StatelessWidget {
  const AvailabilityMeter({
    super.key,
    required this.signalScore,
    required this.accentInk,
    required this.rhythmCaption,
  });

  final int signalScore;
  final Color accentInk;
  final String rhythmCaption;

  @override
  Widget build(BuildContext context) {
    final normalizedScore = signalScore.clamp(0, 100) / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                rhythmCaption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$signalScore%',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: accentInk,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: normalizedScore,
          minHeight: 7,
          color: accentInk,
          backgroundColor: accentInk.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}

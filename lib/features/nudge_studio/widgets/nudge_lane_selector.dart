import 'package:flutter/material.dart';

import '../../../app/theme/squad_ping_colors.dart';
import '../../../field_notes/models/nudge_lane_marker.dart';

class NudgeLaneSelector extends StatelessWidget {
  const NudgeLaneSelector({
    super.key,
    required this.laneMenu,
    required this.focusedLaneKey,
    required this.onLanePulled,
  });

  final List<NudgeLaneMarker> laneMenu;
  final String focusedLaneKey;
  final ValueChanged<NudgeLaneMarker> onLanePulled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final laneMarker in laneMenu) ...[
            _NudgeLaneButton(
              laneMarker: laneMarker,
              isFocused: laneMarker.laneKey == focusedLaneKey,
              onPressed: () => onLanePulled(laneMarker),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _NudgeLaneButton extends StatelessWidget {
  const _NudgeLaneButton({
    required this.laneMarker,
    required this.isFocused,
    required this.onPressed,
  });

  final NudgeLaneMarker laneMarker;
  final bool isFocused;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final accentInk = SquadPingColors.laneInk(laneMarker.laneTint);

    return ChoiceChip(
      selected: isFocused,
      onSelected: (_) => onPressed(),
      avatar: Icon(
        isFocused ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        size: 17,
        color: isFocused ? Colors.white : accentInk,
      ),
      label: Text(laneMarker.menuLabel),
      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: isFocused ? Colors.white : accentInk,
      ),
      selectedColor: accentInk,
      backgroundColor: accentInk.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide(color: accentInk.withValues(alpha: 0.2)),
      showCheckmark: false,
    );
  }
}

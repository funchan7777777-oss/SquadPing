import 'package:flutter/material.dart';

import '../../../app/theme/squad_ping_colors.dart';
import '../../../field_notes/models/teammate_signal_note.dart';
import '../../../field_notes/repositories/pulse_story_repository.dart';
import '../../../shared/widgets/section_caption_bar.dart';
import '../../../shared/widgets/soft_squad_panel.dart';
import '../widgets/nudge_lane_selector.dart';
import '../widgets/ping_wording_card.dart';

class QuickPingStudio extends StatefulWidget {
  const QuickPingStudio({super.key, required this.storyArchive});

  final PulseStoryRepository storyArchive;

  @override
  State<QuickPingStudio> createState() => _QuickPingStudioState();
}

class _QuickPingStudioState extends State<QuickPingStudio> {
  late String _focusedLaneKey;
  late String _spotlightSignalId;

  @override
  void initState() {
    super.initState();
    _focusedLaneKey = widget.storyArchive.nudgeLanes.first.laneKey;
    _spotlightSignalId = widget.storyArchive.squadSignals.first.signalId;
  }

  @override
  Widget build(BuildContext context) {
    final focusedLane = widget.storyArchive.nudgeLanes.firstWhere(
      (lane) => lane.laneKey == _focusedLaneKey,
    );
    final spotlightSignal = widget.storyArchive.squadSignals.firstWhere(
      (signal) => signal.signalId == _spotlightSignalId,
    );
    final accentInk = SquadPingColors.laneInk(focusedLane.laneTint);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          const SectionCaptionBar(
            laneLabel: 'Ping studio',
            signalHeadline: 'Shape one clear ask before the thread gets noisy',
          ),
          const SizedBox(height: 16),
          NudgeLaneSelector(
            laneMenu: widget.storyArchive.nudgeLanes,
            focusedLaneKey: _focusedLaneKey,
            onLanePulled: (laneMarker) {
              setState(() => _focusedLaneKey = laneMarker.laneKey);
            },
          ),
          const SizedBox(height: 16),
          SoftSquadPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recipient rhythm',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final signalNote in widget.storyArchive.squadSignals)
                      _RecipientChoice(
                        signalNote: signalNote,
                        isFocused: signalNote.signalId == _spotlightSignalId,
                        onPressed: () {
                          setState(
                            () => _spotlightSignalId = signalNote.signalId,
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          PingWordingCard(
            nudgeLane: focusedLane,
            spotlightSignal: spotlightSignal,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${focusedLane.buttonCaption} prepared for ${spotlightSignal.displayCallsign}.',
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: SquadPingColors.inkHeavy,
                ),
              );
            },
            icon: const Icon(Icons.send_rounded),
            label: Text(focusedLane.buttonCaption),
            style: FilledButton.styleFrom(backgroundColor: accentInk),
          ),
        ],
      ),
    );
  }
}

class _RecipientChoice extends StatelessWidget {
  const _RecipientChoice({
    required this.signalNote,
    required this.isFocused,
    required this.onPressed,
  });

  final TeammateSignalNote signalNote;
  final bool isFocused;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final accentInk = SquadPingColors.laneInk(signalNote.laneTint);

    return ActionChip(
      onPressed: onPressed,
      avatar: CircleAvatar(
        backgroundColor: isFocused
            ? Colors.white.withValues(alpha: 0.9)
            : accentInk.withValues(alpha: 0.14),
        child: Text(
          signalNote.displayCallsign.substring(0, 1),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isFocused ? accentInk : SquadPingColors.inkHeavy,
          ),
        ),
      ),
      label: Text(signalNote.displayCallsign),
      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: isFocused ? Colors.white : SquadPingColors.inkHeavy,
      ),
      backgroundColor: isFocused ? accentInk : SquadPingColors.raisedSurface,
      side: BorderSide(
        color: isFocused ? accentInk : SquadPingColors.borderTrace,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

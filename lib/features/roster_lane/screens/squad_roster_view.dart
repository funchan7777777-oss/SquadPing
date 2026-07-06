import 'package:flutter/material.dart';

import '../../../field_notes/repositories/pulse_story_repository.dart';
import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/widgets/section_caption_bar.dart';
import '../widgets/teammate_signal_card.dart';

class SquadRosterView extends StatelessWidget {
  const SquadRosterView({super.key, required this.storyArchive});

  final PulseStoryRepository storyArchive;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          squadCompactTopPadding(context),
          20,
          28,
        ),
        children: [
          const SectionCaptionBar(
            laneLabel: 'Roster lane',
            signalHeadline: 'Who is close, ready, or worth a nudge',
          ),
          const SizedBox(height: 14),
          for (final MapEntry(:key, :value)
              in storyArchive.squadSignals.asMap().entries) ...[
            TeammateSignalCard(signalNote: value, rosterOrdinal: key),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

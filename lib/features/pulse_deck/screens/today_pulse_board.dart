import 'package:flutter/material.dart';

import '../../../app/theme/squad_ping_colors.dart';
import '../../../field_notes/repositories/pulse_story_repository.dart';
import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/widgets/section_caption_bar.dart';
import '../widgets/active_ping_banner.dart';
import '../widgets/crew_pulse_tile.dart';
import '../widgets/rally_window_panel.dart';
import '../widgets/signal_weather_strip.dart';

class TodayPulseBoard extends StatelessWidget {
  const TodayPulseBoard({super.key, required this.storyArchive});

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
          ActivePingBanner(
            featuredPulse: storyArchive.crewPulses.first,
            liveSignalCount: storyArchive.squadSignals.length,
            rallyWindowCount: storyArchive.rallyWindows.length,
          ),
          const SizedBox(height: 18),
          SignalWeatherStrip(
            crewPulses: storyArchive.crewPulses,
            rallyWindows: storyArchive.rallyWindows,
            squadSignals: storyArchive.squadSignals,
          ),
          const SizedBox(height: 26),
          const SectionCaptionBar(
            laneLabel: 'Today board',
            signalHeadline: 'Open loops that need a clear reply',
          ),
          const SizedBox(height: 12),
          for (final pulseBrief in storyArchive.crewPulses) ...[
            CrewPulseTile(
              pulseBrief: pulseBrief,
              onNudgeRequested: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Prepared a nudge for ${pulseBrief.pulseCode}.',
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: SquadPingColors.inkHeavy,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          const SectionCaptionBar(
            laneLabel: 'Rally windows',
            signalHeadline: 'Places and cutoffs worth watching',
          ),
          const SizedBox(height: 12),
          for (final rallyWindow in storyArchive.rallyWindows) ...[
            RallyWindowPanel(rallyWindow: rallyWindow),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

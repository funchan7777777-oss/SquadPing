import 'package:flutter/material.dart';

import '../../features/nudge_studio/screens/quick_ping_studio.dart';
import '../../features/pulse_deck/screens/today_pulse_board.dart';
import '../../features/roster_lane/screens/squad_roster_view.dart';
import '../../field_notes/repositories/pulse_story_repository.dart';
import 'squad_ping_tab.dart';

class SquadPingShell extends StatefulWidget {
  const SquadPingShell({super.key, required this.storyArchive});

  final PulseStoryRepository storyArchive;

  @override
  State<SquadPingShell> createState() => _SquadPingShellState();
}

class _SquadPingShellState extends State<SquadPingShell> {
  int _selectedTabSlot = 0;

  @override
  Widget build(BuildContext context) {
    final destinations = SquadPingTab.values
        .map(
          (tab) => NavigationDestination(
            icon: Icon(tab.glyph),
            selectedIcon: Icon(tab.glyph, fill: 1),
            label: tab.caption,
          ),
        )
        .toList();

    return Scaffold(
      body: IndexedStack(
        index: _selectedTabSlot,
        children: [
          TodayPulseBoard(storyArchive: widget.storyArchive),
          SquadRosterView(storyArchive: widget.storyArchive),
          QuickPingStudio(storyArchive: widget.storyArchive),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabSlot,
        destinations: destinations,
        onDestinationSelected: (tabSlot) {
          setState(() => _selectedTabSlot = tabSlot);
        },
      ),
    );
  }
}

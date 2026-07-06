import 'package:flutter/material.dart';

import '../../features/game_zone/screens/game_zone_home_screen.dart';
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
    return Scaffold(
      body: IndexedStack(
        index: _selectedTabSlot,
        children: SquadPingTab.values.map(_buildTabView).toList(),
      ),
      bottomNavigationBar: _SquadPingTabBar(
        selectedIndex: _selectedTabSlot,
        onSelected: (tabSlot) {
          setState(() => _selectedTabSlot = tabSlot);
        },
      ),
    );
  }

  Widget _buildTabView(SquadPingTab tab) {
    return switch (tab) {
      SquadPingTab.beacon => const GameZoneHomeScreen(),
      SquadPingTab.chat => QuickPingStudio(storyArchive: widget.storyArchive),
      SquadPingTab.voice => QuickPingStudio(storyArchive: widget.storyArchive),
      SquadPingTab.emblem => TodayPulseBoard(storyArchive: widget.storyArchive),
      SquadPingTab.forum => SquadRosterView(storyArchive: widget.storyArchive),
    };
  }
}

class _SquadPingTabBar extends StatelessWidget {
  const _SquadPingTabBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 375),
          child: Container(
            width: 375,
            height: 92,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(21, 18, 21, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final entry in SquadPingTab.values.asMap().entries)
                  _SquadPingTabButton(
                    tab: entry.value,
                    isSelected: entry.key == selectedIndex,
                    onPressed: () => onSelected(entry.key),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SquadPingTabButton extends StatelessWidget {
  const _SquadPingTabButton({
    required this.tab,
    required this.isSelected,
    required this.onPressed,
  });

  final SquadPingTab tab;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: tab.caption,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox.square(
          dimension: 56,
          child: Image.asset(
            isSelected ? tab.activeAsset : tab.inactiveAsset,
            width: 56,
            height: 56,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

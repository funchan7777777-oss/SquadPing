import 'package:flutter/material.dart';

import '../../features/community/screens/community_screen.dart';
import '../../features/game_zone/screens/game_zone_home_screen.dart';
import '../../features/information_center/screens/information_center_screen.dart';
import '../../features/profile_center/screens/profile_center_screen.dart';
import '../../features/profile_center/services/coin_economy.dart';
import '../../features/profile_center/services/profile_wallet_store.dart';
import '../../features/profile_center/widgets/coin_feedback.dart';
import '../../features/video_feed/screens/video_feed_screen.dart';
import '../../field_notes/repositories/pulse_story_repository.dart';
import 'session_exit_target.dart';
import 'squad_ping_tab.dart';

class SquadPingShell extends StatefulWidget {
  const SquadPingShell({
    super.key,
    required this.storyArchive,
    this.onSessionClosed,
  });

  final PulseStoryRepository storyArchive;
  final ValueChanged<SessionExitTarget>? onSessionClosed;

  @override
  State<SquadPingShell> createState() => _SquadPingShellState();
}

class _SquadPingShellState extends State<SquadPingShell> {
  int _selectedTabSlot = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _grantWelcomeGift());
  }

  Future<void> _grantWelcomeGift() async {
    final walletStore = ProfileWalletStore.instance;
    await walletStore.initialize();
    final granted = await walletStore.grantWelcomeGiftIfNeeded();
    if (!granted || !mounted) {
      return;
    }
    await showWelcomeGiftDialog(context, coins: CoinEconomy.welcomeGiftCoins);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      SquadPingTab.chat => const VideoFeedScreen(),
      SquadPingTab.voice => const CommunityScreen(),
      SquadPingTab.emblem => const InformationCenterScreen(),
      SquadPingTab.forum => ProfileCenterScreen(
        onSessionClosed: widget.onSessionClosed,
      ),
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

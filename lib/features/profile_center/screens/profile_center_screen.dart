import 'package:flutter/material.dart';

import '../../../app/navigation/session_exit_target.dart';
import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../community/data/community_seed.dart';
import '../../community/models/community_models.dart';
import '../../community/services/community_local_store.dart';
import '../../signal_gate/services/local_gate_record_keeper.dart';
import '../widgets/profile_avatar_image.dart';
import 'profile_coin_shop_screen.dart';
import 'profile_edit_screen.dart';
import 'profile_people_list_screen.dart';
import 'profile_settings_screen.dart';

class ProfileCenterScreen extends StatefulWidget {
  const ProfileCenterScreen({super.key, this.onSessionClosed});

  final ValueChanged<SessionExitTarget>? onSessionClosed;

  @override
  State<ProfileCenterScreen> createState() => _ProfileCenterScreenState();
}

class _ProfileCenterScreenState extends State<ProfileCenterScreen> {
  final _recordKeeper = LocalGateRecordKeeper();
  final _localStore = CommunityLocalStore.instance;
  final _safetyStore = SafetyActionStore.instance;
  GateProfileSnapshot? _profile;
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _load();
    _localStore.addListener(_refresh);
    _safetyStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _localStore.removeListener(_refresh);
    _safetyStore.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _load() async {
    await Future.wait([
      _recordKeeper.initialize(),
      _localStore.initialize(),
      _safetyStore.initialize(),
    ]);
    final profile = await _recordKeeper.loadProfile();
    if (mounted) {
      setState(() {
        _profile = profile;
        _isReady = true;
      });
    }
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfileSettingsScreen(
          recordKeeper: _recordKeeper,
          onSessionClosed: widget.onSessionClosed,
        ),
      ),
    );
    await _load();
  }

  Future<void> _openShop() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileCoinShopScreen()),
    );
    await _load();
  }

  Future<void> _openEdit() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfileEditScreen(recordKeeper: _recordKeeper),
      ),
    );
    await _load();
  }

  void _openPeople(ProfilePeopleMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfilePeopleListScreen(mode: mode),
      ),
    );
  }

  int _visiblePeopleCount(List<String> userIds) {
    return userIds.where((userId) {
      return !_safetyStore.isUserBlocked(userId) && _userById(userId) != null;
    }).length;
  }

  CommunityUser? _userById(String userId) {
    for (final user in CommunitySeed.users) {
      if (user.id == userId) {
        return user;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;

    return ColoredBox(
      color: const Color(0xFF7138F5),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              SquadPingAssets.gameZoneChatBackdrop,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6337EE).withValues(alpha: 0.82),
                    const Color(0xFF7C40F6).withValues(alpha: 0.72),
                    const Color(0xFFC855F7).withValues(alpha: 0.56),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: !_isReady || profile == null
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          squadCompactTopPadding(context, extra: 4),
                          16,
                          112,
                        ),
                        children: [
                          Text(
                            'Mine',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 12),
                          _ProfileHero(
                            profile: profile,
                            onSettingsTap: _openSettings,
                          ),
                          const SizedBox(height: 14),
                          _StatsPanel(
                            followingCount: _visiblePeopleCount(
                              _localStore.followingUserIds,
                            ),
                            fansCount: _visiblePeopleCount(
                              _localStore.approvedFollowerIds,
                            ),
                            onFollowingTap: () =>
                                _openPeople(ProfilePeopleMode.following),
                            onFansTap: () =>
                                _openPeople(ProfilePeopleMode.fans),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _ProfileTile(
                                  asset: SquadPingAssets.profileCoinShopTile,
                                  onTap: _openShop,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _ProfileTile(
                                  asset: SquadPingAssets.profileEditTile,
                                  onTap: _openEdit,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const _MinePostsEmptyState(),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile, required this.onSettingsTap});

  final GateProfileSnapshot profile;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 328 / 214,
            child: ProfileAvatarImage(avatarPath: profile.avatarPath),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.transparent,
                    const Color(0xFF6C34F2).withValues(alpha: 0.94),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: GestureDetector(
              onTap: onSettingsTap,
              child: Image.asset(
                SquadPingAssets.profileSettingsGlyph,
                width: 34,
                height: 34,
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${profile.age} years old',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Image.asset(
                      SquadPingAssets.profileLocationGlyph,
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        profile.areaSignal,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({
    required this.followingCount,
    required this.fansCount,
    required this.onFollowingTap,
    required this.onFansTap,
  });

  final int followingCount;
  final int fansCount;
  final VoidCallback onFollowingTap;
  final VoidCallback onFansTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatButton(
              label: 'Follow',
              value: '$followingCount',
              onTap: onFollowingTap,
            ),
          ),
          Container(width: 1, height: 42, color: const Color(0xFFE3E3EA)),
          Expanded(
            child: _StatButton(
              label: 'Fans',
              value: '$fansCount',
              onTap: onFansTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatButton extends StatelessWidget {
  const _StatButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF1F1D25),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFF1F1D25),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 112,
        child: Image.asset(asset, fit: BoxFit.fill),
      ),
    );
  }
}

class _MinePostsEmptyState extends StatelessWidget {
  const _MinePostsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.article_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'No posts yet.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

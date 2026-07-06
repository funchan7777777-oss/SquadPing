import 'package:flutter/material.dart';

import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../../community/data/community_seed.dart';
import '../../community/models/community_models.dart';
import '../../community/screens/community_user_profile_screen.dart';
import '../../community/services/community_local_store.dart';

enum ProfilePeopleMode { following, fans }

class ProfilePeopleListScreen extends StatefulWidget {
  const ProfilePeopleListScreen({super.key, required this.mode});

  final ProfilePeopleMode mode;

  @override
  State<ProfilePeopleListScreen> createState() =>
      _ProfilePeopleListScreenState();
}

class _ProfilePeopleListScreenState extends State<ProfilePeopleListScreen> {
  final _localStore = CommunityLocalStore.instance;
  final _safetyStore = SafetyActionStore.instance;
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    _localStore.addListener(_refresh);
    _safetyStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _localStore.removeListener(_refresh);
    _safetyStore.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _initialize() async {
    await Future.wait([_localStore.initialize(), _safetyStore.initialize()]);
    if (mounted) {
      setState(() => _isReady = true);
    }
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  String get _title {
    return switch (widget.mode) {
      ProfilePeopleMode.following => 'Follow',
      ProfilePeopleMode.fans => 'Fans',
    };
  }

  List<CommunityUser> get _users {
    final ids = switch (widget.mode) {
      ProfilePeopleMode.following => _localStore.followingUserIds,
      ProfilePeopleMode.fans => _localStore.approvedFollowerIds,
    };
    return ids
        .where((userId) => !_safetyStore.isUserBlocked(userId))
        .map(_userById)
        .whereType<CommunityUser>()
        .toList();
  }

  CommunityUser? _userById(String userId) {
    for (final user in CommunitySeed.users) {
      if (user.id == userId) {
        return user;
      }
    }
    return null;
  }

  Future<void> _followBack(CommunityUser user) async {
    await _localStore.requestFollow(user.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Follow request sent to ${user.displayName}.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openProfile(CommunityUser user) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            CommunityUserProfileScreen(user: user, posts: CommunitySeed.posts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = _users;

    return Scaffold(
      backgroundColor: const Color(0xFF7138F5),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              SquadPingAssets.gameZoneChatBackdrop,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: !_isReady
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                        children: [
                          _PeopleHeader(
                            title: _title,
                            onBack: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 18),
                          if (users.isEmpty)
                            buildSquadEmptyState()
                          else
                            for (final user in users) ...[
                              _PeopleRow(
                                user: user,
                                isFollowing: _localStore.isFollowing(user.id),
                                onProfileTap: () => _openProfile(user),
                                onFollowTap: () => _followBack(user),
                              ),
                              const SizedBox(height: 12),
                            ],
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

class _PeopleHeader extends StatelessWidget {
  const _PeopleHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _PeopleRow extends StatelessWidget {
  const _PeopleRow({
    required this.user,
    required this.isFollowing,
    required this.onProfileTap,
    required this.onFollowTap,
  });

  final CommunityUser user;
  final bool isFollowing;
  final VoidCallback onProfileTap;
  final VoidCallback onFollowTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onProfileTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                user.avatarAsset,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onProfileTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${user.age} years old',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: const Color(0xFF27252F)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF201F29),
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        user.country,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: const Color(0xFF27252F)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isFollowing ? null : onFollowTap,
            child: isFollowing
                ? Image.asset(
                    SquadPingAssets.profileFollowedButton,
                    width: 82,
                    height: 42,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    SquadPingAssets.informationFollowGlyph,
                    width: 82,
                    height: 42,
                    fit: BoxFit.fill,
                  ),
          ),
        ],
      ),
    );
  }
}

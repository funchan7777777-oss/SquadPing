import 'package:flutter/material.dart';

import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../../community/data/community_seed.dart';
import '../../community/models/community_models.dart';
import '../../community/screens/community_user_profile_screen.dart';

class ProfileBlacklistScreen extends StatefulWidget {
  const ProfileBlacklistScreen({super.key});

  @override
  State<ProfileBlacklistScreen> createState() => _ProfileBlacklistScreenState();
}

class _ProfileBlacklistScreenState extends State<ProfileBlacklistScreen> {
  final _safetyStore = SafetyActionStore.instance;
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    _safetyStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _safetyStore.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _initialize() async {
    await _safetyStore.initialize();
    if (mounted) {
      setState(() => _isReady = true);
    }
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  CommunityUser? _userById(String userId) {
    for (final user in CommunitySeed.users) {
      if (user.id == userId) {
        return user;
      }
    }
    return null;
  }

  List<CommunityUser> get _blockedUsers {
    return _safetyStore.blockedUserIds
        .map(_userById)
        .whereType<CommunityUser>()
        .toList();
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
    final users = _blockedUsers;

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
                          _BlacklistHeader(
                            onBack: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 18),
                          if (users.isEmpty)
                            buildSquadEmptyState()
                          else
                            for (final user in users) ...[
                              _BlockedUserRow(
                                user: user,
                                onProfileTap: () => _openProfile(user),
                                onCancel: () =>
                                    _safetyStore.unblockUser(user.id),
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

class _BlacklistHeader extends StatelessWidget {
  const _BlacklistHeader({required this.onBack});

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
            'Blacklist',
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

class _BlockedUserRow extends StatelessWidget {
  const _BlockedUserRow({
    required this.user,
    required this.onProfileTap,
    required this.onCancel,
  });

  final CommunityUser user;
  final VoidCallback onProfileTap;
  final VoidCallback onCancel;

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
            onTap: onCancel,
            child: Image.asset(
              SquadPingAssets.profileCancelButton,
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

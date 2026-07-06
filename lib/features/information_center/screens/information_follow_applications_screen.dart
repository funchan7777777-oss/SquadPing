import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../../community/data/community_seed.dart';
import '../../community/models/community_models.dart';
import '../../community/screens/community_user_profile_screen.dart';
import '../../community/services/community_local_store.dart';

class InformationFollowApplicationsScreen extends StatefulWidget {
  const InformationFollowApplicationsScreen({super.key});

  @override
  State<InformationFollowApplicationsScreen> createState() =>
      _InformationFollowApplicationsScreenState();
}

class _InformationFollowApplicationsScreenState
    extends State<InformationFollowApplicationsScreen> {
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

  List<CommunityUser> get _incomingUsers {
    return CommunitySeed.users.where((user) {
      return user.id != CommunitySeed.viewer.id &&
          _localStore.hasIncomingFollowRequest(user.id) &&
          !_safetyStore.isUserBlocked(user.id);
    }).toList();
  }

  List<CommunityUser> get _sentUsers {
    return CommunitySeed.users.where((user) {
      return user.id != CommunitySeed.viewer.id &&
          _localStore.hasRequestedFollow(user.id) &&
          !_localStore.isMutualFollow(user.id) &&
          !_safetyStore.isUserBlocked(user.id);
    }).toList();
  }

  Future<void> _approve(CommunityUser user) async {
    await _localStore.approveIncomingFollowRequest(user.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You and ${user.displayName} can now chat.'),
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
    final incoming = _incomingUsers;
    final sent = _sentUsers;

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
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6535F2).withValues(alpha: 0.84),
                    const Color(0xFF7C40F6).withValues(alpha: 0.74),
                    const Color(0xFFC855F7).withValues(alpha: 0.58),
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
                child: !_isReady
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          squadCompactTopPadding(context),
                          16,
                          28,
                        ),
                        children: [
                          _ApplyHeader(
                            onBack: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 18),
                          if (incoming.isEmpty && sent.isEmpty)
                            buildSquadEmptyState()
                          else ...[
                            for (final user in incoming) ...[
                              _ApplicationRow(
                                user: user,
                                status: _ApplicationStatus.incoming,
                                onProfileTap: () => _openProfile(user),
                                onActionTap: () => _approve(user),
                              ),
                              const SizedBox(height: 12),
                            ],
                            for (final user in sent) ...[
                              _ApplicationRow(
                                user: user,
                                status: _ApplicationStatus.sent,
                                onProfileTap: () => _openProfile(user),
                                onActionTap: () {},
                              ),
                              const SizedBox(height: 12),
                            ],
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

class _ApplyHeader extends StatelessWidget {
  const _ApplyHeader({required this.onBack});

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
            'Apply',
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

class _ApplicationRow extends StatelessWidget {
  const _ApplicationRow({
    required this.user,
    required this.status,
    required this.onProfileTap,
    required this.onActionTap,
  });

  final CommunityUser user;
  final _ApplicationStatus status;
  final VoidCallback onProfileTap;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final isIncoming = status == _ApplicationStatus.incoming;
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
            onTap: isIncoming ? onActionTap : null,
            child: SizedBox(
              width: 82,
              height: 42,
              child: isIncoming
                  ? Image.asset(
                      SquadPingAssets.informationFollowGlyph,
                      fit: BoxFit.fill,
                    )
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8D8DD),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'Pending',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ApplicationStatus { incoming, sent }

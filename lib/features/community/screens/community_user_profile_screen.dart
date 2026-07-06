import 'package:flutter/material.dart';

import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../information_center/screens/information_chat_screen.dart';
import '../data/community_seed.dart';
import '../models/community_models.dart';
import '../services/community_local_store.dart';
import '../widgets/community_post_card.dart';
import 'community_topic_detail_screen.dart';

class CommunityUserProfileScreen extends StatefulWidget {
  const CommunityUserProfileScreen({
    super.key,
    required this.user,
    required this.posts,
  });

  final CommunityUser user;
  final List<CommunityPost> posts;

  @override
  State<CommunityUserProfileScreen> createState() =>
      _CommunityUserProfileScreenState();
}

class _CommunityUserProfileScreenState
    extends State<CommunityUserProfileScreen> {
  final _localStore = CommunityLocalStore.instance;
  final _safetyStore = SafetyActionStore.instance;

  @override
  void initState() {
    super.initState();
    _localStore.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
    _localStore.addListener(_refresh);
    _safetyStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _localStore.removeListener(_refresh);
    _safetyStore.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _requestFollow() async {
    await _localStore.requestFollow(widget.user.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Follow request sent to ${widget.user.displayName}.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openChat() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => InformationChatScreen(peer: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isViewer = widget.user.id == CommunitySeed.viewer.id;
    final isBlocked = _safetyStore.isUserBlocked(widget.user.id);
    final requestSent = _localStore.hasRequestedFollow(widget.user.id);
    final mutual = _localStore.isMutualFollow(widget.user.id);
    final visiblePosts = widget.posts
        .where((post) => post.author.id == widget.user.id)
        .where(
          (post) =>
              !_safetyStore.isContentHidden(post.id, authorId: post.author.id),
        )
        .toList();

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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 34),
                  children: [
                    _ProfileHeader(
                      onBack: () => Navigator.of(context).pop(),
                      onMore: isViewer
                          ? null
                          : () => showSafetyActionSheet(
                              context: context,
                              contentId: 'profile-${widget.user.id}',
                              authorId: widget.user.id,
                              authorName: widget.user.displayName,
                            ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          widget.user.avatarAsset,
                          width: 210,
                          height: 210,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.user.trendLabel,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.user.age} years old',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.82),
                              ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        Text(
                          widget.user.country,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.82),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StatsPanel(postCount: visiblePosts.length),
                    const SizedBox(height: 14),
                    if (!isViewer)
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _openChat,
                              child: Image.asset(
                                SquadPingAssets.communityChatButton,
                                height: 58,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: requestSent || mutual || isBlocked
                                  ? null
                                  : _requestFollow,
                              child: Image.asset(
                                mutual
                                    ? SquadPingAssets.communityFollowedButton
                                    : SquadPingAssets.communityFollowButton,
                                height: 58,
                                fit: BoxFit.fill,
                                color: requestSent || isBlocked
                                    ? Colors.white.withValues(alpha: 0.35)
                                    : null,
                                colorBlendMode: requestSent || isBlocked
                                    ? BlendMode.srcATop
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (requestSent && !mutual) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Follow request pending. Chat unlocks only after mutual follow.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    Text(
                      widget.user.bio,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.86),
                        height: 1.34,
                      ),
                    ),
                    const SizedBox(height: 18),
                    for (final post in visiblePosts) ...[
                      CommunityPostCard(
                        post: post,
                        onAuthorTap: () {},
                        onMoreTap: () => showSafetyActionSheet(
                          context: context,
                          contentId: post.id,
                          authorId: post.author.id,
                          authorName: post.author.displayName,
                        ),
                        onLikeTap: () {},
                        onCommentTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => CommunityTopicDetailScreen(
                                post: post,
                                onPostChanged: (_) {},
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onBack, required this.onMore});

  final VoidCallback onBack;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        const Spacer(),
        IconButton(
          onPressed: onMore,
          icon: const Icon(Icons.more_horiz_rounded),
          color: Colors.white,
        ),
      ],
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.postCount});

  final int postCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(label: 'Follow', value: '$postCount'),
          ),
          Container(width: 1, height: 38, color: const Color(0xFFE2E2E8)),
          const Expanded(
            child: _Stat(label: 'Fans', value: '0'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFF25202F),
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: const Color(0xFF25202F)),
        ),
      ],
    );
  }
}

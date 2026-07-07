import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
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
  late List<CommunityPost> _posts;

  @override
  void initState() {
    super.initState();
    _posts = [...widget.posts];
    _localStore.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
    _localStore.addListener(_refresh);
    _safetyStore.addListener(_refresh);
  }

  @override
  void didUpdateWidget(covariant CommunityUserProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.posts != widget.posts) {
      _posts = [...widget.posts];
    }
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

  void _replacePost(CommunityPost post) {
    final index = _posts.indexWhere((item) => item.id == post.id);
    if (index == -1) {
      return;
    }
    setState(() => _posts[index] = post);
  }

  void _toggleLike(CommunityPost post) {
    final index = _posts.indexWhere((item) => item.id == post.id);
    if (index == -1) {
      return;
    }
    final liked = !_posts[index].isLiked;
    setState(() {
      _posts[index] = _posts[index].copyWith(
        isLiked: liked,
        likeCount: _posts[index].likeCount + (liked ? 1 : -1),
      );
    });
  }

  void _openPostDetail(CommunityPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            CommunityTopicDetailScreen(post: post, onPostChanged: _replacePost),
      ),
    );
  }

  int _visiblePeopleCount(Iterable<String> userIds) {
    return userIds
        .where((userId) => !_safetyStore.isUserBlocked(userId))
        .where((userId) => CommunitySeed.users.any((user) => user.id == userId))
        .length;
  }

  int _followingCountFor(CommunityUser user) {
    if (user.id == CommunitySeed.viewer.id) {
      return user.followingCount +
          _visiblePeopleCount(_localStore.followingUserIds);
    }
    final followsViewer =
        _localStore.approvedFollowerIds.contains(user.id) ||
        _localStore.incomingFollowRequestIds.contains(user.id);
    return user.followingCount + (followsViewer ? 1 : 0);
  }

  int _fansCountFor(CommunityUser user) {
    if (user.id == CommunitySeed.viewer.id) {
      return user.fansCount +
          _visiblePeopleCount(_localStore.approvedFollowerIds);
    }
    final viewerFollowsUser =
        _localStore.isFollowing(user.id) ||
        _localStore.hasRequestedFollow(user.id);
    return user.fansCount + (viewerFollowsUser ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = squadCompactTopPadding(context);
    final isViewer = widget.user.id == CommunitySeed.viewer.id;
    final isBlocked = _safetyStore.isUserBlocked(widget.user.id);
    final requestSent = _localStore.hasRequestedFollow(widget.user.id);
    final mutual = _localStore.isMutualFollow(widget.user.id);
    final visiblePosts = _posts
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
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6C34F5).withValues(alpha: 0.72),
                    const Color(0xFF8945F6).withValues(alpha: 0.62),
                    const Color(0xFFE050F2).withValues(alpha: 0.60),
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
                child: ListView(
                  padding: EdgeInsets.fromLTRB(24, topPadding, 24, 34),
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
                    const SizedBox(height: 8),
                    Center(
                      child: _ProfileAvatarHero(
                        avatarAsset: widget.user.avatarAsset,
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
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.user.age} years old',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.82),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
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
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _StatsPanel(
                      followingCount: _followingCountFor(widget.user),
                      fansCount: _fansCountFor(widget.user),
                    ),
                    const SizedBox(height: 16),
                    _ProfileActionButtons(
                      onChat: isViewer || isBlocked ? null : _openChat,
                      onFollow: isViewer || requestSent || mutual || isBlocked
                          ? null
                          : _requestFollow,
                      isFollowed: mutual,
                      isDisabled: isViewer || requestSent || isBlocked,
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        height: 1.34,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (final post in visiblePosts) ...[
                      CommunityPostCard(
                        post: post,
                        compact: true,
                        onCardTap: () => _openPostDetail(post),
                        onAuthorTap: () {},
                        onMoreTap: () => showSafetyActionSheet(
                          context: context,
                          contentId: post.id,
                          authorId: post.author.id,
                          authorName: post.author.displayName,
                        ),
                        onLikeTap: () => _toggleLike(post),
                        onCommentTap: () => _openPostDetail(post),
                      ),
                      const SizedBox(height: 18),
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
          iconSize: 32,
        ),
        const Spacer(),
        IconButton(
          onPressed: onMore,
          icon: const Icon(Icons.more_horiz_rounded, size: 32),
          color: Colors.white,
        ),
      ],
    );
  }
}

class _ProfileAvatarHero extends StatelessWidget {
  const _ProfileAvatarHero({required this.avatarAsset});

  final String avatarAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 222,
      height: 222,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipOval(child: Image.asset(avatarAsset, fit: BoxFit.cover)),
    );
  }
}

class _ProfileActionButtons extends StatelessWidget {
  const _ProfileActionButtons({
    required this.onChat,
    required this.onFollow,
    required this.isFollowed,
    required this.isDisabled,
  });

  final VoidCallback? onChat;
  final VoidCallback? onFollow;
  final bool isFollowed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onChat,
          child: Image.asset(
            SquadPingAssets.communityChatButton,
            width: 168,
            height: 61,
            fit: BoxFit.fill,
            color: onChat == null ? Colors.white.withValues(alpha: 0.35) : null,
            colorBlendMode: onChat == null ? BlendMode.srcATop : null,
          ),
        ),
        const SizedBox(width: 18),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onFollow,
          child: Image.asset(
            isFollowed
                ? SquadPingAssets.communityFollowedButton
                : SquadPingAssets.communityFollowButton,
            width: 168,
            height: 61,
            fit: BoxFit.fill,
            color: isDisabled ? Colors.white.withValues(alpha: 0.35) : null,
            colorBlendMode: isDisabled ? BlendMode.srcATop : null,
          ),
        ),
      ],
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.followingCount, required this.fansCount});

  final int followingCount;
  final int fansCount;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 344,
        height: 64,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _Stat(label: 'Follow', value: '$followingCount'),
              ),
              Container(width: 1, height: 38, color: const Color(0xFFE2E2E8)),
              Expanded(
                child: _Stat(label: 'Fans', value: '$fansCount'),
              ),
            ],
          ),
        ),
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
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: const Color(0xFF25202F),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

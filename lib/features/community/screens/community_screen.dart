import 'package:flutter/material.dart';

import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../data/community_seed.dart';
import '../models/community_models.dart';
import '../services/community_local_store.dart';
import '../widgets/community_post_card.dart';
import 'community_ai_assistant_screen.dart';
import 'community_release_screen.dart';
import 'community_topic_detail_screen.dart';
import 'community_user_profile_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _safetyStore = SafetyActionStore.instance;
  final _localStore = CommunityLocalStore.instance;
  late final List<CommunityPost> _posts;
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _posts = [...CommunitySeed.posts];
    _initialize();
    _safetyStore.addListener(_refresh);
    _localStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _safetyStore.removeListener(_refresh);
    _localStore.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _initialize() async {
    await Future.wait([_safetyStore.initialize(), _localStore.initialize()]);
    if (mounted) {
      setState(() => _isReady = true);
    }
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _openUser(CommunityUser user) {
    if (_safetyStore.isUserBlocked(user.id)) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunityUserProfileScreen(user: user, posts: _posts),
      ),
    );
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

  Future<void> _openSafety(CommunityPost post) async {
    final changed = await showSafetyActionSheet(
      context: context,
      contentId: post.id,
      authorId: post.author.id,
      authorName: post.author.displayName,
    );
    if (changed && mounted) {
      setState(() {});
    }
  }

  void _openTopic(CommunityPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunityTopicDetailScreen(
          post: post,
          onPostChanged: (updatedPost) {
            final index = _posts.indexWhere(
              (item) => item.id == updatedPost.id,
            );
            if (index != -1) {
              setState(() => _posts[index] = updatedPost);
            }
          },
        ),
      ),
    );
  }

  void _openAiAssistant() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CommunityAiAssistantScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visiblePosts = _posts
        .where(
          (post) =>
              !_safetyStore.isContentHidden(post.id, authorId: post.author.id),
        )
        .toList();
    final visibleUsers = CommunitySeed.users
        .where((user) => user.id != CommunitySeed.viewer.id)
        .where((user) => !_safetyStore.isUserBlocked(user.id))
        .toList();

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
                    const Color(0xFF6535F2).withValues(alpha: 0.80),
                    const Color(0xFF7B42F7).withValues(alpha: 0.70),
                    const Color(0xFFC64FF5).withValues(alpha: 0.55),
                  ],
                ),
              ),
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
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 126),
                        children: [
                          _CommunityHeader(
                            onRelease: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      const CommunityReleaseScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          _UserStrip(users: visibleUsers, onUserTap: _openUser),
                          const SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _openAiAssistant,
                              child: Image.asset(
                                SquadPingAssets.aiAssistantButton,
                                width: 344,
                                height: 70,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (visiblePosts.isEmpty)
                            buildSquadEmptyState()
                          else
                            for (final post in visiblePosts) ...[
                              CommunityPostCard(
                                post: post,
                                onCardTap: () => _openTopic(post),
                                onAuthorTap: () => _openUser(post.author),
                                onMoreTap: () => _openSafety(post),
                                onLikeTap: () => _toggleLike(post),
                                onCommentTap: () => _openTopic(post),
                              ),
                              const SizedBox(height: 24),
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

class _CommunityHeader extends StatelessWidget {
  const _CommunityHeader({required this.onRelease});

  final VoidCallback onRelease;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Community',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontSize: 34,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onRelease,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF633FEF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF633FEF).withValues(alpha: 0.40),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 42),
          ),
        ),
      ],
    );
  }
}

class _UserStrip extends StatelessWidget {
  const _UserStrip({required this.users, required this.onUserTap});

  final List<CommunityUser> users;
  final ValueChanged<CommunityUser> onUserTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 106,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        separatorBuilder: (_, _) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final user = users[index];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onUserTap(user),
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      user.avatarAsset,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    user.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

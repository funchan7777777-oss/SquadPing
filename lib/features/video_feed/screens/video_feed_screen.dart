import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/moderation/moderation_queue.dart';
import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../data/video_feed_seed.dart';
import '../models/video_feed_models.dart';
import '../widgets/video_comments_sheet.dart';
import '../widgets/video_player_surface.dart';
import 'video_release_screen.dart';

class VideoFeedScreen extends StatefulWidget {
  const VideoFeedScreen({super.key});

  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  final _safetyStore = SafetyActionStore.instance;
  late final PageController _pageController;
  late final List<VideoPost> _posts;
  var _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _posts = [...VideoFeedSeed.posts];
    _safetyStore.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
    _safetyStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _safetyStore.removeListener(_refresh);
    _pageController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {
        final visibleLength = _posts
            .where(
              (post) => !_safetyStore.isContentHidden(
                post.id,
                authorId: post.creator.id,
              ),
            )
            .length;
        final lastIndex = visibleLength - 1;
        if (_activeIndex > lastIndex) {
          _activeIndex = lastIndex < 0 ? 0 : lastIndex;
        }
      });
    }
  }

  Future<void> _openRelease() async {
    final result = await Navigator.of(context).push<VideoDraftResult>(
      MaterialPageRoute(builder: (_) => const VideoReleaseScreen()),
    );
    if (result == null || !mounted) {
      return;
    }
    await ModerationQueue.instance.enqueuePending(
      itemId: 'video-${DateTime.now().microsecondsSinceEpoch}',
      itemType: 'video_post',
      text: result.caption,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _activeIndex = 0;
    });
    await showModerationQueuedDialog(context);
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  void _replacePost(VideoPost post) {
    final index = _posts.indexWhere((item) => item.id == post.id);
    if (index == -1) {
      return;
    }
    setState(() => _posts[index] = post);
  }

  void _toggleLike(VideoPost post) {
    final nextLiked = !post.isLiked;
    _replacePost(
      post.copyWith(
        isLiked: nextLiked,
        likeCount: post.likeCount + (nextLiked ? 1 : -1),
      ),
    );
  }

  void _addComment(VideoPost post, VideoComment comment) {
    final index = _posts.indexWhere((item) => item.id == post.id);
    if (index == -1) {
      return;
    }
    final currentPost = _posts[index];
    setState(() {
      _posts[index] = currentPost.copyWith(
        comments: [comment, ...currentPost.comments],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final visiblePosts = _posts
        .where(
          (post) =>
              !_safetyStore.isContentHidden(post.id, authorId: post.creator.id),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: visiblePosts.isEmpty
          ? buildSquadEmptyState()
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) => setState(() => _activeIndex = index),
              itemCount: visiblePosts.length,
              itemBuilder: (context, index) {
                final post = visiblePosts[index];
                return _VideoPostPage(
                  post: post,
                  commentCount: _visibleCommentCount(post),
                  isActive: index == _activeIndex,
                  onRelease: _openRelease,
                  onLike: () => _toggleLike(post),
                  onComment: () {
                    showVideoCommentsSheet(
                      context: context,
                      comments: post.comments,
                      onCommentAdded: (comment) => _addComment(post, comment),
                    );
                  },
                  onMore: () => _openPostSafety(context, post),
                );
              },
            ),
    );
  }

  int _visibleCommentCount(VideoPost post) {
    return post.comments
        .where(
          (comment) => !_safetyStore.isContentHidden(
            _commentContentId(comment),
            authorId: comment.author.id,
          ),
        )
        .length;
  }

  String _commentContentId(VideoComment comment) {
    return 'video-comment-${comment.author.id}-${comment.sentAt}-${comment.message.hashCode}';
  }

  Future<void> _openPostSafety(BuildContext context, VideoPost post) async {
    final changed = await showSafetyActionSheet(
      context: context,
      contentId: post.id,
      authorId: post.creator.id,
      authorName: post.creator.displayName,
    );
    if (changed && mounted) {
      setState(() {});
    }
  }
}

class _VideoPostPage extends StatelessWidget {
  const _VideoPostPage({
    required this.post,
    required this.commentCount,
    required this.isActive,
    required this.onRelease,
    required this.onLike,
    required this.onComment,
    required this.onMore,
  });

  final VideoPost post;
  final int commentCount;
  final bool isActive;
  final VoidCallback onRelease;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayerSurface(asset: post.videoAsset, isActive: isActive),
        const IgnorePointer(child: _VideoGradient()),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                squadCompactTopPadding(context),
                20,
                0,
              ),
              child: _VideoHeader(onRelease: onRelease),
            ),
          ),
        ),
        Positioned(
          right: 24,
          bottom: 230,
          child: _ActionRail(
            post: post,
            commentCount: commentCount,
            onLike: onLike,
            onComment: onComment,
            onMore: onMore,
          ),
        ),
        Positioned(
          left: 20,
          right: 92,
          bottom: 72,
          child: _CreatorCaption(post: post),
        ),
      ],
    );
  }
}

class _VideoGradient extends StatelessWidget {
  const _VideoGradient();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF5438E8).withValues(alpha: 0.32),
            const Color(0xFF4E7FE8).withValues(alpha: 0.18),
            Colors.black.withValues(alpha: 0.74),
          ],
          stops: const [0, 0.46, 1],
        ),
      ),
    );
  }
}

class _VideoHeader extends StatelessWidget {
  const _VideoHeader({required this.onRelease});

  final VoidCallback onRelease;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'video',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onRelease,
          child: Container(
            width: 48,
            height: 48,
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
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 38),
          ),
        ),
      ],
    );
  }
}

class _ActionRail extends StatelessWidget {
  const _ActionRail({
    required this.post,
    required this.commentCount,
    required this.onLike,
    required this.onComment,
    required this.onMore,
  });

  final VideoPost post;
  final int commentCount;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoundActionButton(
          icon: Icons.mode_comment_outlined,
          label: '$commentCount',
          onTap: onComment,
        ),
        const SizedBox(height: 10),
        _RoundActionButton(
          icon: post.isLiked
              ? Icons.thumb_up_alt_rounded
              : Icons.thumb_up_alt_outlined,
          label: _compactCount(post.likeCount),
          onTap: onLike,
          isActive: post.isLiked,
        ),
        const SizedBox(height: 10),
        _RoundActionButton(
          icon: Icons.more_horiz_rounded,
          label: 'More',
          onTap: onMore,
        ),
      ],
    );
  }

  String _compactCount(int count) {
    return '$count';
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF0F3E55).withValues(alpha: 0.88),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Icon(
                icon,
                color: isActive ? const Color(0xFFFF7BDA) : Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatorCaption extends StatelessWidget {
  const _CreatorCaption({required this.post});

  final VideoPost post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                post.creator.avatarAsset,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                post.creator.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${post.creator.age} years old',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.86),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          post.caption,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            height: 1.24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

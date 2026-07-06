import 'package:flutter/material.dart';

import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../data/community_seed.dart';
import '../models/community_models.dart';
import '../widgets/community_post_card.dart';
import 'community_user_profile_screen.dart';

class CommunityTopicDetailScreen extends StatefulWidget {
  const CommunityTopicDetailScreen({
    super.key,
    required this.post,
    required this.onPostChanged,
  });

  final CommunityPost post;
  final ValueChanged<CommunityPost> onPostChanged;

  @override
  State<CommunityTopicDetailScreen> createState() =>
      _CommunityTopicDetailScreenState();
}

class _CommunityTopicDetailScreenState
    extends State<CommunityTopicDetailScreen> {
  final _safetyStore = SafetyActionStore.instance;
  late final TextEditingController _commentController;
  late CommunityPost _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _commentController = TextEditingController();
    _safetyStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _safetyStore.removeListener(_refresh);
    _commentController.dispose();
    super.dispose();
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
        builder: (_) => CommunityUserProfileScreen(user: user, posts: [_post]),
      ),
    );
  }

  void _toggleLike() {
    final liked = !_post.isLiked;
    setState(() {
      _post = _post.copyWith(
        isLiked: liked,
        likeCount: _post.likeCount + (liked ? 1 : -1),
      );
    });
    widget.onPostChanged(_post);
  }

  void _addComment() {
    final message = _commentController.text.trim();
    if (message.isEmpty) {
      return;
    }
    final comment = CommunityComment(
      id: 'comment-${DateTime.now().microsecondsSinceEpoch}',
      author: CommunitySeed.viewer,
      message: message,
      sentAt: 'just now',
    );
    setState(() {
      _post = _post.copyWith(comments: [comment, ..._post.comments]);
      _commentController.clear();
    });
    widget.onPostChanged(_post);
    FocusScope.of(context).unfocus();
  }

  Future<void> _openSafety({
    required String contentId,
    required CommunityUser author,
    bool allowBlock = true,
  }) async {
    final changed = await showSafetyActionSheet(
      context: context,
      contentId: contentId,
      authorId: author.id,
      authorName: author.displayName,
      allowBlock: allowBlock,
    );
    if (changed && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleComments = _post.comments
        .where(
          (comment) => !_safetyStore.isContentHidden(
            comment.id,
            authorId: comment.author.id,
          ),
        )
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 116),
                  children: [
                    _DetailHeader(onBack: () => Navigator.of(context).pop()),
                    const SizedBox(height: 12),
                    CommunityPostCard(
                      post: _post,
                      onAuthorTap: () => _openUser(_post.author),
                      onMoreTap: () => _openSafety(
                        contentId: _post.id,
                        author: _post.author,
                      ),
                      onLikeTap: _toggleLike,
                      onCommentTap: () {},
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Comment',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (visibleComments.isEmpty)
                      buildSquadEmptyState()
                    else
                      for (final comment in visibleComments) ...[
                        _CommentRow(
                          comment: comment,
                          onAuthorTap: () => _openUser(comment.author),
                          onMoreTap: () => _openSafety(
                            contentId: comment.id,
                            author: comment.author,
                          ),
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  minLines: 1,
                  maxLines: 3,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _addComment(),
                  decoration: InputDecoration(
                    hintText: 'Enter what you want to send',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _addComment,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(SquadPingAssets.sendGlyph),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.onBack});

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
            'Details',
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

class _CommentRow extends StatelessWidget {
  const _CommentRow({
    required this.comment,
    required this.onAuthorTap,
    required this.onMoreTap,
  });

  final CommunityComment comment;
  final VoidCallback onAuthorTap;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onAuthorTap,
          child: ClipOval(
            child: Image.asset(
              comment.author.avatarAsset,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onAuthorTap,
                      child: Text(
                        comment.author.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ),
                  Text(
                    '${comment.author.age} years old',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                  IconButton(
                    onPressed: onMoreTap,
                    icon: const Icon(Icons.more_horiz_rounded),
                    color: Colors.white,
                  ),
                ],
              ),
              Text(
                comment.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                comment.sentAt,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.56),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../data/video_feed_seed.dart';
import '../models/video_feed_models.dart';
import 'video_comment_composer.dart';

Future<void> showVideoCommentsSheet({
  required BuildContext context,
  required List<VideoComment> comments,
  required ValueChanged<VideoComment> onCommentAdded,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.54),
    builder: (context) =>
        _VideoCommentsSheet(comments: comments, onCommentAdded: onCommentAdded),
  );
}

class _VideoCommentsSheet extends StatefulWidget {
  const _VideoCommentsSheet({
    required this.comments,
    required this.onCommentAdded,
  });

  final List<VideoComment> comments;
  final ValueChanged<VideoComment> onCommentAdded;

  @override
  State<_VideoCommentsSheet> createState() => _VideoCommentsSheetState();
}

class _VideoCommentsSheetState extends State<_VideoCommentsSheet> {
  final _safetyStore = SafetyActionStore.instance;
  late final TextEditingController _controller;
  late final List<VideoComment> _comments;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _comments = [...widget.comments];
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
    _controller.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _sendComment() {
    final message = _controller.text.trim();
    if (message.isEmpty) {
      return;
    }
    final comment = VideoComment(
      author: VideoFeedSeed.viewer,
      message: message,
      sentAt: 'just now',
    );
    setState(() {
      _comments.insert(0, comment);
      _controller.clear();
    });
    widget.onCommentAdded(comment);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    const sheetRadius = BorderRadius.vertical(top: Radius.circular(32));
    final visibleComments = _comments
        .where(
          (comment) => !_safetyStore.isContentHidden(
            _commentContentId(comment),
            authorId: comment.author.id,
          ),
        )
        .toList();

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: FractionallySizedBox(
        heightFactor: 0.58,
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: sheetRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.34),
                blurRadius: 34,
                offset: const Offset(0, -16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: sheetRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF12395A).withValues(alpha: 0.94),
                      const Color(0xFF0D4050).withValues(alpha: 0.90),
                      const Color(0xFF112D45).withValues(alpha: 0.96),
                    ],
                    stops: const [0, 0.48, 1],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
                      child: Row(
                        children: [
                          Text(
                            'Comment',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 28,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const Spacer(),
                          Semantics(
                            button: true,
                            label: 'Close comments',
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFF7E48),
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Color(0xFFFF7E48),
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: visibleComments.isEmpty
                          ? buildSquadEmptyState()
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                30,
                                12,
                                28,
                                10,
                              ),
                              itemCount: visibleComments.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 28),
                              itemBuilder: (context, index) {
                                final comment = visibleComments[index];
                                return _CommentRow(
                                  comment: comment,
                                  onMoreTap: () async {
                                    final changed = await showSafetyActionSheet(
                                      context: context,
                                      contentId: _commentContentId(comment),
                                      authorId: comment.author.id,
                                      authorName: comment.author.displayName,
                                      allowBlock:
                                          comment.author.id !=
                                          VideoFeedSeed.viewer.id,
                                    );
                                    if (changed && mounted) {
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                    VideoCommentComposer(
                      controller: _controller,
                      onSend: _sendComment,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _commentContentId(VideoComment comment) {
    return 'video-comment-${comment.author.id}-${comment.sentAt}-${comment.message.hashCode}';
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({required this.comment, required this.onMoreTap});

  final VideoComment comment;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            comment.author.avatarAsset,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            comment.author.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 24,
                                  height: 1.1,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          '${comment.author.age} years old',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.78),
                                fontSize: 16,
                                height: 1.1,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Semantics(
                    button: true,
                    label: 'More actions',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onMoreTap,
                      child: const SizedBox(
                        width: 36,
                        height: 30,
                        child: Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                comment.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  height: 1.34,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                comment.sentAt,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.54),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

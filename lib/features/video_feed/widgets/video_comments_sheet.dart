import 'package:flutter/material.dart';

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
    builder: (context) => _VideoCommentsSheet(
      comments: comments,
      onCommentAdded: onCommentAdded,
    ),
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
  late final TextEditingController _controller;
  late final List<VideoComment> _comments;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _comments = [...widget.comments];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: FractionallySizedBox(
        heightFactor: 0.62,
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF173B50).withValues(alpha: 0.86),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.30),
                blurRadius: 28,
                offset: const Offset(0, -12),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 8),
                child: Row(
                  children: [
                    Text(
                      'Comment',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: const Color(0xFFFF844F),
                      style: IconButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFFF844F),
                          width: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                  itemCount: _comments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    return _CommentRow(comment: _comments[index]);
                  },
                ),
              ),
              VideoCommentComposer(controller: _controller, onSend: _sendComment),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({required this.comment});

  final VideoComment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            comment.author.avatarAsset,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      comment.author.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '${comment.author.age} years old',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_horiz_rounded, color: Colors.white),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                comment.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  height: 1.32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                comment.sentAt,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.60),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../models/community_models.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({
    super.key,
    required this.post,
    required this.onCardTap,
    required this.onAuthorTap,
    required this.onMoreTap,
    required this.onLikeTap,
    required this.onCommentTap,
    this.compact = false,
  });

  final CommunityPost post;
  final VoidCallback onCardTap;
  final VoidCallback onAuthorTap;
  final VoidCallback onMoreTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final avatarSize = compact ? 44.0 : 52.0;
    final nameSize = compact ? 19.0 : 21.0;
    final messageSize = compact ? 15.5 : 17.0;
    final cardPadding = compact
        ? const EdgeInsets.fromLTRB(12, 12, 12, 12)
        : const EdgeInsets.fromLTRB(14, 14, 14, 14);
    final imageRadius = compact ? 7.0 : 8.0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onCardTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.34),
            width: 1.4,
          ),
        ),
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onAuthorTap,
                  child: ClipOval(
                    child: Image.asset(
                      post.author.avatarAsset,
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: compact ? 10 : 12),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onAuthorTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: nameSize,
                                height: 1.08,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${post.author.age} years old',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.76),
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onMoreTap,
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    size: compact ? 28 : 30,
                  ),
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: compact ? 14 : 16),
            Text(
              post.message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: messageSize,
                height: 1.28,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: compact ? 12 : 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(imageRadius),
              child: AspectRatio(
                aspectRatio: 630 / 368,
                child: Image.asset(post.imageAsset, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: compact ? 12 : 14),
            Row(
              children: [
                _MetricButton(
                  icon: post.isLiked
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_up_alt_outlined,
                  label: '${post.likeCount}',
                  onTap: onLikeTap,
                  isActive: post.isLiked,
                ),
                const SizedBox(width: 26),
                _MetricButton(
                  icon: Icons.mode_comment_outlined,
                  label: '${post.comments.length}',
                  onTap: onCommentTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricButton extends StatelessWidget {
  const _MetricButton({
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
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? const Color(0xFFFFD84B) : Colors.white,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

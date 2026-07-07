import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/safety/safety_text_guard.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../data/game_zone_seed.dart';
import '../models/game_zone_models.dart';
import '../widgets/game_zone_composer.dart';
import '../widgets/player_profile_sheet.dart';

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({super.key, required this.game});

  final GameTitle game;

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  final _safetyStore = SafetyActionStore.instance;
  late final TextEditingController _commentController;
  late final List<GameComment> _comments;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _comments = [...widget.game.comments];
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
    _commentController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _sendComment() {
    final message = _commentController.text.trim();
    if (message.isEmpty) {
      return;
    }
    final safetyCheck = SafetyTextGuard.check(message, fieldLabel: 'Comment');
    if (!safetyCheck.isAllowed) {
      showSafetyTextBlockedDialog(context, safetyCheck);
      return;
    }
    setState(() {
      _comments.insert(
        0,
        GameComment(
          author: GameZoneSeed.viewer,
          message: message,
          postedAt: 'Now',
        ),
      );
      _commentController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _openCommentSafety(GameComment comment) async {
    final changed = await showSafetyActionSheet(
      context: context,
      contentId: _commentContentId(comment),
      authorId: comment.author.id,
      authorName: comment.author.displayName,
      allowBlock: comment.author.id != GameZoneSeed.viewer.id,
    );
    if (changed && mounted) {
      setState(() {});
    }
  }

  String _commentContentId(GameComment comment) {
    return 'game-comment-${widget.game.id}-${comment.author.id}-${comment.postedAt}-${comment.message.hashCode}';
  }

  @override
  Widget build(BuildContext context) {
    final visibleComments = _comments
        .where(
          (comment) => !_safetyStore.isContentHidden(
            _commentContentId(comment),
            authorId: comment.author.id,
          ),
        )
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(SquadPingAssets.background, fit: BoxFit.fill),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverToBoxAdapter(child: _GameHero(game: widget.game)),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 116),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _DescriptionCard(game: widget.game),
                        const SizedBox(height: 18),
                        _CommentHeader(count: visibleComments.length),
                        const SizedBox(height: 12),
                        if (visibleComments.isEmpty)
                          buildSquadEmptyState(size: 126)
                        else
                          for (final comment in visibleComments) ...[
                            _CommentTile(
                              comment: comment,
                              onMoreTap: () => _openCommentSafety(comment),
                            ),
                            const SizedBox(height: 12),
                          ],
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: GameZoneComposer(
                  controller: _commentController,
                  hintText: 'Enter what you want to send',
                  onSend: _sendComment,
                  showBackground: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameHero extends StatelessWidget {
  const _GameHero({required this.game});

  final GameTitle game;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(game.coverAsset, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.20),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
          Positioned(
            top: squadCompactTopPadding(context),
            left: 12,
            child: _RoundBackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [for (final tag in game.tags) _GameTag(label: tag)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  const _RoundBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.28),
        foregroundColor: Colors.white,
      ),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }
}

class _GameTag extends StatelessWidget {
  const _GameTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.game});

  final GameTitle game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        game.detail,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: const Color(0xFF141018),
          height: 1.38,
        ),
      ),
    );
  }
}

class _CommentHeader extends StatelessWidget {
  const _CommentHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Comment',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment, required this.onMoreTap});

  final GameComment comment;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => showPlayerProfileSheet(context, comment.author),
            child: ClipOval(
              child: Image.asset(
                comment.author.avatarAsset,
                width: 46,
                height: 46,
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
                    Text(
                      comment.postedAt,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onMoreTap,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(6, 3, 0, 3),
                        child: Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${comment.author.age} years old   ${comment.author.country}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  comment.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    height: 1.32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

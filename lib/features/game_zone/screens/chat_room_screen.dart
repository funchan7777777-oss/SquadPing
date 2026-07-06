import 'package:flutter/material.dart';

import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../data/game_zone_seed.dart';
import '../models/game_zone_models.dart';
import '../widgets/game_zone_composer.dart';
import '../widgets/player_profile_sheet.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.room});

  final ChatRoom room;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen>
    with SingleTickerProviderStateMixin {
  final _safetyStore = SafetyActionStore.instance;
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;
  late final AnimationController _roomMotionController;
  late final Animation<double> _roomFadeAnimation;
  late final Animation<Offset> _roomSlideAnimation;
  late final Animation<Offset> _composerSlideAnimation;
  late final List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _roomMotionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 240),
    );
    final roomCurve = CurvedAnimation(
      parent: _roomMotionController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _roomFadeAnimation = roomCurve;
    _roomSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.035),
      end: Offset.zero,
    ).animate(roomCurve);
    _composerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.24), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _roomMotionController,
            curve: const Interval(0.22, 1, curve: Curves.easeOutCubic),
            reverseCurve: Curves.easeInCubic,
          ),
        );
    _messages = [...widget.room.messages];
    _safetyStore.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
    _safetyStore.addListener(_refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToLatest());
    _roomMotionController.forward();
  }

  @override
  void dispose() {
    _safetyStore.removeListener(_refresh);
    _roomMotionController.dispose();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }
    setState(() {
      _messages.add(
        ChatMessage(
          author: GameZoneSeed.viewer,
          message: message,
          sentAt: 'Now',
          fromViewer: true,
        ),
      );
      _messageController.clear();
    });
    FocusScope.of(context).unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToLatest());
  }

  String get _roomContentId => 'chat-room-${widget.room.id}';

  Future<void> _openRoomSafety() async {
    final changed = await showSafetyActionSheet(
      context: context,
      contentId: _roomContentId,
      authorId: _roomContentId,
      authorName: widget.room.name,
    );
    if (!changed || !mounted) {
      return;
    }
    if (_safetyStore.isContentHidden(
      _roomContentId,
      authorId: _roomContentId,
    )) {
      Navigator.of(context).pop();
    } else {
      setState(() {});
    }
  }

  void _jumpToLatest() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _scrollToLatest() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleParticipants = widget.room.participants
        .where((player) => !_safetyStore.isUserBlocked(player.id))
        .toList();
    final visibleMessages = _messages
        .where((message) => !_safetyStore.isUserBlocked(message.author.id))
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF8C25F4),
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
                    const Color(0xFF6F22EA).withValues(alpha: 0.55),
                    const Color(0xFF7B27EE).withValues(alpha: 0.30),
                    const Color(0xFFFF4AD8).withValues(alpha: 0.32),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: _roomFadeAnimation,
              child: SlideTransition(
                position: _roomSlideAnimation,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      children: [
                        _ChatHeader(
                          roomName: widget.room.name,
                          onMoreTap: _openRoomSafety,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                          child: _WelcomeBanner(room: widget.room),
                        ),
                        const SizedBox(height: 12),
                        _RoomMemberStrip(
                          players: visibleParticipants,
                          memberCount: widget.room.memberCount,
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: visibleMessages.isEmpty
                              ? buildSquadEmptyState()
                              : ListView.builder(
                                  controller: _scrollController,
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  padding: const EdgeInsets.fromLTRB(
                                    18,
                                    8,
                                    18,
                                    112,
                                  ),
                                  itemCount: visibleMessages.length,
                                  itemBuilder: (context, index) {
                                    final message = visibleMessages[index];
                                    return _ChatMessageReveal(
                                      index: index,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: _ChatMessageTile(
                                          message: message,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _composerSlideAnimation,
              child: FadeTransition(
                opacity: _roomFadeAnimation,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: GameZoneComposer(
                      controller: _messageController,
                      hintText: 'Enter what you want to send',
                      onSend: _sendMessage,
                      showBackground: false,
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

class _ChatMessageReveal extends StatelessWidget {
  const _ChatMessageReveal({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final stagger = index > 8 ? 240 : index * 30;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + stagger),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.roomName, required this.onMoreTap});

  final String roomName;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 14, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
          ),
          Expanded(
            child: Text(
              roomName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: onMoreTap,
            icon: const Icon(Icons.more_horiz_rounded),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.room});

  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Text(
            room.welcomeLine,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFE7C7FF),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            room.topic,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Text(
              '${room.memberCount} members online',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomMemberStrip extends StatelessWidget {
  const _RoomMemberStrip({required this.players, required this.memberCount});

  final List<PlayerProfile> players;
  final int memberCount;

  @override
  Widget build(BuildContext context) {
    final remainingCount = memberCount > players.length
        ? memberCount - players.length
        : 0;
    final hasOverflowTile = remainingCount > 0;

    return SizedBox(
      height: 74,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: players.length + (hasOverflowTile ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (hasOverflowTile && index == players.length) {
            return _MoreOnlineMemberTile(count: remainingCount);
          }

          final player = players[index];
          return GestureDetector(
            onTap: () => showPlayerProfileSheet(context, player),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    player.avatarAsset,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 64,
                  child: Text(
                    player.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MoreOnlineMemberTile extends StatelessWidget {
  const _MoreOnlineMemberTile({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF4BEA), Color(0xFF5E31F5)],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.62),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4BEA).withValues(alpha: 0.26),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              '+$count',
              maxLines: 1,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'online',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessageTile extends StatelessWidget {
  const _ChatMessageTile({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final fromViewer =
        message.fromViewer || message.author.id == GameZoneSeed.viewer.id;
    final bubbleColor = fromViewer
        ? Colors.white.withValues(alpha: 0.94)
        : Colors.white.withValues(alpha: 0.18);
    final textColor = fromViewer ? const Color(0xFF26143B) : Colors.white;

    return Row(
      mainAxisAlignment: fromViewer
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!fromViewer) ...[
          _MessageAvatar(player: message.author),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: fromViewer
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (!fromViewer) ...[
                _SenderLine(player: message.author),
                const SizedBox(height: 6),
              ],
              Container(
                constraints: const BoxConstraints(maxWidth: 260),
                padding: const EdgeInsets.fromLTRB(13, 10, 13, 11),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: fromViewer ? 0 : 0.12,
                    ),
                  ),
                ),
                child: Text(
                  message.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    height: 1.28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                message.sentAt,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.64),
                ),
              ),
            ],
          ),
        ),
        if (fromViewer) ...[
          const SizedBox(width: 10),
          _MessageAvatar(player: message.author),
        ],
      ],
    );
  }
}

class _MessageAvatar extends StatelessWidget {
  const _MessageAvatar({required this.player});

  final PlayerProfile player;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPlayerProfileSheet(context, player),
      child: ClipOval(
        child: Image.asset(
          player.avatarAsset,
          width: 54,
          height: 54,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _SenderLine extends StatelessWidget {
  const _SenderLine({required this.player});

  final PlayerProfile player;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(
          player.displayName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          '${player.age} years old',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Icon(Icons.location_on_outlined, color: Colors.white, size: 16),
        Text(
          player.country,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

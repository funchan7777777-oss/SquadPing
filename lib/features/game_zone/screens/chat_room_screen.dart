import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
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

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final TextEditingController _messageController;
  late final List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messages = [...widget.room.messages];
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
          sentAt: 'now',
          fromViewer: true,
        ),
      );
      _messageController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    _ChatHeader(roomName: widget.room.name),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                      child: _WelcomeBanner(room: widget.room),
                    ),
                    const SizedBox(height: 12),
                    _RoomMemberStrip(players: widget.room.participants),
                    const SizedBox(height: 6),
                    Expanded(
                      child: ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 112),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _ChatMessageTile(message: message),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GameZoneComposer(
        controller: _messageController,
        hintText: 'Enter what you want to send',
        onSend: _sendMessage,
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.roomName});

  final String roomName;

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
          const SizedBox(width: 48),
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
        ],
      ),
    );
  }
}

class _RoomMemberStrip extends StatelessWidget {
  const _RoomMemberStrip({required this.players});

  final List<PlayerProfile> players;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: players.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
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

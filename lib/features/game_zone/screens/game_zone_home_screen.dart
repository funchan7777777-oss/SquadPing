import 'package:flutter/material.dart';

import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../data/game_zone_seed.dart';
import '../models/game_zone_models.dart';
import 'chat_room_screen.dart';
import 'game_detail_screen.dart';

enum _GameZoneShelf { game, chat }

class GameZoneHomeScreen extends StatefulWidget {
  const GameZoneHomeScreen({super.key});

  @override
  State<GameZoneHomeScreen> createState() => _GameZoneHomeScreenState();
}

class _GameZoneHomeScreenState extends State<GameZoneHomeScreen> {
  final _safetyStore = SafetyActionStore.instance;
  _GameZoneShelf _focusedShelf = _GameZoneShelf.game;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGameShelf = _focusedShelf == _GameZoneShelf.game;
    final visibleRooms = GameZoneSeed.rooms
        .where(
          (room) => !_safetyStore.isContentHidden(
            _chatRoomContentId(room),
            authorId: _chatRoomContentId(room),
          ),
        )
        .toList();

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _HeroPoster()),
              SliverPadding(
                padding: const EdgeInsets.only(top: 18),
                sliver: SliverToBoxAdapter(
                  child: _ShelfTabs(
                    focusedShelf: _focusedShelf,
                    onSelected: (shelf) {
                      setState(() => _focusedShelf = shelf);
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                sliver: SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: isGameShelf
                        ? _GameDeck(
                            key: const ValueKey('game-deck'),
                            games: GameZoneSeed.games,
                          )
                        : _ChatDeck(
                            key: const ValueKey('chat-deck'),
                            rooms: visibleRooms,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _chatRoomContentId(ChatRoom room) => 'chat-room-${room.id}';

class _HeroPoster extends StatelessWidget {
  const _HeroPoster();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 375 / 269,
      child: Image.asset(
        SquadPingAssets.gameZoneHero,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

class _ShelfTabs extends StatelessWidget {
  const _ShelfTabs({required this.focusedShelf, required this.onSelected});

  final _GameZoneShelf focusedShelf;
  final ValueChanged<_GameZoneShelf> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ShelfArtButton(
            label: 'Game',
            asset: focusedShelf == _GameZoneShelf.game
                ? SquadPingAssets.gameSegmentActive
                : SquadPingAssets.gameSegmentInactive,
            isSelected: focusedShelf == _GameZoneShelf.game,
            onPressed: () => onSelected(_GameZoneShelf.game),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ShelfArtButton(
            label: 'Chat room',
            asset: focusedShelf == _GameZoneShelf.chat
                ? SquadPingAssets.chatSegmentActive
                : SquadPingAssets.chatSegmentInactive,
            isSelected: focusedShelf == _GameZoneShelf.chat,
            onPressed: () => onSelected(_GameZoneShelf.chat),
          ),
        ),
      ],
    );
  }
}

class _ShelfArtButton extends StatelessWidget {
  const _ShelfArtButton({
    required this.label,
    required this.asset,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final String asset;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Image.asset(asset, height: 68, fit: BoxFit.fill),
      ),
    );
  }
}

class _DeckShell extends StatelessWidget {
  const _DeckShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(SquadPingAssets.gameZonePanel, fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 22),
            child: child,
          ),
        ],
      ),
    );
  }
}

BoxDecoration _deckCardDecoration() {
  return BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6331F6), Color(0xFF4B20DF)],
    ),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: const Color(0xFF9A6DFF).withValues(alpha: 0.62),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF7B42FF).withValues(alpha: 0.42),
        blurRadius: 18,
        spreadRadius: -4,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.28),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

class _GameDeck extends StatelessWidget {
  const _GameDeck({super.key, required this.games});

  final List<GameTitle> games;

  @override
  Widget build(BuildContext context) {
    return _DeckShell(
      child: Column(
        children: [
          for (final game in games) ...[
            _GameTile(
              game: game,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => GameDetailScreen(game: game),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile({required this.game, required this.onTap});

  final GameTitle game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: game.name,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 128,
          decoration: _deckCardDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    game.coverAsset,
                    width: 124,
                    height: 108,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              game.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                          Image.asset(
                            SquadPingAssets.hotGlyph,
                            width: 28,
                            height: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        game.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.74),
                          height: 1.24,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFD348),
                            size: 25,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            game.rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const Spacer(),
                          _HotDots(level: game.hotLevel),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HotDots extends StatelessWidget {
  const _HotDots({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < 5; index++)
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: index < level
                  ? const Color(0xFFFF4BEB)
                  : Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

class _ChatDeck extends StatelessWidget {
  const _ChatDeck({super.key, required this.rooms});

  final List<ChatRoom> rooms;

  @override
  Widget build(BuildContext context) {
    return _DeckShell(
      child: Column(
        children: [
          for (final room in rooms) ...[
            _ChatTile(
              room: room,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ChatRoomScreen(room: room),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.room, required this.onTap});

  final ChatRoom room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: room.name,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 128,
          decoration: _deckCardDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    room.coverAsset,
                    width: 124,
                    height: 108,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                          Image.asset(
                            SquadPingAssets.chatBadgeBubble,
                            width: 34,
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.74),
                          height: 1.24,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _ParticipantStack(players: room.participants),
                          const SizedBox(width: 8),
                          Text(
                            '+${room.participants.length * 3}',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const Spacer(),
                          _JoinPill(onTap: onTap),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ParticipantStack extends StatelessWidget {
  const _ParticipantStack({required this.players});

  final List<PlayerProfile> players;

  @override
  Widget build(BuildContext context) {
    final visiblePlayers = players.take(3).toList();

    return SizedBox(
      width: 58,
      height: 26,
      child: Stack(
        children: [
          for (final entry in visiblePlayers.asMap().entries)
            Positioned(
              left: entry.key * 16,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4D20E8), width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    entry.value.avatarAsset,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _JoinPill extends StatelessWidget {
  const _JoinPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        SquadPingAssets.chatJoinButton,
        width: 72,
        height: 36,
        fit: BoxFit.contain,
      ),
    );
  }
}

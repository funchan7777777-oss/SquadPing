import 'package:flutter/material.dart';

import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../../community/data/community_seed.dart';
import '../../community/models/community_models.dart';
import '../../community/screens/community_user_profile_screen.dart';
import '../../community/screens/community_video_call_screen.dart';
import '../../community/services/community_local_store.dart';

class InformationChatScreen extends StatefulWidget {
  const InformationChatScreen({super.key, required this.peer});

  final CommunityUser peer;

  @override
  State<InformationChatScreen> createState() => _InformationChatScreenState();
}

class _InformationChatScreenState extends State<InformationChatScreen> {
  final _localStore = CommunityLocalStore.instance;
  final _safetyStore = SafetyActionStore.instance;
  late final TextEditingController _messageController;
  var _messages = <LocalChatMessage>[];
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _load();
    _localStore.addListener(_load);
    _safetyStore.addListener(_load);
  }

  @override
  void dispose() {
    _localStore.removeListener(_load);
    _safetyStore.removeListener(_load);
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await Future.wait([_localStore.initialize(), _safetyStore.initialize()]);
    final messages = await _localStore.loadMessages(widget.peer.id);
    if (mounted) {
      setState(() {
        _messages = messages;
        _isReady = true;
      });
    }
  }

  bool _canChat({bool showNotice = true}) {
    if (_isChatHidden) {
      if (showNotice) {
        _showLockedNotice('This chat is hidden locally.');
      }
      return false;
    }
    if (!_localStore.isMutualFollow(widget.peer.id)) {
      if (showNotice) {
        _showLockedNotice(
          'Chat unlocks only after you and ${widget.peer.displayName} mutually follow each other.',
        );
      }
      return false;
    }
    return true;
  }

  bool get _isChatHidden {
    return _safetyStore.isContentHidden(
      'chat-${widget.peer.id}',
      authorId: widget.peer.id,
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    if (!_canChat()) {
      return;
    }
    await _localStore.appendMessage(
      LocalChatMessage(
        id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
        peerUserId: widget.peer.id,
        text: text,
        sentAt: DateTime.now(),
        fromViewer: true,
      ),
    );
    _messageController.clear();
    await _load();
  }

  void _startVideoCall() {
    if (!_canChat()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunityVideoCallScreen(peer: widget.peer),
      ),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunityUserProfileScreen(
          user: widget.peer,
          posts: CommunitySeed.posts,
        ),
      ),
    );
  }

  Future<void> _openSafety() async {
    await showSafetyActionSheet(
      context: context,
      contentId: 'chat-${widget.peer.id}',
      authorId: widget.peer.id,
      authorName: widget.peer.displayName,
    );
  }

  void _showLockedNotice(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          decoration: BoxDecoration(
            color: const Color(0xFF130821),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF8E63FF), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B3DFF).withValues(alpha: 0.32),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_person_rounded,
                color: Colors.white,
                size: 44,
              ),
              const SizedBox(height: 12),
              Text(
                'Mutual follow required',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.76),
                  height: 1.34,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF5A31EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hidden = _isChatHidden;

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
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6535F2).withValues(alpha: 0.84),
                    const Color(0xFF7C40F6).withValues(alpha: 0.74),
                    const Color(0xFFC855F7).withValues(alpha: 0.54),
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
                    _ChatHeader(
                      onBack: () => Navigator.of(context).pop(),
                      onMore: _openSafety,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: _PeerBanner(
                        peer: widget.peer,
                        onTap: _openProfile,
                      ),
                    ),
                    Expanded(
                      child: !_isReady
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : hidden
                          ? buildSquadEmptyState()
                          : _messages.isEmpty
                          ? buildSquadEmptyState()
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                22,
                                16,
                                24,
                              ),
                              itemCount: _messages.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                return _MessageBubble(
                                  message: _messages[index],
                                  peer: widget.peer,
                                  onPeerTap: _openProfile,
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _startVideoCall,
                    child: Image.asset(
                      SquadPingAssets.videoActionCamera,
                      width: 58,
                      height: 58,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          minLines: 1,
                          maxLines: 3,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
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
                        onTap: _sendMessage,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.onBack, required this.onMore});

  final VoidCallback onBack;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
          ),
          Expanded(
            child: Text(
              'Chat',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: onMore,
            icon: const Icon(Icons.more_horiz_rounded),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _PeerBanner extends StatelessWidget {
  const _PeerBanner({required this.peer, required this.onTap});

  final CommunityUser peer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                peer.avatarAsset,
                width: 64,
                height: 64,
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
                      Flexible(
                        child: Text(
                          peer.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${peer.age} years old',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.74),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        peer.country,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.peer,
    required this.onPeerTap,
  });

  final LocalChatMessage message;
  final CommunityUser peer;
  final VoidCallback onPeerTap;

  @override
  Widget build(BuildContext context) {
    final fromViewer = message.fromViewer;
    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 230),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: fromViewer ? const Color(0xFF4DBBFF) : Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        message.text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: fromViewer ? Colors.white : const Color(0xFF20202A),
          height: 1.28,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (fromViewer) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onPeerTap,
          child: ClipOval(
            child: Image.asset(
              peer.avatarAsset,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        bubble,
      ],
    );
  }
}

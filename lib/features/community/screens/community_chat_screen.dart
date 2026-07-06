import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../data/community_seed.dart';
import '../models/community_models.dart';
import '../services/community_local_store.dart';
import 'community_user_profile_screen.dart';
import 'community_video_call_screen.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key, required this.peer});

  final CommunityUser peer;

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final _store = CommunityLocalStore.instance;
  final _safetyStore = SafetyActionStore.instance;
  late final TextEditingController _messageController;
  List<LocalChatMessage> _messages = [];
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await Future.wait([_store.initialize(), _safetyStore.initialize()]);
    final messages = await _store.loadMessages(widget.peer.id);
    if (mounted) {
      setState(() {
        _messages = messages;
        _isReady = true;
      });
    }
  }

  bool _canChat({bool showNotice = true}) {
    if (_safetyStore.isUserBlocked(widget.peer.id)) {
      if (showNotice) {
        _showLockedNotice('This user is blocked locally.');
      }
      return false;
    }
    if (!_store.isMutualFollow(widget.peer.id)) {
      if (showNotice) {
        _showLockedNotice(
          'Chat unlocks only after you and ${widget.peer.displayName} mutually follow each other.',
        );
      }
      return false;
    }
    return true;
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    if (!_canChat()) {
      return;
    }
    final message = LocalChatMessage(
      id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
      peerUserId: widget.peer.id,
      text: text,
      sentAt: DateTime.now(),
      fromViewer: true,
    );
    await _store.appendMessage(message);
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

  void _openPeerProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunityUserProfileScreen(
          user: widget.peer,
          posts: CommunitySeed.posts,
        ),
      ),
    );
  }

  void _showLockedNotice(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF130821),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Mutual follow required',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blocked = _safetyStore.isUserBlocked(widget.peer.id);

    return Scaffold(
      extendBody: true,
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
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(top: squadCompactTopPadding(context)),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    children: [
                      _ChatHeader(
                        peer: widget.peer,
                        onBack: () => Navigator.of(context).pop(),
                        onVideoCall: _startVideoCall,
                        onPeerTap: _openPeerProfile,
                      ),
                      Expanded(
                        child: !_isReady
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : blocked
                            ? buildSquadEmptyState()
                            : _messages.isEmpty
                            ? buildSquadEmptyState()
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  110,
                                ),
                                itemCount: _messages.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return _MessageBubble(
                                    message: _messages[index],
                                    peer: widget.peer,
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
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.peer,
    required this.onBack,
    required this.onVideoCall,
    required this.onPeerTap,
  });

  final CommunityUser peer;
  final VoidCallback onBack;
  final VoidCallback onVideoCall;
  final VoidCallback onPeerTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
          ),
          GestureDetector(
            onTap: onPeerTap,
            child: ClipOval(
              child: Image.asset(
                peer.avatarAsset,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onPeerTap,
              child: Text(
                peer.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onVideoCall,
            icon: const Icon(Icons.videocam_rounded),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.peer});

  final LocalChatMessage message;
  final CommunityUser peer;

  @override
  Widget build(BuildContext context) {
    final author = message.fromViewer ? CommunitySeed.viewer : peer;

    return Row(
      mainAxisAlignment: message.fromViewer
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!message.fromViewer) ...[
          ClipOval(
            child: Image.asset(author.avatarAsset, width: 40, height: 40),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(13, 10, 13, 11),
            decoration: BoxDecoration(
              color: message.fromViewer
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              message.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: message.fromViewer
                    ? const Color(0xFF26143B)
                    : Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

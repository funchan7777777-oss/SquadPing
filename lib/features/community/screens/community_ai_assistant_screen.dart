import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_text_guard.dart';
import '../../../shared/visuals/squad_ping_assets.dart';

class CommunityAiAssistantScreen extends StatefulWidget {
  const CommunityAiAssistantScreen({super.key});

  @override
  State<CommunityAiAssistantScreen> createState() =>
      _CommunityAiAssistantScreenState();
}

class _CommunityAiAssistantScreenState
    extends State<CommunityAiAssistantScreen> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  final _messages = <_AiMessage>[
    const _AiMessage(
      text:
          'Hi Alex. I can help tune game picks, squad posts, intro lines, or tonight\'s queue plan.',
      isUser: false,
    ),
    const _AiMessage(
      text: 'Try asking: "What should I play with two friends tonight?"',
      isUser: false,
    ),
  ];
  var _isThinking = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendCurrentText() async {
    await _sendText(_controller.text);
  }

  Future<void> _sendText(String rawText) async {
    final text = rawText.trim();
    if (text.isEmpty || _isThinking) {
      return;
    }
    if (!await ensureSafetyTextAllowed(context, text, fieldLabel: 'Prompt')) {
      return;
    }
    setState(() {
      _messages.add(_AiMessage(text: text, isUser: true));
      _controller.clear();
      _isThinking = true;
    });
    _scrollToBottom();

    await Future<void>.delayed(const Duration(milliseconds: 520));
    if (!mounted) {
      return;
    }
    setState(() {
      _messages.add(
        _AiMessage(text: _buildAssistantReply(text), isUser: false),
      );
      _isThinking = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  String _buildAssistantReply(String text) {
    final normalized = text.toLowerCase();
    if (normalized.contains('post') || normalized.contains('caption')) {
      return 'Stronger squad-post angle: lead with the game mood, add one concrete clip or queue moment, then ask one easy reply question. Example: "Need a chill co-op run tonight. Who can take support after 8?"';
    }
    if (normalized.contains('squad') || normalized.contains('team')) {
      return 'For squad matching, say your mode, time window, and vibe. Try: "Need 2 for relaxed story co-op, voice optional, starting in 20 minutes." That gets clearer replies.';
    }
    if (normalized.contains('play') || normalized.contains('game')) {
      return 'Based on the community feed, pick one of three lanes: quick FPS warmup, relaxed story co-op, or racing clips. If you have two friends online, story co-op is the easiest low-pressure choice.';
    }
    return 'I would turn that into an actionable plan: choose the game mode, set a start time, name the vibe, and ask one direct question. Want me to draft the exact community post?';
  }

  @override
  Widget build(BuildContext context) {
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
                    const Color(0xFF5E24F4).withValues(alpha: 0.92),
                    const Color(0xFF7435EF).withValues(alpha: 0.84),
                    const Color(0xFFE14BEF).withValues(alpha: 0.74),
                  ],
                ),
              ),
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
                      _AssistantHeader(
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: ListView(
                          controller: _scrollController,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
                          children: [
                            const _AssistantSummaryCard(),
                            const SizedBox(height: 18),
                            for (final message in _messages) ...[
                              _MessageBubble(message: message),
                              const SizedBox(height: 12),
                            ],
                            if (_isThinking) ...[
                              const _TypingBubble(),
                              const SizedBox(height: 12),
                            ],
                          ],
                        ),
                      ),
                      _PromptSuggestions(onSuggestionTap: _sendText),
                      _AssistantComposer(
                        controller: _controller,
                        isSending: _isThinking,
                        onSend: _sendCurrentText,
                      ),
                    ],
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

class _AssistantHeader extends StatelessWidget {
  const _AssistantHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 22, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
            iconSize: 30,
          ),
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFF7030F4),
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Game AI Assistant',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7CFFB2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Online - squad and game planner',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.76),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssistantSummaryCard extends StatelessWidget {
  const _AssistantSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_alt_rounded,
              color: Color(0xFF7230F4),
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to help',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ask for game picks, community post drafts, squad matching lines, or quick clip ideas.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.34,
                    fontWeight: FontWeight.w700,
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

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _AiMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 310),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          decoration: BoxDecoration(
            color: isUser
                ? Colors.white
                : const Color(0xFF171144).withValues(alpha: 0.72),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(22),
              topRight: const Radius.circular(22),
              bottomLeft: Radius.circular(isUser ? 22 : 6),
              bottomRight: Radius.circular(isUser ? 6 : 22),
            ),
            border: isUser
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: Text(
            message.text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isUser ? const Color(0xFF281B52) : Colors.white,
              height: 1.34,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF171144).withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < 3; index++) ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  shape: BoxShape.circle,
                ),
              ),
              if (index != 2) const SizedBox(width: 5),
            ],
          ],
        ),
      ),
    );
  }
}

class _PromptSuggestions extends StatelessWidget {
  const _PromptSuggestions({required this.onSuggestionTap});

  final ValueChanged<String> onSuggestionTap;

  static const _suggestions = [
    'Pick tonight\'s game',
    'Draft squad post',
    'Write intro ping',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: _suggestions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSuggestionTap(suggestion),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              child: Text(
                suggestion,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AssistantComposer extends StatelessWidget {
  const _AssistantComposer({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 58,
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  enabled: !isSending,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask your squad planner',
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFBDB9C5),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isSending ? null : onSend,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  SquadPingAssets.sendGlyph,
                  width: 36,
                  height: 36,
                  color: isSending ? Colors.black26 : null,
                  colorBlendMode: isSending ? BlendMode.srcATop : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiMessage {
  const _AiMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}

import 'package:flutter/material.dart';

import '../../../shared/moderation/moderation_queue.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../data/community_seed.dart';

class CommunityReleaseScreen extends StatefulWidget {
  const CommunityReleaseScreen({super.key});

  @override
  State<CommunityReleaseScreen> createState() => _CommunityReleaseScreenState();
}

class _CommunityReleaseScreenState extends State<CommunityReleaseScreen> {
  static const _releaseCost = 10;

  late final TextEditingController _textController;
  var _selectedImage = CommunitySeed.posts.first.imageAsset;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _release() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Say something before releasing.')),
      );
      return;
    }
    await ModerationQueue.instance.enqueuePending(
      itemId: 'community-${DateTime.now().microsecondsSinceEpoch}',
      itemType: 'community_post',
      text: text,
    );
    if (!mounted) {
      return;
    }
    await showModerationQueuedDialog(context);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageOptions = CommunitySeed.posts
        .map((post) => post.imageAsset)
        .toSet()
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF7A35F5),
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
                    const Color(0xFF6535F2).withValues(alpha: 0.82),
                    const Color(0xFF8244F9).withValues(alpha: 0.74),
                    const Color(0xFFC855F7).withValues(alpha: 0.62),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
                  children: [
                    _ReleaseHeader(onBack: () => Navigator.of(context).pop()),
                    const SizedBox(height: 18),
                    Text(
                      'Let me introduce it.',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _TextBox(controller: _textController),
                    const SizedBox(height: 24),
                    Text(
                      'Add photos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 116,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageOptions.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final image = imageOptions[index];
                          final selected = image == _selectedImage;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedImage = image),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selected
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  image,
                                  width: 132,
                                  height: 116,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 42),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Unlocking dynamic posting costs\n',
                          ),
                          const TextSpan(text: '10 '),
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.monetization_on_rounded,
                              size: 23,
                              color: Color(0xFFFFD24A),
                            ),
                          ),
                          const TextSpan(text: ' gold coins.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.28,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        width: 268,
                        height: 68,
                        child: FilledButton(
                          onPressed: _release,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: Text(
                            'release',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: _releaseCost),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReleaseHeader extends StatelessWidget {
  const _ReleaseHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        Expanded(
          child: Text(
            'release',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _TextBox extends StatelessWidget {
  const _TextBox({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TextField(
        controller: controller,
        minLines: 6,
        maxLines: 9,
        decoration: InputDecoration(
          hintText: 'Say something',
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF9B9AA2)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        ),
      ),
    );
  }
}

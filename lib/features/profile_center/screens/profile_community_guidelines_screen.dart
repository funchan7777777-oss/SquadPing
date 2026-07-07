import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/visuals/squad_ping_assets.dart';

class ProfileCommunityGuidelinesScreen extends StatelessWidget {
  const ProfileCommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    18,
                    squadCompactTopPadding(context),
                    18,
                    28,
                  ),
                  children: [
                    _GuidelinesHeader(
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 18),
                    _IntroPanel(),
                    const SizedBox(height: 14),
                    for (final item in _guidelineItems) ...[
                      _GuidelineCard(item: item),
                      const SizedBox(height: 12),
                    ],
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

class _GuidelinesHeader extends StatelessWidget {
  const _GuidelinesHeader({required this.onBack});

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
            'Community Guidelines',
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

class _IntroPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF130821).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Text(
        'SquadPing is built for game fans to share clips, posts, and conversations safely. Chat is not anonymous, direct messages and video calls are available only after both users follow each other, and unsafe text is blocked before posting.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.84),
          height: 1.42,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GuidelineCard extends StatelessWidget {
  const _GuidelineCard({required this.item});

  final _GuidelineItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF130821).withValues(alpha: 0.52),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: Colors.white, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  item.body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.80),
                    height: 1.38,
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

class _GuidelineItem {
  const _GuidelineItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

const _guidelineItems = [
  _GuidelineItem(
    icon: Icons.verified_user_rounded,
    title: 'Use a real account identity',
    body:
        'Do not use the app for anonymous harassment, impersonation, scams, or attempts to evade safety actions.',
  ),
  _GuidelineItem(
    icon: Icons.handshake_rounded,
    title: 'Mutual follow before private chat',
    body:
        'Direct messages and video calls require both users to follow each other. Follow requests must be accepted by the other user.',
  ),
  _GuidelineItem(
    icon: Icons.campaign_rounded,
    title: 'Report unsafe content',
    body:
        'Use report tools on posts, comments, chat rooms, and messages for adult content, abuse, discrimination, threats, harassment, scams, misleading content, or other policy issues.',
  ),
  _GuidelineItem(
    icon: Icons.block_rounded,
    title: 'Block when needed',
    body:
        'Blocking a user hides their posts, comments, and chats locally. You can remove users from the blacklist in Settings.',
  ),
  _GuidelineItem(
    icon: Icons.auto_awesome_rounded,
    title: 'Posts may be reviewed',
    body:
        'New posts enter review before appearing publicly, and unsafe text is rejected before coins are spent. Content that violates these rules may stay hidden.',
  ),
  _GuidelineItem(
    icon: Icons.support_agent_rounded,
    title: 'Contact support for safety issues',
    body:
        'For moderation appeals, account help, or urgent safety concerns, use Contact support in Settings and keep the App Store support contact current.',
  ),
  _GuidelineItem(
    icon: Icons.favorite_rounded,
    title: 'Keep the game space respectful',
    body:
        'No exploitation, identity abuse, targeted bullying, threats, graphic violence, illegal activity, or spam. Keep game chat welcoming.',
  ),
];

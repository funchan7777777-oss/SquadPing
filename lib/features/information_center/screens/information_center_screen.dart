import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_action_store.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../../shared/widgets/squad_empty_state.dart';
import '../../community/data/community_seed.dart';
import '../../community/models/community_models.dart';
import '../../community/screens/community_topic_detail_screen.dart';
import '../../community/screens/community_user_profile_screen.dart';
import '../../community/services/community_local_store.dart';
import 'information_chat_screen.dart';
import 'information_follow_applications_screen.dart';

class InformationCenterScreen extends StatefulWidget {
  const InformationCenterScreen({super.key});

  @override
  State<InformationCenterScreen> createState() =>
      _InformationCenterScreenState();
}

class _InformationCenterScreenState extends State<InformationCenterScreen> {
  final _localStore = CommunityLocalStore.instance;
  final _safetyStore = SafetyActionStore.instance;
  var _threads = <_InformationThread>[];
  var _systemNotices = <_SystemNotice>[];
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _load();
    _localStore.addListener(_load);
    _safetyStore.addListener(_load);
  }

  @override
  void dispose() {
    _localStore.removeListener(_load);
    _safetyStore.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    await Future.wait([_localStore.initialize(), _safetyStore.initialize()]);
    final peerIds = <String>{
      ..._localStore.mutualFollowUserIds,
      ...await _localStore.loadChatPeerIds(),
    };
    final nextThreads = <_InformationThread>[];
    for (final peerId in peerIds) {
      if (!_localStore.isMutualFollow(peerId) ||
          _safetyStore.isContentHidden('chat-$peerId', authorId: peerId)) {
        continue;
      }
      final user = _userById(peerId);
      if (user == null || user.id == CommunitySeed.viewer.id) {
        continue;
      }
      final messages = await _localStore.loadMessages(peerId);
      nextThreads.add(_InformationThread(user: user, messages: messages));
    }
    nextThreads.sort((left, right) {
      final leftTime = left.lastMessage?.sentAt;
      final rightTime = right.lastMessage?.sentAt;
      if (leftTime == null && rightTime == null) {
        return left.user.displayName.compareTo(right.user.displayName);
      }
      if (leftTime == null) {
        return 1;
      }
      if (rightTime == null) {
        return -1;
      }
      return rightTime.compareTo(leftTime);
    });
    if (mounted) {
      setState(() {
        _threads = nextThreads;
        _systemNotices = _buildSystemNotices();
        _isReady = true;
      });
    }
  }

  List<_SystemNotice> _buildSystemNotices() {
    final notices = <_SystemNotice>[];
    for (final userId in _localStore.incomingFollowRequestIds) {
      final user = _visibleUserById(userId);
      if (user == null) {
        continue;
      }
      notices.add(
        _SystemNotice(
          id: 'follow-request-${user.id}',
          type: _SystemNoticeType.followRequest,
          user: user,
        ),
      );
    }
    for (final userId in _localStore.approvedFollowerIds) {
      final user = _visibleUserById(userId);
      if (user == null) {
        continue;
      }
      notices.add(
        _SystemNotice(
          id: 'follower-${user.id}',
          type: _SystemNoticeType.follower,
          user: user,
        ),
      );
    }

    final ownPosts = CommunitySeed.posts.where(
      (post) =>
          post.author.id == CommunitySeed.viewer.id &&
          !_safetyStore.isContentHidden(post.id, authorId: post.author.id),
    );
    for (final post in ownPosts) {
      for (final comment in post.comments) {
        if (comment.author.id == CommunitySeed.viewer.id ||
            _safetyStore.isUserBlocked(comment.author.id)) {
          continue;
        }
        notices.add(
          _SystemNotice(
            id: 'comment-${comment.id}',
            type: _SystemNoticeType.comment,
            user: comment.author,
            post: post,
            comment: comment,
          ),
        );
      }
      if (post.likeCount > 0) {
        notices.add(
          _SystemNotice(
            id: 'like-${post.id}',
            type: _SystemNoticeType.like,
            post: post,
            count: post.likeCount,
          ),
        );
      }
    }
    return notices;
  }

  CommunityUser? _userById(String userId) {
    for (final user in CommunitySeed.users) {
      if (user.id == userId) {
        return user;
      }
    }
    return null;
  }

  CommunityUser? _visibleUserById(String userId) {
    if (userId == CommunitySeed.viewer.id || _safetyStore.isUserBlocked(userId)) {
      return null;
    }
    return _userById(userId);
  }

  int get _incomingRequestCount {
    return _localStore.incomingFollowRequestIds.where((userId) {
      return !_safetyStore.isUserBlocked(userId) && _userById(userId) != null;
    }).length;
  }

  Future<void> _openApplications() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const InformationFollowApplicationsScreen(),
      ),
    );
    await _load();
  }

  Future<void> _openChat(CommunityUser user) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => InformationChatScreen(peer: user),
      ),
    );
    await _load();
  }

  void _openProfile(CommunityUser user) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            CommunityUserProfileScreen(user: user, posts: CommunitySeed.posts),
      ),
    );
  }

  Future<void> _openSystemNotice(_SystemNotice notice) async {
    switch (notice.type) {
      case _SystemNoticeType.followRequest:
        await _openApplications();
      case _SystemNoticeType.follower:
        final user = notice.user;
        if (user != null) {
          _openProfile(user);
        }
      case _SystemNoticeType.comment:
      case _SystemNoticeType.like:
        final post = notice.post;
        if (post == null) {
          return;
        }
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CommunityTopicDetailScreen(
              post: post,
              onPostChanged: (_) {},
            ),
          ),
        );
    }
  }

  Future<void> _deleteThread(CommunityUser user) async {
    await _localStore.deleteMessages(user.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF7138F5),
      child: Stack(
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
                    const Color(0xFF7C40F6).withValues(alpha: 0.72),
                    const Color(0xFFC855F7).withValues(alpha: 0.58),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: !_isReady
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          squadCompactTopPadding(context, extra: 4),
                          16,
                          112,
                        ),
                        children: [
                          Text(
                            'information',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 22),
                          _ApplicationButton(
                            requestCount: _incomingRequestCount,
                            onTap: _openApplications,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'System',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 12),
                          if (_systemNotices.isEmpty)
                            _SystemEmptyNote()
                          else
                            for (final notice in _systemNotices) ...[
                              _SystemNoticeTile(
                                notice: notice,
                                onTap: () => _openSystemNotice(notice),
                              ),
                              const SizedBox(height: 12),
                            ],
                          const SizedBox(height: 6),
                          Text(
                            'Friend',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 12),
                          if (_threads.isEmpty)
                            buildSquadEmptyState()
                          else
                            for (final thread in _threads) ...[
                              _FriendTile(
                                thread: thread,
                                onTap: () => _openChat(thread.user),
                                onAvatarTap: () => _openProfile(thread.user),
                                onDelete: () => _deleteThread(thread.user),
                              ),
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

class _ApplicationButton extends StatelessWidget {
  const _ApplicationButton({required this.requestCount, required this.onTap});

  final int requestCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.infinity,
            height: 70,
            child: Image.asset(
              SquadPingAssets.informationFollowApplication,
              fit: BoxFit.fill,
            ),
          ),
          if (requestCount > 0)
            Positioned(
              right: 36,
              top: -4,
              child: Container(
                constraints: const BoxConstraints(minWidth: 22),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5264),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  '$requestCount',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({
    required this.thread,
    required this.onTap,
    required this.onAvatarTap,
    required this.onDelete,
  });

  final _InformationThread thread;
  final VoidCallback onTap;
  final VoidCallback onAvatarTap;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final lastMessage = thread.lastMessage;
    final hasUnread = lastMessage != null && !lastMessage.fromViewer;

    return Dismissible(
      key: ValueKey('thread-${thread.user.id}'),
      direction: lastMessage == null
          ? DismissDirection.none
          : DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await onDelete();
        return false;
      },
      background: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 74,
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFF5264),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            SquadPingAssets.informationDeleteGlyph,
            width: 42,
            height: 42,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 70),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: ClipOval(
                  child: Image.asset(
                    thread.user.avatarAsset,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: onAvatarTap,
                            child: Text(
                              thread.user.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${thread.user.age} years old',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: const Color(0xFF30303A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastMessage?.text ??
                          'Mutual follow accepted. Start a respectful chat.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF34323A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasUnread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5264),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InformationThread {
  const _InformationThread({required this.user, required this.messages});

  final CommunityUser user;
  final List<LocalChatMessage> messages;

  LocalChatMessage? get lastMessage {
    if (messages.isEmpty) {
      return null;
    }
    return messages.last;
  }
}

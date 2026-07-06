import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/community_models.dart';

class CommunityLocalStore extends ChangeNotifier {
  CommunityLocalStore._();

  static final instance = CommunityLocalStore._();

  SharedPreferences? _preferences;
  Set<String> _incomingFollowRequestIds = {};
  Set<String> _followRequestsSent = {};
  Set<String> _followingUserIds = {};
  Set<String> _approvedFollowerIds = {};

  static const _incomingFollowRequestsKey =
      'community.incoming_follow_requests';
  static const _followRequestsKey = 'community.follow_requests_sent';
  static const _followingKey = 'community.following_user_ids';
  static const _approvedFollowersKey = 'community.approved_follower_ids';
  static const _initialFollowersSeededKey =
      'community.initial_followers_seeded';
  static const _chatPrefix = 'community.chat.';
  static const _initialFollowerIds = <String>[
    'chloe',
    'liam',
    'maya-community',
  ];

  Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
    _incomingFollowRequestIds =
        (_preferences!.getStringList(_incomingFollowRequestsKey) ?? const [])
            .toSet();
    _followRequestsSent =
        (_preferences!.getStringList(_followRequestsKey) ?? const []).toSet();
    _followingUserIds = (_preferences!.getStringList(_followingKey) ?? const [])
        .toSet();
    _approvedFollowerIds =
        (_preferences!.getStringList(_approvedFollowersKey) ?? const [])
            .toSet();
    await _seedInitialFollowersIfNeeded();
  }

  List<String> get incomingFollowRequestIds =>
      _incomingFollowRequestIds.toList();

  List<String> get followingUserIds => _followingUserIds.toList();

  List<String> get approvedFollowerIds => _approvedFollowerIds.toList();

  List<String> get mutualFollowUserIds {
    return _followingUserIds
        .where(_approvedFollowerIds.contains)
        .toList(growable: false);
  }

  bool hasIncomingFollowRequest(String userId) =>
      _incomingFollowRequestIds.contains(userId);

  bool hasRequestedFollow(String userId) =>
      _followRequestsSent.contains(userId);

  bool isFollowing(String userId) => _followingUserIds.contains(userId);

  bool isMutualFollow(String userId) {
    return _followingUserIds.contains(userId) &&
        _approvedFollowerIds.contains(userId);
  }

  Future<void> requestFollow(String userId) async {
    await _store();
    if (_incomingFollowRequestIds.remove(userId)) {
      _approvedFollowerIds.add(userId);
      _followingUserIds.add(userId);
    } else {
      _followRequestsSent.add(userId);
    }
    await _persistRelationshipState();
    notifyListeners();
  }

  Future<void> approveIncomingFollowRequest(String userId) async {
    await _store();
    _incomingFollowRequestIds.remove(userId);
    _approvedFollowerIds.add(userId);
    _followingUserIds.add(userId);
    await _persistRelationshipState();
    notifyListeners();
  }

  Future<void> dismissIncomingFollowRequest(String userId) async {
    await _store();
    _incomingFollowRequestIds.remove(userId);
    await _persistRelationshipState();
    notifyListeners();
  }

  Future<List<LocalChatMessage>> loadMessages(String peerUserId) async {
    final store = await _store();
    final rawItems =
        store.getStringList('$_chatPrefix$peerUserId') ?? <String>[];
    return rawItems
        .map(
          (raw) => LocalChatMessage.fromJson(
            Map<String, Object?>.from(jsonDecode(raw) as Map),
          ),
        )
        .toList()
      ..sort((left, right) => left.sentAt.compareTo(right.sentAt));
  }

  Future<List<String>> loadChatPeerIds() async {
    final store = await _store();
    return store
        .getKeys()
        .where((key) => key.startsWith(_chatPrefix))
        .map((key) => key.substring(_chatPrefix.length))
        .toList(growable: false);
  }

  Future<void> appendMessage(LocalChatMessage message) async {
    final store = await _store();
    final key = '$_chatPrefix${message.peerUserId}';
    final rawItems = store.getStringList(key) ?? <String>[];
    rawItems.add(jsonEncode(message.toJson()));
    await store.setStringList(key, rawItems);
    notifyListeners();
  }

  Future<void> deleteMessages(String peerUserId) async {
    final store = await _store();
    await store.remove('$_chatPrefix$peerUserId');
    notifyListeners();
  }

  Future<void> _persistRelationshipState() async {
    final store = await _store();
    await Future.wait([
      store.setStringList(
        _incomingFollowRequestsKey,
        _incomingFollowRequestIds.toList(),
      ),
      store.setStringList(_followRequestsKey, _followRequestsSent.toList()),
      store.setStringList(_followingKey, _followingUserIds.toList()),
      store.setStringList(_approvedFollowersKey, _approvedFollowerIds.toList()),
    ]);
  }

  Future<SharedPreferences> _store() async {
    if (_preferences == null) {
      await initialize();
    }
    return _preferences!;
  }

  Future<void> _seedInitialFollowersIfNeeded() async {
    final seeded = _preferences!.getBool(_initialFollowersSeededKey) ?? false;
    if (seeded) {
      return;
    }
    _approvedFollowerIds.addAll(_initialFollowerIds);
    await Future.wait([
      _preferences!.setStringList(
        _approvedFollowersKey,
        _approvedFollowerIds.toList(),
      ),
      _preferences!.setBool(_initialFollowersSeededKey, true),
    ]);
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SafetyReportType {
  adultContent,
  verbalViolence,
  religiousDiscrimination,
  contentError,
  genderDiscrimination,
}

extension SafetyReportTypeCopy on SafetyReportType {
  String get label {
    return switch (this) {
      SafetyReportType.adultContent => 'Adult content',
      SafetyReportType.verbalViolence => 'Harassment or threats',
      SafetyReportType.religiousDiscrimination => 'Religious or identity abuse',
      SafetyReportType.contentError => 'Scam or misleading content',
      SafetyReportType.genderDiscrimination => 'Gender-based abuse',
    };
  }
}

class SafetyActionStore extends ChangeNotifier {
  SafetyActionStore._();

  static final instance = SafetyActionStore._();

  SharedPreferences? _preferences;
  Set<String> _reportedContentIds = {};
  Set<String> _blockedUserIds = {};

  static const _reportedContentKey = 'squad_safety.reported_content_ids';
  static const _blockedUsersKey = 'squad_safety.blocked_user_ids';
  static const _reportRecordsKey = 'squad_safety.report_records';
  static const _blockRecordsKey = 'squad_safety.block_records';

  Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
    _reportedContentIds =
        (_preferences!.getStringList(_reportedContentKey) ?? const []).toSet();
    _blockedUserIds =
        (_preferences!.getStringList(_blockedUsersKey) ?? const []).toSet();
  }

  bool isContentHidden(String contentId, {String? authorId}) {
    return _reportedContentIds.contains(contentId) ||
        (authorId != null && _blockedUserIds.contains(authorId));
  }

  bool isUserBlocked(String userId) {
    return _blockedUserIds.contains(userId);
  }

  List<String> get blockedUserIds => _blockedUserIds.toList();

  Future<void> reportContent({
    required String contentId,
    required String authorId,
    required SafetyReportType type,
  }) async {
    final store = await _store();
    _reportedContentIds.add(contentId);
    await store.setStringList(
      _reportedContentKey,
      _reportedContentIds.toList(),
    );
    final records = store.getStringList(_reportRecordsKey) ?? <String>[];
    records.add(
      jsonEncode({
        'contentId': contentId,
        'authorId': authorId,
        'type': type.name,
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );
    await store.setStringList(_reportRecordsKey, records);
    notifyListeners();
  }

  Future<void> blockUser({
    required String userId,
    required String reason,
  }) async {
    final store = await _store();
    _blockedUserIds.add(userId);
    await store.setStringList(_blockedUsersKey, _blockedUserIds.toList());
    final records = store.getStringList(_blockRecordsKey) ?? <String>[];
    records.add(
      jsonEncode({
        'userId': userId,
        'reason': reason,
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );
    await store.setStringList(_blockRecordsKey, records);
    notifyListeners();
  }

  Future<void> unblockUser(String userId) async {
    final store = await _store();
    _blockedUserIds.remove(userId);
    await store.setStringList(_blockedUsersKey, _blockedUserIds.toList());
    notifyListeners();
  }

  Future<SharedPreferences> _store() async {
    await initialize();
    return _preferences!;
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tactical_brief_models.dart';

class TacticalBriefStore extends ChangeNotifier {
  TacticalBriefStore._();

  static final instance = TacticalBriefStore._();

  static const _briefsKey = 'game_zone.tactical_briefs';
  static const _historyLimit = 12;

  SharedPreferences? _preferences;
  var _briefs = <TacticalBrief>[];

  List<TacticalBrief> get briefs => List.unmodifiable(_briefs);

  Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
    final rawItems = _preferences!.getStringList(_briefsKey) ?? const [];
    _briefs = rawItems
        .map(
          (raw) => TacticalBrief.fromJson(
            Map<String, Object?>.from(jsonDecode(raw) as Map),
          ),
        )
        .toList()
      ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
  }

  Future<void> addBrief(TacticalBrief brief) async {
    final store = await _store();
    _briefs = [brief, ..._briefs.take(_historyLimit - 1)];
    await store.setStringList(
      _briefsKey,
      _briefs.map((brief) => jsonEncode(brief.toJson())).toList(),
    );
    notifyListeners();
  }

  Future<SharedPreferences> _store() async {
    if (_preferences == null) {
      await initialize();
    }
    return _preferences!;
  }
}

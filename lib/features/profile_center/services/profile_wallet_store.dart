import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWalletStore extends ChangeNotifier {
  ProfileWalletStore._();

  static final instance = ProfileWalletStore._();

  SharedPreferences? _preferences;
  var _coins = 123123;

  static const _coinsKey = 'profile_center.gold_coins';

  int get coins => _coins;

  Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
    _coins = _preferences!.getInt(_coinsKey) ?? 123123;
  }

  Future<void> addCoins(int amount) async {
    final store = await _store();
    _coins += amount;
    await store.setInt(_coinsKey, _coins);
    notifyListeners();
  }

  Future<SharedPreferences> _store() async {
    if (_preferences == null) {
      await initialize();
    }
    return _preferences!;
  }
}

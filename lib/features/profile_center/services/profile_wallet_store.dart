import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coin_economy.dart';

class ProfileWalletStore extends ChangeNotifier {
  ProfileWalletStore._();

  static final instance = ProfileWalletStore._();

  SharedPreferences? _preferences;
  var _coins = 0;
  var _welcomeGiftClaimed = false;
  var _processedPurchaseIds = <String>{};

  static const _coinsKey = 'profile_center.gold_coins';
  static const _welcomeGiftClaimedKey = 'profile_center.welcome_gift_claimed';
  static const _processedPurchaseIdsKey =
      'profile_center.processed_purchase_ids';

  int get coins => _coins;
  bool get welcomeGiftClaimed => _welcomeGiftClaimed;

  Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
    _coins = _preferences!.getInt(_coinsKey) ?? 0;
    _welcomeGiftClaimed =
        _preferences!.getBool(_welcomeGiftClaimedKey) ?? false;
    _processedPurchaseIds = {
      ...?_preferences!.getStringList(_processedPurchaseIdsKey),
    };
  }

  Future<bool> grantWelcomeGiftIfNeeded() async {
    final store = await _store();
    if (_welcomeGiftClaimed) {
      return false;
    }
    _welcomeGiftClaimed = true;
    _coins += CoinEconomy.welcomeGiftCoins;
    await Future.wait([
      store.setBool(_welcomeGiftClaimedKey, true),
      store.setInt(_coinsKey, _coins),
    ]);
    notifyListeners();
    return true;
  }

  Future<void> addCoins(int amount) async {
    if (amount <= 0) {
      return;
    }
    final store = await _store();
    _coins += amount;
    await store.setInt(_coinsKey, _coins);
    notifyListeners();
  }

  Future<bool> spendCoins(int amount) async {
    if (amount <= 0) {
      return true;
    }
    final store = await _store();
    if (_coins < amount) {
      return false;
    }
    _coins -= amount;
    await store.setInt(_coinsKey, _coins);
    notifyListeners();
    return true;
  }

  Future<bool> addPurchasedCoins({
    required String purchaseId,
    required int coins,
  }) async {
    if (purchaseId.isEmpty || coins <= 0) {
      return false;
    }
    final store = await _store();
    if (_processedPurchaseIds.contains(purchaseId)) {
      return false;
    }
    _processedPurchaseIds.add(purchaseId);
    _coins += coins;
    await Future.wait([
      store.setInt(_coinsKey, _coins),
      store.setStringList(
        _processedPurchaseIdsKey,
        _processedPurchaseIds.toList(growable: false),
      ),
    ]);
    notifyListeners();
    return true;
  }

  Future<SharedPreferences> _store() async {
    if (_preferences == null) {
      await initialize();
    }
    return _preferences!;
  }
}

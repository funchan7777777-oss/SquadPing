import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GateProfileSnapshot {
  const GateProfileSnapshot({
    required this.displayName,
    required this.areaSignal,
    required this.signatureLine,
    required this.age,
    this.avatarPath,
  });

  final String displayName;
  final String areaSignal;
  final String signatureLine;
  final int age;
  final String? avatarPath;
}

class LocalGateRecordKeeper {
  SharedPreferences? _preferences;

  static const _sessionOpenKey = 'squad_gate.session_open';
  static const _accountMailKey = 'squad_gate.account_mail';
  static const _accountSecretKey = 'squad_gate.account_secret';
  static const _appleUserKey = 'squad_gate.apple_user';
  static const _appleMailKey = 'squad_gate.apple_mail';
  static const _profileNameKey = 'squad_gate.profile_name';
  static const _profileAreaKey = 'squad_gate.profile_area';
  static const _profileSignatureKey = 'squad_gate.profile_signature';
  static const _profileAvatarPathKey = 'squad_gate.profile_avatar_path';
  static const _profileAgeKey = 'squad_gate.profile_age';

  Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<bool> hasOpenSession() async {
    final store = await _store();
    return store.getBool(_sessionOpenKey) ?? false;
  }

  Future<void> savePasswordAccount({
    required String mailAddress,
    required String plainPassword,
  }) async {
    final store = await _store();
    await store.setString(_accountMailKey, mailAddress.trim().toLowerCase());
    await store.setString(_accountSecretKey, _digestSecret(plainPassword));
  }

  Future<bool> canOpenPasswordAccount({
    required String mailAddress,
    required String plainPassword,
  }) async {
    final store = await _store();
    final savedMail = store.getString(_accountMailKey);
    final savedSecret = store.getString(_accountSecretKey);
    return savedMail == mailAddress.trim().toLowerCase() &&
        savedSecret == _digestSecret(plainPassword);
  }

  Future<void> saveAppleIdentity({
    required String appleUserIdentifier,
    String? mailAddress,
  }) async {
    final store = await _store();
    await store.setString(_appleUserKey, appleUserIdentifier);
    if (mailAddress != null && mailAddress.trim().isNotEmpty) {
      await store.setString(_appleMailKey, mailAddress.trim().toLowerCase());
    }
  }

  Future<void> openAccountSession({required String fallbackMail}) async {
    final store = await _store();
    final currentName = store.getString(_profileNameKey);
    if (currentName == null || currentName.trim().isEmpty) {
      await store.setString(_profileNameKey, _nameFromMail(fallbackMail));
    }
    await store.setBool(_sessionOpenKey, true);
  }

  Future<void> saveProfileAndOpenSession({
    required String displayName,
    required String areaSignal,
    required String signatureLine,
    String? avatarPath,
  }) async {
    final store = await _store();
    await store.setString(_profileNameKey, displayName.trim());
    await store.setString(_profileAreaKey, areaSignal.trim());
    await store.setString(_profileSignatureKey, signatureLine.trim());
    await store.setInt(_profileAgeKey, store.getInt(_profileAgeKey) ?? 20);
    if (avatarPath != null && avatarPath.trim().isNotEmpty) {
      await store.setString(_profileAvatarPathKey, avatarPath);
    }
    await store.setBool(_sessionOpenKey, true);
  }

  Future<GateProfileSnapshot> loadProfile() async {
    final store = await _store();
    return GateProfileSnapshot(
      displayName: store.getString(_profileNameKey)?.trim().isNotEmpty == true
          ? store.getString(_profileNameKey)!.trim()
          : 'Marceline',
      areaSignal: store.getString(_profileAreaKey)?.trim().isNotEmpty == true
          ? store.getString(_profileAreaKey)!.trim()
          : 'Austria',
      signatureLine:
          store.getString(_profileSignatureKey)?.trim().isNotEmpty == true
          ? store.getString(_profileSignatureKey)!.trim()
          : 'Respectful squads, clean clips, and weekend co-op plans.',
      age: store.getInt(_profileAgeKey) ?? 20,
      avatarPath: store.getString(_profileAvatarPathKey),
    );
  }

  Future<void> updateProfile({
    required String displayName,
    required String areaSignal,
    required int age,
    String? avatarPath,
  }) async {
    final store = await _store();
    await store.setString(_profileNameKey, displayName.trim());
    await store.setString(_profileAreaKey, areaSignal.trim());
    await store.setInt(_profileAgeKey, age);
    if (avatarPath != null && avatarPath.trim().isNotEmpty) {
      await store.setString(_profileAvatarPathKey, avatarPath);
    }
  }

  Future<void> closeSession() async {
    final store = await _store();
    await store.setBool(_sessionOpenKey, false);
  }

  Future<void> deleteLocalAccount() async {
    final store = await _store();
    await Future.wait([
      store.remove(_sessionOpenKey),
      store.remove(_accountMailKey),
      store.remove(_accountSecretKey),
      store.remove(_appleUserKey),
      store.remove(_appleMailKey),
      store.remove(_profileNameKey),
      store.remove(_profileAreaKey),
      store.remove(_profileSignatureKey),
      store.remove(_profileAvatarPathKey),
      store.remove(_profileAgeKey),
    ]);
  }

  Future<String> keepAvatarInsideApp(String pickedPath) async {
    final source = File(pickedPath);
    final directory = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final target = File('${directory.path}/squadping_profile_$stamp.jpg');
    final copied = await source.copy(target.path);
    return copied.path;
  }

  Future<SharedPreferences> _store() async {
    await initialize();
    return _preferences!;
  }

  String _digestSecret(String input) {
    final normalized = input.trim();
    return sha256.convert(utf8.encode('squadping:$normalized')).toString();
  }

  String _nameFromMail(String mailAddress) {
    final handle = mailAddress.split('@').first.trim();
    if (handle.isEmpty) {
      return 'Squad member';
    }
    return handle
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}

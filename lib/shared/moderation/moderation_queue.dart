import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModerationQueue {
  ModerationQueue._();

  static final instance = ModerationQueue._();

  SharedPreferences? _preferences;

  static const _pendingItemsKey = 'squad_moderation.pending_items';

  Future<void> enqueuePending({
    required String itemId,
    required String itemType,
    required String text,
  }) async {
    final store = await _store();
    final records = store.getStringList(_pendingItemsKey) ?? <String>[];
    records.add(
      jsonEncode({
        'itemId': itemId,
        'itemType': itemType,
        'text': text,
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );
    await store.setStringList(_pendingItemsKey, records);
  }

  Future<SharedPreferences> _store() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }
}

Future<void> showModerationQueuedDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        decoration: BoxDecoration(
          color: const Color(0xFF130821),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFFF6FE7), width: 1.4),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4AD8).withValues(alpha: 0.30),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B3DFF), Color(0xFFFF4AD8)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Release received',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your update has entered backstage review. It will appear in the community only after approval.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.78),
                height: 1.38,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 176,
              height: 52,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4D20E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text('Okay'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import 'safety_action_sheet.dart';

enum SafetyTextCategory {
  adultSexualContent,
  sexualExploitation,
  hateHarassment,
  threatsSelfHarm,
  scamsSpam,
}

class SafetyTextCheck {
  const SafetyTextCheck._({
    required this.isAllowed,
    required this.fieldLabel,
    this.category,
  });

  const SafetyTextCheck.allowed({String fieldLabel = 'Text'})
    : this._(isAllowed: true, fieldLabel: fieldLabel);

  const SafetyTextCheck.blocked({
    required SafetyTextCategory category,
    required String fieldLabel,
  }) : this._(isAllowed: false, category: category, fieldLabel: fieldLabel);

  final bool isAllowed;
  final SafetyTextCategory? category;
  final String fieldLabel;

  String get title => '$fieldLabel needs a safer rewrite';

  String get message {
    final reason = switch (category) {
      SafetyTextCategory.adultSexualContent =>
        'Adult sexual, hookup, or pornographic wording is not allowed.',
      SafetyTextCategory.sexualExploitation =>
        'Sexual exploitation, trafficking, or sexual content involving minors is not allowed.',
      SafetyTextCategory.hateHarassment =>
        'Hate, identity-based attacks, bullying, or targeted harassment are not allowed.',
      SafetyTextCategory.threatsSelfHarm =>
        'Threats, self-harm instructions, doxxing, or violent intimidation are not allowed.',
      SafetyTextCategory.scamsSpam =>
        'Scams, credential requests, spam, or unsafe off-platform solicitation are not allowed.',
      null => 'This text needs to be rewritten before it can be used.',
    };
    return '$reason Keep SquadPing focused on game coordination and respectful discussion.';
  }
}

abstract final class SafetyTextGuard {
  static SafetyTextCheck check(String rawText, {String fieldLabel = 'Text'}) {
    final text = _normalize(rawText);
    if (text.isEmpty) {
      return SafetyTextCheck.allowed(fieldLabel: fieldLabel);
    }
    for (final rule in _rules) {
      if (rule.pattern.hasMatch(text)) {
        return SafetyTextCheck.blocked(
          category: rule.category,
          fieldLabel: fieldLabel,
        );
      }
    }
    return SafetyTextCheck.allowed(fieldLabel: fieldLabel);
  }

  static SafetyTextCheck checkMany(Map<String, String> fields) {
    for (final entry in fields.entries) {
      final result = check(entry.value, fieldLabel: entry.key);
      if (!result.isAllowed) {
        return result;
      }
    }
    return const SafetyTextCheck.allowed();
  }

  static String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static final List<_SafetyTextRule> _rules = [
    _SafetyTextRule(
      SafetyTextCategory.sexualExploitation,
      RegExp(
        r'\b(child|minor|under\s*18|teen)\s+(porn|nude|naked|sex|sexual|escort|hook\s*up)\b',
      ),
    ),
    _SafetyTextRule(
      SafetyTextCategory.sexualExploitation,
      RegExp(
        r'\b(human\s+trafficking|sex\s+trafficking|traffick\s+(people|girls|boys|women|men))\b',
      ),
    ),
    _SafetyTextRule(
      SafetyTextCategory.adultSexualContent,
      RegExp(
        r'\b(porn|porno|pornography|xxx|nsfw|nudes?|naked\s+pics?|sex\s*tape|explicit\s+sex|hook\s*up|escort|prostitut(?:e|ion)|onlyfans|blowjob|handjob|camgirl|cam\s*show)\b',
      ),
    ),
    _SafetyTextRule(
      SafetyTextCategory.adultSexualContent,
      RegExp(
        r'\b(want|looking\s+for|dm\s+for|pay\s+for|sell|buy|send)\s+(sex|nudes?|porn)\b',
      ),
    ),
    _SafetyTextRule(
      SafetyTextCategory.hateHarassment,
      RegExp(
        r'\b(kill|wipe\s+out|exterminate)\s+all\s+(women|men|girls|boys|jews|muslims|christians|black|white|asian|gay|trans|immigrants)\b',
      ),
    ),
    _SafetyTextRule(
      SafetyTextCategory.hateHarassment,
      RegExp(
        r'\b(go\s+back\s+to\s+your\s+country|racial\s+slur|homophobic\s+slur|nazi\s+propaganda|everyone\s+harass|mass\s+report\s+this\s+person|you\s+are\s+worthless)\b',
      ),
    ),
    _SafetyTextRule(
      SafetyTextCategory.threatsSelfHarm,
      RegExp(
        r'\b(kill\s+yourself|kys|go\s+die|commit\s+suicide|self\s*harm|doxx|swat\s+you)\b',
      ),
    ),
    _SafetyTextRule(
      SafetyTextCategory.threatsSelfHarm,
      RegExp(
        r'\b(i\s+will\s+(kill|stab|shoot|bomb)|shoot\s+up|bomb\s+threat)\b',
      ),
    ),
    _SafetyTextRule(
      SafetyTextCategory.scamsSpam,
      RegExp(
        r'\b(send|share)\s+(me\s+)?(your\s+)?(password|credit\s+card|card\s+number|2fa|verification\s+code)\b',
      ),
    ),
    _SafetyTextRule(
      SafetyTextCategory.scamsSpam,
      RegExp(
        r'\b(gift\s+card\s+code|crypto\s+giveaway|free\s+coins?\s+generator|telegram\s*@|whatsapp\s*\+)\b',
      ),
    ),
  ];
}

class _SafetyTextRule {
  const _SafetyTextRule(this.category, this.pattern);

  final SafetyTextCategory category;
  final RegExp pattern;
}

Future<bool> ensureSafetyTextAllowed(
  BuildContext context,
  String text, {
  String fieldLabel = 'Text',
}) async {
  final check = SafetyTextGuard.check(text, fieldLabel: fieldLabel);
  if (check.isAllowed) {
    return true;
  }
  await showSafetyTextBlockedDialog(context, check);
  return false;
}

Future<bool> ensureSafetyFieldsAllowed(
  BuildContext context,
  Map<String, String> fields,
) async {
  final check = SafetyTextGuard.checkMany(fields);
  if (check.isAllowed) {
    return true;
  }
  await showSafetyTextBlockedDialog(context, check);
  return false;
}

Future<void> showSafetyTextBlockedDialog(
  BuildContext context,
  SafetyTextCheck check,
) {
  return showSafetyFeedbackDialog(
    context: context,
    title: check.title,
    message: check.message,
  );
}

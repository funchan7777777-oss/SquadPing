import 'package:flutter/material.dart';

import '../visuals/squad_ping_assets.dart';
import 'safety_action_store.dart';

Future<bool> showSafetyActionSheet({
  required BuildContext context,
  required String contentId,
  required String authorId,
  required String authorName,
  bool allowBlock = true,
}) async {
  final hostContext = context;
  final changed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _SafetyActionSheet(
      hostContext: hostContext,
      contentId: contentId,
      authorId: authorId,
      authorName: authorName,
      allowBlock: allowBlock,
    ),
  );
  return changed ?? false;
}

class _SafetyActionSheet extends StatefulWidget {
  const _SafetyActionSheet({
    required this.hostContext,
    required this.contentId,
    required this.authorId,
    required this.authorName,
    required this.allowBlock,
  });

  final BuildContext hostContext;
  final String contentId;
  final String authorId;
  final String authorName;
  final bool allowBlock;

  @override
  State<_SafetyActionSheet> createState() => _SafetyActionSheetState();
}

class _SafetyActionSheetState extends State<_SafetyActionSheet> {
  SafetyReportType? _selectedType;
  var _isSubmitting = false;

  Future<void> _submitReport() async {
    final type = _selectedType;
    if (type == null || _isSubmitting) {
      return;
    }
    final hostContext = widget.hostContext;
    setState(() => _isSubmitting = true);
    await SafetyActionStore.instance.reportContent(
      contentId: widget.contentId,
      authorId: widget.authorId,
      type: type,
    );
    if (!mounted || !hostContext.mounted) {
      return;
    }
    Navigator.of(context).pop(true);
    await showSafetyFeedbackDialog(
      context: hostContext,
      title: 'Report received',
      message:
          'This content is now hidden locally. Your report type was ${type.label}.',
    );
  }

  Future<void> _blockUser() async {
    if (_isSubmitting) {
      return;
    }
    final hostContext = widget.hostContext;
    setState(() => _isSubmitting = true);
    await SafetyActionStore.instance.blockUser(
      userId: widget.authorId,
      reason: 'Blacklist',
    );
    if (!mounted || !hostContext.mounted) {
      return;
    }
    Navigator.of(context).pop(true);
    await showSafetyFeedbackDialog(
      context: hostContext,
      title: 'User hidden',
      message:
          '${widget.authorName} and their posts, comments, and chats are now hidden locally.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _ReportOption(
        type: SafetyReportType.adultContent,
        asset: SquadPingAssets.reportAdult,
      ),
      _ReportOption(
        type: SafetyReportType.verbalViolence,
        asset: SquadPingAssets.reportVerbal,
      ),
      _ReportOption(
        type: SafetyReportType.religiousDiscrimination,
        asset: SquadPingAssets.reportReligious,
      ),
      _ReportOption(
        type: SafetyReportType.contentError,
        asset: SquadPingAssets.reportContentError,
      ),
      _ReportOption(
        type: SafetyReportType.genderDiscrimination,
        asset: SquadPingAssets.reportGender,
      ),
    ];

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF6336F2),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                ),
                Expanded(
                  child: Text(
                    'Report',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 12),
            for (final item in items) ...[
              _ReportButton(
                asset: item.asset,
                label: item.type.label,
                isSelected: item.type == _selectedType,
                onTap: () => setState(() => _selectedType = item.type),
              ),
              const SizedBox(height: 12),
            ],
            if (widget.allowBlock) ...[
              _ReportButton(
                asset: SquadPingAssets.reportBlacklist,
                label: 'Blacklist',
                isSelected: false,
                onTap: _blockUser,
              ),
              const SizedBox(height: 22),
            ] else
              const SizedBox(height: 10),
            SizedBox(
              width: 214,
              height: 58,
              child: FilledButton(
                onPressed: _selectedType == null || _isSubmitting
                    ? null
                    : _submitReport,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: Colors.black.withValues(alpha: 0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  'Submit report',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportOption {
  const _ReportOption({required this.type, required this.asset});

  final SafetyReportType type;
  final String asset;
}

class _ReportButton extends StatelessWidget {
  const _ReportButton({
    required this.asset,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String asset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(asset, height: 54, fit: BoxFit.fill),
          if (isSelected)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          Semantics(
            label: label,
            button: true,
            selected: isSelected,
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

Future<void> showSafetyFeedbackDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7B3DFF), Color(0xFFEF55D8)],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B3DFF).withValues(alpha: 0.35),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                height: 1.36,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text('Understood'),
            ),
          ],
        ),
      ),
    ),
  );
}

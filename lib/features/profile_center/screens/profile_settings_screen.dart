import 'package:flutter/material.dart';

import '../../../app/navigation/session_exit_target.dart';
import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../signal_gate/models/legal_document_links.dart';
import '../../signal_gate/screens/agreement_web_view_stage.dart';
import '../../signal_gate/services/local_gate_record_keeper.dart';
import '../../signal_gate/widgets/route_entry_loading_stage.dart';
import 'profile_blacklist_screen.dart';
import 'profile_community_guidelines_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({
    super.key,
    required this.recordKeeper,
    this.onSessionClosed,
  });

  final LocalGateRecordKeeper recordKeeper;
  final ValueChanged<SessionExitTarget>? onSessionClosed;

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  _SettingsOption? _selectedOption;

  Future<void> _runSelected() async {
    final option = _selectedOption;
    if (option == null) {
      return;
    }
    switch (option) {
      case _SettingsOption.blacklist:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const ProfileBlacklistScreen(),
          ),
        );
      case _SettingsOption.privacy:
        await _openPolicy('Privacy Policy', LegalDocumentLinks.privacyUrl);
      case _SettingsOption.guidelines:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const ProfileCommunityGuidelinesScreen(),
          ),
        );
      case _SettingsOption.agreement:
        await _openPolicy('User Agreement', LegalDocumentLinks.termsUrl);
      case _SettingsOption.logout:
        await _confirmSessionAction(
          title: 'Log out',
          message: 'You will need to sign in again before using SquadPing.',
          actionLabel: 'Log out',
          onConfirmed: widget.recordKeeper.closeSession,
          successTitle: 'Logged out',
          successMessage: 'Your local session has been closed.',
          loadingCaption: 'Logging out',
          exitTarget: SessionExitTarget.signIn,
        );
      case _SettingsOption.deleteAccount:
        await _confirmSessionAction(
          title: 'Delete account',
          message:
              'This removes your local account profile and closes the current session on this device.',
          actionLabel: 'Delete',
          onConfirmed: widget.recordKeeper.deleteLocalAccount,
          successTitle: 'Local account deleted',
          successMessage:
              'The local account record on this device has been removed.',
          loadingCaption: 'Deleting account',
          exitTarget: SessionExitTarget.guide,
        );
    }
  }

  Future<void> _openPolicy(String title, String url) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AgreementWebViewStage(pageTitle: title, pageUrl: url),
      ),
    );
  }

  Future<void> _confirmSessionAction({
    required String title,
    required String message,
    required String actionLabel,
    required Future<void> Function() onConfirmed,
    required String successTitle,
    required String successMessage,
    required String loadingCaption,
    required SessionExitTarget exitTarget,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF130821),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RouteEntryLoadingStage(caption: loadingCaption),
      ),
    );
    await onConfirmed();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
    await showSafetyFeedbackDialog(
      context: context,
      title: successTitle,
      message: successMessage,
    );
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      widget.onSessionClosed?.call(exitTarget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7138F5),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              SquadPingAssets.gameZoneChatBackdrop,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    18,
                    squadCompactTopPadding(context),
                    18,
                    28,
                  ),
                  children: [
                    _SettingsHeader(onBack: () => Navigator.of(context).pop()),
                    const SizedBox(height: 18),
                    for (final option in _SettingsOption.values) ...[
                      _SettingsButton(
                        option: option,
                        isSelected: option == _selectedOption,
                        onTap: () => setState(() => _selectedOption = option),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 72),
                    SizedBox(
                      height: 58,
                      child: FilledButton(
                        onPressed: _selectedOption == null
                            ? null
                            : _runSelected,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                          disabledBackgroundColor: Colors.black.withValues(
                            alpha: 0.36,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Text(
                          'confirm',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                    ),
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

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        Expanded(
          child: Text(
            'set up',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _SettingsOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(option.asset, height: 54, fit: BoxFit.fill),
          if (isSelected)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          Semantics(label: option.label, button: true, selected: isSelected),
        ],
      ),
    );
  }
}

enum _SettingsOption {
  blacklist,
  privacy,
  guidelines,
  agreement,
  logout,
  deleteAccount;

  String get label {
    return switch (this) {
      _SettingsOption.blacklist => 'Blacklist',
      _SettingsOption.privacy => 'Privacy Policy',
      _SettingsOption.guidelines => 'Community Guidelines',
      _SettingsOption.agreement => 'User agreement',
      _SettingsOption.logout => 'Log out',
      _SettingsOption.deleteAccount => 'Deleting an account',
    };
  }

  String get asset {
    return switch (this) {
      _SettingsOption.blacklist => SquadPingAssets.profileBlacklistButton,
      _SettingsOption.privacy => SquadPingAssets.profilePrivacyButton,
      _SettingsOption.guidelines => SquadPingAssets.profileGuidelinesButton,
      _SettingsOption.agreement => SquadPingAssets.profileAgreementButton,
      _SettingsOption.logout => SquadPingAssets.profileLogoutButton,
      _SettingsOption.deleteAccount =>
        SquadPingAssets.profileDeleteAccountButton,
    };
  }
}

import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import '../services/local_gate_record_keeper.dart';
import '../widgets/account_crosslink.dart';
import '../widgets/credential_lane_field.dart';
import '../widgets/full_bleed_asset_stage.dart';
import '../widgets/gate_back_button.dart';
import '../widgets/gate_copy_cluster.dart';
import '../widgets/gate_notice_dialog.dart';
import '../widgets/gate_text_action_button.dart';
import '../widgets/rally_corner_artifact.dart';

class CredentialSigninStage extends StatefulWidget {
  const CredentialSigninStage({
    super.key,
    required this.recordKeeper,
    required this.onCreateAccountPulled,
    required this.onAccessGranted,
  });

  final LocalGateRecordKeeper recordKeeper;
  final VoidCallback onCreateAccountPulled;
  final Future<void> Function(String mailAddress) onAccessGranted;

  @override
  State<CredentialSigninStage> createState() => _CredentialSigninStageState();
}

class _CredentialSigninStageState extends State<CredentialSigninStage> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecking = false;

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FullBleedAssetStage(
      backdropAsset: SquadPingAssets.background,
      allowKeyboardInset: false,
      foreground: Stack(
        fit: StackFit.expand,
        children: [
          const RallyCornerArtifact(top: 70),
          GateBackButton(onPressed: () => Navigator.of(context).pop()),
          const GateCopyCluster(
            heading: 'Log in',
            primaryLine: 'Welcome to join us',
            secondaryLine: 'Log in to share and discuss topics',
            topOffset: 145,
          ),
          Positioned(
            left: 30,
            right: 30,
            top: 402,
            child: Column(
              children: [
                CredentialLaneField(
                  fieldLabel: 'Mail',
                  controller: _mailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 18),
                CredentialLaneField(
                  fieldLabel: 'Password',
                  controller: _passwordController,
                  obscuredByDefault: true,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          Positioned(
            left: 26,
            right: 26,
            bottom: 72,
            child: Column(
              children: [
                AccountCrosslink(
                  prompt: "Don't have an account yet?",
                  actionLabel: 'Create Account',
                  onPressed: widget.onCreateAccountPulled,
                ),
                const SizedBox(height: 18),
                Opacity(
                  opacity: _isChecking ? 0.62 : 1,
                  child: GateTextActionButton(
                    caption: 'Start',
                    semanticLabel: 'Start login',
                    onPressed: _isChecking ? () {} : _startAccountLogin,
                    widthFactor: 0.68,
                    maxWidth: 260,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startAccountLogin() async {
    final mail = _mailController.text.trim();
    final password = _passwordController.text;

    if (mail.isEmpty || password.isEmpty) {
      await _showNotice(
        title: 'Missing login details',
        message: 'Enter your mail and password before starting.',
      );
      return;
    }
    if (!_looksLikeMail(mail)) {
      await _showNotice(
        title: 'Mail needs a second look',
        message:
            'Use a complete mail address so SquadPing can find your local account.',
      );
      return;
    }

    setState(() => _isChecking = true);
    final canOpen = await widget.recordKeeper.canOpenPasswordAccount(
      mailAddress: mail,
      plainPassword: password,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isChecking = false);

    if (!canOpen) {
      await _showNotice(
        title: 'Account not found',
        message:
            'This mail and password do not match a saved SquadPing account on this device.',
      );
      return;
    }

    await widget.onAccessGranted(mail);
  }

  Future<void> _showNotice({required String title, required String message}) {
    return showGateNoticeDialog(
      context: context,
      title: title,
      message: message,
    );
  }

  bool _looksLikeMail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }
}

import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
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
    required this.onCreateAccountPulled,
    required this.onAccessGranted,
  });

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
            primaryLine: 'Return to your squad signal',
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
                  hintText: 'Mail for your SquadPing login',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 18),
                CredentialLaneField(
                  fieldLabel: 'Password',
                  controller: _passwordController,
                  hintText: 'Local account password',
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
        message: 'Enter your mail and password before opening SquadPing.',
      );
      return;
    }
    if (!_looksLikeMail(mail)) {
      await _showNotice(
        title: 'Mail needs a second look',
        message: 'Use a complete mail address before logging in.',
      );
      return;
    }
    if (password.trim().length < 6) {
      await _showNotice(
        title: 'Password is too short',
        message: 'Use at least 6 characters to log in.',
      );
      return;
    }

    setState(() => _isChecking = true);
    await widget.onAccessGranted(mail);
    if (mounted) {
      setState(() => _isChecking = false);
    }
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

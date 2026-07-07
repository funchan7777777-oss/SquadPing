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

class RegisterSignalStage extends StatefulWidget {
  const RegisterSignalStage({
    super.key,
    required this.recordKeeper,
    required this.onSigninPulled,
    required this.onSignupCompleted,
  });

  final LocalGateRecordKeeper recordKeeper;
  final VoidCallback onSigninPulled;
  final Future<void> Function(String mailAddress) onSignupCompleted;

  @override
  State<RegisterSignalStage> createState() => _RegisterSignalStageState();
}

class _RegisterSignalStageState extends State<RegisterSignalStage> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSaving = false;

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
      foreground: Stack(
        fit: StackFit.expand,
        children: [
          const RallyCornerArtifact(top: 65),
          GateBackButton(onPressed: () => Navigator.of(context).pop()),
          const GateCopyCluster(
            heading: 'Register',
            primaryLine: 'Build your squad signal',
            secondaryLine: 'Create a local profile for clips and game chat',
            topOffset: 150,
          ),
          Positioned(
            left: 30,
            right: 30,
            top: 462,
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
                  hintText: 'Create a local account password',
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
                  prompt: 'Already have an account?',
                  actionLabel: 'Sign in',
                  onPressed: widget.onSigninPulled,
                ),
                const SizedBox(height: 18),
                Opacity(
                  opacity: _isSaving ? 0.62 : 1,
                  child: GateTextActionButton(
                    caption: 'Sign up',
                    semanticLabel: 'Sign up',
                    onPressed: _isSaving ? () {} : _saveAccountAndContinue,
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

  Future<void> _saveAccountAndContinue() async {
    final mail = _mailController.text.trim();
    final password = _passwordController.text;

    if (mail.isEmpty || password.isEmpty) {
      await _showNotice(
        title: 'Squad login needs details',
        message:
            'Add both mail and password before creating your local SquadPing account.',
      );
      return;
    }
    if (!_looksLikeMail(mail)) {
      await _showNotice(
        title: 'Mail needs a second look',
        message:
            'Use a complete mail address so SquadPing can save this account locally.',
      );
      return;
    }
    if (password.trim().length < 6) {
      await _showNotice(
        title: 'Password is too short',
        message: 'Use at least 6 characters for your local SquadPing account.',
      );
      return;
    }

    setState(() => _isSaving = true);
    await widget.recordKeeper.savePasswordAccount(
      mailAddress: mail,
      plainPassword: password,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
    await widget.onSignupCompleted(mail);
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

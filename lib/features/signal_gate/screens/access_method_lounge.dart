import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import '../widgets/agreement_consent_line.dart';
import '../widgets/full_bleed_asset_stage.dart';
import '../widgets/gate_notice_dialog.dart';
import '../widgets/png_signal_button.dart';
import 'agreement_web_view_stage.dart';

class AccessMethodLounge extends StatefulWidget {
  const AccessMethodLounge({
    super.key,
    required this.onSignInPulled,
    required this.onCreateAccountPulled,
    required this.onApplePulled,
  });

  final VoidCallback onSignInPulled;
  final VoidCallback onCreateAccountPulled;
  final Future<void> Function() onApplePulled;

  @override
  State<AccessMethodLounge> createState() => _AccessMethodLoungeState();
}

class _AccessMethodLoungeState extends State<AccessMethodLounge> {
  static const _termsUrl =
      'https://sites.google.com/view/squadping-termsofservice/home';
  static const _privacyUrl =
      'https://sites.google.com/view/squadping-privacy-policy/home';

  bool _agreementAccepted = false;
  bool _appleRequestInFlight = false;

  @override
  Widget build(BuildContext context) {
    return FullBleedAssetStage(
      backdropAsset: SquadPingAssets.methodBackdrop,
      foreground: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 42),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PngSignalButton(
                assetPath: SquadPingAssets.signInButton,
                semanticLabel: 'Sign in',
                onPressed: () => _runAfterAgreement(widget.onSignInPulled),
              ),
              const SizedBox(height: 10),
              PngSignalButton(
                assetPath: SquadPingAssets.createAccountButton,
                semanticLabel: 'Create account',
                onPressed: () =>
                    _runAfterAgreement(widget.onCreateAccountPulled),
              ),
              const SizedBox(height: 10),
              Opacity(
                opacity: _appleRequestInFlight ? 0.62 : 1,
                child: PngSignalButton(
                  assetPath: SquadPingAssets.appleButton,
                  semanticLabel: 'Sign in with Apple',
                  onPressed: _appleRequestInFlight ? () {} : _startAppleFlow,
                ),
              ),
              const SizedBox(height: 24),
              AgreementConsentLine(
                isAccepted: _agreementAccepted,
                onAcceptanceChanged: (value) {
                  setState(() => _agreementAccepted = value);
                },
                onTermsPressed: () =>
                    _openAgreementPage(title: 'User Agreement', url: _termsUrl),
                onPrivacyPressed: () => _openAgreementPage(
                  title: 'Privacy Policy',
                  url: _privacyUrl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _runAfterAgreement(VoidCallback action) {
    if (!_agreementAccepted) {
      _showAgreementNotice();
      return;
    }
    action();
  }

  Future<void> _startAppleFlow() async {
    if (!_agreementAccepted) {
      _showAgreementNotice();
      return;
    }
    setState(() => _appleRequestInFlight = true);
    await widget.onApplePulled();
    if (mounted) {
      setState(() => _appleRequestInFlight = false);
    }
  }

  void _showAgreementNotice() {
    showGateNoticeDialog(
      context: context,
      title: 'Agreement required',
      message:
          'Please read and accept the User Agreement and Privacy Policy before continuing.',
      actionLabel: 'I understand',
    );
  }

  void _openAgreementPage({required String title, required String url}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AgreementWebViewStage(pageTitle: title, pageUrl: url),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import '../widgets/account_crosslink.dart';
import '../widgets/credential_lane_field.dart';
import '../widgets/full_bleed_asset_stage.dart';
import '../widgets/gate_back_button.dart';
import '../widgets/gate_copy_cluster.dart';
import '../widgets/png_signal_button.dart';
import '../widgets/rally_corner_artifact.dart';

class CredentialSigninStage extends StatelessWidget {
  const CredentialSigninStage({
    super.key,
    required this.onCreateAccountPulled,
    required this.onAccessGranted,
  });

  final VoidCallback onCreateAccountPulled;
  final VoidCallback onAccessGranted;

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
              children: const [
                CredentialLaneField(
                  fieldLabel: 'Mail',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 18),
                CredentialLaneField(
                  fieldLabel: 'Password',
                  obscuredByDefault: true,
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
                  onPressed: onCreateAccountPulled,
                ),
                const SizedBox(height: 18),
                PngSignalButton(
                  assetPath: SquadPingAssets.loginButton,
                  semanticLabel: 'Login',
                  onPressed: onAccessGranted,
                  widthFactor: 0.68,
                  maxWidth: 260,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

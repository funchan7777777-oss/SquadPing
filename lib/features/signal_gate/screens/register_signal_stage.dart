import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import '../widgets/account_crosslink.dart';
import '../widgets/credential_lane_field.dart';
import '../widgets/full_bleed_asset_stage.dart';
import '../widgets/gate_back_button.dart';
import '../widgets/gate_copy_cluster.dart';
import '../widgets/png_signal_button.dart';
import '../widgets/rally_corner_artifact.dart';

class RegisterSignalStage extends StatelessWidget {
  const RegisterSignalStage({
    super.key,
    required this.onSigninPulled,
    required this.onSignupPulled,
  });

  final VoidCallback onSigninPulled;
  final VoidCallback onSignupPulled;

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
            primaryLine: 'Welcome to join us',
            secondaryLine: 'Register to share and discuss topics',
            topOffset: 150,
          ),
          Positioned(
            left: 30,
            right: 30,
            top: 462,
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
                  prompt: 'Already have an account?',
                  actionLabel: 'Sign in',
                  onPressed: onSigninPulled,
                ),
                const SizedBox(height: 18),
                PngSignalButton(
                  assetPath: SquadPingAssets.signupButton,
                  semanticLabel: 'Signup',
                  onPressed: onSignupPulled,
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

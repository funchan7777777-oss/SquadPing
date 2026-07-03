import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import '../widgets/full_bleed_asset_stage.dart';
import '../widgets/png_signal_button.dart';

class AccessMethodLounge extends StatelessWidget {
  const AccessMethodLounge({
    super.key,
    required this.onSignInPulled,
    required this.onCreateAccountPulled,
    required this.onApplePulled,
  });

  final VoidCallback onSignInPulled;
  final VoidCallback onCreateAccountPulled;
  final VoidCallback onApplePulled;

  @override
  Widget build(BuildContext context) {
    return FullBleedAssetStage(
      backdropAsset: SquadPingAssets.methodBackdrop,
      foreground: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 52),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PngSignalButton(
                assetPath: SquadPingAssets.signInButton,
                semanticLabel: 'Sign in',
                onPressed: onSignInPulled,
              ),
              const SizedBox(height: 10),
              PngSignalButton(
                assetPath: SquadPingAssets.createAccountButton,
                semanticLabel: 'Create account',
                onPressed: onCreateAccountPulled,
              ),
              const SizedBox(height: 10),
              PngSignalButton(
                assetPath: SquadPingAssets.appleButton,
                semanticLabel: 'Sign in with Apple',
                onPressed: onApplePulled,
              ),
              const SizedBox(height: 34),
              const Text(
                'By continuing, you agree to SquadPing service terms and community notes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

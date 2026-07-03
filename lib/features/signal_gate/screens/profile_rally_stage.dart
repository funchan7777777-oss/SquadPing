import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import '../widgets/account_crosslink.dart';
import '../widgets/credential_lane_field.dart';
import '../widgets/full_bleed_asset_stage.dart';
import '../widgets/gate_back_button.dart';
import '../widgets/png_signal_button.dart';

class ProfileRallyStage extends StatelessWidget {
  const ProfileRallyStage({
    super.key,
    required this.onSigninPulled,
    required this.onProfileConfirmed,
  });

  final VoidCallback onSigninPulled;
  final VoidCallback onProfileConfirmed;

  @override
  Widget build(BuildContext context) {
    return FullBleedAssetStage(
      backdropAsset: SquadPingAssets.background,
      foreground: Stack(
        fit: StackFit.expand,
        children: [
          GateBackButton(onPressed: () => Navigator.of(context).pop()),
          Positioned(
            top: 116,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    SquadPingAssets.profileBadge,
                    width: 120,
                    height: 120,
                  ),
                  Positioned(
                    right: -4,
                    bottom: 8,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B7CF6),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.72),
                          width: 1.4,
                        ),
                      ),
                      child: const Icon(
                        Icons.photo_camera_rounded,
                        color: Color(0xFFE8DEFF),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 30,
            right: 30,
            top: 304,
            child: Column(
              children: const [
                CredentialLaneField(fieldLabel: 'Name'),
                SizedBox(height: 18),
                CredentialLaneField(
                  fieldLabel: 'Age',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 18),
                CredentialLaneField(fieldLabel: 'Area'),
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
                  assetPath: SquadPingAssets.confirmButton,
                  semanticLabel: 'Confirm',
                  onPressed: onProfileConfirmed,
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

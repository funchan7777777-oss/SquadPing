import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/navigation/squad_ping_shell.dart';
import '../../../field_notes/repositories/pulse_story_repository.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../widgets/full_bleed_asset_stage.dart';
import 'access_method_lounge.dart';
import 'credential_signin_stage.dart';
import 'profile_rally_stage.dart';
import 'register_passage_stage.dart';
import 'register_signal_stage.dart';

class SignalGateCoordinator extends StatefulWidget {
  const SignalGateCoordinator({super.key, required this.storyArchive});

  final PulseStoryRepository storyArchive;

  @override
  State<SignalGateCoordinator> createState() => _SignalGateCoordinatorState();
}

class _SignalGateCoordinatorState extends State<SignalGateCoordinator> {
  bool _showMethodLounge = false;
  Timer? _launchTimer;

  @override
  void initState() {
    super.initState();
    _launchTimer = Timer(const Duration(milliseconds: 1150), () {
      if (mounted) {
        setState(() => _showMethodLounge = true);
      }
    });
  }

  @override
  void dispose() {
    _launchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 360),
      child: _showMethodLounge
          ? AccessMethodLounge(
              key: const ValueKey('method-lounge'),
              onSignInPulled: _pushSignin,
              onCreateAccountPulled: _pushRegisterEntrance,
              onApplePulled: _openSquadShell,
            )
          : FullBleedAssetStage(
              key: const ValueKey('launch-curtain'),
              backdropAsset: SquadPingAssets.gatewayLaunch,
              foreground: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _showMethodLounge = true),
              ),
            ),
    );
  }

  void _pushSignin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CredentialSigninStage(
          onCreateAccountPulled: _pushRegisterEntranceFromNestedRoute,
          onAccessGranted: _openSquadShell,
        ),
      ),
    );
  }

  void _pushRegisterEntrance() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterSignalStage(
          onSigninPulled: _replaceWithSignin,
          onSignupPulled: _pushRegisterPassage,
        ),
      ),
    );
  }

  void _pushRegisterEntranceFromNestedRoute() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RegisterSignalStage(
          onSigninPulled: _replaceWithSignin,
          onSignupPulled: _pushRegisterPassage,
        ),
      ),
    );
  }

  void _replaceWithSignin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CredentialSigninStage(
          onCreateAccountPulled: _pushRegisterEntranceFromNestedRoute,
          onAccessGranted: _openSquadShell,
        ),
      ),
    );
  }

  void _pushRegisterPassage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterPassageStage(
          onSigninPulled: _replaceWithSignin,
          onNextStepPulled: _pushProfileStage,
        ),
      ),
    );
  }

  void _pushProfileStage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileRallyStage(
          onSigninPulled: _replaceWithSignin,
          onProfileConfirmed: _openSquadShell,
        ),
      ),
    );
  }

  void _openSquadShell() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => SquadPingShell(storyArchive: widget.storyArchive),
      ),
      (_) => false,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../app/navigation/squad_ping_shell.dart';
import '../../../field_notes/repositories/pulse_story_repository.dart';
import '../models/gate_profile_origin.dart';
import '../services/local_gate_record_keeper.dart';
import '../widgets/gate_notice_dialog.dart';
import '../widgets/launch_signal_loading.dart';
import '../widgets/route_entry_loading_stage.dart';
import 'access_method_lounge.dart';
import 'credential_signin_stage.dart';
import 'profile_rally_stage.dart';
import 'register_signal_stage.dart';

enum _GatePhase { loading, method, home }

class SignalGateCoordinator extends StatefulWidget {
  const SignalGateCoordinator({super.key, required this.storyArchive});

  final PulseStoryRepository storyArchive;

  @override
  State<SignalGateCoordinator> createState() => _SignalGateCoordinatorState();
}

class _SignalGateCoordinatorState extends State<SignalGateCoordinator> {
  final LocalGateRecordKeeper _recordKeeper = LocalGateRecordKeeper();
  _GatePhase _phase = _GatePhase.loading;

  @override
  void initState() {
    super.initState();
    unawaited(_bootstrapGate());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 360),
      child: switch (_phase) {
        _GatePhase.loading => const LaunchSignalLoading(
          key: ValueKey('launch-loading'),
        ),
        _GatePhase.method => AccessMethodLounge(
          key: const ValueKey('method-lounge'),
          onSignInPulled: _pushSignin,
          onCreateAccountPulled: _pushRegisterEntrance,
          onApplePulled: _startAppleSignin,
        ),
        _GatePhase.home => SquadPingShell(
          key: const ValueKey('squad-home'),
          storyArchive: widget.storyArchive,
        ),
      },
    );
  }

  Future<void> _bootstrapGate() async {
    await _recordKeeper.initialize();
    await Future<void>.delayed(const Duration(milliseconds: 1300));
    if (!mounted) {
      return;
    }

    if (await _recordKeeper.hasOpenSession()) {
      setState(() => _phase = _GatePhase.home);
      return;
    }

    setState(() => _phase = _GatePhase.method);
  }

  void _pushSignin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CredentialSigninStage(
          recordKeeper: _recordKeeper,
          onCreateAccountPulled: _pushRegisterEntranceFromNestedRoute,
          onAccessGranted: _openPasswordSession,
        ),
      ),
    );
  }

  void _pushRegisterEntrance() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterSignalStage(
          recordKeeper: _recordKeeper,
          onSigninPulled: _replaceWithSignin,
          onSignupCompleted: _pushProfileStageFromRegister,
        ),
      ),
    );
  }

  void _pushRegisterEntranceFromNestedRoute() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RegisterSignalStage(
          recordKeeper: _recordKeeper,
          onSigninPulled: _replaceWithSignin,
          onSignupCompleted: _pushProfileStageFromRegister,
        ),
      ),
    );
  }

  void _replaceWithSignin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CredentialSigninStage(
          recordKeeper: _recordKeeper,
          onCreateAccountPulled: _pushRegisterEntranceFromNestedRoute,
          onAccessGranted: _openPasswordSession,
        ),
      ),
    );
  }

  Future<void> _pushProfileStageFromRegister(String mailAddress) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileRallyStage(
          recordKeeper: _recordKeeper,
          origin: GateProfileOrigin.localAccount,
          initialName: _nameFromMail(mailAddress),
          onSigninPulled: _replaceWithSignin,
          onProfileConfirmed: () =>
              _finishThroughEntryLoading(caption: 'Preparing your squad room'),
        ),
      ),
    );
  }

  Future<void> _startAppleSignin() async {
    try {
      final appleAvailable = await SignInWithApple.isAvailable();
      if (!appleAvailable) {
        if (!mounted) {
          return;
        }
        await showGateNoticeDialog(
          context: context,
          title: 'Apple sign-in unavailable',
          message:
              'This device is not ready for Sign in with Apple. Try account login or check Apple ID settings.',
        );
        return;
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      await _recordKeeper.saveAppleIdentity(
        appleUserIdentifier: credential.userIdentifier ?? '',
        mailAddress: credential.email,
      );

      if (!mounted) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProfileRallyStage(
            recordKeeper: _recordKeeper,
            origin: GateProfileOrigin.appleIdentity,
            initialName: _appleDisplayName(credential),
            onSigninPulled: _replaceWithSignin,
            onProfileConfirmed: () => _finishThroughEntryLoading(
              caption: 'Linking your Apple identity',
            ),
          ),
        ),
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (!mounted || error.code == AuthorizationErrorCode.canceled) {
        return;
      }
      await showGateNoticeDialog(
        context: context,
        title: 'Apple sign-in paused',
        message:
            'Apple did not complete the request. Please try again or use account login.',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      await showGateNoticeDialog(
        context: context,
        title: 'Apple sign-in paused',
        message:
            'Apple did not complete the request. Please try again or use account login.',
      );
    }
  }

  Future<void> _openPasswordSession(String mailAddress) async {
    await _recordKeeper.openAccountSession(fallbackMail: mailAddress);
    await _finishThroughEntryLoading(caption: 'Checking your saved signal');
  }

  Future<void> _finishThroughEntryLoading({required String caption}) async {
    if (!mounted) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RouteEntryLoadingStage(caption: caption),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 3800));
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => SquadPingShell(storyArchive: widget.storyArchive),
      ),
      (_) => false,
    );
  }

  String _appleDisplayName(AuthorizationCredentialAppleID credential) {
    final nameParts = [
      credential.givenName,
      credential.familyName,
    ].whereType<String>().where((part) => part.trim().isNotEmpty).toList();
    if (nameParts.isNotEmpty) {
      return nameParts.join(' ');
    }
    final mail = credential.email;
    if (mail != null && mail.contains('@')) {
      return _nameFromMail(mail);
    }
    return 'Squad member';
  }

  String _nameFromMail(String mailAddress) {
    final handle = mailAddress.split('@').first.trim();
    if (handle.isEmpty) {
      return 'Squad member';
    }
    return handle
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}

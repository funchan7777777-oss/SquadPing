import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import '../models/gate_profile_origin.dart';
import '../services/local_gate_record_keeper.dart';
import '../widgets/account_crosslink.dart';
import '../widgets/credential_lane_field.dart';
import '../widgets/full_bleed_asset_stage.dart';
import '../widgets/gate_back_button.dart';
import '../widgets/gate_notice_dialog.dart';
import '../widgets/gate_text_action_button.dart';

class ProfileRallyStage extends StatefulWidget {
  const ProfileRallyStage({
    super.key,
    required this.recordKeeper,
    required this.origin,
    required this.onSigninPulled,
    required this.onProfileConfirmed,
    this.initialName,
  });

  final LocalGateRecordKeeper recordKeeper;
  final GateProfileOrigin origin;
  final VoidCallback onSigninPulled;
  final Future<void> Function() onProfileConfirmed;
  final String? initialName;

  @override
  State<ProfileRallyStage> createState() => _ProfileRallyStageState();
}

class _ProfileRallyStageState extends State<ProfileRallyStage> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();
  String? _avatarPath;
  bool _isSavingProfile = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName?.trim() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FullBleedAssetStage(
      backdropAsset: SquadPingAssets.background,
      foreground: Stack(
        fit: StackFit.expand,
        children: [
          GateBackButton(onPressed: () => Navigator.of(context).pop()),
          Positioned(
            top: 88,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _showAvatarChoices,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 116,
                      height: 116,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.8),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: _avatarPath == null
                          ? Image.asset(
                              SquadPingAssets.profileBadge,
                              fit: BoxFit.cover,
                            )
                          : Image.file(File(_avatarPath!), fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: -4,
                      bottom: 8,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B7CF6),
                          borderRadius: BorderRadius.circular(8),
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
          ),
          Positioned(
            left: 30,
            right: 30,
            top: 252,
            child: Column(
              children: [
                CredentialLaneField(
                  fieldLabel: 'Name',
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                CredentialLaneField(
                  fieldLabel: 'Area',
                  controller: _areaController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                CredentialLaneField(
                  fieldLabel: 'Signature',
                  controller: _signatureController,
                  hintText: 'A short line your squad will recognize',
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          Positioned(
            left: 26,
            right: 26,
            bottom: 60,
            child: Column(
              children: [
                AccountCrosslink(
                  prompt: 'Already have an account?',
                  actionLabel: 'Sign in',
                  onPressed: widget.onSigninPulled,
                ),
                const SizedBox(height: 16),
                Opacity(
                  opacity: _isSavingProfile ? 0.62 : 1,
                  child: GateTextActionButton(
                    caption: widget.origin.nextCaption,
                    semanticLabel: widget.origin.nextCaption,
                    onPressed: _isSavingProfile ? () {} : _confirmProfile,
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

  Future<void> _showAvatarChoices() {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7D45FF), Color(0xFFA85CFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AvatarChoiceTile(
                icon: Icons.photo_library_rounded,
                title: 'Choose from library',
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickAvatar(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 10),
              _AvatarChoiceTile(
                icon: Icons.photo_camera_rounded,
                title: 'Take a new photo',
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickAvatar(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAvatar(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 86,
        maxWidth: 1200,
      );
      if (picked == null) {
        return;
      }
      final savedPath = await widget.recordKeeper.keepAvatarInsideApp(
        picked.path,
      );
      if (mounted) {
        setState(() => _avatarPath = savedPath);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      await showGateNoticeDialog(
        context: context,
        title: 'Photo unavailable',
        message:
            'SquadPing could not open that photo source. Check camera or photo permissions and try again.',
      );
    }
  }

  Future<void> _confirmProfile() async {
    final displayName = _nameController.text.trim();
    final areaSignal = _areaController.text.trim();
    final signatureLine = _signatureController.text.trim();

    if (displayName.isEmpty || areaSignal.isEmpty || signatureLine.isEmpty) {
      await showGateNoticeDialog(
        context: context,
        title: 'Profile needs a few signals',
        message:
            'Add your name, area, and signature before entering SquadPing.',
      );
      return;
    }

    setState(() => _isSavingProfile = true);
    await widget.recordKeeper.saveProfileAndOpenSession(
      displayName: displayName,
      areaSignal: areaSignal,
      signatureLine: signatureLine,
      avatarPath: _avatarPath,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSavingProfile = false);
    await widget.onProfileConfirmed();
  }
}

class _AvatarChoiceTile extends StatelessWidget {
  const _AvatarChoiceTile({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

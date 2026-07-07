import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/safety/safety_text_guard.dart';
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
  final TextEditingController _signatureController = TextEditingController();
  String? _avatarPath;
  String? _selectedCountry;
  bool _isSavingProfile = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName?.trim() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
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
              child: _ProfileAvatarPicker(
                avatarPath: _avatarPath,
                onPressed: _showAvatarChoices,
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
                  hintText: 'Enter your display name',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                _CountryPickerField(
                  selectedCountry: _selectedCountry,
                  onPressed: _showCountryPicker,
                ),
                const SizedBox(height: 14),
                CredentialLaneField(
                  fieldLabel: 'Signature (optional)',
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

  Future<void> _showCountryPicker() {
    FocusScope.of(context).unfocus();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
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
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose country',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _countryOptions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final country = _countryOptions[index];
                    return _CountryChoiceTile(
                      country: country,
                      isSelected: country.name == _selectedCountry,
                      onPressed: () {
                        setState(() => _selectedCountry = country.name);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAvatarChoices() {
    FocusScope.of(context).unfocus();
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
    final areaSignal = _selectedCountry?.trim() ?? '';
    final signatureLine = _signatureController.text.trim();

    if (displayName.isEmpty || areaSignal.isEmpty) {
      await showGateNoticeDialog(
        context: context,
        title: 'Profile needs a few signals',
        message: 'Add your name and country before entering SquadPing.',
      );
      return;
    }
    if (!await ensureSafetyFieldsAllowed(context, {
      'Name': displayName,
      if (signatureLine.isNotEmpty) 'Signature': signatureLine,
    })) {
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

class _ProfileAvatarPicker extends StatelessWidget {
  const _ProfileAvatarPicker({
    required this.avatarPath,
    required this.onPressed,
  });

  final String? avatarPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Change profile photo',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 108,
              height: 108,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.58),
                  width: 1.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: avatarPath == null
                  ? const _ProfileAvatarPlaceholder()
                  : Image.file(File(avatarPath!), fit: BoxFit.cover),
            ),
            Positioned(
              right: 0,
              bottom: 4,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B7CF6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.86),
                    width: 1.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  color: Color(0xFFEFEAFF),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatarPlaceholder extends StatelessWidget {
  const _ProfileAvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.28),
                const Color(0xFFB08BFF).withValues(alpha: 0.16),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Center(
          child: Icon(
            Icons.person_rounded,
            color: Colors.white.withValues(alpha: 0.78),
            size: 58,
          ),
        ),
      ],
    );
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

class _CountryPickerField extends StatelessWidget {
  const _CountryPickerField({
    required this.selectedCountry,
    required this.onPressed,
  });

  final String? selectedCountry;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final displayCountry = selectedCountry;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Area',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: Material(
            color: Colors.white.withValues(alpha: 0.93),
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 18, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayCountry ?? 'Choose your country',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: displayCountry == null
                              ? const Color(0xFF7B7488).withValues(alpha: 0.62)
                              : const Color(0xFF231A35),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.expand_more_rounded,
                      color: Color(0xFF8F879D),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CountryChoiceTile extends StatelessWidget {
  const _CountryChoiceTile({
    required this.country,
    required this.isSelected,
    required this.onPressed,
  });

  final _CountryOption country;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? Colors.white.withValues(alpha: 0.24)
          : Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  country.code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  country.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_rounded, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryOption {
  const _CountryOption(this.name, this.code);

  final String name;
  final String code;
}

const _countryOptions = [
  _CountryOption('United States', 'US'),
  _CountryOption('China', 'CN'),
  _CountryOption('Canada', 'CA'),
  _CountryOption('United Kingdom', 'UK'),
  _CountryOption('Australia', 'AU'),
  _CountryOption('Japan', 'JP'),
  _CountryOption('South Korea', 'KR'),
  _CountryOption('Singapore', 'SG'),
  _CountryOption('Germany', 'DE'),
  _CountryOption('France', 'FR'),
  _CountryOption('Italy', 'IT'),
  _CountryOption('Spain', 'ES'),
  _CountryOption('Netherlands', 'NL'),
  _CountryOption('Brazil', 'BR'),
  _CountryOption('Mexico', 'MX'),
  _CountryOption('India', 'IN'),
  _CountryOption('Indonesia', 'ID'),
  _CountryOption('Thailand', 'TH'),
  _CountryOption('Vietnam', 'VN'),
  _CountryOption('Philippines', 'PH'),
  _CountryOption('Malaysia', 'MY'),
  _CountryOption('New Zealand', 'NZ'),
  _CountryOption('United Arab Emirates', 'UAE'),
];

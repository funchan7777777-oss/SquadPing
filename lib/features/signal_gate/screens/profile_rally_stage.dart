import 'package:flutter/material.dart';

import '../models/gate_profile_origin.dart';
import '../services/local_gate_record_keeper.dart';
import '../widgets/account_crosslink.dart';
import '../widgets/full_bleed_asset_stage.dart';
import '../widgets/gate_back_button.dart';
import '../widgets/gate_notice_dialog.dart';
import '../widgets/gate_text_action_button.dart';
import '../widgets/credential_lane_field.dart';
import '../../../shared/visuals/squad_ping_assets.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();
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
              child: const _ProfilePlaceholderArt(),
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

    setState(() => _isSavingProfile = true);
    await widget.recordKeeper.saveProfileAndOpenSession(
      displayName: displayName,
      areaSignal: areaSignal,
      signatureLine: signatureLine,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSavingProfile = false);
    await widget.onProfileConfirmed();
  }
}

class _ProfilePlaceholderArt extends StatelessWidget {
  const _ProfilePlaceholderArt();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164,
      height: 112,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.52),
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.32),
                  Colors.white.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Container(
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 24,
            child: Icon(
              Icons.image_outlined,
              color: Colors.white.withValues(alpha: 0.84),
              size: 34,
            ),
          ),
          Positioned(
            right: 22,
            top: 22,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFB15E).withValues(alpha: 0.86),
              ),
            ),
          ),
        ],
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
                        displayCountry ?? 'Choose country',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: displayCountry == null
                              ? const Color(
                                  0xFF7B7488,
                                ).withValues(alpha: 0.62)
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
              Text(
                country.flag,
                style: const TextStyle(fontSize: 20, letterSpacing: 0),
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
  const _CountryOption(this.name, this.flag);

  final String name;
  final String flag;
}

const _countryOptions = [
  _CountryOption('United States', '🇺🇸'),
  _CountryOption('China', '🇨🇳'),
  _CountryOption('Canada', '🇨🇦'),
  _CountryOption('United Kingdom', '🇬🇧'),
  _CountryOption('Australia', '🇦🇺'),
  _CountryOption('Japan', '🇯🇵'),
  _CountryOption('South Korea', '🇰🇷'),
  _CountryOption('Singapore', '🇸🇬'),
  _CountryOption('Germany', '🇩🇪'),
  _CountryOption('France', '🇫🇷'),
  _CountryOption('Italy', '🇮🇹'),
  _CountryOption('Spain', '🇪🇸'),
  _CountryOption('Netherlands', '🇳🇱'),
  _CountryOption('Brazil', '🇧🇷'),
  _CountryOption('Mexico', '🇲🇽'),
  _CountryOption('India', '🇮🇳'),
  _CountryOption('Indonesia', '🇮🇩'),
  _CountryOption('Thailand', '🇹🇭'),
  _CountryOption('Vietnam', '🇻🇳'),
  _CountryOption('Philippines', '🇵🇭'),
  _CountryOption('Malaysia', '🇲🇾'),
  _CountryOption('New Zealand', '🇳🇿'),
  _CountryOption('United Arab Emirates', '🇦🇪'),
];

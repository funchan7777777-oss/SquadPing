import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../signal_gate/services/local_gate_record_keeper.dart';
import '../widgets/profile_avatar_image.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key, required this.recordKeeper});

  final LocalGateRecordKeeper recordKeeper;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _imagePicker = ImagePicker();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _areaController = TextEditingController();
  String? _avatarPath;
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await widget.recordKeeper.initialize();
    final profile = await widget.recordKeeper.loadProfile();
    if (mounted) {
      setState(() {
        _nameController.text = profile.displayName;
        _ageController.text = '${profile.age}';
        _areaController.text = profile.areaSignal;
        _avatarPath = profile.avatarPath;
        _isReady = true;
      });
    }
  }

  Future<void> _pickAvatar() {
    FocusScope.of(context).unfocus();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7D45FF), Color(0xFFA85CFF)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AvatarSourceTile(
              icon: Icons.photo_library_rounded,
              title: 'Choose from library',
              onTap: () {
                Navigator.of(context).pop();
                _readAvatar(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
            _AvatarSourceTile(
              icon: Icons.photo_camera_rounded,
              title: 'Take a new photo',
              onTap: () {
                Navigator.of(context).pop();
                _readAvatar(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _readAvatar(ImageSource source) async {
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
      await showSafetyFeedbackDialog(
        context: context,
        title: 'Photo unavailable',
        message: 'Check camera or photo permissions and try again.',
      );
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final area = _areaController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    if (name.isEmpty || area.isEmpty || age == null || age < 13 || age > 99) {
      await showSafetyFeedbackDialog(
        context: context,
        title: 'Profile incomplete',
        message: 'Enter a name, age from 13 to 99, and area before confirming.',
      );
      return;
    }
    await widget.recordKeeper.updateProfile(
      displayName: name,
      areaSignal: area,
      age: age,
      avatarPath: _avatarPath,
    );
    if (!mounted) {
      return;
    }
    await showSafetyFeedbackDialog(
      context: context,
      title: 'Profile updated',
      message: 'Your profile information has been saved locally.',
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF7138F5),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              SquadPingAssets.gameZoneChatBackdrop,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: !_isReady
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(
                          18,
                          squadCompactTopPadding(context),
                          18,
                          28,
                        ),
                        children: [
                          _EditHeader(
                            onBack: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: GestureDetector(
                              onTap: _pickAvatar,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipOval(
                                    child: ProfileAvatarImage(
                                      avatarPath: _avatarPath,
                                      width: 110,
                                      height: 110,
                                    ),
                                  ),
                                  Positioned(
                                    right: 2,
                                    bottom: 6,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8B7CF6),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.photo_camera_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          _EditField(
                            label: 'Name',
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            onClear: () => _nameController.clear(),
                          ),
                          const SizedBox(height: 22),
                          _EditField(
                            label: 'Age',
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 22),
                          _EditField(
                            label: 'Area',
                            controller: _areaController,
                            textInputAction: TextInputAction.done,
                            onClear: () => _areaController.clear(),
                          ),
                          const SizedBox(height: 56),
                          SizedBox(
                            height: 58,
                            child: FilledButton(
                              onPressed: _save,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: Text(
                                'confirm',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditHeader extends StatelessWidget {
  const _EditHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        Expanded(
          child: Text(
            'Edit data',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.label,
    required this.controller,
    required this.textInputAction,
    this.keyboardType,
    this.onClear,
  });

  final String label;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 16, 0),
            suffixIcon: onClear == null
                ? null
                : IconButton(
                    onPressed: onClear,
                    icon: const Icon(Icons.close_rounded),
                    color: const Color(0xFF96939E),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarSourceTile extends StatelessWidget {
  const _AvatarSourceTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
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

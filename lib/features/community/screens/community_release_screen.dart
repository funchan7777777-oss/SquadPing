import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/moderation/moderation_queue.dart';
import '../../../shared/safety/safety_text_guard.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../profile_center/services/coin_economy.dart';
import '../../profile_center/services/profile_wallet_store.dart';
import '../../profile_center/widgets/coin_feedback.dart';

class CommunityReleaseScreen extends StatefulWidget {
  const CommunityReleaseScreen({super.key});

  @override
  State<CommunityReleaseScreen> createState() => _CommunityReleaseScreenState();
}

class _CommunityReleaseScreenState extends State<CommunityReleaseScreen> {
  static const _releaseCost = CoinEconomy.communityPostCost;
  static const _maxPhotos = 6;

  late final TextEditingController _textController;
  final _imagePicker = ImagePicker();
  final _walletStore = ProfileWalletStore.instance;
  final List<XFile> _selectedPhotos = [];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _walletStore.initialize();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _showPhotoSourcePicker() {
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF753DFF), Color(0xFFA84CFF)],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
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
              _PhotoSourceTile(
                icon: Icons.photo_library_rounded,
                title: 'Choose from album',
                subtitle: 'Upload photos from your local library',
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromAlbum();
                },
              ),
              const SizedBox(height: 10),
              _PhotoSourceTile(
                icon: Icons.photo_camera_rounded,
                title: 'Take a photo',
                subtitle: 'Open camera and attach a new shot',
                onTap: () {
                  Navigator.of(context).pop();
                  _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromAlbum() async {
    if (_selectedPhotos.length >= _maxPhotos) {
      _showSnack('You can add up to $_maxPhotos photos.');
      return;
    }
    try {
      final photos = await _imagePicker.pickMultiImage(
        imageQuality: 86,
        maxWidth: 1800,
      );
      if (photos.isEmpty || !mounted) {
        return;
      }
      final remaining = _maxPhotos - _selectedPhotos.length;
      setState(() => _selectedPhotos.addAll(photos.take(remaining)));
      if (photos.length > remaining) {
        _showSnack('Only $remaining more photos were added.');
      }
    } catch (_) {
      if (mounted) {
        _showSnack('Photo access failed. Check permissions and try again.');
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_selectedPhotos.length >= _maxPhotos) {
      _showSnack('You can add up to $_maxPhotos photos.');
      return;
    }
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 86,
        maxWidth: 1800,
      );
      if (photo == null || !mounted) {
        return;
      }
      setState(() => _selectedPhotos.add(photo));
    } catch (_) {
      if (mounted) {
        _showSnack('Camera unavailable. Check permissions and try again.');
      }
    }
  }

  void _removePhoto(XFile photo) {
    setState(() => _selectedPhotos.remove(photo));
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _release() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      _showSnack('Say something before releasing.');
      return;
    }
    if (_selectedPhotos.isEmpty) {
      _showSnack('Add at least one real photo before releasing.');
      return;
    }
    if (!await ensureSafetyTextAllowed(context, text, fieldLabel: 'Post')) {
      return;
    }
    final charged = await _walletStore.spendCoins(_releaseCost);
    if (!charged) {
      if (mounted) {
        await showInsufficientCoinsDialog(
          context,
          cost: _releaseCost,
          balance: _walletStore.coins,
        );
      }
      return;
    }
    if (!mounted) {
      return;
    }
    showCoinSpentSnack(
      context,
      cost: _releaseCost,
      balance: _walletStore.coins,
    );
    await ModerationQueue.instance.enqueuePending(
      itemId: 'community-${DateTime.now().microsecondsSinceEpoch}',
      itemType: 'community_post',
      text: text,
    );
    if (!mounted) {
      return;
    }
    await showModerationQueuedDialog(context);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF7A35F5),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              SquadPingAssets.gameZoneChatBackdrop,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6535F2).withValues(alpha: 0.84),
                    const Color(0xFF8244F9).withValues(alpha: 0.76),
                    const Color(0xFFC855F7).withValues(alpha: 0.64),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    squadCompactTopPadding(context),
                    24,
                    26,
                  ),
                  children: [
                    _ReleaseHeader(onBack: () => Navigator.of(context).pop()),
                    const SizedBox(height: 18),
                    Text(
                      'Let me introduce it.',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _TextBox(controller: _textController),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Add photos',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          '${_selectedPhotos.length}/$_maxPhotos',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.78),
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _PhotoUploadStrip(
                      selectedPhotos: _selectedPhotos,
                      onAddPhoto: _showPhotoSourcePicker,
                      onRemovePhoto: _removePhoto,
                    ),
                    const SizedBox(height: 34),
                    _CostLine(cost: _releaseCost),
                    const SizedBox(height: 22),
                    _ReleaseButton(onPressed: _release),
                    const SizedBox(height: 10),
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

class _ReleaseHeader extends StatelessWidget {
  const _ReleaseHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          iconSize: 32,
        ),
        Expanded(
          child: Text(
            'release',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _TextBox extends StatelessWidget {
  const _TextBox({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        expands: true,
        minLines: null,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: const Color(0xFF2C2440),
          height: 1.32,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: 'Say something',
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFFA4A1AC),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        ),
      ),
    );
  }
}

class _PhotoUploadStrip extends StatelessWidget {
  const _PhotoUploadStrip({
    required this.selectedPhotos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  final List<XFile> selectedPhotos;
  final VoidCallback onAddPhoto;
  final ValueChanged<XFile> onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: SizedBox(
        height: 112,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: selectedPhotos.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _AddPhotoTile(onTap: onAddPhoto);
            }
            final photo = selectedPhotos[index - 1];
            return _SelectedPhotoTile(
              photo: photo,
              onRemove: () => onRemovePhoto(photo),
            );
          },
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add photo',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF6E3DF3).withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_photo_alternate_rounded,
                  color: Color(0xFF6E3DF3),
                  size: 27,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Upload',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF37265C),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Album / Camera',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF8A8496),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedPhotoTile extends StatelessWidget {
  const _SelectedPhotoTile({required this.photo, required this.onRemove});

  final XFile photo;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(photo.path),
            width: 128,
            height: 112,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onRemove,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5865),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoSourceTile extends StatelessWidget {
  const _PhotoSourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF6E3DF3), size: 26),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _CostLine extends StatelessWidget {
  const _CostLine({required this.cost});

  final int cost;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Unlocking dynamic posting costs\n'),
          TextSpan(text: '$cost '),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
              Icons.monetization_on_rounded,
              size: 24,
              color: Color(0xFFFFD24A),
            ),
          ),
          const TextSpan(text: ' gold coins.'),
        ],
      ),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        height: 1.28,
      ),
    );
  }
}

class _ReleaseButton extends StatelessWidget {
  const _ReleaseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 268,
        height: 68,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: Text(
            'release',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

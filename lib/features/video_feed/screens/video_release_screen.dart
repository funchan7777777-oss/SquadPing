import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../data/video_feed_seed.dart';
import '../models/video_feed_models.dart';

class VideoReleaseScreen extends StatefulWidget {
  const VideoReleaseScreen({super.key, required this.walletCoins});

  final int walletCoins;

  @override
  State<VideoReleaseScreen> createState() => _VideoReleaseScreenState();
}

class _VideoReleaseScreenState extends State<VideoReleaseScreen> {
  static const _releaseCost = 10;

  late final TextEditingController _captionController;
  final _imagePicker = ImagePicker();
  final List<XFile> _selectedPhotos = [];
  late String _selectedVideoAsset;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
    _selectedVideoAsset = VideoFeedSeed.releaseVideoOptions.first.videoAsset;
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    if (_selectedPhotos.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can add up to 3 photos.')),
      );
      return;
    }
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 86,
      );
      if (photo == null || !mounted) {
        return;
      }
      setState(() => _selectedPhotos.add(photo));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo access failed. Try again.')),
      );
    }
  }

  void _removePhoto(XFile photo) {
    setState(() => _selectedPhotos.remove(photo));
  }

  void _release() {
    final caption = _captionController.text.trim();
    if (caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Say something before releasing.')),
      );
      return;
    }
    if (widget.walletCoins < _releaseCost) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not enough gold coins.')));
      return;
    }
    Navigator.of(context).pop(
      VideoDraftResult(
        caption: caption,
        videoAsset: _selectedVideoAsset,
        attachedPhotos: _selectedPhotos.map((photo) => photo.path).toList(),
        cost: _releaseCost,
      ),
    );
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
                    const Color(0xFF6436F3).withValues(alpha: 0.78),
                    const Color(0xFF8045F9).withValues(alpha: 0.72),
                    const Color(0xFFC954FA).withValues(alpha: 0.58),
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
                    30,
                  ),
                  children: [
                    _ReleaseHeader(onBack: () => Navigator.of(context).pop()),
                    const SizedBox(height: 20),
                    Text(
                      'Let me introduce it.',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _CaptionField(controller: _captionController),
                    const SizedBox(height: 26),
                    Text(
                      'Add photos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PhotoPicker(
                      selectedPhotos: _selectedPhotos,
                      onPickPhoto: _pickPhoto,
                      onRemovePhoto: _removePhoto,
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'Choose clip',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ClipSelector(
                      selectedVideoAsset: _selectedVideoAsset,
                      onSelected: (asset) {
                        setState(() => _selectedVideoAsset = asset);
                      },
                    ),
                    const SizedBox(height: 32),
                    _CostLine(cost: _releaseCost),
                    const SizedBox(height: 22),
                    _ReleaseButton(onPressed: _release),
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
        ),
        Expanded(
          child: Text(
            'release',
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

class _CaptionField extends StatelessWidget {
  const _CaptionField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 178,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.78)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 18,
            offset: Offset(0, 10),
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
          height: 1.3,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: 'Say something',
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF9B9AA2)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        ),
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.selectedPhotos,
    required this.onPickPhoto,
    required this.onRemovePhoto,
  });

  final List<XFile> selectedPhotos;
  final VoidCallback onPickPhoto;
  final ValueChanged<XFile> onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: selectedPhotos.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddPhotoTile(onTap: onPickPhoto);
          }
          final photo = selectedPhotos[index - 1];
          return _SelectedPhotoTile(
            photo: photo,
            onRemove: () => onRemovePhoto(photo),
          );
        },
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104,
        height: 104,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF787878), width: 1.5),
          ),
          child: const Icon(
            Icons.add_circle_outline_rounded,
            color: Color(0xFF787878),
            size: 28,
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
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            File(photo.path),
            width: 104,
            height: 104,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
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

class _ClipSelector extends StatelessWidget {
  const _ClipSelector({
    required this.selectedVideoAsset,
    required this.onSelected,
  });

  final String selectedVideoAsset;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: VideoFeedSeed.releaseVideoOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final clip = VideoFeedSeed.releaseVideoOptions[index];
          final isSelected = clip.videoAsset == selectedVideoAsset;
          return GestureDetector(
            onTap: () => onSelected(clip.videoAsset),
            child: Container(
              width: 142,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: isSelected ? 0.96 : 0.13),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.18),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF603BF0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(7),
                    child: Image.asset(
                      isSelected
                          ? SquadPingAssets.videoCameraEnabledGlyph
                          : SquadPingAssets.videoCameraMutedGlyph,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      clip.tags.first,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? const Color(0xFF4D20E8)
                            : Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
              size: 23,
              color: Color(0xFFFFD24A),
            ),
          ),
          const TextSpan(text: ' gold coins.'),
        ],
      ),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w800,
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

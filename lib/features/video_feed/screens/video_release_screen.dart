import 'package:flutter/material.dart';

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
  final Set<String> _selectedPhotos = {};
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

  void _togglePhoto(String asset) {
    setState(() {
      if (_selectedPhotos.contains(asset)) {
        _selectedPhotos.remove(asset);
      } else {
        _selectedPhotos.add(asset);
      }
    });
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
        attachedPhotos: _selectedPhotos.toList(),
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
                  children: [
                    _ReleaseHeader(onBack: () => Navigator.of(context).pop()),
                    const SizedBox(height: 18),
                    Text(
                      'Let me introduce it.',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CaptionField(controller: _captionController),
                    const SizedBox(height: 24),
                    Text(
                      'Add photos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _PhotoPicker(
                      selectedPhotos: _selectedPhotos,
                      onTogglePhoto: _togglePhoto,
                    ),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 34),
                    _CostLine(cost: _releaseCost),
                    const SizedBox(height: 24),
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
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        minLines: 6,
        maxLines: 8,
        textInputAction: TextInputAction.newline,
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
    required this.onTogglePhoto,
  });

  final Set<String> selectedPhotos;
  final ValueChanged<String> onTogglePhoto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: VideoFeedSeed.releasePhotoOptions.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _AddPhotoTile();
          }
          final asset = VideoFeedSeed.releasePhotoOptions[index - 1];
          final isSelected = selectedPhotos.contains(asset);
          return GestureDetector(
            onTap: () => onTogglePhoto(asset),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    asset,
                    width: 116,
                    height: 116,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.28),
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(SquadPingAssets.videoDeleteGlyph),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      height: 116,
      decoration: const BoxDecoration(color: Colors.white),
      alignment: Alignment.center,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF787878), width: 1.5),
        ),
        child: const Icon(
          Icons.add_circle_outline_rounded,
          color: Color(0xFF787878),
        ),
      ),
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
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: VideoFeedSeed.releaseVideoOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final clip = VideoFeedSeed.releaseVideoOptions[index];
          final isSelected = clip.videoAsset == selectedVideoAsset;
          return GestureDetector(
            onTap: () => onSelected(clip.videoAsset),
            child: Container(
              width: 126,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: isSelected ? 0.96 : 0.18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.20),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    isSelected
                        ? SquadPingAssets.videoCameraEnabledGlyph
                        : SquadPingAssets.videoCameraMutedGlyph,
                    width: 34,
                    height: 34,
                  ),
                  const SizedBox(width: 8),
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

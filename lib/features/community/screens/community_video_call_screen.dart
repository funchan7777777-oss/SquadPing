import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../models/community_models.dart';

class CommunityVideoCallScreen extends StatefulWidget {
  const CommunityVideoCallScreen({super.key, required this.peer});

  final CommunityUser peer;

  @override
  State<CommunityVideoCallScreen> createState() =>
      _CommunityVideoCallScreenState();
}

class _CommunityVideoCallScreenState extends State<CommunityVideoCallScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  var _cameraIndex = 0;
  String? _notice;
  var _isMicMuted = false;
  var _isCameraMuted = false;

  @override
  void initState() {
    super.initState();
    _prepareCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _prepareCamera() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();
    if (!cameraStatus.isGranted || !micStatus.isGranted) {
      if (!mounted) {
        return;
      }
      setState(() {
        _notice =
            'Camera and microphone permission are required for video call preview.';
      });
      return;
    }
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      if (!mounted) {
        return;
      }
      setState(() => _notice = 'No camera is available on this device.');
      return;
    }
    final frontIndex = cameras.indexWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    _cameras = cameras;
    _cameraIndex = frontIndex == -1 ? 0 : frontIndex;
    final frontCamera = cameras[_cameraIndex];
    final controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: true,
    );
    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() => _controller = controller);
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) {
      return;
    }
    final oldController = _controller;
    setState(() {
      _controller = null;
      _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    });
    await oldController?.dispose();
    final controller = CameraController(
      _cameras[_cameraIndex],
      ResolutionPreset.medium,
      enableAudio: true,
    );
    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() => _controller = controller);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(widget.peer.avatarAsset, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.16),
                    Colors.black.withValues(alpha: 0.62),
                  ],
                  stops: const [0, 0.52, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                10,
                squadCompactTopPadding(context),
                14,
                0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Text(
                      widget.peer.displayName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
          Positioned(
            top: squadCompactTopPadding(context, extra: 66),
            right: 18,
            child: Container(
              width: 138,
              height: 172,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  controller != null &&
                      controller.value.isInitialized &&
                      !_isCameraMuted
                  ? CameraPreview(controller)
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          _notice ?? 'Camera preview paused',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 26,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.38),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CallButton(
                      asset: SquadPingAssets.callFlipGlyph,
                      label: 'Flip',
                      onTap: _flipCamera,
                    ),
                    _CallButton(
                      asset: _isCameraMuted
                          ? SquadPingAssets.videoCameraMutedGlyph
                          : SquadPingAssets.communityCallGlyph,
                      label: _isCameraMuted ? 'Video off' : 'Video on',
                      onTap: () =>
                          setState(() => _isCameraMuted = !_isCameraMuted),
                    ),
                    _CallButton(
                      asset: _isMicMuted
                          ? SquadPingAssets.videoMicMutedGlyph
                          : SquadPingAssets.communityMicGlyph,
                      label: _isMicMuted ? 'Mic off' : 'Mic on',
                      onTap: () => setState(() => _isMicMuted = !_isMicMuted),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.asset(
                        SquadPingAssets.callEndGlyph,
                        width: 58,
                        height: 58,
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

class _CallButton extends StatelessWidget {
  const _CallButton({
    required this.asset,
    required this.label,
    required this.onTap,
  });

  final String asset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(asset, width: 58, height: 58),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerSurface extends StatefulWidget {
  const VideoPlayerSurface({
    super.key,
    required this.asset,
    required this.isActive,
  });

  final String asset;
  final bool isActive;

  @override
  State<VideoPlayerSurface> createState() => _VideoPlayerSurfaceState();
}

class _VideoPlayerSurfaceState extends State<VideoPlayerSurface> {
  late final VideoPlayerController _controller;
  var _isReady = false;
  var _isManuallyPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.asset)
      ..setLooping(true)
      ..setVolume(0);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() => _isReady = true);
      if (widget.isActive) {
        _controller.play();
      }
    });
  }

  @override
  void didUpdateWidget(covariant VideoPlayerSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive == widget.isActive || !_isReady) {
      return;
    }
    if (widget.isActive) {
      if (!_isManuallyPaused) {
        _controller.play();
      }
    } else {
      _isManuallyPaused = false;
      _controller.pause();
    }
    setState(() {});
  }

  void _togglePlayback() {
    if (!_isReady || !widget.isActive) {
      return;
    }
    if (_controller.value.isPlaying) {
      _isManuallyPaused = true;
      _controller.pause();
    } else {
      _isManuallyPaused = false;
      _controller.play();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5E4BDB), Color(0xFF25A9D8)],
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.6,
            color: Colors.white,
          ),
        ),
      );
    }

    final size = _controller.value.size;
    final showPlayCue = widget.isActive && !_controller.value.isPlaying;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _togglePlayback,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: VideoPlayer(_controller),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: AnimatedOpacity(
                opacity: showPlayCue ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.42),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 56,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

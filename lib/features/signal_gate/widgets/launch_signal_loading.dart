import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import 'full_bleed_asset_stage.dart';

class LaunchSignalLoading extends StatefulWidget {
  const LaunchSignalLoading({super.key});

  @override
  State<LaunchSignalLoading> createState() => _LaunchSignalLoadingState();
}

class _LaunchSignalLoadingState extends State<LaunchSignalLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FullBleedAssetStage(
      backdropAsset: SquadPingAssets.gatewayLaunch,
      foreground: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 84),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.46, end: 1).animate(
              CurvedAnimation(
                parent: _pulseController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _LaunchDot(delaySlot: 0),
                    SizedBox(width: 8),
                    _LaunchDot(delaySlot: 1),
                    SizedBox(width: 8),
                    _LaunchDot(delaySlot: 2),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Opening your squad signal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LaunchDot extends StatelessWidget {
  const _LaunchDot({required this.delaySlot});

  final int delaySlot;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.58, end: 1),
      duration: Duration(milliseconds: 720 + delaySlot * 130),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: value),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }
}

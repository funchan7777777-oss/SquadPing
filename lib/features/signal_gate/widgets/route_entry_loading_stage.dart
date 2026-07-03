import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import 'full_bleed_asset_stage.dart';

class RouteEntryLoadingStage extends StatefulWidget {
  const RouteEntryLoadingStage({super.key, required this.caption});

  final String caption;

  @override
  State<RouteEntryLoadingStage> createState() => _RouteEntryLoadingStageState();
}

class _RouteEntryLoadingStageState extends State<RouteEntryLoadingStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FullBleedAssetStage(
      backdropAsset: SquadPingAssets.background,
      foreground: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _spinController,
              child: Container(
                width: 86,
                height: 86,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.68),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB16CFF).withValues(alpha: 0.32),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Image.asset(SquadPingAssets.appMark),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.caption,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Syncing your local squad card',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.76),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

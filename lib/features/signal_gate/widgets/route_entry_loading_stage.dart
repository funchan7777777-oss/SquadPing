import 'dart:math' as math;

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
  late final AnimationController _loopController;

  @override
  void initState() {
    super.initState();
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FullBleedAssetStage(
      backdropAsset: SquadPingAssets.background,
      foreground: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.04),
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.03),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SignalLoadingMark(controller: _loopController),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    child: Text(
                      widget.caption,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                        height: 1.12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Getting your room ready',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _SignalLoadingBar(controller: _loopController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalLoadingMark extends StatelessWidget {
  const _SignalLoadingMark({required this.controller});

  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = controller.value;
        final pulse = 0.5 + math.sin(progress * math.pi * 2) * 0.5;

        return SizedBox(
          width: 132,
          height: 132,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 112 + pulse * 8,
                height: 112 + pulse * 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05 + pulse * 0.03),
                ),
              ),
              CustomPaint(
                size: const Size.square(118),
                painter: _SignalRingPainter(progress: progress),
              ),
              Transform.rotate(
                angle: progress * math.pi * 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB45F),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFFFB45F,
                          ).withValues(alpha: 0.52),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.34),
                      Colors.white.withValues(alpha: 0.14),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.46),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5A34CE).withValues(alpha: 0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.groups_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 34,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SignalRingPainter extends CustomPainter {
  const _SignalRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 5;
    final ringRect = Rect.fromCircle(center: center, radius: radius);
    final basePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.24)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.4;
    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.88),
          const Color(0xFFFFB45F).withValues(alpha: 0.9),
          Colors.white.withValues(alpha: 0.08),
        ],
        stops: const [0, 0.42, 0.72, 1],
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(ringRect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.4;

    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(
      ringRect,
      -math.pi / 2 + progress * math.pi * 2,
      math.pi * 1.24,
      false,
      arcPaint,
    );
    canvas.drawCircle(center, radius - 16, basePaint..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(covariant _SignalRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _SignalLoadingBar extends StatelessWidget {
  const _SignalLoadingBar({required this.controller});

  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 162,
      height: 4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(999),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment(-1 + controller.value * 2, 0),
                child: FractionallySizedBox(
                  widthFactor: 0.38,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0.9),
                          const Color(0xFFFFB45F).withValues(alpha: 0.92),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

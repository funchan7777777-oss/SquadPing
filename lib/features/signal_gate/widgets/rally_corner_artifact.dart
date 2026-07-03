import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';

class RallyCornerArtifact extends StatelessWidget {
  const RallyCornerArtifact({super.key, this.top = 65});

  final double top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: -18,
      child: IgnorePointer(
        child: Image.asset(
          SquadPingAssets.rallyArtifact,
          width: 164,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

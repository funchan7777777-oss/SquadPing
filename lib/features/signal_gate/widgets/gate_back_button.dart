import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';

class GateBackButton extends StatelessWidget {
  const GateBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      top: 58,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            SquadPingAssets.backGlyph,
            width: 26,
            height: 26,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

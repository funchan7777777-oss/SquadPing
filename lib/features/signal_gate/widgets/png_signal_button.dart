import 'package:flutter/material.dart';

class PngSignalButton extends StatelessWidget {
  const PngSignalButton({
    super.key,
    required this.assetPath,
    required this.semanticLabel,
    required this.onPressed,
    this.widthFactor = 0.78,
    this.maxWidth = 310,
  });

  final String assetPath;
  final String semanticLabel;
  final VoidCallback onPressed;
  final double widthFactor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = MediaQuery.sizeOf(context).width;
        final buttonWidth = (viewportWidth * widthFactor).clamp(
          220.0,
          maxWidth,
        );

        return Semantics(
          button: true,
          label: semanticLabel,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
            child: Image.asset(
              assetPath,
              width: buttonWidth,
              fit: BoxFit.fitWidth,
            ),
          ),
        );
      },
    );
  }
}

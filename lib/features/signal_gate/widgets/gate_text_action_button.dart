import 'package:flutter/material.dart';

class GateTextActionButton extends StatelessWidget {
  const GateTextActionButton({
    super.key,
    required this.caption,
    required this.semanticLabel,
    required this.onPressed,
    this.widthFactor = 0.68,
    this.maxWidth = 260,
  });

  final String caption;
  final String semanticLabel;
  final VoidCallback onPressed;
  final double widthFactor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final buttonWidth = (viewportWidth * widthFactor).clamp(220.0, maxWidth);

    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          width: buttonWidth,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            caption,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}

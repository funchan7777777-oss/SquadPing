import 'package:flutter/material.dart';

class FullBleedAssetStage extends StatelessWidget {
  const FullBleedAssetStage({
    super.key,
    required this.backdropAsset,
    required this.foreground,
    this.allowKeyboardInset = false,
  });

  final String backdropAsset;
  final Widget foreground;
  final bool allowKeyboardInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: allowKeyboardInset,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(backdropAsset, fit: BoxFit.fill),
          foreground,
        ],
      ),
    );
  }
}

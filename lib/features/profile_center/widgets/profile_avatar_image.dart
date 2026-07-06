import 'dart:io';

import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';

class ProfileAvatarImage extends StatelessWidget {
  const ProfileAvatarImage({
    super.key,
    this.avatarPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String? avatarPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final path = avatarPath;
    if (path != null && path.trim().isNotEmpty && File(path).existsSync()) {
      return Image.file(File(path), width: width, height: height, fit: fit);
    }
    return Image.asset(
      SquadPingAssets.avatarFemaleSunlitSelfie,
      width: width,
      height: height,
      fit: fit,
    );
  }
}

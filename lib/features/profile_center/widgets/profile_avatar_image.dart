import 'dart:io';

import 'package:flutter/material.dart';

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
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8DFFF), Color(0xFF7E56F4)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final iconSize = _placeholderIconSize(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            return Center(
              child: Icon(
                Icons.person_rounded,
                size: iconSize,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  double _placeholderIconSize(double? width, double? height) {
    final sides = [width, height, this.width, this.height]
        .whereType<double>()
        .where((value) => value > 0 && value.isFinite)
        .toList();
    final shortestSide = sides.isEmpty
        ? 96.0
        : sides.reduce((current, value) => value < current ? value : current);
    return shortestSide * 0.46;
  }
}

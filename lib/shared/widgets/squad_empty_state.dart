import 'package:flutter/material.dart';

import '../visuals/squad_ping_assets.dart';

Widget buildSquadEmptyState({
  double size = 156,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 28),
}) {
  return Padding(
    padding: padding,
    child: Center(
      child: Image.asset(
        SquadPingAssets.emptyState,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    ),
  );
}

class SquadEmptyState extends StatelessWidget {
  const SquadEmptyState({
    super.key,
    this.size = 156,
    this.padding = const EdgeInsets.symmetric(vertical: 28),
  });

  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return buildSquadEmptyState(size: size, padding: padding);
  }
}

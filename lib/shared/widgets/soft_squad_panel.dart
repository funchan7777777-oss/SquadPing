import 'package:flutter/material.dart';

import '../../app/theme/squad_ping_colors.dart';

class SoftSquadPanel extends StatelessWidget {
  const SoftSquadPanel({
    super.key,
    required this.child,
    this.panelPadding = const EdgeInsets.all(16),
    this.panelTint,
    this.borderTint,
    this.onPanelPressed,
  });

  final Widget child;
  final EdgeInsetsGeometry panelPadding;
  final Color? panelTint;
  final Color? borderTint;
  final VoidCallback? onPanelPressed;

  @override
  Widget build(BuildContext context) {
    final decoratedPanel = Container(
      width: double.infinity,
      padding: panelPadding,
      decoration: BoxDecoration(
        color: panelTint ?? SquadPingColors.raisedSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderTint ?? SquadPingColors.borderTrace),
      ),
      child: child,
    );

    if (onPanelPressed == null) {
      return decoratedPanel;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPanelPressed,
        child: decoratedPanel,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';

class GameZoneComposer extends StatelessWidget {
  const GameZoneComposer({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSend,
    this.backgroundAsset = SquadPingAssets.gameZoneChatBackdrop,
    this.backgroundFit = BoxFit.cover,
    this.backgroundColorFilter = const ColorFilter.mode(
      Color(0x997D36F4),
      BlendMode.srcATop,
    ),
    this.showBackground = true,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSend;
  final String backgroundAsset;
  final BoxFit backgroundFit;
  final ColorFilter? backgroundColorFilter;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomPadding = bottomInset == 0 ? 12.0 : bottomInset;

    return Container(
      padding: EdgeInsets.fromLTRB(18, 10, 18, bottomPadding),
      decoration: showBackground
          ? BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF8B45F7), Color(0xFFC655F7)],
              ),
              image: DecorationImage(
                image: AssetImage(backgroundAsset),
                fit: backgroundFit,
                alignment: Alignment.bottomCenter,
                colorFilter: backgroundColorFilter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, -8),
                ),
              ],
            )
          : null,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFB8B8C5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Semantics(
            button: true,
            label: 'Send',
            child: GestureDetector(
              onTap: onSend,
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  SquadPingAssets.sendGlyph,
                  width: 34,
                  height: 34,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

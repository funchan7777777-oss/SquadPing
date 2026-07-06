import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';

class VideoCommentComposer extends StatelessWidget {
  const VideoCommentComposer({
    super.key,
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 26),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 58,
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter what you want to send',
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFBDB9C5),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            Semantics(
              button: true,
              label: 'Send comment',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSend,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    SquadPingAssets.sendGlyph,
                    width: 36,
                    height: 36,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
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
                  hintText: 'Enter what you want to send',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFC5C3CC),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 13,
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
              label: 'Send comment',
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
      ),
    );
  }
}

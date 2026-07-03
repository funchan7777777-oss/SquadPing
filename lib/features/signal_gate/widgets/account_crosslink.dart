import 'package:flutter/material.dart';

class AccountCrosslink extends StatelessWidget {
  const AccountCrosslink({
    super.key,
    required this.prompt,
    required this.actionLabel,
    required this.onPressed,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            prompt,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF987D),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

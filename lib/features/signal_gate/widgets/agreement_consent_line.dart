import 'package:flutter/material.dart';

class AgreementConsentLine extends StatelessWidget {
  const AgreementConsentLine({
    super.key,
    required this.isAccepted,
    required this.onAcceptanceChanged,
    required this.onTermsPressed,
    required this.onPrivacyPressed,
  });

  final bool isAccepted;
  final ValueChanged<bool> onAcceptanceChanged;
  final VoidCallback onTermsPressed;
  final VoidCallback onPrivacyPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onAcceptanceChanged(!isAccepted),
          child: Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: isAccepted
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: isAccepted
                ? const Icon(
                    Icons.check_rounded,
                    size: 17,
                    color: Color(0xFF7D45FF),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _copy('I have read and agree to the '),
              _link('User Agreement', onTermsPressed),
              _copy(' and '),
              _link('Privacy Policy', onPrivacyPressed),
              _copy('.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _copy(String value) {
    return Text(
      value,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.88),
        fontSize: 11,
        height: 1.35,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
    );
  }

  Widget _link(String value, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        value,
        style: const TextStyle(
          color: Color(0xFFFFB18F),
          fontSize: 11,
          height: 1.35,
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFFFFB18F),
          letterSpacing: 0,
        ),
      ),
    );
  }
}

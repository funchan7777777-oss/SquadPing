import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';

class CredentialLaneField extends StatefulWidget {
  const CredentialLaneField({
    super.key,
    required this.fieldLabel,
    this.keyboardType,
    this.obscuredByDefault = false,
  });

  final String fieldLabel;
  final TextInputType? keyboardType;
  final bool obscuredByDefault;

  @override
  State<CredentialLaneField> createState() => _CredentialLaneFieldState();
}

class _CredentialLaneFieldState extends State<CredentialLaneField> {
  late final TextEditingController _laneController;
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _laneController = TextEditingController();
    _isObscured = widget.obscuredByDefault;
  }

  @override
  void dispose() {
    _laneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suffixAsset = widget.obscuredByDefault
        ? (_isObscured
              ? SquadPingAssets.hiddenGlyph
              : SquadPingAssets.visibleGlyph)
        : SquadPingAssets.clearGlyph;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fieldLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: TextField(
            controller: _laneController,
            keyboardType: widget.keyboardType,
            obscureText: _isObscured,
            cursorColor: const Color(0xFF7044EC),
            style: const TextStyle(
              color: Color(0xFF231A35),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.93),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 18,
              ),
              border: _fieldBorder(),
              enabledBorder: _fieldBorder(),
              focusedBorder: _fieldBorder(
                color: Colors.white.withValues(alpha: 0.98),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  if (widget.obscuredByDefault) {
                    setState(() => _isObscured = !_isObscured);
                    return;
                  }
                  _laneController.clear();
                },
                icon: Image.asset(
                  suffixAsset,
                  width: 22,
                  height: 22,
                  color: const Color(0xFF9A9A9A),
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _fieldBorder({Color color = Colors.transparent}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}

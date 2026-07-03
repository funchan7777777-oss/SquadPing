import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';

class CredentialLaneField extends StatefulWidget {
  const CredentialLaneField({
    super.key,
    required this.fieldLabel,
    this.controller,
    this.keyboardType,
    this.obscuredByDefault = false,
    this.textInputAction,
    this.maxLines = 1,
    this.hintText,
  });

  final String fieldLabel;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscuredByDefault;
  final TextInputAction? textInputAction;
  final int maxLines;
  final String? hintText;

  @override
  State<CredentialLaneField> createState() => _CredentialLaneFieldState();
}

class _CredentialLaneFieldState extends State<CredentialLaneField> {
  TextEditingController? _ownedLaneController;
  late bool _isObscured;

  TextEditingController get _laneController =>
      widget.controller ?? _ownedLaneController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownedLaneController = TextEditingController();
    }
    _isObscured = widget.obscuredByDefault;
  }

  @override
  void dispose() {
    _ownedLaneController?.dispose();
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
          height: widget.maxLines > 1 ? 96 : 60,
          child: TextField(
            controller: _laneController,
            keyboardType: widget.keyboardType,
            obscureText: _isObscured,
            textInputAction: widget.textInputAction,
            maxLines: widget.obscuredByDefault ? 1 : widget.maxLines,
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
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: const Color(0xFF7B7488).withValues(alpha: 0.62),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
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

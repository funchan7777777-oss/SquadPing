import 'package:flutter/material.dart';

import '../../shared/markings/squad_color_token.dart';

abstract final class SquadPingColors {
  static const canvasMist = Color(0xFFF7F8F5);
  static const raisedSurface = Color(0xFFFFFFFF);
  static const borderTrace = Color(0xFFE0E3DD);
  static const inkHeavy = Color(0xFF17211B);
  static const inkSoft = Color(0xFF5D665F);
  static const cedarSignal = Color(0xFF27715D);
  static const emberSignal = Color(0xFFE15D48);
  static const marigoldSignal = Color(0xFFE7AE36);
  static const tidepoolSignal = Color(0xFF2F79A8);
  static const graphiteSignal = Color(0xFF4D5561);

  static Color laneInk(SquadColorToken token) {
    return switch (token) {
      SquadColorToken.grove => cedarSignal,
      SquadColorToken.ember => emberSignal,
      SquadColorToken.marigold => marigoldSignal,
      SquadColorToken.tidepool => tidepoolSignal,
      SquadColorToken.graphite => graphiteSignal,
    };
  }

  static Color laneWash(SquadColorToken token) {
    return laneInk(token).withValues(alpha: 0.12);
  }
}

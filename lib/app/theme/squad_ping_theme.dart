import 'package:flutter/material.dart';

import 'squad_ping_colors.dart';

const _baseFontFamily = 'Rajdhani';
const _displayFontFamily = 'Orbitron';
const _accentFontFamily = 'Oxanium';
const _fontFallbacks = <String>[
  'SF Pro Text',
  'Helvetica Neue',
  'Arial',
  'sans-serif',
];

ThemeData buildSquadPingTheme() {
  final baseScheme = ColorScheme.fromSeed(
    seedColor: SquadPingColors.cedarSignal,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: _baseFontFamily,
    fontFamilyFallback: _fontFallbacks,
    colorScheme: baseScheme.copyWith(
      primary: SquadPingColors.cedarSignal,
      secondary: SquadPingColors.emberSignal,
      tertiary: SquadPingColors.tidepoolSignal,
      surface: SquadPingColors.raisedSurface,
    ),
    scaffoldBackgroundColor: SquadPingColors.canvasMist,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: _displayFontFamily,
        fontFamilyFallback: _fontFallbacks,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.08,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontFamily: _displayFontFamily,
        fontFamilyFallback: _fontFallbacks,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontFamily: _accentFontFamily,
        fontFamilyFallback: _fontFallbacks,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontFamily: _baseFontFamily,
        fontFamilyFallback: _fontFallbacks,
        fontSize: 15,
        height: 1.4,
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        fontFamily: _baseFontFamily,
        fontFamilyFallback: _fontFallbacks,
        fontSize: 13.5,
        height: 1.35,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        fontFamily: _accentFontFamily,
        fontFamilyFallback: _fontFallbacks,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        fontFamily: _accentFontFamily,
        fontFamilyFallback: _fontFallbacks,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: SquadPingColors.raisedSurface,
      indicatorColor: SquadPingColors.cedarSignal.withValues(alpha: 0.14),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? SquadPingColors.cedarSignal
              : SquadPingColors.inkSoft,
          fontFamily: _accentFontFamily,
          fontFamilyFallback: _fontFallbacks,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: _accentFontFamily,
          fontFamilyFallback: _fontFallbacks,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: SquadPingColors.raisedSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

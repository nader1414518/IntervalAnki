import 'package:flutter/material.dart';

/// Interval's Material 3 design tokens.
///
/// A single seed color drives light/dark [ColorScheme]s so the accent stays
/// consistent across both; per-user custom accent colors (PRD §4.11) extend
/// this by swapping [_seedColor] for a user preference in a later milestone.
abstract final class AppTheme {
  static const _seedColor = Color(0xFF3D5AFE);

  static ThemeData get light => _themeFrom(Brightness.light);

  static ThemeData get dark => _themeFrom(Brightness.dark);

  static ThemeData _themeFrom(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }
}

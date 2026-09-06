import 'package:flutter/material.dart';

/// Interval's Material 3 design tokens.
///
/// A single seed color drives light/dark [ColorScheme]s by default; a
/// per-user custom accent (PRD §4.11) overrides it via an `accentColor`
/// argument to [light]/[dark].
abstract final class AppTheme {
  static const _seedColor = Color(0xFF3D5AFE);

  /// Preset accent choices shown in Settings, alongside the app default.
  static const List<Color> accentChoices = [
    _seedColor,
    Color(0xFFE53935), // red
    Color(0xFFFB8C00), // orange
    Color(0xFF43A047), // green
    Color(0xFF00897B), // teal
    Color(0xFF8E24AA), // purple
    Color(0xFFD81B60), // pink
  ];

  static ThemeData light({Color? accentColor, bool reducedMotion = false}) =>
      _themeFrom(Brightness.light, accentColor, reducedMotion);

  static ThemeData dark({Color? accentColor, bool reducedMotion = false}) =>
      _themeFrom(Brightness.dark, accentColor, reducedMotion);

  static ThemeData _themeFrom(
    Brightness brightness,
    Color? accentColor,
    bool reducedMotion,
  ) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accentColor ?? _seedColor,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      pageTransitionsTheme: reducedMotion
          ? const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: _InstantPageTransitionsBuilder(),
                TargetPlatform.iOS: _InstantPageTransitionsBuilder(),
                TargetPlatform.macOS: _InstantPageTransitionsBuilder(),
                TargetPlatform.linux: _InstantPageTransitionsBuilder(),
                TargetPlatform.windows: _InstantPageTransitionsBuilder(),
                TargetPlatform.fuchsia: _InstantPageTransitionsBuilder(),
              },
            )
          : null,
    );
  }
}

/// Cuts route transitions to an instant swap, for the reduced-motion
/// accessibility setting (PRD §7).
class _InstantPageTransitionsBuilder extends PageTransitionsBuilder {
  const _InstantPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}

import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
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

  /// Corner radius shared by cards, dialogs, buttons, and text fields —
  /// one knob for a consistent, rounded "premium" look app-wide.
  static const double _radius = 16;

  static ThemeData _themeFrom(
    Brightness brightness,
    Color? accentColor,
    bool reducedMotion,
  ) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accentColor ?? _seedColor,
      brightness: brightness,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_radius),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      // A denser default than Flutter's — the "compact" look applies
      // everywhere Material widgets read visual density from, without
      // having to touch every screen individually.
      visualDensity: VisualDensity.compact,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values)
            platform: reducedMotion
                ? const _InstantPageTransitionsBuilder()
                // A slicker, consistent slide-in on every platform reads
                // more "premium" than the stock per-platform defaults
                // (a plain fade on desktop, a zoom+fade on Android).
                : const CupertinoPageTransitionsBuilder(),
        },
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: shape,
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius + 4),
        ),
      ),
      listTileTheme: ListTileThemeData(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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

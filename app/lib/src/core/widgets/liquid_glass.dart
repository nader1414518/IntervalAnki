import 'dart:ui';

import 'package:flutter/material.dart';

/// A translucent "liquid glass" surface — the kind you see in iOS 26 / visionOS
/// — built from a [BackdropFilter] blur, a low-opacity tinted fill, a 1px
/// edge highlight, and a soft drop shadow.
///
/// Drop a [LiquidGlass] over a colourful background (e.g. the app's gradient
/// backdrop) to get the refractive glass look; on a solid white scaffold the
/// blur is invisible. Use [LiquidGlassBackground] as the scaffold child if you
/// need a colourful surface underneath.
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    required this.child,
    super.key,
    this.tint,
    this.blur = 20,
    this.tintOpacity = 0.55,
    this.borderOpacity = 0.18,
    this.shadowOpacity = 0.08,
    this.radius = 20,
    this.borderWidth = 1,
    this.padding,
    this.elevated = true,
  });

  final Widget child;

  /// Fill color of the glass. Defaults to the theme's `surfaceContainerHigh`
  /// in light mode, `surfaceContainer` in dark.
  final Color? tint;

  /// Sigma of the backdrop blur. 20 is a good default; 30+ for a frosted
  /// heavy look, 10 for barely-there.
  final double blur;

  /// Alpha applied to [tint]. 0.5–0.6 reads as glass; above 0.7 it starts
  /// to feel opaque.
  final double tintOpacity;

  /// Alpha of the 1px edge highlight — the thin line that gives glass its
  /// "edge of a pane" feel.
  final double borderOpacity;

  /// Alpha of the drop shadow.
  final double shadowOpacity;

  /// Corner radius.
  final double radius;

  /// Border thickness.
  final double borderWidth;

  /// Optional inner padding around [child].
  final EdgeInsetsGeometry? padding;

  /// Whether to draw a drop shadow. Disable for glass elements that already
  /// sit on top of something darker (e.g. an answer-button bar that floats
  /// above the card).
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final fillColor = tint ?? scheme.surfaceContainerHigh;

    // The edge highlight is a thin white line in dark mode (catches "light
    // from above" against a dark background) and a thin black line in light
    // mode (catches "shadow from the edge"). A pure white line in light mode
    // disappears; a pure black line in dark mode reads as a hard outline.
    final edgeColor = isDark
        ? Colors.white.withValues(alpha: borderOpacity)
        : Colors.black.withValues(alpha: borderOpacity * 0.45);

    final shadow = elevated
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: shadowOpacity),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ]
        : null;

    final radius0 = BorderRadius.circular(radius);

    return ClipRRect(
      borderRadius: radius0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fillColor.withValues(alpha: tintOpacity),
            borderRadius: radius0,
            border: Border.all(color: edgeColor, width: borderWidth),
            boxShadow: shadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// The colourful gradient painted behind every screen so the [LiquidGlass]
/// surfaces have something to refract. Three soft stops, anchored to the
/// theme's primary/tertiary containers at low alpha so the underlying app
/// identity still reads.
class LiquidGlassBackground extends StatelessWidget {
  const LiquidGlassBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final stops = isDark
        ? [
            scheme.surfaceContainerLow,
            scheme.surface,
            scheme.surfaceContainerHigh,
          ]
        : [
            scheme.primaryContainer.withValues(alpha: 0.55),
            scheme.surface,
            scheme.tertiaryContainer.withValues(alpha: 0.45),
          ];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: stops,
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: child,
    );
  }
}

/// A pill-shaped [LiquidGlass] button — useful for FABs and floating toolbars.
/// The FAB is a small enough surface that the blur reads as a strong "pane
/// of glass"; using this widget for it is a bigger payoff per surface.
class LiquidGlassFab extends StatelessWidget {
  const LiquidGlassFab({
    required this.onPressed,
    required this.child,
    super.key,
    this.tooltip,
    this.size = 56,
  });

  final VoidCallback onPressed;
  final Widget child;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fab = LiquidGlass(
      radius: size / 2,
      tintOpacity: 0.6,
      shadowOpacity: 0.16,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Center(child: child),
          ),
        ),
      ),
    );
    final tip = tooltip;
    if (tip == null) return fab;
    return Tooltip(message: tip, child: fab);
  }
}

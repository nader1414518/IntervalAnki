import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Renders a resolved card face (front or back HTML) with its note type's
/// CSS, sandboxed with no network access and JavaScript disabled (PRD §6
/// notes JS as a possible extension for community-deck compatibility —
/// out of scope for this pass, since none of our own templates need it).
///
/// The optional gesture callbacks are captured by a transparent overlay on
/// top of the `WebViewWidget` rather than a wrapping `GestureDetector` or
/// the platform view's own `gestureRecognizers` — both proved unreliable
/// for a plain tap on iOS (the platform view's native touch handling won,
/// even after registering matching Flutter recognizers), while an opaque
/// overlay above it unconditionally receives every touch.
class CardWebView extends StatefulWidget {
  const CardWebView({
    required this.html,
    required this.css,
    this.onTap,
    this.onHorizontalDragEnd,
    this.onVerticalDragEnd,
    this.fontScale = 1,
    this.fontFamily,
    super.key,
  });

  final String html;
  final String css;
  final VoidCallback? onTap;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final GestureDragEndCallback? onVerticalDragEnd;

  /// User preference (PRD §4.11) applied on top of the template's own CSS.
  final double fontScale;

  /// A `font-family` override; `null` keeps the template's own font.
  final String? fontFamily;

  @override
  State<CardWebView> createState() => _CardWebViewState();
}

class _CardWebViewState extends State<CardWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    unawaited(_init());
  }

  Future<void> _init() async {
    await _controller.setJavaScriptMode(JavaScriptMode.disabled);
    await _controller.setBackgroundColor(Colors.transparent);
    await _load();
  }

  @override
  void didUpdateWidget(covariant CardWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.html != widget.html ||
        oldWidget.css != widget.css ||
        oldWidget.fontScale != widget.fontScale ||
        oldWidget.fontFamily != widget.fontFamily) {
      unawaited(_load());
    }
  }

  /// `zoom` (non-standard but broadly supported by both WKWebView and
  /// Blink-based system WebViews) scales the whole rendered card, unlike
  /// a `font-size` override — most templates set absolute `px` sizes, which
  /// wouldn't respond to a relative/`em`-based override.
  String get _overrideCss {
    final rules = StringBuffer();
    if (widget.fontScale != 1) {
      rules.writeln('body { zoom: ${widget.fontScale}; }');
    }
    if (widget.fontFamily case final family?) {
      rules.writeln("body, body * { font-family: '$family' !important; }");
    }
    return rules.toString();
  }

  Future<void> _load() {
    final document =
        '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>${widget.css}</style>
<style>$_overrideCss</style>
</head>
<body class="card">${widget.html}</body>
</html>
''';
    return _controller.loadHtmlString(document);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onHorizontalDragEnd: widget.onHorizontalDragEnd,
            onVerticalDragEnd: widget.onVerticalDragEnd,
          ),
        ),
      ],
    );
  }
}

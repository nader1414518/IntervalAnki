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
    super.key,
  });

  final String html;
  final String css;
  final VoidCallback? onTap;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final GestureDragEndCallback? onVerticalDragEnd;

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
    if (oldWidget.html != widget.html || oldWidget.css != widget.css) {
      unawaited(_load());
    }
  }

  Future<void> _load() {
    final document =
        '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>${widget.css}</style>
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

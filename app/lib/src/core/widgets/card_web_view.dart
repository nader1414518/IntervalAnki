import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../data/local/media_storage.dart';

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
    this.isDarkMode = false,
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

  /// Built-in note types (and most imported/custom ones) hardcode a plain
  /// white `.card` background with black text, same as real Anki — without
  /// this, every card face renders as a fixed white box regardless of the
  /// app's own theme. `true` layers on a dark-friendly override so the card
  /// matches the surrounding dark UI unless a template already sets its own
  /// colors with higher CSS specificity than a plain `.card` rule.
  final bool isDarkMode;

  @override
  State<CardWebView> createState() => _CardWebViewState();
}

class _CardWebViewState extends State<CardWebView> {
  late final WebViewController _controller;
  late final Future<String> _mediaDir;

  @override
  void initState() {
    super.initState();
    // Embedded `[sound:...]` clips (see CardTemplateRenderer) render as an
    // `autoplay` <audio> element — the gesture overlay below claims every
    // touch for tap-to-reveal/swipe-to-grade, so a manual tap on the
    // WebView's own play button can't reach it. Autoplay sidesteps that
    // entirely, matching Anki's own default of playing card audio
    // automatically rather than requiring a deliberate tap.
    final params = WebViewPlatform.instance is WebKitWebViewPlatform
        ? WebKitWebViewControllerCreationParams(
            mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
          )
        : const PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(params);
    if (_controller.platform case final AndroidWebViewController android) {
      unawaited(android.setMediaPlaybackRequiresUserGesture(false));
    }
    _mediaDir = MediaStorage().directoryPath();
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
        oldWidget.fontFamily != widget.fontFamily ||
        oldWidget.isDarkMode != widget.isDarkMode) {
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
    if (widget.isDarkMode) {
      // `body.card` (specificity 0,1,1) beats a template's plain `.card`
      // rule (0,1,0) without needing `!important`, so a template that never
      // customized its colors picks this up while one that styles `.card`
      // more specifically (e.g. `.card.mytheme`) still wins on its own.
      rules.writeln('body.card { background-color: #121212; color: #e6e6e6; }');
    }
    return rules.toString();
  }

  Future<void> _load() async {
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
    // A relative `<img src="...">` (every embedded field image, plus
    // Image Occlusion's own picture) otherwise has nothing to resolve
    // against — WebView content loaded via loadHtmlString has no
    // filesystem context of its own.
    final mediaDir = await _mediaDir;
    await _controller.loadHtmlString(document, baseUrl: 'file://$mediaDir/');
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

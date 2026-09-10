import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:card_template/card_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:path/path.dart' as p;

import '../../../core/widgets/card_web_view.dart';
import '../../../core/widgets/liquid_glass.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/media_storage.dart';
import '../../../data/local/tables.dart' show CardQueue;
import '../../../data/repositories/card_repository.dart';
import '../../../data/repositories/settings_repository.dart';

/// Matches the `src="..."` of an `<audio>` element `CardTemplateRenderer`
/// renders from a `[sound:...]` field marker, to find what to replay.
final _audioSrcPattern = RegExp(r'<audio[^>]*\bsrc="([^"]*)"');

/// The core study loop (PRD §4.5): reveal, then grade with either the
/// answer buttons or a swipe (left = Again, right = Good, up = Easy —
/// matching PRD §5.2's gesture-first design, with buttons always visible
/// too as the accessible/discoverable fallback rather than a hidden-only
/// gesture).
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({required this.deckId, super.key});

  static const routeName = 'review';

  final int deckId;

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _UndoState {
  const _UndoState({required this.previousCard, required this.reviewLogId});

  final StudyCard previousCard;
  final int reviewLogId;
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  static const _renderer = CardTemplateRenderer();

  ReviewCardData? _renderData;
  int? _loadingForCardId;
  bool _showingAnswer = false;
  _UndoState? _undo;
  final _player = AudioPlayer();

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  /// Filenames of every `[sound:...]` clip embedded in the side currently
  /// on screen, read back off the already-rendered HTML.
  List<String> _currentSoundFiles() {
    final html = _renderData == null
        ? null
        : (_showingAnswer ? _renderData!.back : _renderData!.front);
    if (html == null) return const [];
    return [
      for (final match in _audioSrcPattern.allMatches(html)) match.group(1)!,
    ];
  }

  /// Replays this side's embedded audio — the WebView's own gesture
  /// overlay (tap-to-reveal, swipe-to-grade) sits above the card and would
  /// swallow a tap meant for a native `<audio>` control, so this button is
  /// the only way to hear a clip again on demand.
  Future<void> _replayAudio() async {
    final mediaDir = await MediaStorage().directoryPath();
    for (final filename in _currentSoundFiles()) {
      await _player.stop();
      await _player.play(DeviceFileSource(p.join(mediaDir, filename)));
      await _player.onPlayerComplete.first;
    }
  }

  void _scheduleLoad(StudyCard card) {
    if (_loadingForCardId == card.id) return;
    _loadingForCardId = card.id;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await ref
          .read(cardRepositoryProvider)
          .loadRenderData(card, _renderer);
      if (!mounted) return;
      setState(() {
        _renderData = data;
        _showingAnswer = false;
      });
    });
  }

  Future<void> _grade(StudyCard card, fsrs.Rating rating) async {
    final reviewLogId = await ref
        .read(cardRepositoryProvider)
        .grade(card, rating);
    if (!mounted) return;
    setState(
      () => _undo = _UndoState(previousCard: card, reviewLogId: reviewLogId),
    );
  }

  Future<void> _performUndo() async {
    final undo = _undo;
    if (undo == null) return;
    await ref
        .read(cardRepositoryProvider)
        .undoGrade(undo.previousCard, undo.reviewLogId);
    if (!mounted) return;
    setState(() {
      _undo = null;
      _renderData = null;
      _loadingForCardId = null;
    });
  }

  Future<void> _setQueue(int cardId, CardQueue queue) async {
    await ref.read(cardRepositoryProvider).setQueue(cardId, queue);
    if (!mounted) return;
    setState(() {
      _renderData = null;
      _loadingForCardId = null;
    });
  }

  Future<void> _setFlag(int cardId, int flag) {
    return ref.read(cardRepositoryProvider).setFlag(cardId, flag);
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(dueCardsProvider(widget.deckId));
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.7),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.08),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Text('Study'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo last answer',
            onPressed: _undo == null ? null : () => unawaited(_performUndo()),
          ),
        ],
      ),
      body: cardsAsync.when(
        data: _buildBody,
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildBody(List<StudyCard> cards) {
    if (cards.isEmpty) {
      return const Center(child: Text('All done for now!'));
    }
    final card = cards.first;
    if (_renderData == null || _renderData!.card.id != card.id) {
      _scheduleLoad(card);
      return const Center(child: CircularProgressIndicator());
    }
    final data = _renderData!;
    final options = ref.read(cardRepositoryProvider).previewSchedule(card);
    final settings = ref.watch(settingsProvider).value;

    return Column(
      children: [
        // Top padding to account for the floating glass app bar (kToolbarHeight
        // + the device status bar inset). Kept here rather than via SafeArea
        // because the app bar's flexibleSpace already covers that region.
        SizedBox(
          height: kToolbarHeight + MediaQuery.of(context).padding.top - 4,
        ),
        _CardToolbar(
          card: card,
          onFlag: (flag) => unawaited(_setFlag(card.id, flag)),
          onSuspend: () => unawaited(_setQueue(card.id, CardQueue.suspended)),
          onBury: () => unawaited(_setQueue(card.id, CardQueue.buried)),
          onReplayAudio: _currentSoundFiles().isEmpty
              ? null
              : () => unawaited(_replayAudio()),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            // Fixed height for the card so short cards like "hola/hello"
            // don't expand to fill the screen — the WebView's intrinsic
            // size ignores maxHeight constraints, so we use a tight
            // SizedBox. Long cards get a scrollable viewport inside.
            height: 280,
            child: LiquidGlass(
              radius: 20,
              tintOpacity: 0.75,
              borderOpacity: 0.35,
              shadowOpacity: 0.22,
              padding: const EdgeInsets.all(14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CardWebView(
                  html: _showingAnswer ? data.back : data.front,
                  css: data.css,
                  fontScale: settings?.cardFontScale ?? 1,
                  fontFamily: settings?.cardFontFamily,
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  onTap: _showingAnswer
                      ? null
                      : () => setState(() => _showingAnswer = true),
                  onHorizontalDragEnd: !_showingAnswer
                      ? null
                      : (details) {
                          final velocity = details.primaryVelocity ?? 0;
                          if (velocity < -250) {
                            unawaited(_grade(card, fsrs.Rating.again));
                          }
                          if (velocity > 250) {
                            unawaited(_grade(card, fsrs.Rating.good));
                          }
                        },
                  onVerticalDragEnd: !_showingAnswer
                      ? null
                      : (details) {
                          if ((details.primaryVelocity ?? 0) < -250) {
                            unawaited(_grade(card, fsrs.Rating.easy));
                          }
                        },
                ),
              ),
            ),
          ),
        ),
        // Fills the remaining vertical space between the card and the
        // answer buttons, pushing the buttons to the bottom of the screen.
        const Spacer(),
        if (_showingAnswer)
          _AnswerButtons(
            options: options,
            buttonCount: settings?.answerButtonCount ?? 4,
            onGrade: (rating) => unawaited(_grade(card, rating)),
          )
        else
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Tap to reveal'),
          ),
      ],
    );
  }
}

class _CardToolbar extends StatelessWidget {
  const _CardToolbar({
    required this.card,
    required this.onFlag,
    required this.onSuspend,
    required this.onBury,
    this.onReplayAudio,
  });

  final StudyCard card;
  final ValueChanged<int> onFlag;
  final VoidCallback onSuspend;
  final VoidCallback onBury;

  /// Replays the current side's embedded audio; `null` when this side has
  /// none, which hides the button rather than showing it disabled.
  final VoidCallback? onReplayAudio;

  static const List<Color> _flagColors = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.teal,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
      child: LiquidGlass(
        radius: 16,
        tintOpacity: 0.55,
        borderOpacity: 0.2,
        shadowOpacity: 0.1,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onReplayAudio != null)
              IconButton(
                icon: const Icon(Icons.volume_up_outlined, size: 18),
                tooltip: 'Replay audio',
                visualDensity: VisualDensity.compact,
                onPressed: onReplayAudio,
              ),
            PopupMenuButton<int>(
              tooltip: 'Flag',
              icon: Icon(
                Icons.flag,
                size: 18,
                color: card.flag == 0 ? null : _flagColors[card.flag - 1],
              ),
              position: PopupMenuPosition.under,
              onSelected: onFlag,
              itemBuilder: (context) => [
                const PopupMenuItem(value: 0, child: Text('No flag')),
                for (var i = 0; i < _flagColors.length; i++)
                  PopupMenuItem(
                    value: i + 1,
                    child: Row(
                      children: [
                        Icon(Icons.flag, color: _flagColors[i], size: 18),
                        const SizedBox(width: 8),
                        Text('Flag ${i + 1}'),
                      ],
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.visibility_off_outlined, size: 18),
              tooltip: 'Bury',
              visualDensity: VisualDensity.compact,
              onPressed: onBury,
            ),
            IconButton(
              icon: const Icon(Icons.pause_circle_outline, size: 18),
              tooltip: 'Suspend',
              visualDensity: VisualDensity.compact,
              onPressed: onSuspend,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerButtons extends StatelessWidget {
  const _AnswerButtons({
    required this.options,
    required this.onGrade,
    this.buttonCount = 4,
  });

  final fsrs.SchedulingOptions options;
  final ValueChanged<fsrs.Rating> onGrade;

  /// How many grading buttons to show, `2`-`4` (PRD §4.11): 2 keeps Again
  /// and Good, 3 adds Easy, 4 (the default) adds Hard too.
  final int buttonCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Row(
        children: [
          _gradeButton('Again', options.again, fsrs.Rating.again, Colors.red),
          if (buttonCount >= 4)
            _gradeButton('Hard', options.hard, fsrs.Rating.hard, Colors.orange),
          _gradeButton('Good', options.good, fsrs.Rating.good, Colors.green),
          if (buttonCount >= 3)
            _gradeButton('Easy', options.easy, fsrs.Rating.easy, Colors.blue),
        ],
      ),
    );
  }

  Widget _gradeButton(
    String label,
    fsrs.SchedulingOutcome outcome,
    fsrs.Rating rating,
    Color color,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        // Solid color background, white text — the rating color carries
        // the meaning, the text must be readable on it. The radius,
        // shadow and a 1px translucent white inner border keep the
        // "premium" feel without the glass tint washing the text out.
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onGrade(rating),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _formatInterval(outcome.intervalDays),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatInterval(double days) {
    if (days < 1) return '<1d';
    if (days < 30) return '${days.round()}d';
    if (days < 365) return '${(days / 30).round()}mo';
    return '${(days / 365).toStringAsFixed(1)}y';
  }
}

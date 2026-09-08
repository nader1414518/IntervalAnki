import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:card_template/card_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:path/path.dart' as p;

import '../../../core/widgets/card_web_view.dart';
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
      appBar: AppBar(
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
        _CardToolbar(
          card: card,
          onFlag: (flag) => unawaited(_setFlag(card.id, flag)),
          onSuspend: () => unawaited(_setQueue(card.id, CardQueue.suspended)),
          onBury: () => unawaited(_setQueue(card.id, CardQueue.buried)),
          onReplayAudio: _currentSoundFiles().isEmpty
              ? null
              : () => unawaited(_replayAudio()),
        ),
        Expanded(
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
        if (_showingAnswer)
          _AnswerButtons(
            options: options,
            buttonCount: settings?.answerButtonCount ?? 4,
            onGrade: (rating) => unawaited(_grade(card, rating)),
          )
        else
          const Padding(
            padding: EdgeInsets.all(24),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onReplayAudio != null)
          IconButton(
            icon: const Icon(Icons.volume_up_outlined),
            tooltip: 'Replay audio',
            onPressed: onReplayAudio,
          ),
        PopupMenuButton<int>(
          tooltip: 'Flag',
          icon: Icon(
            Icons.flag,
            color: card.flag == 0 ? null : _flagColors[card.flag - 1],
          ),
          onSelected: onFlag,
          itemBuilder: (context) => [
            const PopupMenuItem(value: 0, child: Text('No flag')),
            for (var i = 0; i < _flagColors.length; i++)
              PopupMenuItem(
                value: i + 1,
                child: Row(
                  children: [
                    Icon(Icons.flag, color: _flagColors[i]),
                    const SizedBox(width: 8),
                    Text('Flag ${i + 1}'),
                  ],
                ),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.visibility_off_outlined),
          tooltip: 'Bury',
          onPressed: onBury,
        ),
        IconButton(
          icon: const Icon(Icons.pause_circle_outline),
          tooltip: 'Suspend',
          onPressed: onSuspend,
        ),
      ],
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
      padding: const EdgeInsets.all(12),
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
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: color),
          onPressed: () => onGrade(rating),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              Text(
                _formatInterval(outcome.intervalDays),
                style: const TextStyle(fontSize: 11),
              ),
            ],
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

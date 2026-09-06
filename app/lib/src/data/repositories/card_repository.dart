import 'dart:convert';

import 'package:card_template/card_template.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../local/tables.dart';

part 'card_repository.g.dart';

/// Days since the Unix epoch (UTC), used for [Cards.due] on review/
/// relearning cards.
int currentDayNumber() =>
    DateTime.now().toUtc().millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000);

/// Everything the study session needs to render one card: its note's field
/// values, the template to render (already resolved for Cloze note types,
/// where every card shares one template but tests a different deletion),
/// and the css to render it with.
class ReviewCardData {
  const ReviewCardData({
    required this.card,
    required this.fields,
    required this.front,
    required this.back,
    required this.css,
    this.clozeOrd,
  });

  final StudyCard card;
  final Map<String, String> fields;
  final String front;
  final String back;
  final String css;
  final int? clozeOrd;
}

/// Read/write access to cards: the due queue, and grading via the FSRS
/// engine (`packages/fsrs`).
class CardRepository {
  CardRepository(this._db);

  final AppDatabase _db;
  static const _fsrs = fsrs.Fsrs();

  /// Emits the cards due for study in [deckId] — new cards, plus review/
  /// relearning cards whose due day has arrived — ordered so new cards and
  /// the earliest-due reviews come first.
  Stream<List<StudyCard>> watchDueCards(int deckId) {
    final today = currentDayNumber();
    return (_db.select(_db.cards)
          ..where(
            (c) =>
                c.deckId.equals(deckId) &
                (c.queue.equalsValue(CardQueue.newCard) |
                    ((c.queue.equalsValue(CardQueue.review) |
                            c.queue.equalsValue(CardQueue.relearning)) &
                        c.due.isSmallerOrEqualValue(today))),
          )
          ..orderBy([(c) => OrderingTerm(expression: c.due)]))
        .watch();
  }

  /// Loads and renders the front/back/css for [card].
  Future<ReviewCardData> loadRenderData(
    StudyCard card,
    CardTemplateRenderer renderer,
  ) async {
    final note = await (_db.select(
      _db.notes,
    )..where((n) => n.id.equals(card.noteId))).getSingle();
    final noteType = await (_db.select(
      _db.noteTypes,
    )..where((t) => t.id.equals(note.noteTypeId))).getSingle();
    final noteFields =
        await (_db.select(_db.fields)
              ..where((f) => f.noteTypeId.equals(noteType.id))
              ..orderBy([(f) => OrderingTerm(expression: f.ord)]))
            .get();
    final templates =
        await (_db.select(_db.templates)
              ..where((t) => t.noteTypeId.equals(noteType.id))
              ..orderBy([(t) => OrderingTerm(expression: t.ord)]))
            .get();

    final values = (jsonDecode(note.fieldValues) as List).cast<String>();
    final fields = <String, String>{
      for (var i = 0; i < noteFields.length && i < values.length; i++)
        noteFields[i].name: values[i],
    };

    final isCloze = templates.any((t) => t.front.contains('{{cloze:'));
    final template = isCloze
        ? templates.first
        : templates.firstWhere((t) => t.ord == card.templateOrd);
    final clozeOrd = isCloze ? card.templateOrd + 1 : null;

    final front = renderer.renderFront(
      template.front,
      fields,
      clozeOrd: clozeOrd,
    );
    final back = renderer.renderBack(
      template.back,
      fields,
      front,
      clozeOrd: clozeOrd,
    );

    return ReviewCardData(
      card: card,
      fields: fields,
      front: front,
      back: back,
      css: template.css,
      clozeOrd: clozeOrd,
    );
  }

  /// Previews the resulting interval for each possible rating of [card],
  /// so the review screen can show e.g. "Good — 3d" on its answer buttons.
  fsrs.SchedulingOptions previewSchedule(StudyCard card) {
    final elapsedDays = card.lastReviewedAt == null
        ? 0.0
        : DateTime.now().difference(card.lastReviewedAt!).inMinutes / (24 * 60);
    final memory = card.stability != null && card.difficulty != null
        ? fsrs.MemoryState(
            stability: card.stability!,
            difficulty: card.difficulty!,
          )
        : null;
    return _fsrs.preview(memory: memory, elapsedDays: elapsedDays);
  }

  /// Grades [card] with [rating], updating its FSRS memory state and
  /// scheduling it via the review-queue interval (or a fixed 1-day
  /// relearning bump for "Again" — see the note on `Fsrs` about short-term
  /// learning steps being out of scope). Returns the inserted review-log
  /// row's id, so the caller can support a single-step undo.
  Future<int> grade(StudyCard card, fsrs.Rating rating) async {
    final now = DateTime.now();
    final elapsedDays = card.lastReviewedAt == null
        ? 0.0
        : now.difference(card.lastReviewedAt!).inMinutes / (24 * 60);
    final memory = card.stability != null && card.difficulty != null
        ? fsrs.MemoryState(
            stability: card.stability!,
            difficulty: card.difficulty!,
          )
        : null;
    final outcome = _fsrs.review(
      memory: memory,
      elapsedDays: elapsedDays,
      rating: rating,
    );

    final today = currentDayNumber();
    final nextQueue = rating == fsrs.Rating.again
        ? CardQueue.relearning
        : CardQueue.review;
    final nextDue = rating == fsrs.Rating.again
        ? today + 1
        : today + outcome.intervalDays.round();

    return await _db.transaction(() async {
      await (_db.update(_db.cards)..where((c) => c.id.equals(card.id))).write(
        CardsCompanion(
          queue: Value(nextQueue),
          due: Value(nextDue),
          stability: Value(outcome.memory.stability),
          difficulty: Value(outcome.memory.difficulty),
          reps: Value(card.reps + 1),
          lapses: Value(
            rating == fsrs.Rating.again ? card.lapses + 1 : card.lapses,
          ),
          lastReviewedAt: Value(now),
        ),
      );
      return await _db
          .into(_db.reviewLog)
          .insert(
            ReviewLogCompanion.insert(
              cardId: card.id,
              rating: ReviewRating.values.byName(rating.name),
              elapsedDays: elapsedDays,
              scheduledDays: outcome.intervalDays,
              state: ReviewCardState.values.byName(card.queue.name),
            ),
          );
    });
  }

  /// Reverts a single [grade] call: deletes the review-log row it wrote and
  /// restores the card to [previous]'s state.
  Future<void> undoGrade(StudyCard previous, int reviewLogId) {
    return _db.transaction(() async {
      await (_db.delete(
        _db.reviewLog,
      )..where((r) => r.id.equals(reviewLogId))).go();
      await (_db.update(
        _db.cards,
      )..where((c) => c.id.equals(previous.id))).write(
        CardsCompanion(
          queue: Value(previous.queue),
          due: Value(previous.due),
          stability: Value(previous.stability),
          difficulty: Value(previous.difficulty),
          reps: Value(previous.reps),
          lapses: Value(previous.lapses),
          lastReviewedAt: Value(previous.lastReviewedAt),
        ),
      );
    });
  }

  /// Suspends or buries [cardId] (excluded from due queues until manually
  /// restored — see M6 for bulk unsuspend/unbury actions).
  Future<void> setQueue(int cardId, CardQueue queue) {
    return (_db.update(_db.cards)..where((c) => c.id.equals(cardId))).write(
      CardsCompanion(queue: Value(queue)),
    );
  }

  /// Sets [cardId]'s flag (0 = none, 1-7 = a color).
  Future<void> setFlag(int cardId, int flag) {
    return (_db.update(_db.cards)..where((c) => c.id.equals(cardId))).write(
      CardsCompanion(flag: Value(flag)),
    );
  }
}

@riverpod
CardRepository cardRepository(Ref ref) {
  return CardRepository(ref.watch(appDatabaseProvider));
}

/// Hand-written, not `@riverpod` — see the note on `deckListProvider` in
/// `deck_repository.dart`. Untyped for the same reason as
/// `deckOptionsProvider` in `deck_options_repository.dart`:
/// `StreamProviderFamily` isn't part of riverpod's public API surface.
// ignore: specify_nonobvious_property_types
final dueCardsProvider = StreamProvider.autoDispose
    .family<List<StudyCard>, int>((ref, deckId) {
      return ref.watch(cardRepositoryProvider).watchDueCards(deckId);
    });

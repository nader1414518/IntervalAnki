import 'dart:math' as math;

import 'package:fsrs/src/fsrs_parameters.dart';
import 'package:fsrs/src/memory_state.dart';
import 'package:fsrs/src/rating.dart';

/// The result of grading a card once: its updated memory model and the
/// resulting interval (in days) until it's next due.
class SchedulingOutcome {
  /// Creates a scheduling outcome.
  const SchedulingOutcome({required this.memory, required this.intervalDays});

  /// The card's updated memory state.
  final MemoryState memory;

  /// Days until the card is next due.
  final double intervalDays;

  @override
  String toString() =>
      'SchedulingOutcome(memory: $memory, intervalDays: $intervalDays)';
}

/// All four grading outcomes for a card at a single point in time — one per
/// [Rating] — so a review screen can preview each answer button's resulting
/// interval before the user picks one (an Anki staple, PRD §4.4).
class SchedulingOptions {
  /// Creates a set of scheduling options, one per [Rating].
  const SchedulingOptions({
    required this.again,
    required this.hard,
    required this.good,
    required this.easy,
  });

  /// The outcome if graded "Again".
  final SchedulingOutcome again;

  /// The outcome if graded "Hard".
  final SchedulingOutcome hard;

  /// The outcome if graded "Good".
  final SchedulingOutcome good;

  /// The outcome if graded "Easy".
  final SchedulingOutcome easy;

  /// The outcome for a specific [rating], e.g. the one the user picked.
  SchedulingOutcome forRating(Rating rating) => switch (rating) {
    Rating.again => again,
    Rating.hard => hard,
    Rating.good => good,
    Rating.easy => easy,
  };
}

/// Pure-Dart implementation of the FSRS (Free Spaced Repetition Scheduler)
/// memory model: given a card's current [MemoryState] (or `null` for a card
/// that's never been reviewed) and how long ago it was last reviewed, computes
/// the next memory state and interval for each possible [Rating].
///
/// This class only models long-term review scheduling. Short-term
/// "learning/relearning steps" (PRD §4.1's per-deck configurable minute
/// steps) are a separate, deck-configured queue policy layered on top by the
/// app — matching how FSRS is used in upstream Anki, where the algorithm
/// only ever touches cards already in the long-term review queue.
class Fsrs {
  /// Creates an engine using the given [parameters] (FSRS-4.5 defaults if
  /// omitted).
  const Fsrs([this.parameters = const FsrsParameters()]);

  /// The weights and limits this engine schedules with.
  final FsrsParameters parameters;

  /// The forgetting curve's decay exponent, fixed by the FSRS-4.5 spec.
  static const double _decay = -0.5;

  /// Chosen so that `retrievability(elapsedDays: stability) == 0.9`.
  static double get _factor => math.pow(0.9, 1 / _decay) - 1;

  /// The probability this card is still remembered, [elapsedDays] after it
  /// was last reviewed with the given [memory].
  double retrievability({
    required MemoryState memory,
    required double elapsedDays,
  }) {
    return math
        .pow(1 + _factor * elapsedDays / memory.stability, _decay)
        .toDouble();
  }

  /// Computes every grading outcome for a card whose current memory state is
  /// [memory] (`null` if it's never been reviewed) and which was last
  /// reviewed [elapsedDays] ago (ignored/pass `0` when [memory] is `null`).
  SchedulingOptions preview({
    required MemoryState? memory,
    required double elapsedDays,
  }) {
    return SchedulingOptions(
      again: review(
        memory: memory,
        elapsedDays: elapsedDays,
        rating: Rating.again,
      ),
      hard: review(
        memory: memory,
        elapsedDays: elapsedDays,
        rating: Rating.hard,
      ),
      good: review(
        memory: memory,
        elapsedDays: elapsedDays,
        rating: Rating.good,
      ),
      easy: review(
        memory: memory,
        elapsedDays: elapsedDays,
        rating: Rating.easy,
      ),
    );
  }

  /// Grades a card whose current memory state is [memory] (`null` if it's
  /// never been reviewed) with [rating], given it was last reviewed
  /// [elapsedDays] ago (ignored/pass `0` when [memory] is `null`).
  SchedulingOutcome review({
    required MemoryState? memory,
    required double elapsedDays,
    required Rating rating,
  }) {
    final nextMemory = memory == null
        ? _initialMemory(rating)
        : _nextMemory(memory, elapsedDays, rating);
    return SchedulingOutcome(
      memory: nextMemory,
      intervalDays: _intervalFor(nextMemory.stability),
    );
  }

  MemoryState _initialMemory(Rating rating) {
    final w = parameters.weights;
    final grade = rating.index + 1;
    final stability = w[rating.index];
    final difficulty = _clampDifficulty(w[4] - (grade - 3) * w[5]);
    return MemoryState(stability: stability, difficulty: difficulty);
  }

  MemoryState _nextMemory(
    MemoryState memory,
    double elapsedDays,
    Rating rating,
  ) {
    final r = retrievability(memory: memory, elapsedDays: elapsedDays);
    final difficulty = _nextDifficulty(memory.difficulty, rating);
    final stability = rating == Rating.again
        ? _nextForgetStability(memory, r)
        : _nextRecallStability(memory, r, rating);
    return MemoryState(stability: stability, difficulty: difficulty);
  }

  double _clampDifficulty(double d) => d.clamp(1, 10);

  double _nextDifficulty(double difficulty, Rating rating) {
    final w = parameters.weights;
    final grade = rating.index + 1;
    final nextD = difficulty - w[6] * (grade - 3);
    // Mean-reversion towards the difficulty a brand-new "Easy" card would
    // start at (D0(Easy)), so difficulty doesn't drift unboundedly over many
    // reviews.
    final easyStart = w[4] - (4 - 3) * w[5];
    return _clampDifficulty(w[7] * easyStart + (1 - w[7]) * nextD);
  }

  double _nextRecallStability(MemoryState memory, double r, Rating rating) {
    final w = parameters.weights;
    final hardPenalty = rating == Rating.hard ? w[15] : 1.0;
    final easyBonus = rating == Rating.easy ? w[16] : 1.0;
    final growth =
        math.exp(w[8]) *
        (11 - memory.difficulty) *
        math.pow(memory.stability, -w[9]) *
        (math.exp(w[10] * (1 - r)) - 1) *
        hardPenalty *
        easyBonus;
    return memory.stability * (growth + 1);
  }

  double _nextForgetStability(MemoryState memory, double r) {
    final w = parameters.weights;
    return w[11] *
        math.pow(memory.difficulty, -w[12]) *
        (math.pow(memory.stability + 1, w[13]) - 1) *
        math.exp(w[14] * (1 - r));
  }

  /// The interval (days) at which retrievability decays to
  /// [FsrsParameters.requestRetention], solved from the forgetting curve.
  double _intervalFor(double stability) {
    final raw =
        stability /
        _factor *
        (math.pow(parameters.requestRetention, 1 / _decay) - 1);
    return raw.clamp(1, parameters.maximumIntervalDays.toDouble());
  }
}

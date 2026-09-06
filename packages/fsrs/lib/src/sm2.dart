import 'package:fsrs/src/rating.dart';

/// Tunable inputs to the legacy SM-2 scheduler.
class Sm2Parameters {
  /// Creates SM-2 parameters, defaulting to the classic SuperMemo constants.
  const Sm2Parameters({
    this.startingEaseFactor = 2.5,
    this.minimumEaseFactor = 1.3,
    this.easyBonus = 1.3,
    this.hardIntervalFactor = 1.2,
  });

  /// Ease factor a new card starts at.
  final double startingEaseFactor;

  /// Ease factor never drops below this floor.
  final double minimumEaseFactor;

  /// Extra interval multiplier applied on top of the ease factor for Easy.
  final double easyBonus;

  /// Interval multiplier used for Hard, independent of the ease factor.
  final double hardIntervalFactor;
}

/// A card's scheduling state under the legacy SM-2 algorithm.
class Sm2State {
  /// Creates an SM-2 state snapshot.
  const Sm2State({
    required this.easeFactor,
    required this.intervalDays,
    required this.reps,
  });

  /// The current ease factor.
  final double easeFactor;

  /// Days until this card is next due.
  final double intervalDays;

  /// Consecutive non-"Again" reviews since the last lapse.
  final int reps;

  @override
  String toString() =>
      'Sm2State(easeFactor: $easeFactor, intervalDays: $intervalDays, '
      'reps: $reps)';
}

/// The legacy SM-2 scheduler, kept only for decks imported from Anki
/// collections that hadn't switched to FSRS (PRD §4.4) — new cards always
/// schedule via `Fsrs` (see `scheduler.dart`).
class Sm2Scheduler {
  /// Creates a scheduler using the given [parameters].
  const Sm2Scheduler([this.parameters = const Sm2Parameters()]);

  /// The constants this scheduler grades with.
  final Sm2Parameters parameters;

  /// Grades a card whose current state is [state] (`null` if it's never
  /// been reviewed) with [rating].
  Sm2State review(Sm2State? state, Rating rating) {
    if (rating == Rating.again) {
      final priorEase = state?.easeFactor ?? parameters.startingEaseFactor;
      final easeFactor = (priorEase - 0.2).clamp(
        parameters.minimumEaseFactor,
        double.infinity,
      );
      return Sm2State(easeFactor: easeFactor, intervalDays: 1, reps: 0);
    }

    final priorEase = state?.easeFactor ?? parameters.startingEaseFactor;
    final reps = (state?.reps ?? 0) + 1;
    final easeDelta = switch (rating) {
      Rating.hard => -0.15,
      Rating.good => 0.0,
      Rating.easy => 0.15,
      Rating.again => 0.0,
    };
    final easeFactor = (priorEase + easeDelta).clamp(
      parameters.minimumEaseFactor,
      double.infinity,
    );

    final double intervalDays;
    if (reps == 1) {
      intervalDays = 1;
    } else if (reps == 2) {
      intervalDays = 6;
    } else {
      final priorInterval = state?.intervalDays ?? 1;
      final factor = rating == Rating.hard
          ? parameters.hardIntervalFactor
          : easeFactor * (rating == Rating.easy ? parameters.easyBonus : 1.0);
      intervalDays = priorInterval * factor;
    }

    return Sm2State(
      easeFactor: easeFactor,
      intervalDays: intervalDays,
      reps: reps,
    );
  }
}

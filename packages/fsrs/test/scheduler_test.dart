import 'package:fsrs/fsrs.dart';
import 'package:test/test.dart';

void main() {
  const fsrs = Fsrs();
  const w = FsrsParameters.defaultWeights;

  group('a brand-new card (no prior memory state)', () {
    for (final rating in Rating.values) {
      test('initial stability for $rating equals w[${rating.index}]', () {
        final outcome = fsrs.review(
          memory: null,
          elapsedDays: 0,
          rating: rating,
        );
        expect(outcome.memory.stability, closeTo(w[rating.index], 1e-9));
      });
    }

    test('initial difficulty for Good equals w[4] exactly (grade 3)', () {
      final outcome = fsrs.review(
        memory: null,
        elapsedDays: 0,
        rating: Rating.good,
      );
      expect(outcome.memory.difficulty, closeTo(w[4], 1e-9));
    });

    test('initial difficulty is always clamped to [1, 10]', () {
      for (final rating in Rating.values) {
        final outcome = fsrs.review(
          memory: null,
          elapsedDays: 0,
          rating: rating,
        );
        expect(outcome.memory.difficulty, inInclusiveRange(1, 10));
      }
    });
  });

  group('retrievability', () {
    const memory = MemoryState(stability: 10, difficulty: 5);

    test('is 1.0 immediately after review (elapsed = 0)', () {
      expect(
        fsrs.retrievability(memory: memory, elapsedDays: 0),
        closeTo(1, 1e-9),
      );
    });

    test('is ~0.9 exactly when elapsed == stability (FSRS decay constant)', () {
      expect(
        fsrs.retrievability(memory: memory, elapsedDays: memory.stability),
        closeTo(0.9, 1e-9),
      );
    });

    test('decreases monotonically as elapsed time increases', () {
      final r10 = fsrs.retrievability(memory: memory, elapsedDays: 10);
      final r20 = fsrs.retrievability(memory: memory, elapsedDays: 20);
      expect(r20, lessThan(r10));
    });
  });

  group('review intervals', () {
    test('round-trips through retrievability at the requested retention', () {
      const memory = MemoryState(stability: 15, difficulty: 4);
      const params = FsrsParameters(requestRetention: 0.85);
      const customFsrs = Fsrs(params);

      final outcome = customFsrs.review(
        memory: memory,
        elapsedDays: memory.stability,
        rating: Rating.good,
      );

      final r = customFsrs.retrievability(
        memory: outcome.memory,
        elapsedDays: outcome.intervalDays,
      );
      expect(r, closeTo(0.85, 1e-6));
    });

    test('is clamped to at least 1 day', () {
      final outcome = fsrs.review(
        memory: null,
        elapsedDays: 0,
        rating: Rating.again,
      );
      expect(outcome.intervalDays, greaterThanOrEqualTo(1));
    });

    test('is clamped to the configured maximum', () {
      const params = FsrsParameters(maximumIntervalDays: 100);
      const customFsrs = Fsrs(params);
      const hugeMemory = MemoryState(stability: 100000, difficulty: 1);

      final outcome = customFsrs.review(
        memory: hugeMemory,
        elapsedDays: 100000,
        rating: Rating.easy,
      );
      expect(outcome.intervalDays, equals(100));
    });

    test('orders Again < Hard <= Good <= Easy for the same review', () {
      const memory = MemoryState(stability: 20, difficulty: 5);
      final options = fsrs.preview(memory: memory, elapsedDays: 20);

      expect(options.again.intervalDays, lessThan(options.hard.intervalDays));
      expect(
        options.hard.intervalDays,
        lessThanOrEqualTo(options.good.intervalDays),
      );
      expect(
        options.good.intervalDays,
        lessThanOrEqualTo(options.easy.intervalDays),
      );
    });
  });

  test('difficulty stays within [1, 10] across many repeated reviews', () {
    var memory = fsrs
        .review(memory: null, elapsedDays: 0, rating: Rating.good)
        .memory;

    for (var i = 0; i < 50; i++) {
      final rating = i.isEven ? Rating.again : Rating.easy;
      memory = fsrs
          .review(memory: memory, elapsedDays: 5, rating: rating)
          .memory;
      expect(memory.difficulty, inInclusiveRange(1, 10));
      expect(memory.stability, greaterThan(0));
    }
  });
}

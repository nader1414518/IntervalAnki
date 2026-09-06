import 'package:fsrs/fsrs.dart';
import 'package:test/test.dart';

void main() {
  const scheduler = Sm2Scheduler();

  test('first Good review schedules a 1-day interval', () {
    final state = scheduler.review(null, Rating.good);
    expect(state.intervalDays, equals(1));
    expect(state.reps, equals(1));
  });

  test('second consecutive Good review schedules 6 days', () {
    var state = scheduler.review(null, Rating.good);
    state = scheduler.review(state, Rating.good);
    expect(state.intervalDays, equals(6));
    expect(state.reps, equals(2));
  });

  test('third+ Good review multiplies the interval by the ease factor', () {
    var state = scheduler.review(null, Rating.good);
    state = scheduler.review(state, Rating.good);
    final easeBefore = state.easeFactor;
    state = scheduler.review(state, Rating.good);
    expect(state.intervalDays, closeTo(6 * easeBefore, 1e-9));
  });

  test('Again resets reps and drops the interval back to 1 day', () {
    var state = scheduler.review(null, Rating.good);
    state = scheduler.review(state, Rating.good);
    state = scheduler.review(state, Rating.good);
    state = scheduler.review(state, Rating.again);
    expect(state.reps, equals(0));
    expect(state.intervalDays, equals(1));
  });

  test('ease factor never drops below the configured minimum', () {
    var state = scheduler.review(null, Rating.good);
    for (var i = 0; i < 20; i++) {
      state = scheduler.review(state, Rating.again);
    }
    expect(
      state.easeFactor,
      greaterThanOrEqualTo(const Sm2Parameters().minimumEaseFactor),
    );
  });

  test('Easy grows the interval faster than Good', () {
    var goodState = scheduler.review(null, Rating.good);
    goodState = scheduler.review(goodState, Rating.good);
    var easyState = scheduler.review(null, Rating.good);
    easyState = scheduler.review(easyState, Rating.easy);

    final goodNext = scheduler.review(goodState, Rating.good);
    final easyNext = scheduler.review(easyState, Rating.easy);
    expect(easyNext.intervalDays, greaterThan(goodNext.intervalDays));
  });
}

import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/repositories/card_repository.dart'
    show currentDayNumber;
import 'package:app/src/data/repositories/streak_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late StreakRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = StreakRepository(db);
  });

  tearDown(() => db.close());

  Future<void> setStreakState({
    required int currentStreak,
    required int longestStreak,
    int? lastStudyDay,
    int freezesAvailable = 0,
  }) async {
    final row = await db.select(db.studyStreaks).getSingle();
    await (db.update(db.studyStreaks)..where((s) => s.id.equals(row.id))).write(
      StudyStreaksCompanion(
        currentStreak: Value(currentStreak),
        longestStreak: Value(longestStreak),
        lastStudyDay: Value(lastStudyDay),
        freezesAvailable: Value(freezesAvailable),
      ),
    );
  }

  test('first ever study day starts the streak at 1', () async {
    await repo.recordStudyToday();
    final streak = await db.select(db.studyStreaks).getSingle();
    expect(streak.currentStreak, 1);
    expect(streak.longestStreak, 1);
    expect(streak.lastStudyDay, currentDayNumber());
  });

  test('studying again the same day does not double-count', () async {
    await repo.recordStudyToday();
    await repo.recordStudyToday();
    final streak = await db.select(db.studyStreaks).getSingle();
    expect(streak.currentStreak, 1);
  });

  test('studying on the very next day extends the streak', () async {
    await setStreakState(
      currentStreak: 3,
      longestStreak: 5,
      lastStudyDay: currentDayNumber() - 1,
    );
    await repo.recordStudyToday();
    final streak = await db.select(db.studyStreaks).getSingle();
    expect(streak.currentStreak, 4);
    expect(streak.longestStreak, 5);
  });

  test('a new longest streak updates longestStreak too', () async {
    await setStreakState(
      currentStreak: 5,
      longestStreak: 5,
      lastStudyDay: currentDayNumber() - 1,
    );
    await repo.recordStudyToday();
    final streak = await db.select(db.studyStreaks).getSingle();
    expect(streak.currentStreak, 6);
    expect(streak.longestStreak, 6);
  });

  test('a missed day resets the streak with no freeze banked', () async {
    await setStreakState(
      currentStreak: 10,
      longestStreak: 10,
      lastStudyDay: currentDayNumber() - 2,
    );
    await repo.recordStudyToday();
    final streak = await db.select(db.studyStreaks).getSingle();
    expect(streak.currentStreak, 1);
  });

  test('a banked freeze bridges exactly one missed day', () async {
    await setStreakState(
      currentStreak: 10,
      longestStreak: 10,
      lastStudyDay: currentDayNumber() - 2,
      freezesAvailable: 1,
    );
    await repo.recordStudyToday();
    final streak = await db.select(db.studyStreaks).getSingle();
    expect(streak.currentStreak, 11);
    expect(streak.freezesAvailable, 0);
  });

  test('a freeze cannot bridge a two-day gap', () async {
    await setStreakState(
      currentStreak: 10,
      longestStreak: 10,
      lastStudyDay: currentDayNumber() - 3,
      freezesAvailable: 1,
    );
    await repo.recordStudyToday();
    final streak = await db.select(db.studyStreaks).getSingle();
    expect(streak.currentStreak, 1);
    // The unused freeze is preserved rather than burned on a gap it
    // couldn't cover.
    expect(streak.freezesAvailable, 1);
  });

  test('a 7-day streak earns a freeze, up to the cap of 2', () async {
    await setStreakState(
      currentStreak: 6,
      longestStreak: 6,
      lastStudyDay: currentDayNumber() - 1,
      freezesAvailable: 1,
    );
    await repo.recordStudyToday();
    final streak = await db.select(db.studyStreaks).getSingle();
    expect(streak.currentStreak, 7);
    expect(streak.freezesAvailable, 2);
  });
}

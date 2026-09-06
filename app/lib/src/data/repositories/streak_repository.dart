import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';
import 'card_repository.dart' show currentDayNumber;

part 'streak_repository.g.dart';

/// A freeze is earned every this many streak days, up to [_maxFreezes]
/// banked at once — the "protection mechanic" PRD §4.10 calls for.
const _freezeEveryDays = 7;
const _maxFreezes = 2;

/// Tracks and updates the daily-study streak (PRD §4.10).
class StreakRepository {
  StreakRepository(this._db);

  final AppDatabase _db;

  Stream<StudyStreak> watch() => _db.select(_db.studyStreaks).watchSingle();

  /// Call once per graded review. A no-op if today already extended the
  /// streak; otherwise extends it by one (bridging exactly one missed day
  /// with a banked freeze, if one's available), or resets to 1 if the gap
  /// since the last study day is larger than that.
  Future<void> recordStudyToday() async {
    final today = currentDayNumber();
    final streak = await _db.select(_db.studyStreaks).getSingle();
    if (streak.lastStudyDay == today) return;

    var freezesAvailable = streak.freezesAvailable;
    int newStreak;
    if (streak.lastStudyDay == null) {
      newStreak = 1;
    } else {
      final gap = today - streak.lastStudyDay!;
      if (gap == 1) {
        newStreak = streak.currentStreak + 1;
      } else if (gap == 2 && freezesAvailable > 0) {
        newStreak = streak.currentStreak + 1;
        freezesAvailable -= 1;
      } else {
        newStreak = 1;
      }
    }

    if (newStreak % _freezeEveryDays == 0 && freezesAvailable < _maxFreezes) {
      freezesAvailable += 1;
    }

    await (_db.update(
      _db.studyStreaks,
    )..where((s) => s.id.equals(streak.id))).write(
      StudyStreaksCompanion(
        currentStreak: Value(newStreak),
        longestStreak: Value(
          newStreak > streak.longestStreak ? newStreak : streak.longestStreak,
        ),
        lastStudyDay: Value(today),
        freezesAvailable: Value(freezesAvailable),
      ),
    );
  }
}

@riverpod
StreakRepository streakRepository(Ref ref) {
  return StreakRepository(ref.watch(appDatabaseProvider));
}

/// Hand-written, not `@riverpod` — see the note on `deckListProvider` in
/// `deck_repository.dart`: riverpod_generator can't code-generate a provider
/// returning a Drift-generated data class.
final streakProvider = StreamProvider<StudyStreak>(
  (ref) => ref.watch(streakRepositoryProvider).watch(),
);

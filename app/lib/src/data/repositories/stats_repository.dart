import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../local/tables.dart';
import 'card_repository.dart' show currentDayNumber;

part 'stats_repository.g.dart';

/// Reviews done on one calendar day, for the activity chart.
class DailyReviewCount {
  const DailyReviewCount({required this.dayNumber, required this.count});

  final int dayNumber;
  final int count;
}

/// Everything the statistics dashboard (PRD §4.7) shows, computed from
/// [ReviewLog] and [Cards] — a small number of aggregate queries rather
/// than one big join, since each is independent and the review-log table
/// isn't large enough for that to matter.
class ReviewStats {
  const ReviewStats({
    required this.totalReviews,
    required this.totalCards,
    required this.retentionRate,
    required this.dailyCounts,
    required this.cardsByQueue,
  });

  final int totalReviews;
  final int totalCards;

  /// Share of reviews rated anything but Again, `null` if there have been
  /// no reviews yet.
  final double? retentionRate;

  /// One entry per day in the window, oldest first, including days with a
  /// zero count so the chart has no gaps.
  final List<DailyReviewCount> dailyCounts;
  final Map<CardQueue, int> cardsByQueue;
}

class StatsRepository {
  StatsRepository(this._db);

  final AppDatabase _db;

  Future<ReviewStats> load({int dayWindow = 14}) async {
    final totalReviews =
        await (_db.selectOnly(_db.reviewLog)
              ..addColumns([_db.reviewLog.id.count()]))
            .map((row) => row.read(_db.reviewLog.id.count()) ?? 0)
            .getSingle();
    final totalCards =
        await (_db.selectOnly(_db.cards)
              ..addColumns([_db.cards.id.count()])
              ..where(_db.cards.deletedAt.isNull()))
            .map((row) => row.read(_db.cards.id.count()) ?? 0)
            .getSingle();

    final ratings =
        await (_db.selectOnly(_db.reviewLog)
              ..addColumns([_db.reviewLog.rating]))
            .map((row) => row.read(_db.reviewLog.rating)!)
            .get();
    // `.read()` on a selectOnly/addColumns query yields the raw stored
    // value, not the enum a normal table select would convert to — compare
    // against the same `.name` string `textEnum` stores.
    final correct = ratings.where((r) => r != ReviewRating.again.name).length;
    final retentionRate = ratings.isEmpty ? null : correct / ratings.length;

    final today = currentDayNumber();
    final windowStartDay = today - dayWindow + 1;
    final windowStart = DateTime.fromMillisecondsSinceEpoch(
      windowStartDay * 24 * 60 * 60 * 1000,
      isUtc: true,
    );
    final recentReviewDates =
        await (_db.selectOnly(_db.reviewLog)
              ..addColumns([_db.reviewLog.reviewedAt])
              ..where(
                _db.reviewLog.reviewedAt.isBiggerOrEqualValue(windowStart),
              ))
            .map((row) => row.read(_db.reviewLog.reviewedAt)!)
            .get();
    final countsByDay = <int, int>{};
    for (final reviewedAt in recentReviewDates) {
      final day =
          reviewedAt.toUtc().millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000);
      countsByDay[day] = (countsByDay[day] ?? 0) + 1;
    }
    final dailyCounts = [
      for (var day = windowStartDay; day <= today; day++)
        DailyReviewCount(dayNumber: day, count: countsByDay[day] ?? 0),
    ];

    final cardsByQueue = <CardQueue, int>{};
    for (final queue in CardQueue.values) {
      cardsByQueue[queue] =
          await (_db.selectOnly(_db.cards)
                ..addColumns([_db.cards.id.count()])
                ..where(
                  _db.cards.queue.equalsValue(queue) &
                      _db.cards.deletedAt.isNull(),
                ))
              .map((row) => row.read(_db.cards.id.count()) ?? 0)
              .getSingle();
    }

    return ReviewStats(
      totalReviews: totalReviews,
      totalCards: totalCards,
      retentionRate: retentionRate,
      dailyCounts: dailyCounts,
      cardsByQueue: cardsByQueue,
    );
  }
}

@riverpod
StatsRepository statsRepository(Ref ref) {
  return StatsRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Future<ReviewStats> reviewStats(Ref ref) {
  return ref.watch(statsRepositoryProvider).load();
}

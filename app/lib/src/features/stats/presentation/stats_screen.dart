import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/tables.dart' show CardQueue;
import '../../../data/repositories/stats_repository.dart';
import '../../../data/repositories/streak_repository.dart';

/// The statistics dashboard (PRD §4.7): review activity, retention, and a
/// breakdown of where cards currently stand — all derived from the
/// review-log/cards tables already kept for scheduling, no separate
/// tracking needed.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  static const routeName = 'stats';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(reviewStatsProvider);
    final streakAsync = ref.watch(streakProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: statsAsync.when(
        data: (stats) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatCard(
                  label: 'Reviews',
                  value: '${stats.totalReviews}',
                  icon: Icons.fact_check_outlined,
                ),
                _StatCard(
                  label: 'Cards',
                  value: '${stats.totalCards}',
                  icon: Icons.style_outlined,
                ),
                _StatCard(
                  label: 'Retention',
                  value: stats.retentionRate == null
                      ? '—'
                      : '${(stats.retentionRate! * 100).round()}%',
                  icon: Icons.track_changes_outlined,
                ),
                streakAsync.when(
                  data: (streak) => _StatCard(
                    label: 'Day streak',
                    value: '${streak.currentStreak}',
                    icon: Icons.local_fire_department_outlined,
                  ),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Last ${stats.dailyCounts.length} days',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: _DailyReviewsChart(counts: stats.dailyCounts),
            ),
            const SizedBox(height: 28),
            Text(
              'Cards by state',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            for (final queue in CardQueue.values)
              _QueueRow(
                queue: queue,
                count: stats.cardsByQueue[queue] ?? 0,
                total: stats.totalCards,
              ),
          ],
        ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _DailyReviewsChart extends StatelessWidget {
  const _DailyReviewsChart({required this.counts});

  final List<DailyReviewCount> counts;

  @override
  Widget build(BuildContext context) {
    final maxCount = counts.fold<int>(
      1,
      (max, c) => c.count > max ? c.count : max,
    );
    final barColor = Theme.of(context).colorScheme.primary;
    return BarChart(
      BarChartData(
        maxY: maxCount.toDouble(),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        barTouchData: const BarTouchData(enabled: false),
        barGroups: [
          for (final (index, c) in counts.indexed)
            BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: c.count.toDouble(),
                  color: barColor,
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _QueueRow extends StatelessWidget {
  const _QueueRow({
    required this.queue,
    required this.count,
    required this.total,
  });

  final CardQueue queue;
  final int count;
  final int total;

  static const Map<CardQueue, String> _labels = {
    CardQueue.newCard: 'New',
    CardQueue.learning: 'Learning',
    CardQueue.review: 'Review',
    CardQueue.relearning: 'Relearning',
    CardQueue.suspended: 'Suspended',
    CardQueue.buried: 'Buried',
  };

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : count / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(_labels[queue] ?? queue.name)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 32, child: Text('$count', textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

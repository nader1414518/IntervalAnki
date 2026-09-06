// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statsRepository)
final statsRepositoryProvider = StatsRepositoryProvider._();

final class StatsRepositoryProvider
    extends
        $FunctionalProvider<StatsRepository, StatsRepository, StatsRepository>
    with $Provider<StatsRepository> {
  StatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsRepositoryHash();

  @$internal
  @override
  $ProviderElement<StatsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatsRepository create(Ref ref) {
    return statsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsRepository>(value),
    );
  }
}

String _$statsRepositoryHash() => r'd7f53f9ba3b0ce78f4893ed16f37af5c04e57e68';

@ProviderFor(reviewStats)
final reviewStatsProvider = ReviewStatsProvider._();

final class ReviewStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReviewStats>,
          ReviewStats,
          FutureOr<ReviewStats>
        >
    with $FutureModifier<ReviewStats>, $FutureProvider<ReviewStats> {
  ReviewStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewStatsHash();

  @$internal
  @override
  $FutureProviderElement<ReviewStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReviewStats> create(Ref ref) {
    return reviewStats(ref);
  }
}

String _$reviewStatsHash() => r'99a8ac7fb87f5257d4c74f0e231ca2cb7ae50168';

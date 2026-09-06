// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationService,
          NotificationService,
          NotificationService
        >
    with $Provider<NotificationService> {
  NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'585c1e42ea844e71a2b76b80b165adfe2c5c8529';

/// Keeps the scheduled reminder in sync with Settings — re-runs whenever
/// the daily-reminder fields change, since it watches `settingsProvider`.
/// Held alive by a `ref.watch` in `IntervalApp`, the app's root widget.

@ProviderFor(notificationScheduleSync)
final notificationScheduleSyncProvider = NotificationScheduleSyncProvider._();

/// Keeps the scheduled reminder in sync with Settings — re-runs whenever
/// the daily-reminder fields change, since it watches `settingsProvider`.
/// Held alive by a `ref.watch` in `IntervalApp`, the app's root widget.

final class NotificationScheduleSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the scheduled reminder in sync with Settings — re-runs whenever
  /// the daily-reminder fields change, since it watches `settingsProvider`.
  /// Held alive by a `ref.watch` in `IntervalApp`, the app's root widget.
  NotificationScheduleSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationScheduleSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationScheduleSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return notificationScheduleSync(ref);
  }
}

String _$notificationScheduleSyncHash() =>
    r'de33c3a7463975402e476c5b4dfe48a17fa100bb';

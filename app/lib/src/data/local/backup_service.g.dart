// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(backupService)
final backupServiceProvider = BackupServiceProvider._();

final class BackupServiceProvider
    extends $FunctionalProvider<BackupService, BackupService, BackupService>
    with $Provider<BackupService> {
  BackupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupServiceHash();

  @$internal
  @override
  $ProviderElement<BackupService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BackupService create(Ref ref) {
    return backupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupService>(value),
    );
  }
}

String _$backupServiceHash() => r'2e1feec66ff27cdab5f44c42739d7a8bda665b8d';

/// Runs the automatic local backup once per app launch, if enabled — a
/// one-shot [Future] (not a stream) so it fires exactly once regardless of
/// how many widgets watch it.

@ProviderFor(autoBackupOnStartup)
final autoBackupOnStartupProvider = AutoBackupOnStartupProvider._();

/// Runs the automatic local backup once per app launch, if enabled — a
/// one-shot [Future] (not a stream) so it fires exactly once regardless of
/// how many widgets watch it.

final class AutoBackupOnStartupProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Runs the automatic local backup once per app launch, if enabled — a
  /// one-shot [Future] (not a stream) so it fires exactly once regardless of
  /// how many widgets watch it.
  AutoBackupOnStartupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoBackupOnStartupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoBackupOnStartupHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return autoBackupOnStartup(ref);
  }
}

String _$autoBackupOnStartupHash() =>
    r'963ba671b785bee33d4feb4229e6b96c56a39398';

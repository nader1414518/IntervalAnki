// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apkg_import_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apkgImportRepository)
final apkgImportRepositoryProvider = ApkgImportRepositoryProvider._();

final class ApkgImportRepositoryProvider
    extends
        $FunctionalProvider<
          ApkgImportRepository,
          ApkgImportRepository,
          ApkgImportRepository
        >
    with $Provider<ApkgImportRepository> {
  ApkgImportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apkgImportRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apkgImportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ApkgImportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApkgImportRepository create(Ref ref) {
    return apkgImportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApkgImportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApkgImportRepository>(value),
    );
  }
}

String _$apkgImportRepositoryHash() =>
    r'ca4d2a61091cc8e9ccfce1ac3270da294f6e6dd7';

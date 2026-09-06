// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(browseRepository)
final browseRepositoryProvider = BrowseRepositoryProvider._();

final class BrowseRepositoryProvider
    extends
        $FunctionalProvider<
          BrowseRepository,
          BrowseRepository,
          BrowseRepository
        >
    with $Provider<BrowseRepository> {
  BrowseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browseRepositoryHash();

  @$internal
  @override
  $ProviderElement<BrowseRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BrowseRepository create(Ref ref) {
    return browseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowseRepository>(value),
    );
  }
}

String _$browseRepositoryHash() => r'9252c83940049916de7dc93975b66fda30f51d5f';

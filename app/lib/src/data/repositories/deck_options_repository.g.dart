// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_options_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deckOptionsRepository)
final deckOptionsRepositoryProvider = DeckOptionsRepositoryProvider._();

final class DeckOptionsRepositoryProvider
    extends
        $FunctionalProvider<
          DeckOptionsRepository,
          DeckOptionsRepository,
          DeckOptionsRepository
        >
    with $Provider<DeckOptionsRepository> {
  DeckOptionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deckOptionsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deckOptionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DeckOptionsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeckOptionsRepository create(Ref ref) {
    return deckOptionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeckOptionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeckOptionsRepository>(value),
    );
  }
}

String _$deckOptionsRepositoryHash() =>
    r'1a939ac43ee47e0d4c77fd3054fde0a3fd3d377b';

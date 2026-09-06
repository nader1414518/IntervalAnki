// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_type_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(noteTypeRepository)
final noteTypeRepositoryProvider = NoteTypeRepositoryProvider._();

final class NoteTypeRepositoryProvider
    extends
        $FunctionalProvider<
          NoteTypeRepository,
          NoteTypeRepository,
          NoteTypeRepository
        >
    with $Provider<NoteTypeRepository> {
  NoteTypeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteTypeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noteTypeRepositoryHash();

  @$internal
  @override
  $ProviderElement<NoteTypeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NoteTypeRepository create(Ref ref) {
    return noteTypeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoteTypeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoteTypeRepository>(value),
    );
  }
}

String _$noteTypeRepositoryHash() =>
    r'87e2eae749945bef92214c3c1c73494f22166b1c';

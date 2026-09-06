// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tagRepository)
final tagRepositoryProvider = TagRepositoryProvider._();

final class TagRepositoryProvider
    extends $FunctionalProvider<TagRepository, TagRepository, TagRepository>
    with $Provider<TagRepository> {
  TagRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagRepositoryHash();

  @$internal
  @override
  $ProviderElement<TagRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TagRepository create(Ref ref) {
    return tagRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TagRepository>(value),
    );
  }
}

String _$tagRepositoryHash() => r'1a764a09ef13ccaac28cd5a0c4a18d81ee396093';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';

part 'deck_options_repository.g.dart';

/// Read/write access to deck-options presets (new/day limits, learning
/// steps, FSRS desired retention — PRD §4.1).
class DeckOptionsRepository {
  DeckOptionsRepository(this._db);

  final AppDatabase _db;

  /// Emits deck options [id] whenever it changes.
  Stream<DeckOption> watch(int id) {
    return (_db.select(
      _db.deckOptions,
    )..where((o) => o.id.equals(id))).watchSingle();
  }

  /// Applies a partial update to deck options [id].
  Future<void> update(int id, DeckOptionsCompanion changes) {
    return (_db.update(
      _db.deckOptions,
    )..where((o) => o.id.equals(id))).write(changes);
  }
}

@riverpod
DeckOptionsRepository deckOptionsRepository(Ref ref) {
  return DeckOptionsRepository(ref.watch(appDatabaseProvider));
}

/// Hand-written, not `@riverpod` — see the note on `deckListProvider` in
/// `deck_repository.dart`: riverpod_generator can't code-generate a provider
/// returning a Drift-generated data class.
///
/// Untyped (not `final StreamProviderFamily<...> = ...`): the family variant
/// of a provider's runtime type (`StreamProviderFamily`) isn't part of
/// riverpod's public API surface, so it can't be named here.
// ignore: specify_nonobvious_property_types
final deckOptionsProvider = StreamProvider.autoDispose.family<DeckOption, int>(
  (ref, id) => ref.watch(deckOptionsRepositoryProvider).watch(id),
);

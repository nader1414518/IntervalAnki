import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';

part 'deck_repository.g.dart';

/// Read/write access to decks, keeping Drift usage out of the UI layer.
class DeckRepository {
  DeckRepository(this._db);

  final AppDatabase _db;

  /// Emits the current deck list whenever it changes, ordered by name so
  /// nested decks (`Parent::Child`) group under their parent.
  Stream<List<Deck>> watchAll() {
    return (_db.select(
      _db.decks,
    )..orderBy([(d) => OrderingTerm(expression: d.name)])).watch();
  }
}

@riverpod
DeckRepository deckRepository(Ref ref) {
  return DeckRepository(ref.watch(appDatabaseProvider));
}

/// Hand-written rather than `@riverpod`: riverpod_generator 4.0.9's current
/// dev-prerelease analyzer dependency (`riverpod_analyzer_utils 1.0.0-dev.12`)
/// throws `InvalidTypeException` when asked to code-generate a provider whose
/// return type is a Drift-generated data class (any of them — confirmed not
/// specific to [Deck]). Every future repository that streams a raw Drift row
/// type should follow this same hand-written-provider pattern until that's
/// fixed upstream.
final StreamProvider<List<Deck>> deckListProvider =
    StreamProvider.autoDispose<List<Deck>>((ref) {
      return ref.watch(deckRepositoryProvider).watchAll();
    });

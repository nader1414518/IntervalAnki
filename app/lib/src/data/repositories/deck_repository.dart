import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';

part 'deck_repository.g.dart';

/// Thrown when a deck can't be deleted because it still has cards in it.
class DeckNotEmptyException implements Exception {
  const DeckNotEmptyException(this.deckName);

  final String deckName;

  @override
  String toString() => 'Deck "$deckName" still has cards in it.';
}

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

  /// One-shot fetch of deck [id], e.g. to resolve a route parameter.
  Future<Deck> get(int id) {
    return (_db.select(_db.decks)..where((d) => d.id.equals(id))).getSingle();
  }

  /// The id of the shared "Default" deck-options preset every profile is
  /// seeded with.
  Future<int> defaultDeckOptionsId() async {
    final row = await (_db.select(
      _db.deckOptions,
    )..where((o) => o.name.equals('Default'))).getSingle();
    return row.id;
  }

  /// Creates a new deck named [name] (use `::` for nesting, e.g.
  /// `"Spanish::Verbs"`), using the given options preset or the shared
  /// "Default" one if omitted.
  Future<int> create(String name, {int? deckOptionsId}) async {
    final optionsId = deckOptionsId ?? await defaultDeckOptionsId();
    return await _db
        .into(_db.decks)
        .insert(DecksCompanion.insert(name: name, deckOptionsId: optionsId));
  }

  /// Renames the deck [id] to [newName].
  Future<void> rename(int id, String newName) {
    return (_db.update(_db.decks)..where((d) => d.id.equals(id))).write(
      DecksCompanion(name: Value(newName)),
    );
  }

  /// Deletes the deck [id]. Throws [DeckNotEmptyException] if it still has
  /// cards — bulk "move cards then delete" is a browse/search (M6) action.
  Future<void> delete(int id) async {
    final deck = await (_db.select(
      _db.decks,
    )..where((d) => d.id.equals(id))).getSingle();
    final cardCount =
        await (_db.selectOnly(_db.cards)
              ..addColumns([_db.cards.id.count()])
              ..where(_db.cards.deckId.equals(id)))
            .map((row) => row.read(_db.cards.id.count()) ?? 0)
            .getSingle();
    if (cardCount > 0) {
      throw DeckNotEmptyException(deck.name);
    }
    await (_db.delete(_db.decks)..where((d) => d.id.equals(id))).go();
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

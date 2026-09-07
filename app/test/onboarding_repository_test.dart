import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/repositories/deck_repository.dart';
import 'package:app/src/data/repositories/note_repository.dart';
import 'package:app/src/data/repositories/onboarding_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late OnboardingRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = OnboardingRepository(db, DeckRepository(db), NoteRepository(db));
  });

  tearDown(() => db.close());

  test('creates a deck seeded with the sample cards', () async {
    final deckId = await repo.createFirstDeck('My First Deck');
    final deck = await (db.select(
      db.decks,
    )..where((d) => d.id.equals(deckId))).getSingle();
    expect(deck.name, 'My First Deck');

    final noteCount =
        await (db.selectOnly(db.cards)
              ..addColumns([db.cards.id.count()])
              ..where(db.cards.deckId.equals(deckId)))
            .map((row) => row.read(db.cards.id.count()) ?? 0)
            .getSingle();
    expect(noteCount, 3);
  });

  test('running onboarding again with the same name disambiguates instead '
      'of crashing — regression test for Settings > "Replay the welcome '
      'tour" hitting decks.name\'s UNIQUE constraint', () async {
    final firstId = await repo.createFirstDeck('My First Deck');
    final secondId = await repo.createFirstDeck('My First Deck');

    expect(secondId, isNot(firstId));
    final firstDeck = await (db.select(
      db.decks,
    )..where((d) => d.id.equals(firstId))).getSingle();
    final secondDeck = await (db.select(
      db.decks,
    )..where((d) => d.id.equals(secondId))).getSingle();
    expect(firstDeck.name, 'My First Deck');
    expect(secondDeck.name, 'My First Deck (2)');
  });

  test('a third run picks the next available suffix', () async {
    await repo.createFirstDeck('My First Deck');
    await repo.createFirstDeck('My First Deck');
    final thirdId = await repo.createFirstDeck('My First Deck');
    final thirdDeck = await (db.select(
      db.decks,
    )..where((d) => d.id.equals(thirdId))).getSingle();
    expect(thirdDeck.name, 'My First Deck (3)');
  });
}

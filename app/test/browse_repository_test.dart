import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/repositories/browse_repository.dart';
import 'package:app/src/data/repositories/note_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late BrowseRepository browseRepo;
  late NoteRepository noteRepo;
  late int basicNoteTypeId;
  late int spacedDeckId;
  late int otherDeckId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    browseRepo = BrowseRepository(db);
    noteRepo = NoteRepository(db);
    basicNoteTypeId = (await (db.select(
      db.noteTypes,
    )..where((t) => t.name.equals('Basic'))).getSingle()).id;

    final defaultOptionsId = await (db.select(
      db.deckOptions,
    )..where((o) => o.name.equals('Default'))).map((o) => o.id).getSingle();
    // A name with a space, to prove the deckId filter isn't tripped up by
    // the text-query grammar's naive whitespace split (unlike `deck:Name`).
    spacedDeckId = await db
        .into(db.decks)
        .insert(
          DecksCompanion.insert(
            name: 'My Spaced Deck',
            deckOptionsId: defaultOptionsId,
          ),
        );
    otherDeckId = await db
        .into(db.decks)
        .insert(
          DecksCompanion.insert(name: 'Other', deckOptionsId: defaultOptionsId),
        );

    await noteRepo.create(
      noteTypeId: basicNoteTypeId,
      deckId: spacedDeckId,
      fieldValues: ['In spaced deck', 'Back'],
      tags: const [],
    );
    await noteRepo.create(
      noteTypeId: basicNoteTypeId,
      deckId: otherDeckId,
      fieldValues: ['In other deck', 'Back'],
      tags: const [],
    );
  });

  tearDown(() => db.close());

  test('deckId restricts results to that deck, spaces and all', () async {
    final rows = await browseRepo.search('', deckId: spacedDeckId);

    expect(rows, hasLength(1));
    expect(rows.single.deckName, 'My Spaced Deck');
  });

  test('deckId combines (AND) with a text query term', () async {
    final matching = await browseRepo.search('in', deckId: spacedDeckId);
    expect(matching, hasLength(1));

    final nonMatching = await browseRepo.search(
      'nonexistent',
      deckId: spacedDeckId,
    );
    expect(nonMatching, isEmpty);
  });

  test(
    'a `deck:` text term alone breaks on a deck name with a space',
    () async {
      // Documents the known limitation the deckId param exists to route
      // around — not something to "fix" here without a real deck-scoping
      // caller regressing to typed queries.
      final rows = await browseRepo.search('deck:My Spaced Deck');
      expect(rows, isEmpty);
    },
  );
}

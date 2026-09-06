import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/repositories/browse_repository.dart';
import 'package:app/src/data/repositories/card_repository.dart';
import 'package:app/src/data/repositories/note_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('watchDueCards never surfaces a trashed card', () async {
    final basicNoteTypeId = (await (db.select(
      db.noteTypes,
    )..where((t) => t.name.equals('Basic'))).getSingle()).id;
    final deckId = (await (db.select(
      db.decks,
    )..where((d) => d.name.equals('Welcome'))).getSingle()).id;

    final created = await NoteRepository(db).create(
      noteTypeId: basicNoteTypeId,
      deckId: deckId,
      fieldValues: ['Front', 'Back'],
      tags: const [],
    );
    final card = await (db.select(
      db.cards,
    )..where((c) => c.noteId.equals(created.noteId))).getSingle();

    final beforeTrash = await CardRepository(db).watchDueCards(deckId).first;
    expect(beforeTrash.map((c) => c.id), contains(card.id));

    await BrowseRepository(db).bulkMoveToTrash([card.id]);

    final afterTrash = await CardRepository(db).watchDueCards(deckId).first;
    expect(afterTrash.map((c) => c.id), isNot(contains(card.id)));
  });
}

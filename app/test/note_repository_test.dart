import 'dart:convert';

import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/local/tables.dart' show CardQueue;
import 'package:app/src/data/repositories/note_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late NoteRepository repo;
  late int basicNoteTypeId;
  late int clozeNoteTypeId;
  late int deckId;
  late int otherDeckId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = NoteRepository(db);
    basicNoteTypeId = (await (db.select(
      db.noteTypes,
    )..where((t) => t.name.equals('Basic'))).getSingle()).id;
    clozeNoteTypeId = (await (db.select(
      db.noteTypes,
    )..where((t) => t.name.equals('Cloze'))).getSingle()).id;
    deckId = (await (db.select(
      db.decks,
    )..where((d) => d.name.equals('Welcome'))).getSingle()).id;
    otherDeckId = await db
        .into(db.decks)
        .insert(
          DecksCompanion.insert(
            name: 'Other',
            deckOptionsId:
                await (db.select(db.deckOptions)
                      ..where((o) => o.name.equals('Default')))
                    .map((o) => o.id)
                    .getSingle(),
          ),
        );
  });

  tearDown(() => db.close());

  test('update changes field values, tags, and deck', () async {
    final created = await repo.create(
      noteTypeId: basicNoteTypeId,
      deckId: deckId,
      fieldValues: ['Original front', 'Original back'],
      tags: ['old'],
    );

    await repo.update(
      noteId: created.noteId,
      fieldValues: ['New front', 'New back'],
      tags: ['new'],
      deckId: otherDeckId,
    );

    final note = await (db.select(
      db.notes,
    )..where((n) => n.id.equals(created.noteId))).getSingle();
    expect(jsonDecode(note.fieldValues), ['New front', 'New back']);
    expect(note.tags, contains('new'));
    expect(note.tags, isNot(contains('old')));

    final card = await (db.select(
      db.cards,
    )..where((c) => c.noteId.equals(created.noteId))).getSingle();
    expect(card.deckId, otherDeckId);
  });

  test(
    "update reconciles a Cloze note's cards when deletions change",
    () async {
      final created = await repo.create(
        noteTypeId: clozeNoteTypeId,
        deckId: deckId,
        fieldValues: ['{{c1::Paris}} is the capital of {{c2::France}}', ''],
        tags: const [],
      );
      final originalCards = await (db.select(
        db.cards,
      )..where((c) => c.noteId.equals(created.noteId))).get();
      expect(originalCards.map((c) => c.templateOrd).toSet(), {0, 1});

      // Grade the first card so it has real scheduling state to preserve.
      final firstCardId = originalCards
          .firstWhere((c) => c.templateOrd == 0)
          .id;
      await (db.update(db.cards)..where((c) => c.id.equals(firstCardId))).write(
        const CardsCompanion(
          queue: Value(CardQueue.review),
          stability: Value(5),
        ),
      );

      // Drop c2 and add a new c3 — c1's card should be untouched, c2's
      // card removed, and a new card added for c3.
      await repo.update(
        noteId: created.noteId,
        fieldValues: [
          '{{c1::Paris}} is the capital of France, {{c3::not Lyon}}',
          '',
        ],
        tags: const [],
      );

      final updatedCards = await (db.select(
        db.cards,
      )..where((c) => c.noteId.equals(created.noteId))).get();
      expect(updatedCards.map((c) => c.templateOrd).toSet(), {0, 2});

      final preservedCard = updatedCards.firstWhere((c) => c.templateOrd == 0);
      expect(preservedCard.id, firstCardId);
      expect(preservedCard.queue, CardQueue.review);
      expect(preservedCard.stability, 5);

      final newCard = updatedCards.firstWhere((c) => c.templateOrd == 2);
      expect(newCard.queue, CardQueue.newCard);
    },
  );

  test('update does not flag the note as a duplicate of itself', () async {
    final created = await repo.create(
      noteTypeId: basicNoteTypeId,
      deckId: deckId,
      fieldValues: ['Same front', 'Back'],
      tags: const [],
    );

    final wasDuplicate = await repo.update(
      noteId: created.noteId,
      fieldValues: ['Same front', 'Different back'],
      tags: const [],
    );

    expect(wasDuplicate, isFalse);
  });
}

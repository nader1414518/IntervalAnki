import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/local/image_occlusion.dart';
import 'package:app/src/data/repositories/card_repository.dart';
import 'package:app/src/data/repositories/note_repository.dart';
import 'package:card_template/card_template.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late int noteTypeId;
  late int deckId;

  const masks = [
    ImageOcclusionMask(left: 10, top: 10, width: 20, height: 20),
    ImageOcclusionMask(left: 40, top: 40, width: 20, height: 20),
  ];

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    noteTypeId = (await (db.select(
      db.noteTypes,
    )..where((t) => t.name.equals(imageOcclusionNoteTypeName))).getSingle()).id;
    deckId = (await (db.select(
      db.decks,
    )..where((d) => d.name.equals('Welcome'))).getSingle()).id;
  });

  tearDown(() => db.close());

  test('creating a note generates one card per mask', () async {
    final result = await NoteRepository(db).create(
      noteTypeId: noteTypeId,
      deckId: deckId,
      fieldValues: ['diagram.png', encodeMasks(masks), ''],
      tags: const [],
    );

    final cards = await (db.select(
      db.cards,
    )..where((c) => c.noteId.equals(result.noteId))).get();
    expect(cards.map((c) => c.templateOrd).toSet(), {0, 1});
  });

  test(
    'editing to add/remove masks reconciles cards, preserving the rest',
    () async {
      final repo = NoteRepository(db);
      final created = await repo.create(
        noteTypeId: noteTypeId,
        deckId: deckId,
        fieldValues: ['diagram.png', encodeMasks(masks), ''],
        tags: const [],
      );

      await repo.update(
        noteId: created.noteId,
        fieldValues: [
          'diagram.png',
          encodeMasks([
            masks[0],
            const ImageOcclusionMask(left: 60, top: 60, width: 15, height: 15),
            const ImageOcclusionMask(left: 5, top: 70, width: 10, height: 10),
          ]),
          '',
        ],
        tags: const [],
      );

      final cards = await (db.select(
        db.cards,
      )..where((c) => c.noteId.equals(created.noteId))).get();
      expect(cards.map((c) => c.templateOrd).toSet(), {0, 1, 2});
    },
  );

  test(
    'rendering hides only the target mask on the front, none on the back',
    () async {
      final result = await NoteRepository(db).create(
        noteTypeId: noteTypeId,
        deckId: deckId,
        fieldValues: ['diagram.png', encodeMasks(masks), 'Extra info'],
        tags: const [],
      );
      final card =
          await (db.select(db.cards)
                ..where((c) => c.noteId.equals(result.noteId))
                ..where((c) => c.templateOrd.equals(1)))
              .getSingle();

      final data = await CardRepository(db)
          .loadRenderData(card, const CardTemplateRenderer());

      // Front: the image renders, and exactly one mask div (the target,
      // mask index 1 — positioned at left:40%) is drawn.
      expect(data.front, contains('src="diagram.png"'));
      expect('class="io-mask"'.allMatches(data.front).length, 1);
      expect(data.front, contains('left:40.0%'));

      // Back: fully unmasked, plus the Extra field.
      expect(data.back, isNot(contains('class="io-mask"')));
      expect(data.back, contains('Extra info'));
    },
  );
}

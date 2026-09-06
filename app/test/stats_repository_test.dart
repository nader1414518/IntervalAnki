import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/local/tables.dart' show CardQueue;
import 'package:app/src/data/repositories/card_repository.dart';
import 'package:app/src/data/repositories/note_repository.dart';
import 'package:app/src/data/repositories/stats_repository.dart';
import 'package:card_template/card_template.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

void main() {
  late AppDatabase db;
  late StatsRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = StatsRepository(db);
  });

  tearDown(() => db.close());

  test(
    'an empty database reports zero reviews and no retention rate',
    () async {
      final stats = await repo.load();
      expect(stats.totalReviews, 0);
      expect(stats.retentionRate, isNull);
      expect(stats.dailyCounts, hasLength(14));
      expect(stats.dailyCounts.every((c) => c.count == 0), isTrue);
    },
  );

  test('retention rate counts anything but Again as correct', () async {
    final basicNoteTypeId = (await (db.select(
      db.noteTypes,
    )..where((t) => t.name.equals('Basic'))).getSingle()).id;
    final deckId = (await (db.select(
      db.decks,
    )..where((d) => d.name.equals('Welcome'))).getSingle()).id;
    final noteRepo = NoteRepository(db);
    final cardRepo = CardRepository(db);
    const renderer = CardTemplateRenderer();

    final noteIds = <int>[];
    for (var i = 0; i < 3; i++) {
      final created = await noteRepo.create(
        noteTypeId: basicNoteTypeId,
        deckId: deckId,
        fieldValues: ['Front $i', 'Back $i'],
        tags: const [],
      );
      noteIds.add(created.noteId);
    }

    final ratings = [fsrs.Rating.good, fsrs.Rating.easy, fsrs.Rating.again];
    for (var i = 0; i < noteIds.length; i++) {
      final card = await (db.select(
        db.cards,
      )..where((c) => c.noteId.equals(noteIds[i]))).getSingle();
      final data = await cardRepo.loadRenderData(card, renderer);
      await cardRepo.grade(data.card, ratings[i]);
    }

    final stats = await repo.load();
    expect(stats.totalReviews, 3);
    // 2 of 3 (good, easy) count as correct; again does not.
    expect(stats.retentionRate, closeTo(2 / 3, 0.0001));
    expect(stats.dailyCounts.last.count, 3);
    expect(stats.cardsByQueue[CardQueue.review], 2);
    expect(stats.cardsByQueue[CardQueue.relearning], 1);
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:anki_format/anki_format.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

/// Builds a minimal but real `.apkg` archive (zip + legacy Anki sqlite
/// schema) for testing, so [ApkgImporter] is exercised against the actual
/// binary format rather than a hand-rolled stand-in.
Future<List<int>> _buildFixtureApkg(Directory tempDir) async {
  final dbPath = p.join(tempDir.path, 'collection.anki2');
  final db = sqlite3.open(dbPath)
    ..execute('''
    CREATE TABLE col (id INTEGER, decks TEXT, models TEXT);
    CREATE TABLE notes (id INTEGER, mid INTEGER, flds TEXT, tags TEXT);
    CREATE TABLE cards (
      id INTEGER, nid INTEGER, did INTEGER, ord INTEGER,
      queue INTEGER, reps INTEGER, lapses INTEGER, flags INTEGER
    );
  ''');

  final decks = jsonEncode({
    '1': {'name': 'Default'},
    '2': {'name': 'Spanish::Verbs'},
  });
  final models = jsonEncode({
    '100': {
      'name': 'Basic',
      'css': '.card { color: black; }',
      'flds': [
        {'name': 'Front', 'ord': 0},
        {'name': 'Back', 'ord': 1},
      ],
      'tmpls': [
        {'name': 'Card 1', 'ord': 0, 'qfmt': '{{Front}}', 'afmt': '{{Back}}'},
      ],
    },
  });
  db.execute('INSERT INTO col (id, decks, models) VALUES (1, ?, ?)', [
    decks,
    models,
  ]);

  // Not cascaded: readability suffers when db.execute calls are
  // interleaved with unrelated variable setup.
  // ignore: cascade_invocations
  db.execute('INSERT INTO notes (id, mid, flds, tags) VALUES (?, ?, ?, ?)', [
    500,
    100,
    'hablar\x1fto speak',
    ' verb ',
  ]);
  db.execute(
    'INSERT INTO cards '
    '(id, nid, did, ord, queue, reps, lapses, flags) '
    'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [900, 500, 2, 0, 0, 3, 1, 2],
  );
  db.close();

  final dbBytes = await File(dbPath).readAsBytes();
  final mediaJson = jsonEncode({'0': 'sound.mp3'});

  final archive = Archive()
    ..addFile(ArchiveFile('collection.anki2', dbBytes.length, dbBytes))
    ..addFile(
      ArchiveFile(
        'media',
        utf8.encode(mediaJson).length,
        utf8.encode(mediaJson),
      ),
    )
    ..addFile(ArchiveFile('0', 3, [1, 2, 3]));

  return ZipEncoder().encode(archive);
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('apkg_importer_test');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test(
    'parses decks, note types, notes, cards, and media from a fixture apkg',
    () async {
      final bytes = await _buildFixtureApkg(tempDir);
      final result = await const ApkgImporter().parseBytes(bytes);

      expect(result.decks, hasLength(2));
      expect(
        result.decks.map((d) => d.name),
        containsAll(['Default', 'Spanish::Verbs']),
      );

      expect(result.noteTypes, hasLength(1));
      final noteType = result.noteTypes.single;
      expect(noteType.name, 'Basic');
      expect(noteType.fields.map((f) => f.name), ['Front', 'Back']);
      expect(noteType.templates.single.front, '{{Front}}');

      expect(result.notes, hasLength(1));
      final note = result.notes.single;
      expect(note.fieldValues, ['hablar', 'to speak']);
      expect(note.tags, ['verb']);
      expect(note.noteTypeAnkiId, 100);

      expect(result.cards, hasLength(1));
      final card = result.cards.single;
      expect(card.deckAnkiId, 2);
      expect(card.queue, ImportedCardQueue.newCard);
      expect(card.reps, 3);
      expect(card.lapses, 1);
      expect(card.flag, 2);

      expect(result.mediaFiles, {
        'sound.mp3': [1, 2, 3],
      });
    },
  );

  test('maps suspended and buried queues', () async {
    final dbPath = p.join(tempDir.path, 'collection.anki2');
    final db = sqlite3.open(dbPath)
      ..execute('''
      CREATE TABLE col (id INTEGER, decks TEXT, models TEXT);
      CREATE TABLE notes (id INTEGER, mid INTEGER, flds TEXT, tags TEXT);
      CREATE TABLE cards (
        id INTEGER, nid INTEGER, did INTEGER, ord INTEGER,
        queue INTEGER, reps INTEGER, lapses INTEGER, flags INTEGER
      );
    ''');
    // Not cascaded: readability suffers when db.execute calls are
    // interleaved with unrelated variable setup.
    // ignore: cascade_invocations
    db.execute('INSERT INTO col (id, decks, models) VALUES (1, ?, ?)', [
      jsonEncode({
        '1': {'name': 'Default'},
      }),
      jsonEncode(<String, dynamic>{}),
    ]);
    db.execute('INSERT INTO notes (id, mid, flds, tags) VALUES (1, 1, ?, ?)', [
      'x',
      '',
    ]);
    db.execute(
      'INSERT INTO cards (id, nid, did, ord, queue, reps, lapses, flags) '
      'VALUES (1, 1, 1, 0, -1, 0, 0, 0), (2, 1, 1, 0, -2, 0, 0, 0)',
    );
    db.close();

    final dbBytes = await File(dbPath).readAsBytes();
    final archive = Archive()
      ..addFile(ArchiveFile('collection.anki2', dbBytes.length, dbBytes));
    final bytes = ZipEncoder().encode(archive);

    final result = await const ApkgImporter().parseBytes(bytes);
    expect(result.cards[0].queue, ImportedCardQueue.suspended);
    expect(result.cards[1].queue, ImportedCardQueue.buried);
  });
}

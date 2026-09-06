import 'dart:convert';
import 'dart:io';

import 'package:anki_format/anki_format.dart';
import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/local/media_storage.dart';
import 'package:app/src/data/local/tables.dart' show CardQueue;
import 'package:app/src/data/repositories/apkg_import_repository.dart';
import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

/// Fakes the documents-directory lookup [MediaStorage] needs, since plain
/// `test()` (unlike `testWidgets()`) has no platform channel to answer it.
class _FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProviderPlatform(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

/// Builds a small but real `.apkg` archive for exercising the full
/// parse-then-insert import pipeline end to end against a real (in-memory)
/// app database.
Future<List<int>> _buildFixtureApkg(Directory tempDir) async {
  final dbPath = p.join(tempDir.path, 'collection.anki2');
  final db = sqlite3.sqlite3.open(dbPath)
    ..execute('''
      CREATE TABLE col (id INTEGER, decks TEXT, models TEXT);
      CREATE TABLE notes (id INTEGER, mid INTEGER, flds TEXT, tags TEXT);
      CREATE TABLE cards (
        id INTEGER, nid INTEGER, did INTEGER, ord INTEGER,
        queue INTEGER, reps INTEGER, lapses INTEGER, flags INTEGER
      );
    ''');

  final decks = jsonEncode({
    '1': {'name': 'Imported::French'},
  });
  final models = jsonEncode({
    '100': {
      'name': 'Imported Basic',
      'css': '.card { color: blue; }',
      'flds': [
        {'name': 'Front', 'ord': 0},
        {'name': 'Back', 'ord': 1},
      ],
      'tmpls': [
        {
          'name': 'Card 1',
          'ord': 0,
          'qfmt': '{{Front}}',
          'afmt': '{{FrontSide}}<hr>{{Back}}',
        },
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
    'bonjour\x1fhello',
    ' greeting ',
  ]);
  db.execute(
    'INSERT INTO cards '
    '(id, nid, did, ord, queue, reps, lapses, flags) '
    'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [900, 500, 1, 0, 0, 0, 0, 0],
  );
  db.close();

  final dbBytes = await File(dbPath).readAsBytes();
  final mediaJson = utf8.encode('{"0": "greeting.mp3"}');
  final archive = Archive()
    ..addFile(ArchiveFile('collection.anki2', dbBytes.length, dbBytes))
    ..addFile(ArchiveFile('media', mediaJson.length, mediaJson))
    ..addFile(ArchiveFile('0', 3, [9, 9, 9]));
  return ZipEncoder().encode(archive);
}

void main() {
  test('imports a real .apkg into the app schema end to end', () async {
    final tempDir = await Directory.systemTemp.createTemp('apkg_e2e_test');
    addTearDown(() => tempDir.delete(recursive: true));
    PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);

    final apkgBytes = await _buildFixtureApkg(tempDir);
    final parsed = await const ApkgImporter().parseBytes(apkgBytes);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final repository = ApkgImportRepository(db, MediaStorage());
    final summary = await repository.import(parsed);

    expect(summary.deckCount, 1);
    expect(summary.noteTypeCount, 1);
    expect(summary.noteCount, 1);
    expect(summary.cardCount, 1);
    expect(summary.mediaCount, 1);

    final deck = await (db.select(
      db.decks,
    )..where((d) => d.name.equals('Imported::French'))).getSingle();

    expect(
      await (db.select(
        db.noteTypes,
      )..where((t) => t.name.equals('Imported Basic'))).getSingleOrNull(),
      isNotNull,
    );

    final note = await db.select(db.notes).getSingle();
    expect(jsonDecode(note.fieldValues), ['bonjour', 'hello']);
    expect(note.tags, contains('greeting'));

    final card = await db.select(db.cards).getSingle();
    expect(card.deckId, deck.id);
    expect(card.queue, CardQueue.newCard);
  });
}

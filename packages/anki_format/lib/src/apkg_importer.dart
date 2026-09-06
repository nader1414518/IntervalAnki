import 'dart:convert';
import 'dart:io';

import 'package:anki_format/src/models.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

/// Parses `.apkg` archives (a zip containing a legacy Anki SQLite collection
/// plus media) into a portable [ApkgImportResult].
///
/// Scope: reads the classic `collection.anki2`/`collection.anki21` SQLite
/// schema (decks/note types as JSON blobs on the `col` row) used by the vast
/// majority of shared decks. The newer zstd-compressed `.anki21b` schema
/// (Anki's "modern" storage since schema 18) isn't supported.
///
/// Imported cards always start fresh in the new-card queue (suspended/
/// buried status aside) rather than attempting to carry over Anki's
/// interval/ease/due state: those are SM-2 concepts with no faithful
/// mapping to this app's FSRS memory model, and Anki's `due` field's
/// meaning depends on the source collection's creation date in ways that
/// are easy to get subtly wrong. Lapses/reps counters, which aren't
/// date-dependent, are preserved.
class ApkgImporter {
  /// Creates an importer.
  const ApkgImporter();

  /// Parses the `.apkg` file at [path].
  Future<ApkgImportResult> parseFile(String path) {
    return parseBytes(File(path).readAsBytesSync());
  }

  /// Parses raw `.apkg` archive bytes.
  Future<ApkgImportResult> parseBytes(List<int> apkgBytes) async {
    final archive = ZipDecoder().decodeBytes(apkgBytes);
    final dbEntry = archive.files.firstWhere(
      (f) => f.name == 'collection.anki2' || f.name == 'collection.anki21',
      orElse: () => throw const FormatException(
        'No collection.anki2/anki21 database found in this .apkg',
      ),
    );

    final tempDir = await Directory.systemTemp.createTemp('anki_import');
    try {
      final dbFile = File(p.join(tempDir.path, 'collection.sqlite'));
      await dbFile.writeAsBytes(dbEntry.content as List<int>);

      final db = sqlite3.open(dbFile.path);
      try {
        return _parseDatabase(db, archive);
      } finally {
        db.close();
      }
    } finally {
      await tempDir.delete(recursive: true);
    }
  }

  ApkgImportResult _parseDatabase(Database db, Archive archive) {
    final col = db.select('SELECT decks, models FROM col').first;
    final decksJson =
        jsonDecode(col['decks'] as String) as Map<String, dynamic>;
    final modelsJson =
        jsonDecode(col['models'] as String) as Map<String, dynamic>;

    final decks = [
      for (final entry in decksJson.entries)
        ImportedDeck(
          ankiId: int.parse(entry.key),
          name: (entry.value as Map<String, dynamic>)['name'] as String,
        ),
    ];

    final noteTypes = [
      for (final entry in modelsJson.entries)
        _parseNoteType(
          int.parse(entry.key),
          entry.value as Map<String, dynamic>,
        ),
    ];

    final notes = [
      for (final row in db.select('SELECT id, mid, flds, tags FROM notes'))
        ImportedNote(
          ankiId: row['id'] as int,
          noteTypeAnkiId: row['mid'] as int,
          fieldValues: (row['flds'] as String).split('\x1f'),
          tags: (row['tags'] as String)
              .trim()
              .split(RegExp(r'\s+'))
              .where((t) => t.isNotEmpty)
              .toList(),
        ),
    ];

    final cards = [
      for (final row in db.select(
        'SELECT id, nid, did, ord, queue, reps, lapses, flags FROM cards',
      ))
        ImportedCard(
          ankiId: row['id'] as int,
          noteAnkiId: row['nid'] as int,
          deckAnkiId: row['did'] as int,
          templateOrd: row['ord'] as int,
          queue: _mapQueue(row['queue'] as int),
          reps: row['reps'] as int,
          lapses: row['lapses'] as int,
          flag: row['flags'] as int,
        ),
    ];

    return ApkgImportResult(
      noteTypes: noteTypes,
      decks: decks,
      notes: notes,
      cards: cards,
      mediaFiles: _readMedia(archive),
    );
  }

  ImportedNoteType _parseNoteType(int ankiId, Map<String, dynamic> json) {
    final fields = (json['flds'] as List).map((f) {
      final map = f as Map<String, dynamic>;
      return ImportedField(name: map['name'] as String, ord: map['ord'] as int);
    }).toList()..sort((a, b) => a.ord.compareTo(b.ord));

    final templates = (json['tmpls'] as List).map((t) {
      final map = t as Map<String, dynamic>;
      return ImportedTemplate(
        name: map['name'] as String,
        front: map['qfmt'] as String,
        back: map['afmt'] as String,
        ord: map['ord'] as int,
      );
    }).toList()..sort((a, b) => a.ord.compareTo(b.ord));

    return ImportedNoteType(
      ankiId: ankiId,
      name: json['name'] as String,
      fields: fields,
      templates: templates,
      css: json['css'] as String? ?? '',
    );
  }

  ImportedCardQueue _mapQueue(int queue) {
    if (queue == -1) return ImportedCardQueue.suspended;
    if (queue == -2 || queue == -3) return ImportedCardQueue.buried;
    return ImportedCardQueue.newCard;
  }

  Map<String, List<int>> _readMedia(Archive archive) {
    final mediaEntry = archive.files
        .where((f) => f.name == 'media')
        .firstOrNull;
    if (mediaEntry == null) return const {};

    final mediaMap = (jsonDecode(
      utf8.decode(mediaEntry.content as List<int>),
    ) as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String));

    final files = <String, List<int>>{};
    for (final file in archive.files) {
      final realName = mediaMap[file.name];
      if (realName != null && file.isFile) {
        files[realName] = file.content as List<int>;
      }
    }
    return files;
  }
}

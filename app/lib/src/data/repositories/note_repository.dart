import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../local/tables.dart' show CardQueue;

part 'note_repository.g.dart';

final _clozeNumber = RegExp(r'\{\{c(\d+)::');

/// Result of creating a note: whether a near-duplicate (same first field,
/// same note type) already existed (PRD §4.3 — a non-blocking warning, the
/// note is still created).
class CreateNoteResult {
  const CreateNoteResult({required this.noteId, required this.wasDuplicate});

  final int noteId;
  final bool wasDuplicate;
}

/// Creates notes and the cards their note type's templates generate.
class NoteRepository {
  NoteRepository(this._db);

  final AppDatabase _db;

  /// Hashes a field value for duplicate detection, scoped to a note type.
  static String hashFirstField(int noteTypeId, String value) {
    return sha1.convert(utf8.encode('$noteTypeId:${value.trim()}')).toString();
  }

  /// Creates a note of type [noteTypeId] with [fieldValues] (ordered to
  /// match the note type's fields) and [tags], generating cards in
  /// [deckId] for each of its templates — or one card per distinct cloze
  /// deletion number, for a Cloze-style note type.
  Future<CreateNoteResult> create({
    required int noteTypeId,
    required int deckId,
    required List<String> fieldValues,
    required List<String> tags,
  }) async {
    final firstFieldHash = hashFirstField(
      noteTypeId,
      fieldValues.isEmpty ? '' : fieldValues.first,
    );
    final wasDuplicate = await _hasDuplicate(noteTypeId, firstFieldHash);

    final noteId = await _db.transaction(() async {
      final noteId = await _db
          .into(_db.notes)
          .insert(
            NotesCompanion.insert(
              noteTypeId: noteTypeId,
              fieldValues: jsonEncode(fieldValues),
              firstFieldHash: firstFieldHash,
              tags: Value(' ${tags.join(' ')} '),
            ),
          );

      final templateOrds = await _cardTemplateOrds(noteTypeId, fieldValues);
      for (final ord in templateOrds) {
        await _db
            .into(_db.cards)
            .insert(
              CardsCompanion.insert(
                noteId: noteId,
                deckId: deckId,
                templateOrd: ord,
                queue: CardQueue.newCard,
                due: 0,
              ),
            );
      }
      return noteId;
    });

    return CreateNoteResult(noteId: noteId, wasDuplicate: wasDuplicate);
  }

  Future<bool> _hasDuplicate(int noteTypeId, String firstFieldHash) async {
    final existing =
        await (_db.select(_db.notes)..where(
              (n) =>
                  n.noteTypeId.equals(noteTypeId) &
                  n.firstFieldHash.equals(firstFieldHash),
            ))
            .get();
    return existing.isNotEmpty;
  }

  /// The template ords to generate cards for: one per `Templates` row,
  /// except for a Cloze note type (detected by a `{{cloze:` template),
  /// which generates one card per distinct `{{cN::...}}` deletion number
  /// found in [fieldValues] (falling back to a single card if none are
  /// found, rather than blocking the note's creation).
  Future<List<int>> _cardTemplateOrds(
    int noteTypeId,
    List<String> fieldValues,
  ) async {
    final templates = await (_db.select(
      _db.templates,
    )..where((t) => t.noteTypeId.equals(noteTypeId))).get();
    final isCloze = templates.any((t) => t.front.contains('{{cloze:'));
    if (!isCloze) {
      return templates.map((t) => t.ord).toList();
    }

    final clozeNumbers = <int>{};
    for (final value in fieldValues) {
      for (final match in _clozeNumber.allMatches(value)) {
        clozeNumbers.add(int.parse(match.group(1)!));
      }
    }
    if (clozeNumbers.isEmpty) return [0];
    return clozeNumbers.map((n) => n - 1).toList()..sort();
  }
}

@riverpod
NoteRepository noteRepository(Ref ref) {
  return NoteRepository(ref.watch(appDatabaseProvider));
}

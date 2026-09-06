import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../local/image_occlusion.dart';
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

/// A note's current state, loaded for the editor (PRD §4.3's "unified
/// add/edit flow" — the same screen that creates notes also edits them).
class NoteEditData {
  const NoteEditData({
    required this.noteTypeId,
    required this.fieldValues,
    required this.tags,
    required this.deckId,
  });

  final int noteTypeId;
  final List<String> fieldValues;
  final List<String> tags;

  /// The deck its cards currently live in — inferred from one of them,
  /// since deck is a property of a card, not the note itself, but every
  /// card `create()` generates for a note starts in the same deck.
  final int deckId;
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

  Future<bool> _hasDuplicate(
    int noteTypeId,
    String firstFieldHash, {
    int? excludeNoteId,
  }) async {
    final existing =
        await (_db.select(_db.notes)..where(
              (n) =>
                  n.noteTypeId.equals(noteTypeId) &
                  n.firstFieldHash.equals(firstFieldHash),
            ))
            .get();
    return existing.any((n) => n.id != excludeNoteId);
  }

  /// Loads note [noteId]'s current field values, tags, and deck, for the
  /// editor to pre-fill.
  Future<NoteEditData> loadForEdit(int noteId) async {
    final note = await (_db.select(
      _db.notes,
    )..where((n) => n.id.equals(noteId))).getSingle();
    final firstCard = await (_db.select(
      _db.cards,
    )..where((c) => c.noteId.equals(noteId))).getSingle();
    final tags = note.tags.trim();
    return NoteEditData(
      noteTypeId: note.noteTypeId,
      fieldValues: (jsonDecode(note.fieldValues) as List).cast<String>(),
      tags: tags.isEmpty ? const [] : tags.split(RegExp(r'\s+')),
      deckId: firstCard.deckId,
    );
  }

  /// Updates note [noteId]'s field values/tags and, if given, moves its
  /// cards to [deckId]. Reconciles the card set the same way [create] does,
  /// so editing a Cloze note's deletions adds/removes cards to match rather
  /// than leaving stale or missing ones — cards for deletions that still
  /// exist keep their scheduling state untouched.
  Future<bool> update({
    required int noteId,
    required List<String> fieldValues,
    required List<String> tags,
    int? deckId,
  }) async {
    final note = await (_db.select(
      _db.notes,
    )..where((n) => n.id.equals(noteId))).getSingle();
    final firstFieldHash = hashFirstField(
      note.noteTypeId,
      fieldValues.isEmpty ? '' : fieldValues.first,
    );
    final wasDuplicate = await _hasDuplicate(
      note.noteTypeId,
      firstFieldHash,
      excludeNoteId: noteId,
    );

    await _db.transaction(() async {
      await (_db.update(_db.notes)..where((n) => n.id.equals(noteId))).write(
        NotesCompanion(
          fieldValues: Value(jsonEncode(fieldValues)),
          firstFieldHash: Value(firstFieldHash),
          tags: Value(' ${tags.join(' ')} '),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final existingCards = await (_db.select(
        _db.cards,
      )..where((c) => c.noteId.equals(noteId))).get();
      if (existingCards.isEmpty) return;

      if (deckId != null) {
        await (_db.update(_db.cards)..where((c) => c.noteId.equals(noteId)))
            .write(CardsCompanion(deckId: Value(deckId)));
      }

      final desiredOrds = (await _cardTemplateOrds(
        note.noteTypeId,
        fieldValues,
      )).toSet();
      final existingOrds = existingCards.map((c) => c.templateOrd).toSet();

      for (final ord in desiredOrds.difference(existingOrds)) {
        await _db
            .into(_db.cards)
            .insert(
              CardsCompanion.insert(
                noteId: noteId,
                deckId: deckId ?? existingCards.first.deckId,
                templateOrd: ord,
                queue: CardQueue.newCard,
                due: 0,
              ),
            );
      }

      final removedOrds = existingOrds.difference(desiredOrds);
      if (removedOrds.isNotEmpty) {
        await (_db.delete(_db.cards)..where(
              (c) => c.noteId.equals(noteId) & c.templateOrd.isIn(removedOrds),
            ))
            .go();
      }
    });

    return wasDuplicate;
  }

  /// The template ords to generate cards for: one per `Templates` row,
  /// except for a Cloze note type (detected by a `{{cloze:` template),
  /// which generates one card per distinct `{{cN::...}}` deletion number
  /// found in [fieldValues] (falling back to a single card if none are
  /// found, rather than blocking the note's creation) — or an Image
  /// Occlusion note type, one card per mask in its "Masks" field.
  Future<List<int>> _cardTemplateOrds(
    int noteTypeId,
    List<String> fieldValues,
  ) async {
    final templates = await (_db.select(
      _db.templates,
    )..where((t) => t.noteTypeId.equals(noteTypeId))).get();

    if (templates.any((t) => t.front.contains('{{image-occlusion-front}}'))) {
      final masksJson = fieldValues.length > 1 ? fieldValues[1] : '';
      final maskCount = decodeMasks(masksJson).length;
      return List.generate(maskCount, (i) => i);
    }

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

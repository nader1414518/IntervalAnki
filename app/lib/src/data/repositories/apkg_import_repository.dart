import 'dart:convert';

import 'package:anki_format/anki_format.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../local/media_storage.dart';
import '../local/tables.dart';
import 'note_repository.dart' show NoteRepository;

part 'apkg_import_repository.g.dart';

/// Post-import counts, shown to the user as a fidelity report (PRD §4.8).
class ApkgImportSummary {
  const ApkgImportSummary({
    required this.deckCount,
    required this.noteTypeCount,
    required this.noteCount,
    required this.cardCount,
    required this.mediaCount,
  });

  final int deckCount;
  final int noteTypeCount;
  final int noteCount;
  final int cardCount;
  final int mediaCount;
}

/// Inserts a parsed `.apkg` ([ApkgImportResult]) into this app's schema.
///
/// Decks and note types are merged into existing ones of the same name
/// (matching Anki's own import behavior) rather than always creating
/// duplicates; notes/cards are always inserted fresh, remapping the
/// source collection's ids to this app's own.
class ApkgImportRepository {
  ApkgImportRepository(this._db, this._mediaStorage);

  final AppDatabase _db;
  final MediaStorage _mediaStorage;

  Future<ApkgImportSummary> import(ApkgImportResult data) async {
    return await _db.transaction(() async {
      final deckIdByAnkiId = await _importDecks(data.decks);
      final noteTypeIdByAnkiId = await _importNoteTypes(data.noteTypes);
      final noteIdByAnkiId = await _importNotes(data.notes, noteTypeIdByAnkiId);
      final cardCount = await _importCards(
        data.cards,
        noteIdByAnkiId,
        deckIdByAnkiId,
      );

      for (final entry in data.mediaFiles.entries) {
        await _mediaStorage.storeWithOriginalFilename(entry.key, entry.value);
      }

      return ApkgImportSummary(
        deckCount: deckIdByAnkiId.length,
        noteTypeCount: noteTypeIdByAnkiId.length,
        noteCount: noteIdByAnkiId.length,
        cardCount: cardCount,
        mediaCount: data.mediaFiles.length,
      );
    });
  }

  Future<Map<int, int>> _importDecks(List<ImportedDeck> decks) async {
    final result = <int, int>{};
    for (final deck in decks) {
      final existing = await (_db.select(
        _db.decks,
      )..where((d) => d.name.equals(deck.name))).getSingleOrNull();
      if (existing != null) {
        result[deck.ankiId] = existing.id;
        continue;
      }
      final optionsId = await _defaultDeckOptionsId();
      result[deck.ankiId] = await _db
          .into(_db.decks)
          .insert(
            DecksCompanion.insert(name: deck.name, deckOptionsId: optionsId),
          );
    }
    return result;
  }

  Future<int> _defaultDeckOptionsId() async {
    final existing = await (_db.select(
      _db.deckOptions,
    )..where((o) => o.name.equals('Default'))).getSingleOrNull();
    if (existing != null) return existing.id;
    return await _db
        .into(_db.deckOptions)
        .insert(const DeckOptionsCompanion(name: Value('Default')));
  }

  Future<Map<int, int>> _importNoteTypes(
    List<ImportedNoteType> noteTypes,
  ) async {
    final result = <int, int>{};
    for (final noteType in noteTypes) {
      final existing = await (_db.select(
        _db.noteTypes,
      )..where((t) => t.name.equals(noteType.name))).getSingleOrNull();
      if (existing != null) {
        result[noteType.ankiId] = existing.id;
        continue;
      }

      final id = await _db
          .into(_db.noteTypes)
          .insert(NoteTypesCompanion.insert(name: noteType.name));
      result[noteType.ankiId] = id;

      for (final field in noteType.fields) {
        await _db
            .into(_db.fields)
            .insert(
              FieldsCompanion.insert(
                noteTypeId: id,
                name: field.name,
                ord: field.ord,
              ),
            );
      }
      for (final template in noteType.templates) {
        await _db
            .into(_db.templates)
            .insert(
              TemplatesCompanion.insert(
                noteTypeId: id,
                name: template.name,
                front: template.front,
                back: template.back,
                ord: template.ord,
                css: Value(noteType.css),
              ),
            );
      }
    }
    return result;
  }

  Future<Map<int, int>> _importNotes(
    List<ImportedNote> notes,
    Map<int, int> noteTypeIdByAnkiId,
  ) async {
    final result = <int, int>{};
    for (final note in notes) {
      final noteTypeId = noteTypeIdByAnkiId[note.noteTypeAnkiId];
      if (noteTypeId == null) continue;

      final firstField = note.fieldValues.isEmpty ? '' : note.fieldValues.first;
      final id = await _db
          .into(_db.notes)
          .insert(
            NotesCompanion.insert(
              noteTypeId: noteTypeId,
              fieldValues: jsonEncode(note.fieldValues),
              firstFieldHash: NoteRepository.hashFirstField(
                noteTypeId,
                firstField,
              ),
              tags: Value(' ${note.tags.join(' ')} '),
            ),
          );
      result[note.ankiId] = id;
    }
    return result;
  }

  Future<int> _importCards(
    List<ImportedCard> cards,
    Map<int, int> noteIdByAnkiId,
    Map<int, int> deckIdByAnkiId,
  ) async {
    var count = 0;
    for (final card in cards) {
      final noteId = noteIdByAnkiId[card.noteAnkiId];
      final deckId = deckIdByAnkiId[card.deckAnkiId];
      if (noteId == null || deckId == null) continue;

      await _db
          .into(_db.cards)
          .insert(
            CardsCompanion.insert(
              noteId: noteId,
              deckId: deckId,
              templateOrd: card.templateOrd,
              queue: _mapQueue(card.queue),
              due: 0,
              lapses: Value(card.lapses),
              reps: Value(card.reps),
              flag: Value(card.flag),
            ),
          );
      count++;
    }
    return count;
  }

  CardQueue _mapQueue(ImportedCardQueue queue) => switch (queue) {
    ImportedCardQueue.newCard => CardQueue.newCard,
    ImportedCardQueue.suspended => CardQueue.suspended,
    ImportedCardQueue.buried => CardQueue.buried,
  };
}

@riverpod
ApkgImportRepository apkgImportRepository(Ref ref) {
  return ApkgImportRepository(ref.watch(appDatabaseProvider), MediaStorage());
}

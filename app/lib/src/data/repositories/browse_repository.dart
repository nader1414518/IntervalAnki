import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../local/tables.dart';
import 'card_repository.dart' show currentDayNumber;

part 'browse_repository.g.dart';

final _htmlTag = RegExp('<[^>]*>');

/// A sort key for the browse table (PRD §4.6).
enum BrowseSortKey { due, deck, noteType, flag }

/// One row in the card browser: a card, joined with everything the table
/// and search need to display/filter on.
class BrowseCardRow {
  const BrowseCardRow({
    required this.card,
    required this.deckName,
    required this.noteTypeName,
    required this.preview,
    required this.tags,
  });

  final StudyCard card;
  final String deckName;
  final String noteTypeName;
  final String preview;
  final String tags;
}

/// Read/write access for the card browser (PRD §4.6): search, sort, and
/// bulk actions.
///
/// Search filtering runs in Dart over an eagerly-joined row set rather than
/// compiling to SQL — simple and correct for the note-taking-app scale this
/// targets today, but the PRD's 50k-card NFR would need this pushed back
/// into indexed SQL (or an FTS table) before it holds up at that scale.
class BrowseRepository {
  BrowseRepository(this._db);

  final AppDatabase _db;

  Future<List<BrowseCardRow>> _allRows() async {
    final cards = await _db.select(_db.cards).get();
    final decks = {for (final d in await _db.select(_db.decks).get()) d.id: d};
    final notes = {for (final n in await _db.select(_db.notes).get()) n.id: n};
    final noteTypes = {
      for (final t in await _db.select(_db.noteTypes).get()) t.id: t,
    };

    return [
      for (final card in cards)
        if (notes[card.noteId] case final note?)
          BrowseCardRow(
            card: card,
            deckName: decks[card.deckId]?.name ?? '',
            noteTypeName: noteTypes[note.noteTypeId]?.name ?? '',
            preview: _preview(note.fieldValues),
            tags: note.tags,
          ),
    ];
  }

  String _preview(String fieldValuesJson) {
    final values = (jsonDecode(fieldValuesJson) as List).cast<String>();
    final first = values.isEmpty ? '' : values.first;
    return first.replaceAll(_htmlTag, '').trim();
  }

  /// Returns cards matching [query] (Anki-style `deck:`/`tag:`/`is:`/`flag:`
  /// terms, AND-combined, `-` negates a term; anything else matches
  /// front-field text or tags), sorted by [sortKey].
  Future<List<BrowseCardRow>> search(
    String query, {
    BrowseSortKey sortKey = BrowseSortKey.due,
  }) async {
    final rows = await _allRows();
    final terms = query.trim().split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
    final matching =
        rows.where((row) {
          for (final term in terms) {
            final negate = term.startsWith('-');
            final body = negate ? term.substring(1) : term;
            final matched = _matchesTerm(row, body);
            if (matched == negate) return false;
          }
          return true;
        }).toList()..sort((a, b) {
          switch (sortKey) {
            case BrowseSortKey.due:
              return a.card.due.compareTo(b.card.due);
            case BrowseSortKey.deck:
              return a.deckName.compareTo(b.deckName);
            case BrowseSortKey.noteType:
              return a.noteTypeName.compareTo(b.noteTypeName);
            case BrowseSortKey.flag:
              return b.card.flag.compareTo(a.card.flag);
          }
        });
    return matching;
  }

  bool _matchesTerm(BrowseCardRow row, String term) {
    if (term.startsWith('deck:')) {
      final name = term.substring('deck:'.length);
      return row.deckName == name || row.deckName.startsWith('$name::');
    }
    if (term.startsWith('tag:')) {
      final name = term.substring('tag:'.length);
      return row.tags.contains(' $name ');
    }
    if (term.startsWith('flag:')) {
      final n = int.tryParse(term.substring('flag:'.length));
      return n != null && row.card.flag == n;
    }
    if (term == 'is:new') return row.card.queue == CardQueue.newCard;
    if (term == 'is:suspended') return row.card.queue == CardQueue.suspended;
    if (term == 'is:buried') return row.card.queue == CardQueue.buried;
    if (term == 'is:due') {
      final today = currentDayNumber();
      return row.card.queue == CardQueue.newCard ||
          ((row.card.queue == CardQueue.review ||
                  row.card.queue == CardQueue.relearning) &&
              row.card.due <= today);
    }
    final needle = term.toLowerCase();
    return row.preview.toLowerCase().contains(needle) ||
        row.tags.toLowerCase().contains(needle);
  }

  /// Applies [queue] to every card in [cardIds].
  Future<void> bulkSetQueue(Iterable<int> cardIds, CardQueue queue) async {
    await (_db.update(_db.cards)..where((c) => c.id.isIn(cardIds))).write(
      CardsCompanion(queue: Value(queue)),
    );
  }

  /// Moves every card in [cardIds] to [deckId].
  Future<void> bulkMoveDeck(Iterable<int> cardIds, int deckId) async {
    await (_db.update(_db.cards)..where((c) => c.id.isIn(cardIds))).write(
      CardsCompanion(deckId: Value(deckId)),
    );
  }

  /// Deletes every card in [cardIds] (and any note left with no cards).
  Future<void> bulkDelete(Iterable<int> cardIds) async {
    final ids = cardIds.toList();
    final noteIds =
        await (_db.selectOnly(_db.cards)
              ..addColumns([_db.cards.noteId])
              ..where(_db.cards.id.isIn(ids)))
            .map((row) => row.read(_db.cards.noteId)!)
            .get();

    await _db.transaction(() async {
      await (_db.delete(_db.cards)..where((c) => c.id.isIn(ids))).go();
      for (final noteId in noteIds.toSet()) {
        final remaining =
            await (_db.selectOnly(_db.cards)
                  ..addColumns([_db.cards.id.count()])
                  ..where(_db.cards.noteId.equals(noteId)))
                .map((row) => row.read(_db.cards.id.count()) ?? 0)
                .getSingle();
        if (remaining == 0) {
          await (_db.delete(_db.notes)..where((n) => n.id.equals(noteId))).go();
        }
      }
    });
  }
}

@riverpod
BrowseRepository browseRepository(Ref ref) {
  return BrowseRepository(ref.watch(appDatabaseProvider));
}

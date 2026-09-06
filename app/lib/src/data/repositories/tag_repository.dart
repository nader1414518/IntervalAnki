import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';

part 'tag_repository.g.dart';

/// Read/write access to tags (PRD §4.6): hierarchical tags (`Parent::Child`)
/// live as plain strings, same as deck names, so listing/renaming just
/// means scanning and rewriting each note's space-separated tag string.
class TagRepository {
  TagRepository(this._db);

  final AppDatabase _db;

  /// All distinct tags currently in use, alphabetically.
  Future<List<String>> listTags() async {
    final notes = await _db.select(_db.notes).get();
    final tags = <String>{};
    for (final note in notes) {
      tags.addAll(
        note.tags.trim().split(RegExp(r'\s+')).where((t) => t.isNotEmpty),
      );
    }
    final sorted = tags.toList()..sort();
    return sorted;
  }

  /// Renames every occurrence of [oldName] to [newName] across all notes —
  /// effectively a merge if [newName] already exists on some notes.
  Future<void> rename(String oldName, String newName) async {
    final notes = await _db.select(_db.notes).get();
    await _db.transaction(() async {
      for (final note in notes) {
        final tags = note.tags.trim().split(RegExp(r'\s+'));
        if (!tags.contains(oldName)) continue;
        final updated = {for (final t in tags) t == oldName ? newName : t}
            .where((t) => t.isNotEmpty)
            .toList();
        await (_db.update(_db.notes)..where((n) => n.id.equals(note.id))).write(
          NotesCompanion(tags: Value(' ${updated.join(' ')} ')),
        );
      }
    });
  }
}

@riverpod
TagRepository tagRepository(Ref ref) {
  return TagRepository(ref.watch(appDatabaseProvider));
}

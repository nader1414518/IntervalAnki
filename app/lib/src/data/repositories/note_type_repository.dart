import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';

part 'note_type_repository.g.dart';

/// Thrown when a note type can't be deleted because notes still use it.
class NoteTypeInUseException implements Exception {
  const NoteTypeInUseException(this.noteTypeName);

  final String noteTypeName;

  @override
  String toString() => 'Note type "$noteTypeName" is still used by notes.';
}

/// A front/back/css template, before it has an id (used when creating or
/// replacing a note type's templates).
class TemplateDraft {
  const TemplateDraft({
    required this.name,
    required this.front,
    required this.back,
    this.css = '',
  });

  final String name;
  final String front;
  final String back;
  final String css;
}

/// A note type together with its fields and templates, as edited by the
/// note-type builder (PRD §4.2).
class NoteTypeDetail {
  const NoteTypeDetail({
    required this.noteType,
    required this.fields,
    required this.templates,
  });

  final NoteType noteType;
  final List<NoteField> fields;
  final List<CardTemplate> templates;
}

/// Read/write access to note types, fields, and templates.
class NoteTypeRepository {
  NoteTypeRepository(this._db);

  final AppDatabase _db;

  /// Emits the current note type list whenever it changes.
  Stream<List<NoteType>> watchAll() {
    return (_db.select(
      _db.noteTypes,
    )..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();
  }

  /// Loads note type [id] with its fields and templates. A one-shot fetch
  /// (not a stream) since the builder screen edits a local draft and only
  /// needs the starting state.
  Future<NoteTypeDetail> loadDetail(int id) async {
    final noteType = await (_db.select(
      _db.noteTypes,
    )..where((t) => t.id.equals(id))).getSingle();
    final fields =
        await (_db.select(_db.fields)
              ..where((f) => f.noteTypeId.equals(id))
              ..orderBy([(f) => OrderingTerm(expression: f.ord)]))
            .get();
    final templates =
        await (_db.select(_db.templates)
              ..where((t) => t.noteTypeId.equals(id))
              ..orderBy([(t) => OrderingTerm(expression: t.ord)]))
            .get();
    return NoteTypeDetail(
      noteType: noteType,
      fields: fields,
      templates: templates,
    );
  }

  /// Creates a note type named [name] with [fieldNames] and [templates].
  Future<int> create(
    String name,
    List<String> fieldNames,
    List<TemplateDraft> templates,
  ) {
    return _db.transaction(() async {
      final noteTypeId = await _db
          .into(_db.noteTypes)
          .insert(NoteTypesCompanion.insert(name: name));
      await _writeFieldsAndTemplates(noteTypeId, fieldNames, templates);
      return noteTypeId;
    });
  }

  /// Renames note type [id] and replaces its fields/templates with
  /// [fieldNames]/[templates].
  ///
  /// This replaces (rather than diffs) the field/template rows, which is
  /// simple and correct for a note type with no notes yet; editing a note
  /// type that already has notes can shift which field/template ord a note's
  /// stored values line up with if fields are reordered or removed.
  Future<void> update(
    int id,
    String name,
    List<String> fieldNames,
    List<TemplateDraft> templates,
  ) {
    return _db.transaction(() async {
      await (_db.update(_db.noteTypes)..where((t) => t.id.equals(id))).write(
        NoteTypesCompanion(name: Value(name)),
      );
      await (_db.delete(
        _db.fields,
      )..where((f) => f.noteTypeId.equals(id))).go();
      await (_db.delete(
        _db.templates,
      )..where((t) => t.noteTypeId.equals(id))).go();
      await _writeFieldsAndTemplates(id, fieldNames, templates);
    });
  }

  /// Deletes note type [id]. Throws [NoteTypeInUseException] if any notes
  /// still use it.
  Future<void> delete(int id) async {
    final noteType = await (_db.select(
      _db.noteTypes,
    )..where((t) => t.id.equals(id))).getSingle();
    final noteCount =
        await (_db.selectOnly(_db.notes)
              ..addColumns([_db.notes.id.count()])
              ..where(_db.notes.noteTypeId.equals(id)))
            .map((row) => row.read(_db.notes.id.count()) ?? 0)
            .getSingle();
    if (noteCount > 0) {
      throw NoteTypeInUseException(noteType.name);
    }
    await _db.transaction(() async {
      await (_db.delete(
        _db.fields,
      )..where((f) => f.noteTypeId.equals(id))).go();
      await (_db.delete(
        _db.templates,
      )..where((t) => t.noteTypeId.equals(id))).go();
      await (_db.delete(_db.noteTypes)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> _writeFieldsAndTemplates(
    int noteTypeId,
    List<String> fieldNames,
    List<TemplateDraft> templates,
  ) async {
    for (var ord = 0; ord < fieldNames.length; ord++) {
      await _db
          .into(_db.fields)
          .insert(
            FieldsCompanion.insert(
              noteTypeId: noteTypeId,
              name: fieldNames[ord],
              ord: ord,
            ),
          );
    }
    for (var ord = 0; ord < templates.length; ord++) {
      final template = templates[ord];
      await _db
          .into(_db.templates)
          .insert(
            TemplatesCompanion.insert(
              noteTypeId: noteTypeId,
              name: template.name,
              front: template.front,
              back: template.back,
              css: Value(template.css),
              ord: ord,
            ),
          );
    }
  }
}

@riverpod
NoteTypeRepository noteTypeRepository(Ref ref) {
  return NoteTypeRepository(ref.watch(appDatabaseProvider));
}

/// Hand-written, not `@riverpod` — see the note on `deckListProvider` in
/// `deck_repository.dart`.
final StreamProvider<List<NoteType>> noteTypeListProvider =
    StreamProvider.autoDispose<List<NoteType>>((ref) {
      return ref.watch(noteTypeRepositoryProvider).watchAll();
    });

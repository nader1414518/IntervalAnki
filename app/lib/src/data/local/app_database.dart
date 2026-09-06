import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    DeckOptions,
    Decks,
    NoteTypes,
    Fields,
    Templates,
    Notes,
    Cards,
    ReviewLog,
    Media,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'interval'));

  /// For tests: pass an in-memory or otherwise isolated [QueryExecutor]
  /// instead of opening the app's real on-disk database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _seedDefaults(this);
      await into(settings).insert(const SettingsCompanion());
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(settings);
        await into(settings).insert(const SettingsCompanion());
      }
      if (from < 3) {
        await migrator.addColumn(cards, cards.deletedAt);
      }
    },
  );
}

/// The shared CSS every built-in note type's cards render with.
const _defaultCardCss = '''
.card {
  font-family: arial;
  font-size: 20px;
  text-align: center;
  color: black;
  background-color: white;
}
''';

/// Inserts the data every profile starts with on first run: a default deck
/// options preset, the "Welcome" deck (PRD §5.1's onboarding builds on this
/// in M8), and Anki's built-in note types (PRD §4.2) so the add-card screen
/// (M4) has something to create cards with immediately.
Future<void> _seedDefaults(AppDatabase db) async {
  final defaultOptionsId = await db
      .into(db.deckOptions)
      .insert(const DeckOptionsCompanion(name: Value('Default')));

  await db
      .into(db.decks)
      .insert(
        DecksCompanion.insert(name: 'Welcome', deckOptionsId: defaultOptionsId),
      );

  await _seedBasicNoteType(db);
  await _seedBasicReversedNoteType(db);
  await _seedBasicTypeInAnswerNoteType(db);
  await _seedClozeNoteType(db);
}

Future<int> _insertNoteType(AppDatabase db, String name) {
  return db.into(db.noteTypes).insert(NoteTypesCompanion.insert(name: name));
}

Future<void> _insertFields(
  AppDatabase db,
  int noteTypeId,
  List<String> names,
) async {
  for (var ord = 0; ord < names.length; ord++) {
    await db
        .into(db.fields)
        .insert(
          FieldsCompanion.insert(
            noteTypeId: noteTypeId,
            name: names[ord],
            ord: ord,
          ),
        );
  }
}

Future<void> _seedBasicNoteType(AppDatabase db) async {
  final noteTypeId = await _insertNoteType(db, 'Basic');
  await _insertFields(db, noteTypeId, ['Front', 'Back']);
  await db
      .into(db.templates)
      .insert(
        TemplatesCompanion.insert(
          noteTypeId: noteTypeId,
          name: 'Card 1',
          front: '{{Front}}',
          back: '{{FrontSide}}\n\n<hr id=answer>\n\n{{Back}}',
          ord: 0,
          css: const Value(_defaultCardCss),
        ),
      );
}

Future<void> _seedBasicReversedNoteType(AppDatabase db) async {
  final noteTypeId = await _insertNoteType(db, 'Basic (and reversed card)');
  await _insertFields(db, noteTypeId, ['Front', 'Back']);
  await db
      .into(db.templates)
      .insert(
        TemplatesCompanion.insert(
          noteTypeId: noteTypeId,
          name: 'Card 1',
          front: '{{Front}}',
          back: '{{FrontSide}}\n\n<hr id=answer>\n\n{{Back}}',
          ord: 0,
          css: const Value(_defaultCardCss),
        ),
      );
  await db
      .into(db.templates)
      .insert(
        TemplatesCompanion.insert(
          noteTypeId: noteTypeId,
          name: 'Card 2',
          front: '{{Back}}',
          back: '{{FrontSide}}\n\n<hr id=answer>\n\n{{Front}}',
          ord: 1,
          css: const Value(_defaultCardCss),
        ),
      );
}

Future<void> _seedBasicTypeInAnswerNoteType(AppDatabase db) async {
  final noteTypeId = await _insertNoteType(db, 'Basic (type-in-answer)');
  await _insertFields(db, noteTypeId, ['Front', 'Back']);
  await db
      .into(db.templates)
      .insert(
        TemplatesCompanion.insert(
          noteTypeId: noteTypeId,
          name: 'Card 1',
          front: '{{Front}}\n\n{{type:Back}}',
          back: '{{FrontSide}}\n\n<hr id=answer>\n\n{{type:Back}}',
          ord: 0,
          css: const Value(_defaultCardCss),
        ),
      );
}

Future<void> _seedClozeNoteType(AppDatabase db) async {
  final noteTypeId = await _insertNoteType(db, 'Cloze');
  await _insertFields(db, noteTypeId, ['Text', 'Back Extra']);
  await db
      .into(db.templates)
      .insert(
        TemplatesCompanion.insert(
          noteTypeId: noteTypeId,
          name: 'Cloze',
          front: '{{cloze:Text}}',
          back: '{{cloze:Text}}\n\n<br>\n{{Back Extra}}',
          ord: 0,
          css: const Value(_defaultCardCss),
        ),
      );
}

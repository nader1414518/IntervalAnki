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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'interval'));

  /// For tests: pass an in-memory or otherwise isolated [QueryExecutor]
  /// instead of opening the app's real on-disk database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _seedDefaults(this);
    },
  );
}

/// Inserts the one deck every profile starts with, so the app never shows an
/// empty deck list on first run (PRD §5.1's onboarding still builds on this
/// in M8, but the deck itself needs to exist from the first migration).
Future<void> _seedDefaults(AppDatabase db) async {
  final defaultOptionsId = await db
      .into(db.deckOptions)
      .insert(const DeckOptionsCompanion(name: Value('Default')));

  await db
      .into(db.decks)
      .insert(
        DecksCompanion.insert(name: 'Welcome', deckOptionsId: defaultOptionsId),
      );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';

part 'settings_repository.g.dart';

/// Read/write access to the app's single [AppSettings] row (PRD §4.11).
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  /// Emits the settings row whenever it changes. A row is guaranteed to
  /// exist by the time the app starts — seeded on database creation and on
  /// upgrade from schema version 1 (see [AppDatabase.migration]).
  Stream<AppSettings> watch() => _db.select(_db.settings).watchSingle();

  /// Applies a partial update, built from the current settings.
  Future<void> update(
    SettingsCompanion Function(AppSettings current) build,
  ) async {
    final current = await _db.select(_db.settings).getSingle();
    await (_db.update(
      _db.settings,
    )..where((s) => s.id.equals(current.id))).write(build(current));
  }
}

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider));
}

/// Hand-written, not `@riverpod` — see the note on `deckListProvider` in
/// `deck_repository.dart`: riverpod_generator can't code-generate a provider
/// returning a Drift-generated data class.
final settingsProvider = StreamProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

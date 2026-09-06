import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';
import 'database_provider.dart';

part 'backup_service.g.dart';

/// Copies the on-disk database (PRD §4.11's "backup management") — either
/// automatically to a rotating local folder, or manually to wherever the
/// user picks via the OS save dialog.
///
/// `drift_flutter`'s `driftDatabase()` (used by [AppDatabase]) names the
/// file `interval.sqlite` in the app's documents directory; this mirrors
/// that path rather than asking [AppDatabase] for it, since Drift doesn't
/// expose the underlying file path directly.
class BackupService {
  const BackupService();

  Future<File> _databaseFile() async {
    final docs = await getApplicationDocumentsDirectory();
    return File(p.join(docs.path, 'interval.sqlite'));
  }

  Future<Directory> _backupDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'backups'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Copies the database into the local backup folder, keeping only the
  /// [keep] most recent copies. A no-op if the database file doesn't exist
  /// yet (e.g. the very first launch, before any writes have flushed).
  Future<void> runAutoBackup({int keep = 5}) async {
    final dbFile = await _databaseFile();
    if (!await dbFile.exists()) return;

    final dir = await _backupDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(
      RegExp('[:.]'),
      '-',
    );
    await dbFile.copy(p.join(dir.path, 'interval-$timestamp.sqlite'));

    final backups =
        dir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.sqlite'))
            .toList()
          ..sort((a, b) => b.path.compareTo(a.path));
    for (final stale in backups.skip(keep)) {
      await stale.delete();
    }
  }

  /// Lets the user save a copy of the database wherever they choose.
  /// Returns `false` if there's nothing to export yet or they cancel.
  Future<bool> exportManually() async {
    final dbFile = await _databaseFile();
    if (!await dbFile.exists()) return false;

    final bytes = await dbFile.readAsBytes();
    final datestamp = DateTime.now().toIso8601String().split('T').first;
    final uri = await FilePicker.saveFile(
      fileName: 'interval-backup-$datestamp.sqlite',
      bytes: bytes,
    );
    return uri != null;
  }
}

@riverpod
BackupService backupService(Ref ref) => const BackupService();

/// Runs the automatic local backup once per app launch, if enabled — a
/// one-shot [Future] (not a stream) so it fires exactly once regardless of
/// how many widgets watch it.
@Riverpod(keepAlive: true)
Future<void> autoBackupOnStartup(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final settings = await db.select(db.settings).getSingle();
  if (settings.autoBackupEnabled) {
    await ref.watch(backupServiceProvider).runAutoBackup();
  }
}

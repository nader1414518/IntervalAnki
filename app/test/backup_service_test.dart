import 'dart:io';
import 'dart:typed_data';

import 'package:app/src/data/local/backup_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

/// Fakes the documents-directory lookup [BackupService] needs, since plain
/// `test()` (unlike `testWidgets()`) has no platform channel to answer it.
class _FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProviderPlatform(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

/// A minimal but real SQLite database's bytes, so [BackupService]'s
/// `looksLikeDatabase` is exercised against the actual on-disk format
/// rather than a hand-rolled stand-in header.
Uint8List _realSqliteBytes(Directory tempDir) {
  final dbPath = p.join(tempDir.path, 'fixture.sqlite');
  sqlite3.sqlite3.open(dbPath)
    ..execute('CREATE TABLE t (id INTEGER)')
    ..close();
  return File(dbPath).readAsBytesSync();
}

void main() {
  group('looksLikeDatabase', () {
    test('accepts real SQLite file bytes', () async {
      final tempDir = await Directory.systemTemp.createTemp('backup_test');
      addTearDown(() => tempDir.delete(recursive: true));

      final bytes = _realSqliteBytes(tempDir);
      expect(const BackupService().looksLikeDatabase(bytes), isTrue);
    });

    test('rejects arbitrary bytes', () {
      final bytes = Uint8List.fromList('not a database'.codeUnits);
      expect(const BackupService().looksLikeDatabase(bytes), isFalse);
    });

    test('rejects a file shorter than the SQLite header', () {
      final bytes = Uint8List.fromList('short'.codeUnits);
      expect(const BackupService().looksLikeDatabase(bytes), isFalse);
    });
  });

  group('restoreFromBytes', () {
    test('writes the bytes to the app database path', () async {
      final tempDir = await Directory.systemTemp.createTemp('backup_test');
      addTearDown(() => tempDir.delete(recursive: true));
      PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);

      final bytes = _realSqliteBytes(tempDir);
      await const BackupService().restoreFromBytes(bytes);

      final restored = File(p.join(tempDir.path, 'interval.sqlite'));
      expect(await restored.exists(), isTrue);
      expect(await restored.readAsBytes(), equals(bytes));
    });

    test(
      'clears stale WAL/SHM sidecars from the previous connection',
      () async {
        final tempDir = await Directory.systemTemp.createTemp('backup_test');
        addTearDown(() => tempDir.delete(recursive: true));
        PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);

        final dbPath = p.join(tempDir.path, 'interval.sqlite');
        final walFile = File('$dbPath-wal')..writeAsBytesSync([1, 2, 3]);
        final shmFile = File('$dbPath-shm')..writeAsBytesSync([4, 5, 6]);

        await const BackupService().restoreFromBytes(_realSqliteBytes(tempDir));

        expect(await walFile.exists(), isFalse);
        expect(await shmFile.exists(), isFalse);
      },
    );
  });
}

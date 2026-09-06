import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../local/media_storage.dart';

part 'media_repository.g.dart';

/// Stores media files and tracks them in the `Media` table for dedup/GC
/// (PRD §6).
class MediaRepository {
  MediaRepository(this._db, this._storage);

  final AppDatabase _db;
  final MediaStorage _storage;

  /// Copies [sourcePath] into media storage, registers/increments its
  /// reference count, and returns the stored filename.
  Future<String> add(String sourcePath) async {
    final filename = await _storage.store(sourcePath);
    final hash = p.basenameWithoutExtension(filename);
    final existing = await (_db.select(
      _db.media,
    )..where((m) => m.hash.equals(hash))).getSingleOrNull();
    if (existing == null) {
      await _db
          .into(_db.media)
          .insert(MediaCompanion.insert(hash: hash, filename: filename));
    } else {
      await (_db.update(_db.media)..where((m) => m.hash.equals(hash))).write(
        MediaCompanion(refCount: Value(existing.refCount + 1)),
      );
    }
    return filename;
  }

  /// The directory stored media files live in.
  Future<String> directoryPath() => _storage.directoryPath();
}

@riverpod
MediaRepository mediaRepository(Ref ref) {
  return MediaRepository(ref.watch(appDatabaseProvider), MediaStorage());
}

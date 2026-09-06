import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Copies media files into the app's local storage, deduped by content hash
/// (PRD §6's "media storage... referenced by hash" architecture note).
class MediaStorage {
  Future<Directory> _mediaDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'media'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Copies [sourcePath] into media storage and returns the stored filename
  /// (its content hash plus original extension) to reference from a field's
  /// HTML, e.g. `<img src="$filename">`.
  Future<String> store(String sourcePath) async {
    final bytes = await File(sourcePath).readAsBytes();
    final hash = sha1.convert(bytes).toString();
    final filename = '$hash${p.extension(sourcePath)}';
    final destination = File(p.join((await _mediaDir()).path, filename));
    if (!await destination.exists()) {
      await destination.writeAsBytes(bytes);
    }
    return filename;
  }

  /// Writes [bytes] under [filename] as-is (no hash rename/dedup) — used
  /// only by `.apkg` import, since imported field HTML already references
  /// media by its original filename and rewriting every reference to a
  /// hash-based name isn't worth the complexity for this pass.
  Future<void> storeWithOriginalFilename(
    String filename,
    List<int> bytes,
  ) async {
    final destination = File(p.join((await _mediaDir()).path, filename));
    await destination.writeAsBytes(bytes);
  }

  /// The directory stored media files live in, e.g. to resolve an `<img
  /// src="...">` path when rendering a card.
  Future<String> directoryPath() async => (await _mediaDir()).path;
}

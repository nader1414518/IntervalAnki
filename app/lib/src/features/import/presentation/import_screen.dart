import 'dart:async';

import 'package:anki_format/anki_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/apkg_import_repository.dart';

/// Import a `.apkg` export (PRD §4.8): pick a file, parse it, insert it,
/// and show a fidelity report (counts imported).
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  static const routeName = 'import';

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  bool _importing = false;
  ApkgImportSummary? _summary;
  String? _error;

  Future<void> _pickAndImport() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['apkg'],
    );
    final path = picked?.path;
    if (path == null) return;

    setState(() {
      _importing = true;
      _error = null;
      _summary = null;
    });
    try {
      final parsed = await const ApkgImporter().parseFile(path);
      final summary = await ref
          .read(apkgImportRepositoryProvider)
          .import(parsed);
      if (!mounted) return;
      setState(() => _summary = summary);
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import .apkg')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Import notes, cards, and media from an Anki .apkg export. '
            'Imported cards start fresh as new cards — their prior Anki '
            "scheduling history isn't carried over.",
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _importing ? null : () => unawaited(_pickAndImport()),
            icon: const Icon(Icons.file_upload_outlined),
            label: Text(_importing ? 'Importing…' : 'Choose .apkg file'),
          ),
          if (_importing) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_error case final error?) ...[
            const SizedBox(height: 24),
            Text(
              'Import failed: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (_summary case final summary?) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Import complete',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('${summary.deckCount} decks'),
                    Text('${summary.noteTypeCount} note types'),
                    Text('${summary.noteCount} notes'),
                    Text('${summary.cardCount} cards'),
                    Text('${summary.mediaCount} media files'),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

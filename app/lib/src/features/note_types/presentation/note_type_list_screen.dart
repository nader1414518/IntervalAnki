import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/app_database.dart';
import '../../../data/repositories/note_type_repository.dart';

/// Manage note types (PRD §4.2): built-in ones seeded on first run, plus any
/// custom ones the user builds.
class NoteTypeListScreen extends ConsumerWidget {
  const NoteTypeListScreen({super.key});

  static const routeName = 'note-types';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteTypes = ref.watch(noteTypeListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Note types')),
      body: noteTypes.when(
        data: (noteTypes) => ListView.builder(
          itemCount: noteTypes.length,
          itemBuilder: (context, index) {
            final noteType = noteTypes[index];
            return ListTile(
              title: Text(noteType.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _delete(context, ref, noteType),
              ),
              onTap: () => context.push('/note-types/${noteType.id}/edit'),
            );
          },
        ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/note-types/new'),
        tooltip: 'New note type',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    NoteType noteType,
  ) async {
    try {
      await ref.read(noteTypeRepositoryProvider).delete(noteType.id);
    } on NoteTypeInUseException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/tag_repository.dart';

/// Manage tags (PRD §4.6): rename (or merge, by renaming to an existing
/// tag) across every note that uses them.
class TagListScreen extends ConsumerStatefulWidget {
  const TagListScreen({super.key});

  static const routeName = 'tags';

  @override
  ConsumerState<TagListScreen> createState() => _TagListScreenState();
}

class _TagListScreenState extends ConsumerState<TagListScreen> {
  List<String> _tags = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final tags = await ref.read(tagRepositoryProvider).listTags();
    if (!mounted) return;
    setState(() {
      _tags = tags;
      _loading = false;
    });
  }

  Future<void> _rename(String tag) async {
    final controller = TextEditingController(text: tag);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename tag'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newName == null || newName.isEmpty || newName == tag) return;
    await ref.read(tagRepositoryProvider).rename(tag, newName);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tags.isEmpty
          ? const Center(child: Text('No tags yet.'))
          : ListView.builder(
              itemCount: _tags.length,
              itemBuilder: (context, index) {
                final tag = _tags[index];
                return ListTile(
                  leading: const Icon(Icons.sell_outlined),
                  title: Text(tag),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Rename or merge',
                    onPressed: () => unawaited(_rename(tag)),
                  ),
                );
              },
            ),
    );
  }
}

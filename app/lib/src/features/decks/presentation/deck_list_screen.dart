import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/app_database.dart';
import '../../../data/repositories/deck_repository.dart';
import 'deck_name_sheet.dart';

/// The deck-list home screen (PRD §5.5 — a card-style tree in later
/// milestones; a plain indented list for now).
class DeckListScreen extends ConsumerWidget {
  const DeckListScreen({super.key});

  static const routeName = 'decks';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interval'),
        actions: [
          IconButton(
            icon: const Icon(Icons.style_outlined),
            tooltip: 'Note types',
            onPressed: () => context.push('/note-types'),
          ),
        ],
      ),
      body: decks.when(
        data: (decks) => decks.isEmpty
            ? const Center(child: Text('Your decks will show up here.'))
            : ListView.builder(
                itemCount: decks.length,
                itemBuilder: (context, index) => _DeckTile(deck: decks[index]),
              ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createDeck(context, ref),
        tooltip: 'Add deck',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _createDeck(BuildContext context, WidgetRef ref) async {
    final name = await showDeckNameSheet(context, title: 'New deck');
    if (name == null || name.isEmpty) return;
    await ref.read(deckRepositoryProvider).create(name);
  }
}

class _DeckTile extends ConsumerWidget {
  const _DeckTile({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final segments = deck.name.split('::');
    final depth = segments.length - 1;
    final label = segments.last;

    return ListTile(
      contentPadding: EdgeInsets.only(left: 16.0 + depth * 20, right: 8),
      leading: const Icon(Icons.style_outlined),
      title: Text(label),
      trailing: PopupMenuButton<_DeckAction>(
        onSelected: (action) => _handleAction(context, ref, action),
        itemBuilder: (context) => const [
          PopupMenuItem(value: _DeckAction.rename, child: Text('Rename')),
          PopupMenuItem(value: _DeckAction.options, child: Text('Options')),
          PopupMenuItem(value: _DeckAction.delete, child: Text('Delete')),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    _DeckAction action,
  ) async {
    switch (action) {
      case _DeckAction.rename:
        final newName = await showDeckNameSheet(
          context,
          title: 'Rename deck',
          initialName: deck.name,
        );
        if (newName == null || newName.isEmpty) return;
        await ref.read(deckRepositoryProvider).rename(deck.id, newName);
      case _DeckAction.options:
        if (context.mounted) {
          unawaited(context.push('/deck-options/${deck.deckOptionsId}'));
        }
      case _DeckAction.delete:
        await _delete(context, ref);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete deck?'),
        content: Text('Delete "${deck.name}"? This can\'t be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(deckRepositoryProvider).delete(deck.id);
    } on DeckNotEmptyException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}

enum _DeckAction { rename, options, delete }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/confirm_dialog.dart';
import '../../../data/local/app_database.dart';
import '../../../data/repositories/deck_repository.dart';
import '../../../data/repositories/streak_repository.dart';
import 'deck_name_sheet.dart';

/// The deck-list home screen (PRD §5.5 — a card-style tree in later
/// milestones; a plain indented list for now).
class DeckListScreen extends ConsumerWidget {
  const DeckListScreen({super.key});

  static const routeName = 'decks';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckListProvider);
    final streak = ref.watch(streakProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interval'),
        actions: [
          if (streak != null && streak.currentStreak > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Center(child: _StreakBadge(days: streak.currentStreak)),
            ),
          IconButton(
            icon: const Icon(Icons.add_card_outlined),
            tooltip: 'Add cards',
            onPressed: () => unawaited(context.push('/add-note')),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Browse',
            onPressed: () => unawaited(context.push('/browse')),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => unawaited(context.push('/settings')),
          ),
          PopupMenuButton<String>(
            onSelected: (route) => unawaited(context.push(route)),
            itemBuilder: (context) => const [
              PopupMenuItem(value: '/note-types', child: Text('Note types')),
              PopupMenuItem(value: '/tags', child: Text('Tags')),
              PopupMenuItem(value: '/trash', child: Text('Trash')),
              PopupMenuItem(value: '/stats', child: Text('Statistics')),
              PopupMenuItem(value: '/import', child: Text('Import .apkg')),
            ],
          ),
        ],
      ),
      body: decks.when(
        data: (decks) => decks.isEmpty
            ? const _EmptyDeckList()
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                itemCount: decks.length,
                itemBuilder: (context, index) => _AnimatedEntry(
                  index: index,
                  child: _DeckTile(deck: decks[index]),
                ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(left: depth * 16.0, bottom: 8),
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => unawaited(context.push('/review/${deck.id}')),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.style_outlined,
                    size: 20,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<_DeckAction>(
                  onSelected: (action) => _handleAction(context, ref, action),
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _DeckAction.browse,
                      child: Text('Browse cards'),
                    ),
                    PopupMenuItem(
                      value: _DeckAction.rename,
                      child: Text('Rename'),
                    ),
                    PopupMenuItem(
                      value: _DeckAction.options,
                      child: Text('Options'),
                    ),
                    PopupMenuItem(
                      value: _DeckAction.delete,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    _DeckAction action,
  ) async {
    switch (action) {
      case _DeckAction.browse:
        unawaited(context.push('/browse?deckId=${deck.id}'));
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
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete deck?',
      message: 'Delete "${deck.name}"? This can\'t be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!confirmed) return;
    if (!context.mounted) return;

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

enum _DeckAction { browse, rename, options, delete }

class _EmptyDeckList extends StatelessWidget {
  const _EmptyDeckList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.style_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'Your decks will show up here.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

/// Fades and slides each list item in on first build, staggered a little
/// by [index] — a small bit of polish for what's otherwise an instant
/// population of the deck list.
class _AnimatedEntry extends StatefulWidget {
  const _AnimatedEntry({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_AnimatedEntry> createState() => _AnimatedEntryState();
}

class _AnimatedEntryState extends State<_AnimatedEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _fade = curved;
    _slide = Tween(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(curved);
  }

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    // Respect the reduce-motion setting (MediaQuery.disableAnimations is
    // wired to it app-wide, see IntervalApp) by skipping straight to the
    // end state instead of running the stagger.
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _controller.value = 1;
      return;
    }
    final delay = Duration(milliseconds: 25 * widget.index.clamp(0, 8));
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// A small "current streak" indicator (PRD §4.10) in the deck list's app
/// bar — only shown once there's a streak worth showing.
class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '$days-day streak',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '$days',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

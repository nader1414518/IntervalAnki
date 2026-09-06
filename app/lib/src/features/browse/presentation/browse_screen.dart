import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/confirm_dialog.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/tables.dart';
import '../../../data/repositories/browse_repository.dart';
import '../../../data/repositories/deck_repository.dart';

/// The card browser (PRD §4.6): search with Anki-style syntax, sort, and
/// bulk actions over the results. Passing [deckId] scopes it to one deck
/// (e.g. opened from that deck's menu) — edit/remove/add all still work
/// the same, just restricted to that deck's cards.
class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({this.deckId, super.key});

  static const routeName = 'browse';

  final int? deckId;

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  final _queryController = TextEditingController();
  BrowseSortKey _sortKey = BrowseSortKey.due;
  List<BrowseCardRow> _rows = [];
  final Set<int> _selected = {};
  bool _loading = true;
  Deck? _scopedDeck;

  static const List<Color> _flagColors = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.teal,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.deckId case final deckId?) {
      unawaited(
        ref.read(deckRepositoryProvider).get(deckId).then((deck) {
          if (mounted) setState(() => _scopedDeck = deck);
        }),
      );
    }
    unawaited(_search());
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() => _loading = true);
    final rows = await ref
        .read(browseRepositoryProvider)
        .search(
          _queryController.text,
          sortKey: _sortKey,
          deckId: widget.deckId,
        );
    if (!mounted) return;
    setState(() {
      _rows = rows;
      _loading = false;
      _selected.removeWhere((id) => rows.every((r) => r.card.id != id));
    });
  }

  /// Opens the unified add/edit screen (PRD §5.4) for [row]'s note, and
  /// refreshes the results afterward since its preview text may have
  /// changed.
  Future<void> _openEditor(BrowseCardRow row) async {
    final changed = await context.push<bool>(
      '/add-note?noteId=${row.card.noteId}',
    );
    if (changed == true) await _search();
  }

  /// Opens the add-cards screen, preselecting the scoped deck if any, and
  /// refreshes afterward — batch add mode may add any number of cards
  /// without ever popping a "changed" result, so this always refreshes
  /// rather than only on a signal.
  Future<void> _openAddCard() async {
    await context.push<bool>(
      widget.deckId == null ? '/add-note' : '/add-note?deckId=${widget.deckId}',
    );
    await _search();
  }

  Future<void> _bulkSetQueue(CardQueue queue) async {
    await ref.read(browseRepositoryProvider).bulkSetQueue(_selected, queue);
    _selected.clear();
    await _search();
  }

  Future<void> _bulkMoveToTrash() async {
    final count = _selected.length;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Move to trash?',
      message:
          '${count == 1 ? 'This card' : '$count cards'} will move to the '
          "trash. You can restore ${count == 1 ? 'it' : 'them'} from Trash "
          'later, or delete for good from there.',
      confirmLabel: 'Move to trash',
    );
    if (!confirmed) return;
    await ref.read(browseRepositoryProvider).bulkMoveToTrash(_selected);
    _selected.clear();
    await _search();
  }

  Future<void> _bulkMoveDeck() async {
    final decks = await ref.read(deckRepositoryProvider).watchAll().first;
    if (!mounted) return;
    final deckId = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Move to deck'),
        children: [
          for (final deck in decks)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(deck.id),
              child: Text(deck.name),
            ),
        ],
      ),
    );
    if (deckId == null) return;
    await ref.read(browseRepositoryProvider).bulkMoveDeck(_selected, deckId);
    _selected.clear();
    await _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => unawaited(_openAddCard()),
        tooltip: 'Add cards',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: TextField(
          controller: _queryController,
          decoration: const InputDecoration(
            hintText: 'deck:Verbs is:due tag:hard',
            border: InputBorder.none,
          ),
          onSubmitted: (_) => unawaited(_search()),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => unawaited(_search()),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Trash',
            onPressed: () => unawaited(context.push('/trash')),
          ),
          PopupMenuButton<BrowseSortKey>(
            icon: const Icon(Icons.sort),
            onSelected: (key) {
              setState(() => _sortKey = key);
              unawaited(_search());
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: BrowseSortKey.due, child: Text('Due')),
              PopupMenuItem(value: BrowseSortKey.deck, child: Text('Deck')),
              PopupMenuItem(
                value: BrowseSortKey.noteType,
                child: Text('Note type'),
              ),
              PopupMenuItem(value: BrowseSortKey.flag, child: Text('Flag')),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _ScopeBanner(deck: _scopedDeck),
                _SelectionBar(
                  count: _selected.length,
                  onMoveDeck: _bulkMoveDeck,
                  onSuspend: () => _bulkSetQueue(CardQueue.suspended),
                  onUnsuspend: () => _bulkSetQueue(CardQueue.newCard),
                  onTrash: _bulkMoveToTrash,
                ),
                Expanded(
                  child: _rows.isEmpty
                      ? const _EmptyState()
                      : ListView.builder(
                          itemCount: _rows.length,
                          itemBuilder: (context, index) {
                            final row = _rows[index];
                            final selected = _selected.contains(row.card.id);
                            void toggleSelected() => setState(() {
                              if (selected) {
                                _selected.remove(row.card.id);
                              } else {
                                _selected.add(row.card.id);
                              }
                            });
                            return _BrowseRow(
                              row: row,
                              selected: selected,
                              flagColor: row.card.flag == 0
                                  ? null
                                  : _flagColors[row.card.flag - 1],
                              onToggleSelected: toggleSelected,
                              // Tapping opens the editor normally, but while
                              // a bulk-action selection is in progress it
                              // extends the selection instead — otherwise a
                              // stray tap while multi-selecting would jump
                              // into the editor rather than adding the row.
                              onTap: _selected.isNotEmpty
                                  ? toggleSelected
                                  : () => unawaited(_openEditor(row)),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _ScopeBanner extends StatelessWidget {
  const _ScopeBanner({required this.deck});

  final Deck? deck;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: deck == null
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.style_outlined, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Showing: ${deck!.name}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SelectionBar extends StatelessWidget {
  const _SelectionBar({
    required this.count,
    required this.onMoveDeck,
    required this.onSuspend,
    required this.onUnsuspend,
    required this.onTrash,
  });

  final int count;
  final Future<void> Function() onMoveDeck;
  final Future<void> Function() onSuspend;
  final Future<void> Function() onUnsuspend;
  final Future<void> Function() onTrash;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: count == 0
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('$count selected'),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.drive_file_move_outline),
                    tooltip: 'Move to deck',
                    onPressed: () => unawaited(onMoveDeck()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause_circle_outline),
                    tooltip: 'Suspend',
                    onPressed: () => unawaited(onSuspend()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_circle_outline),
                    tooltip: 'Unsuspend (as new)',
                    onPressed: () => unawaited(onUnsuspend()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Move to trash',
                    onPressed: () => unawaited(onTrash()),
                  ),
                ],
              ),
            ),
    );
  }
}

class _BrowseRow extends StatelessWidget {
  const _BrowseRow({
    required this.row,
    required this.selected,
    required this.flagColor,
    required this.onToggleSelected,
    required this.onTap,
  });

  final BrowseCardRow row;
  final bool selected;
  final Color? flagColor;
  final VoidCallback onToggleSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Checkbox(value: selected, onChanged: (_) => onToggleSelected()),
      trailing: flagColor == null
          ? null
          : Icon(Icons.flag, color: flagColor, size: 18),
      title: Text(
        row.preview.isEmpty ? '(empty)' : row.preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${row.deckName} • ${row.noteTypeName} • ${row.card.queue.name}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No cards found.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

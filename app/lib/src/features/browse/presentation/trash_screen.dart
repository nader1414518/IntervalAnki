import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/confirm_dialog.dart';
import '../../../data/repositories/browse_repository.dart';

/// Cards moved out of the browser aren't gone for good: they land here,
/// where they can be restored or deleted permanently. Mirrors Anki's own
/// lack of a trash (Anki deletes immediately) as a deliberate improvement —
/// a destructive action deserves a second chance, not just a confirmation
/// dialog on the way in.
class TrashScreen extends ConsumerStatefulWidget {
  const TrashScreen({super.key});

  static const routeName = 'trash';

  @override
  ConsumerState<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends ConsumerState<TrashScreen> {
  List<BrowseCardRow> _rows = [];
  final Set<int> _selected = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await ref
        .read(browseRepositoryProvider)
        .search('', trashedOnly: true);
    if (!mounted) return;
    setState(() {
      _rows = rows;
      _loading = false;
      _selected.removeWhere((id) => rows.every((r) => r.card.id != id));
    });
  }

  Future<void> _restoreSelected() async {
    await ref.read(browseRepositoryProvider).bulkRestore(_selected);
    _selected.clear();
    await _load();
  }

  Future<void> _deleteSelectedForever() async {
    final count = _selected.length;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete permanently?',
      message:
          '${count == 1 ? 'This card' : '$count cards'} will be deleted '
          "for good — this can't be undone.",
      confirmLabel: 'Delete forever',
      isDestructive: true,
    );
    if (!confirmed) return;
    await ref.read(browseRepositoryProvider).bulkPermanentlyDelete(_selected);
    _selected.clear();
    await _load();
  }

  Future<void> _emptyTrash() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Empty trash?',
      message:
          'All ${_rows.length} card${_rows.length == 1 ? '' : 's'} in the '
          "trash will be deleted for good — this can't be undone.",
      confirmLabel: 'Empty trash',
      isDestructive: true,
    );
    if (!confirmed) return;
    await ref.read(browseRepositoryProvider).emptyTrash();
    _selected.clear();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        actions: [
          if (_rows.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever_outlined),
              tooltip: 'Empty trash',
              onPressed: () => unawaited(_emptyTrash()),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _SelectionBar(
                  count: _selected.length,
                  onRestore: _restoreSelected,
                  onDeleteForever: _deleteSelectedForever,
                ),
                Expanded(
                  child: _rows.isEmpty
                      ? const _EmptyTrash()
                      : ListView.builder(
                          itemCount: _rows.length,
                          itemBuilder: (context, index) {
                            final row = _rows[index];
                            final selected = _selected.contains(row.card.id);
                            return ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              leading: Checkbox(
                                value: selected,
                                onChanged: (value) => setState(() {
                                  if (value ?? false) {
                                    _selected.add(row.card.id);
                                  } else {
                                    _selected.remove(row.card.id);
                                  }
                                }),
                              ),
                              title: Text(
                                row.preview.isEmpty ? '(empty)' : row.preview,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${row.deckName} • ${row.noteTypeName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onTap: () => setState(() {
                                if (selected) {
                                  _selected.remove(row.card.id);
                                } else {
                                  _selected.add(row.card.id);
                                }
                              }),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _SelectionBar extends StatelessWidget {
  const _SelectionBar({
    required this.count,
    required this.onRestore,
    required this.onDeleteForever,
  });

  final int count;
  final Future<void> Function() onRestore;
  final Future<void> Function() onDeleteForever;

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
                    icon: const Icon(Icons.restore_outlined),
                    tooltip: 'Restore',
                    onPressed: () => unawaited(onRestore()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever_outlined),
                    tooltip: 'Delete forever',
                    onPressed: () => unawaited(onDeleteForever()),
                  ),
                ],
              ),
            ),
    );
  }
}

class _EmptyTrash extends StatelessWidget {
  const _EmptyTrash();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.delete_outline,
            size: 40,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'Trash is empty.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

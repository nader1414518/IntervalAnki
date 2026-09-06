import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/local/app_database.dart';
import '../../../data/repositories/deck_repository.dart';
import '../../../data/repositories/media_repository.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../data/repositories/note_type_repository.dart';

/// Add cards to a deck: pick a deck + note type, fill in its fields, and
/// save — the screen stays open afterwards for rapid batch entry (PRD
/// §4.3's "batch add mode"), with a single unified flow rather than Anki's
/// separate modal windows (PRD §5.4).
class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({super.key});

  static const routeName = 'add-note';

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  Deck? _deck;
  NoteType? _noteType;
  List<NoteField> _fields = [];
  final _fieldControllers = <TextEditingController>[];
  final _tagsController = TextEditingController();
  bool _saving = false;
  bool _selectingNoteType = false;

  @override
  void dispose() {
    for (final c in _fieldControllers) {
      c.dispose();
    }
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _selectNoteType(NoteType noteType) async {
    _selectingNoteType = true;
    final detail = await ref
        .read(noteTypeRepositoryProvider)
        .loadDetail(noteType.id);
    for (final c in _fieldControllers) {
      c.dispose();
    }
    if (!mounted) return;
    setState(() {
      _noteType = noteType;
      _fields = detail.fields;
      _fieldControllers
        ..clear()
        ..addAll(_fields.map((_) => TextEditingController()));
      _selectingNoteType = false;
    });
  }

  /// Picks a default deck/note type once their lists load, since a
  /// dropdown's `initialValue` only affects display — it doesn't fire
  /// `onChanged`, so without this the fields for the displayed default note
  /// type would never actually load.
  void _selectDefaultsIfNeeded(List<Deck> decks, List<NoteType> noteTypes) {
    if (_deck == null && decks.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _deck == null) setState(() => _deck = decks.first);
      });
    }
    if (_noteType == null && !_selectingNoteType && noteTypes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _noteType == null && !_selectingNoteType) {
          unawaited(_selectNoteType(noteTypes.first));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final decks = ref.watch(deckListProvider);
    final noteTypes = ref.watch(noteTypeListProvider);
    _selectDefaultsIfNeeded(decks.value ?? [], noteTypes.value ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add cards'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            decks.when(
              data: (decks) => _DeckAndNoteTypePickers(
                decks: decks,
                noteTypes: noteTypes.value ?? [],
                selectedDeck: _deck,
                selectedNoteType: _noteType,
                onDeckChanged: (deck) => setState(() => _deck = deck),
                onNoteTypeChanged: (noteType) {
                  if (noteType != null) unawaited(_selectNoteType(noteType));
                },
              ),
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => const LinearProgressIndicator(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  for (var i = 0; i < _fields.length; i++)
                    _FieldEditor(
                      label: _fields[i].name,
                      controller: _fieldControllers[i],
                      onInsertImage: () => _insertImage(_fieldControllers[i]),
                    ),
                  TextField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                      labelText: 'Tags (space-separated)',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _saving || _deck == null || _noteType == null
                  ? null
                  : _save,
              child: Text(_saving ? 'Saving…' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _insertImage(TextEditingController controller) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final filename = await ref.read(mediaRepositoryProvider).add(image.path);
    _insertAtCursor(controller, '<img src="$filename">');
  }

  Future<void> _save() async {
    final deck = _deck;
    final noteType = _noteType;
    if (deck == null || noteType == null) return;

    setState(() => _saving = true);
    final result = await ref
        .read(noteRepositoryProvider)
        .create(
          noteTypeId: noteType.id,
          deckId: deck.id,
          fieldValues: _fieldControllers.map((c) => c.text).toList(),
          tags: _tagsController.text
              .split(RegExp(r'\s+'))
              .where((tag) => tag.isNotEmpty)
              .toList(),
        );

    for (final c in _fieldControllers) {
      c.clear();
    }
    setState(() => _saving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.wasDuplicate
              ? 'Card added (looks like a possible duplicate).'
              : 'Card added.',
        ),
      ),
    );
  }
}

void _insertAtCursor(TextEditingController controller, String text) {
  final selection = controller.selection;
  final value = controller.text;
  final start = selection.start < 0 ? value.length : selection.start;
  final end = selection.end < 0 ? value.length : selection.end;
  final newText = value.replaceRange(start, end, text);
  controller.value = TextEditingValue(
    text: newText,
    selection: TextSelection.collapsed(offset: start + text.length),
  );
}

class _DeckAndNoteTypePickers extends StatelessWidget {
  const _DeckAndNoteTypePickers({
    required this.decks,
    required this.noteTypes,
    required this.selectedDeck,
    required this.selectedNoteType,
    required this.onDeckChanged,
    required this.onNoteTypeChanged,
  });

  final List<Deck> decks;
  final List<NoteType> noteTypes;
  final Deck? selectedDeck;
  final NoteType? selectedNoteType;
  final ValueChanged<Deck?> onDeckChanged;
  final ValueChanged<NoteType?> onNoteTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<Deck>(
            initialValue: selectedDeck ?? (decks.isEmpty ? null : decks.first),
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Deck'),
            items: [
              for (final deck in decks)
                DropdownMenuItem(
                  value: deck,
                  child: Text(deck.name, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: onDeckChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<NoteType>(
            initialValue:
                selectedNoteType ??
                (noteTypes.isEmpty ? null : noteTypes.first),
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Note type'),
            items: [
              for (final noteType in noteTypes)
                DropdownMenuItem(
                  value: noteType,
                  child: Text(noteType.name, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: onNoteTypeChanged,
          ),
        ),
      ],
    );
  }
}

class _FieldEditor extends StatelessWidget {
  const _FieldEditor({
    required this.label,
    required this.controller,
    required this.onInsertImage,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onInsertImage;

  void _wrap(String prefix, String suffix) {
    final selection = controller.selection;
    final text = controller.text;
    final start = selection.start < 0 ? text.length : selection.start;
    final end = selection.end < 0 ? text.length : selection.end;
    final selected = text.substring(start, end);
    final newText = text.replaceRange(start, end, '$prefix$selected$suffix');
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: start + prefix.length + selected.length + suffix.length,
      ),
    );
  }

  void _cloze() {
    final existing = RegExp(r'\{\{c(\d+)::')
        .allMatches(controller.text)
        .map((m) => int.parse(m.group(1)!));
    final next = existing.isEmpty
        ? 1
        : existing.reduce((a, b) => a > b ? a : b) + 1;
    _wrap('{{c$next::', '}}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 4,
            children: [
              IconButton(
                tooltip: 'Bold',
                icon: const Icon(Icons.format_bold),
                onPressed: () => _wrap('<b>', '</b>'),
              ),
              IconButton(
                tooltip: 'Italic',
                icon: const Icon(Icons.format_italic),
                onPressed: () => _wrap('<i>', '</i>'),
              ),
              IconButton(
                tooltip: 'Underline',
                icon: const Icon(Icons.format_underlined),
                onPressed: () => _wrap('<u>', '</u>'),
              ),
              IconButton(
                tooltip: 'Superscript',
                icon: const Icon(Icons.superscript),
                onPressed: () => _wrap('<sup>', '</sup>'),
              ),
              IconButton(
                tooltip: 'Subscript',
                icon: const Icon(Icons.subscript),
                onPressed: () => _wrap('<sub>', '</sub>'),
              ),
              IconButton(
                tooltip: 'Cloze deletion',
                icon: const Icon(Icons.circle_outlined),
                onPressed: _cloze,
              ),
              IconButton(
                tooltip: 'Insert image',
                icon: const Icon(Icons.image_outlined),
                onPressed: onInsertImage,
              ),
            ],
          ),
          TextField(
            controller: controller,
            minLines: 2,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

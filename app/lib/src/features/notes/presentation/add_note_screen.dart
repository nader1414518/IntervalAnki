import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/media_storage.dart';
import '../../../data/repositories/deck_repository.dart';
import '../../../data/repositories/media_repository.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../data/repositories/note_type_repository.dart';

/// Add cards to a deck, or edit an existing note: pick a deck + note type,
/// fill in its fields, and save. In add mode, the screen stays open
/// afterwards for rapid batch entry (PRD §4.3's "batch add mode"); passing
/// [noteId] switches it to edit mode instead, pre-filled with that note's
/// current values — one unified flow for both, rather than Anki's separate
/// modal windows (PRD §5.4).
class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({this.noteId, this.deckId, super.key});

  static const routeName = 'add-note';

  /// The note to edit, or `null` to add a new one.
  final int? noteId;

  /// The deck to preselect in add mode (e.g. opened from that deck's
  /// browse screen). Ignored when [noteId] is set — editing keeps the
  /// note's own deck as the starting selection instead.
  final int? deckId;

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  Deck? _deck;
  NoteType? _noteType;
  List<NoteField> _fields = [];
  List<CardTemplate> _templates = [];
  final _fieldControllers = <TextEditingController>[];
  final _tagsController = TextEditingController();
  bool _saving = false;
  bool _selectingNoteType = false;
  bool _loadingForEdit = false;

  bool get _isEditing => widget.noteId != null;

  /// Whether this note type actually processes `{{cN::...}}` — the
  /// built-in Cloze type, or a custom one with a `{{cloze:Field}}`
  /// template — so the cloze tools/tutorial are only offered where they'd
  /// do something.
  bool get _isClozeNoteType =>
      _templates.any((t) => t.front.contains('{{cloze:'));

  @override
  void initState() {
    super.initState();
    if (widget.noteId case final noteId?) {
      _loadingForEdit = true;
      unawaited(_loadForEdit(noteId));
    }
  }

  Future<void> _loadForEdit(int noteId) async {
    final data = await ref.read(noteRepositoryProvider).loadForEdit(noteId);
    final detail = await ref
        .read(noteTypeRepositoryProvider)
        .loadDetail(data.noteTypeId);
    final decks = await ref.read(deckListProvider.future);
    final deck = decks.firstWhere(
      (d) => d.id == data.deckId,
      orElse: () => decks.first,
    );
    if (!mounted) return;
    setState(() {
      _deck = deck;
      _noteType = detail.noteType;
      _fields = detail.fields;
      _templates = detail.templates;
      _fieldControllers
        ..clear()
        ..addAll(
          List.generate(
            _fields.length,
            (i) => TextEditingController(
              text: i < data.fieldValues.length ? data.fieldValues[i] : '',
            ),
          ),
        );
      _tagsController.text = data.tags.join(' ');
      _loadingForEdit = false;
    });
  }

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
      _templates = detail.templates;
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
    if (_isEditing) return;
    if (_deck == null && decks.isNotEmpty) {
      Deck? preselected;
      for (final deck in decks) {
        if (deck.id == widget.deckId) {
          preselected = deck;
          break;
        }
      }
      final initialDeck = preselected ?? decks.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _deck == null) setState(() => _deck = initialDeck);
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
    if (_loadingForEdit) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit card')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final decks = ref.watch(deckListProvider);
    final noteTypes = ref.watch(noteTypeListProvider);
    _selectDefaultsIfNeeded(decks.value ?? [], noteTypes.value ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit card' : 'Add cards'),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => unawaited(_saveAndClose()),
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
                noteTypeLocked: _isEditing,
                onDeckChanged: (deck) => setState(() => _deck = deck),
                onNoteTypeChanged: (noteType) {
                  if (noteType != null) unawaited(_selectNoteType(noteType));
                },
              ),
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => const LinearProgressIndicator(),
            ),
            const SizedBox(height: 16),
            if (_noteType?.name == imageOcclusionNoteTypeName)
              Expanded(
                child: _ImageOcclusionRedirect(
                  deck: _deck,
                  isEditing: _isEditing,
                ),
              )
            else ...[
              Expanded(
                child: ListView(
                  children: [
                    if (_isClozeNoteType)
                      _ClozeBanner(
                        onTap: () => unawaited(showClozeTutorial(context)),
                      ),
                    for (var i = 0; i < _fields.length; i++)
                      _FieldEditor(
                        label: _fields[i].name,
                        controller: _fieldControllers[i],
                        onInsertImage: () => _insertImage(_fieldControllers[i]),
                        onAudioRecorded: _storeAudio,
                        showCloze: _isClozeNoteType,
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
                child: Text(
                  _saving ? 'Saving…' : (_isEditing ? 'Save' : 'Add'),
                ),
              ),
            ],
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

  /// Copies a just-recorded clip (still sitting in a temp file) into media
  /// storage the same way [_insertImage] does for photos, returning the
  /// stored filename for [_FieldEditor] to wrap in a `[sound:...]` tag.
  Future<String> _storeAudio(String tempFilePath) {
    return ref.read(mediaRepositoryProvider).add(tempFilePath);
  }

  /// "Done" in the app bar: saves whatever's been filled in (same as the
  /// "Add"/"Save" button) before closing, rather than silently discarding
  /// it — the field-based flow has no other save point in edit mode, and in
  /// add mode a card with content shouldn't be lost just because the user
  /// tapped "Done" instead of "Add". A blank, never-touched form (or the
  /// Image Occlusion redirect, which has no fields at all) closes without
  /// saving, so "Done" alone doesn't create empty notes.
  Future<void> _saveAndClose() async {
    if (_isEditing) {
      await _save(); // Pops the screen itself once the update completes.
      return;
    }
    final hasContent = _fieldControllers.any((c) => c.text.trim().isNotEmpty);
    if (_deck != null && _noteType != null && hasContent) {
      await _save();
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _save() async {
    final deck = _deck;
    final noteType = _noteType;
    if (deck == null || noteType == null) return;

    setState(() => _saving = true);
    final fieldValues = _fieldControllers.map((c) => c.text).toList();
    final tags = _tagsController.text
        .split(RegExp(r'\s+'))
        .where((tag) => tag.isNotEmpty)
        .toList();

    if (_isEditing) {
      await ref
          .read(noteRepositoryProvider)
          .update(
            noteId: widget.noteId!,
            fieldValues: fieldValues,
            tags: tags,
            deckId: deck.id,
          );
      if (!mounted) return;
      setState(() => _saving = false);
      Navigator.of(context).pop(true);
      return;
    }

    final result = await ref
        .read(noteRepositoryProvider)
        .create(
          noteTypeId: noteType.id,
          deckId: deck.id,
          fieldValues: fieldValues,
          tags: tags,
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

/// Image Occlusion notes aren't built from plain text fields — this stands
/// in for the field list, handing off to the dedicated editor (create) or
/// explaining the current limitation (edit: masks aren't editable yet, so
/// there's nothing useful to show here beyond "delete and redo").
class _ImageOcclusionRedirect extends StatelessWidget {
  const _ImageOcclusionRedirect({required this.deck, required this.isEditing});

  final Deck? deck;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            "Image Occlusion notes can't be edited here yet — delete "
            'this card from Browse and create a new one instead.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image_outlined, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Image Occlusion cards are built in their own editor: pick '
              'an image, then draw a box over each region to hide.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: deck == null
                  ? null
                  : () => unawaited(
                      context.push('/image-occlusion?deckId=${deck!.id}'),
                    ),
              child: const Text('Open Image Occlusion editor'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A one-line, tappable pointer to [showClozeTutorial] shown above a Cloze
/// note's fields — more discoverable than the per-field "?" toolbar icon
/// for someone who's never seen `{{c1::...}}` before.
class _ClozeBanner extends StatelessWidget {
  const _ClozeBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.help_outline,
                  size: 18,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'New to cloze? Wrap text in {{c1::...}} to hide it — '
                    'tap for a quick guide.',
                    style: TextStyle(color: colorScheme.onSecondaryContainer),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Explains `{{cN::...}}` cloze-deletion syntax for anyone coming from a
/// plain front/back mental model. Shown from the field toolbar's "?" and
/// the banner above a Cloze note's fields.
Future<void> showClozeTutorial(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cloze deletions'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "A cloze deletion hides part of a field's text and asks you "
              'to recall just that part — one note can make several cards '
              'this way, each hiding a different blank.',
            ),
            SizedBox(height: 16),
            Text('Basic syntax', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            _ClozeExample(
              markup: 'The capital of France is {{c1::Paris}}.',
              frontResult: 'The capital of France is [...].',
              backResult: 'The capital of France is Paris.',
            ),
            SizedBox(height: 16),
            Text(
              'Multiple blanks',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Use a different number for each blank you want tested on '
              'its own card:',
            ),
            SizedBox(height: 4),
            _ClozeExample(
              markup: '{{c1::Paris}} is the capital of {{c2::France}}.',
              frontResult:
                  'Card 1 hides "Paris" only; Card 2 hides "France" only — '
                  'each shows the other blank normally.',
            ),
            SizedBox(height: 16),
            Text(
              'Grouping blanks',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Reuse the same number to hide multiple blanks together, on '
              'one card, instead of making separate cards:',
            ),
            SizedBox(height: 4),
            _ClozeExample(
              markup:
                  '{{c1::Add}} and {{c1::subtract}} are inverse '
                  'operations.',
              frontResult: '[...] and [...] are inverse operations.',
            ),
            SizedBox(height: 16),
            Text('Hints', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(
              'Add a hint after a second "::" — it replaces the plain '
              '"..." placeholder on the front:',
            ),
            SizedBox(height: 4),
            _ClozeExample(
              markup: '{{c1::Paris::capital of France}}',
              frontResult: '[capital of France]',
              backResult: 'Paris',
            ),
            SizedBox(height: 16),
            Text(
              'Tip: select the text to hide and tap the ⊙ toolbar button — '
              'it fills in the next number for you. With nothing selected, '
              'it drops in an empty {{cN::}} and puts the cursor right '
              'where the hidden text goes.',
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}

class _ClozeExample extends StatelessWidget {
  const _ClozeExample({
    required this.markup,
    required this.frontResult,
    this.backResult,
  });

  final String markup;
  final String frontResult;
  final String? backResult;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You type: $markup',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text('Front: $frontResult', style: const TextStyle(fontSize: 12)),
          if (backResult case final back?) ...[
            const SizedBox(height: 2),
            Text('Back: $back', style: const TextStyle(fontSize: 12)),
          ],
        ],
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
    this.noteTypeLocked = false,
  });

  final List<Deck> decks;
  final List<NoteType> noteTypes;
  final Deck? selectedDeck;
  final NoteType? selectedNoteType;
  final ValueChanged<Deck?> onDeckChanged;
  final ValueChanged<NoteType?> onNoteTypeChanged;

  /// Disables the note-type dropdown — editing an existing note keeps its
  /// note type fixed rather than migrating its fields, which Anki treats as
  /// a separate, more involved operation.
  final bool noteTypeLocked;

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
            onChanged: noteTypeLocked ? null : onNoteTypeChanged,
          ),
        ),
      ],
    );
  }
}

/// Matches a `[sound:filename]` marker in field text — the same tag
/// `CardTemplateRenderer` turns into a playable `<audio>` element when a
/// card is rendered (see `packages/card_template`).
final _soundTagPattern = RegExp(r'\[sound:(.*?)\]');

class _FieldEditor extends StatefulWidget {
  const _FieldEditor({
    required this.label,
    required this.controller,
    required this.onInsertImage,
    required this.onAudioRecorded,
    this.showCloze = false,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onInsertImage;

  /// Copies a just-recorded clip into media storage and returns its stored
  /// filename, to be wrapped in a `[sound:...]` tag.
  final Future<String> Function(String tempFilePath) onAudioRecorded;

  /// Shows the cloze-deletion button — only worth offering on a note type
  /// that actually processes `{{cN::...}}` (the built-in Cloze type, or a
  /// custom one with a `{{cloze:Field}}` template); on Basic and friends it
  /// would just insert dead text that prints literally on the card.
  final bool showCloze;

  @override
  State<_FieldEditor> createState() => _FieldEditorState();
}

class _FieldEditorState extends State<_FieldEditor> {
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  bool _isRecording = false;
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;
  String? _playingFilename;

  TextEditingController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    _recordTimer?.cancel();
    unawaited(_recorder.dispose());
    unawaited(_player.dispose());
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

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

  /// Wraps the selection in the next unused `{{cN::...}}` — or, with
  /// nothing selected, inserts an empty one and lands the cursor right
  /// after the `::` so the hidden text can be typed immediately, instead
  /// of after the closing braces where you'd have to click back in.
  void _cloze() {
    final existing = RegExp(r'\{\{c(\d+)::')
        .allMatches(controller.text)
        .map((m) => int.parse(m.group(1)!));
    final next = existing.isEmpty
        ? 1
        : existing.reduce((a, b) => a > b ? a : b) + 1;

    final selection = controller.selection;
    final text = controller.text;
    final start = selection.start < 0 ? text.length : selection.start;
    final end = selection.end < 0 ? text.length : selection.end;
    final selected = text.substring(start, end);
    final prefix = '{{c$next::';
    const suffix = '}}';
    final newText = text.replaceRange(start, end, '$prefix$selected$suffix');
    final cursorOffset = selected.isEmpty
        ? start + prefix.length
        : start + prefix.length + selected.length + suffix.length;

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      _recordTimer?.cancel();
      setState(() => _isRecording = false);
      if (path == null) return;
      final filename = await widget.onAudioRecorded(path);
      _insertAtCursor(controller, '[sound:$filename]');
      return;
    }

    if (!await _recorder.hasPermission()) return;
    final tempDir = await getTemporaryDirectory();
    final path = p.join(
      tempDir.path,
      '${DateTime.now().microsecondsSinceEpoch}.m4a',
    );
    try {
      // The underlying platform recorder can hang indefinitely rather than
      // reject its Future if the OS never resolves the mic permission it
      // needs (seen on a freshly-created iOS Simulator before its host Mac
      // has granted the Simulator app microphone access in System
      // Settings) — a plain `await` here would leave the button stuck
      // showing no feedback forever, so bound it and surface a message
      // instead of hanging the whole field editor.
      await _recorder
          .start(const RecordConfig(), path: path)
          .timeout(const Duration(seconds: 8));
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Couldn't start recording — check microphone permission.",
          ),
        ),
      );
      return;
    }
    if (!mounted) return;
    setState(() {
      _isRecording = true;
      _recordDuration = Duration.zero;
    });
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _recordDuration += const Duration(seconds: 1));
    });
  }

  Future<void> _togglePlay(String filename) async {
    if (_playingFilename == filename) {
      await _player.stop();
      if (mounted) setState(() => _playingFilename = null);
      return;
    }
    final mediaDir = await MediaStorage().directoryPath();
    await _player.play(DeviceFileSource(p.join(mediaDir, filename)));
    if (!mounted) return;
    setState(() => _playingFilename = filename);
    unawaited(
      _player.onPlayerComplete.first.then((_) {
        if (mounted && _playingFilename == filename) {
          setState(() => _playingFilename = null);
        }
      }),
    );
  }

  void _removeSound(RegExpMatch match) {
    final text = controller.text;
    final newText = text.replaceRange(match.start, match.end, '');
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: match.start),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final soundMatches = _soundTagPattern.allMatches(controller.text).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
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
              if (widget.showCloze) ...[
                IconButton(
                  tooltip: 'Cloze deletion',
                  icon: const Icon(Icons.circle_outlined),
                  onPressed: _cloze,
                ),
                IconButton(
                  tooltip: 'How cloze deletions work',
                  icon: const Icon(Icons.help_outline),
                  onPressed: () => unawaited(showClozeTutorial(context)),
                ),
              ],
              IconButton(
                tooltip: 'Insert image',
                icon: const Icon(Icons.image_outlined),
                onPressed: widget.onInsertImage,
              ),
              IconButton(
                tooltip: _isRecording ? 'Stop recording' : 'Record audio',
                icon: Icon(
                  _isRecording ? Icons.stop_circle : Icons.mic_none,
                  color: _isRecording
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
                onPressed: () => unawaited(_toggleRecording()),
              ),
              if (_isRecording)
                Text(
                  _formatDuration(_recordDuration),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          TextField(
            controller: controller,
            minLines: 2,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
            ),
          ),
          if (soundMatches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (var i = 0; i < soundMatches.length; i++)
                    _AudioChip(
                      label: 'Audio ${i + 1}',
                      isPlaying: _playingFilename == soundMatches[i].group(1),
                      onTap: () =>
                          unawaited(_togglePlay(soundMatches[i].group(1)!)),
                      onDelete: () => _removeSound(soundMatches[i]),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AudioChip extends StatelessWidget {
  const _AudioChip({
    required this.label,
    required this.isPlaying,
    required this.onTap,
    required this.onDelete,
  });

  final String label;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      avatar: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 18),
      label: Text(label),
      onPressed: onTap,
      onDeleted: onDelete,
    );
  }
}

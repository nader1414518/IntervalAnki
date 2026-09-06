import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/image_occlusion.dart';
import '../../../data/repositories/deck_repository.dart';
import '../../../data/repositories/media_repository.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../data/repositories/note_type_repository.dart';

/// Creates an Image Occlusion note (PRD §4.2/Phase 2's "custom note
/// types"): pick an image, draw a box over each region to hide, and save —
/// one card is generated per box, "hide one, guess one" (the box under
/// test is hidden; every other region stays visible for context).
class ImageOcclusionEditorScreen extends ConsumerStatefulWidget {
  const ImageOcclusionEditorScreen({this.deckId, super.key});

  static const routeName = 'image-occlusion';

  final int? deckId;

  @override
  ConsumerState<ImageOcclusionEditorScreen> createState() =>
      _ImageOcclusionEditorScreenState();
}

class _ImageOcclusionEditorScreenState
    extends ConsumerState<ImageOcclusionEditorScreen> {
  File? _imageFile;
  double? _imageAspectRatio;
  final List<ImageOcclusionMask> _masks = [];
  Offset? _dragStart;
  Rect? _dragRect;
  Deck? _deck;
  final _extraController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _extraController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final file = File(picked.path);
    final aspectRatio = await _resolveAspectRatio(file);
    if (!mounted) return;
    setState(() {
      _imageFile = file;
      _imageAspectRatio = aspectRatio;
      _masks.clear();
    });
  }

  Future<double> _resolveAspectRatio(File file) {
    final completer = Completer<double>();
    final stream = FileImage(file).resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;
    listener = ImageStreamListener((info, _) {
      completer.complete(info.image.width / info.image.height);
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }

  void _addMask(Rect rect, Size containerSize) {
    if (rect.width < 8 || rect.height < 8) return;
    setState(() {
      _masks.add(
        ImageOcclusionMask(
          left: rect.left / containerSize.width * 100,
          top: rect.top / containerSize.height * 100,
          width: rect.width / containerSize.width * 100,
          height: rect.height / containerSize.height * 100,
        ),
      );
    });
  }

  Future<void> _save() async {
    final image = _imageFile;
    final deck = _deck;
    if (image == null || deck == null || _masks.isEmpty) return;

    setState(() => _saving = true);
    final filename = await ref.read(mediaRepositoryProvider).add(image.path);
    final noteTypes = await ref
        .read(noteTypeRepositoryProvider)
        .watchAll()
        .first;
    final noteType = noteTypes.firstWhere(
      (t) => t.name == imageOcclusionNoteTypeName,
    );
    await ref
        .read(noteRepositoryProvider)
        .create(
          noteTypeId: noteType.id,
          deckId: deck.id,
          fieldValues: [filename, encodeMasks(_masks), _extraController.text],
          tags: _tagsController.text
              .split(RegExp(r'\s+'))
              .where((t) => t.isNotEmpty)
              .toList(),
        );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final decks = ref.watch(deckListProvider);
    if (_deck == null && widget.deckId != null && decks.value != null) {
      final match = decks.value!.where((d) => d.id == widget.deckId);
      if (match.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _deck == null) setState(() => _deck = match.first);
        });
      }
    }
    final canSave = _imageFile != null && _deck != null && _masks.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Occlusion'),
        actions: [
          TextButton(
            onPressed: _saving || !canSave ? null : () => unawaited(_save()),
            child: Text(_saving ? 'Saving…' : 'Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          decks.when(
            data: (decks) => DropdownButtonFormField<Deck>(
              initialValue: _deck,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Deck'),
              items: [
                for (final deck in decks)
                  DropdownMenuItem(
                    value: deck,
                    child: Text(deck.name, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (deck) => setState(() => _deck = deck),
            ),
            error: (error, stackTrace) => Text('Error: $error'),
            loading: () => const LinearProgressIndicator(),
          ),
          const SizedBox(height: 16),
          if (_imageFile == null)
            OutlinedButton.icon(
              onPressed: () => unawaited(_pickImage()),
              icon: const Icon(Icons.image_outlined),
              label: const Text('Choose image'),
            )
          else ...[
            AspectRatio(
              aspectRatio: _imageAspectRatio ?? 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final containerSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return GestureDetector(
                    onPanStart: (details) => setState(() {
                      _dragStart = details.localPosition;
                      _dragRect = Rect.fromPoints(
                        details.localPosition,
                        details.localPosition,
                      );
                    }),
                    onPanUpdate: (details) => setState(() {
                      if (_dragStart == null) return;
                      _dragRect = Rect.fromPoints(
                        _dragStart!,
                        details.localPosition,
                      );
                    }),
                    onPanEnd: (_) {
                      final rect = _dragRect;
                      setState(() {
                        _dragStart = null;
                        _dragRect = null;
                      });
                      if (rect != null) _addMask(rect, containerSize);
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(_imageFile!, fit: BoxFit.fill),
                        for (final mask in _masks)
                          Positioned(
                            left: mask.left / 100 * containerSize.width,
                            top: mask.top / 100 * containerSize.height,
                            width: mask.width / 100 * containerSize.width,
                            height: mask.height / 100 * containerSize.height,
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.75),
                            ),
                          ),
                        if (_dragRect != null)
                          Positioned.fromRect(
                            rect: _dragRect!,
                            child: Container(
                              color: Theme.of(context).colorScheme.primary
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _masks.isEmpty
                        ? 'Drag over a region to hide it — one card is '
                              'made per region.'
                        : '${_masks.length} '
                              'region${_masks.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (_masks.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(_masks.removeLast),
                    child: const Text('Undo last'),
                  ),
                TextButton(
                  onPressed: () => unawaited(_pickImage()),
                  child: const Text('Change image'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _extraController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Extra (shown on the back, optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'Tags (space-separated)',
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:card_template/card_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/card_web_view.dart';
import '../../../data/repositories/note_type_repository.dart';

/// Create or edit a note type: its fields and the card templates generated
/// from them (PRD §4.2). Pass `null` [noteTypeId] to create a new one.
class NoteTypeEditorScreen extends ConsumerStatefulWidget {
  const NoteTypeEditorScreen({this.noteTypeId, super.key});

  final int? noteTypeId;

  @override
  ConsumerState<NoteTypeEditorScreen> createState() =>
      _NoteTypeEditorScreenState();
}

class _NoteTypeEditorScreenState extends ConsumerState<NoteTypeEditorScreen> {
  final _nameController = TextEditingController();
  final _fieldControllers = <TextEditingController>[];
  final _templateControllers = <_TemplateControllers>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final id = widget.noteTypeId;
    if (id == null) {
      _nameController.text = 'New note type';
      _fieldControllers.addAll([
        TextEditingController(text: 'Front'),
        TextEditingController(text: 'Back'),
      ]);
      _templateControllers.add(
        _TemplateControllers(
          name: 'Card 1',
          front: '{{Front}}',
          back: '{{FrontSide}}\n\n<hr id=answer>\n\n{{Back}}',
        ),
      );
    } else {
      final detail = await ref.read(noteTypeRepositoryProvider).loadDetail(id);
      _nameController.text = detail.noteType.name;
      _fieldControllers.addAll(
        detail.fields.map((f) => TextEditingController(text: f.name)),
      );
      _templateControllers.addAll(
        detail.templates.map(
          (t) => _TemplateControllers(
            name: t.name,
            front: t.front,
            back: t.back,
            css: t.css,
          ),
        ),
      );
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final c in _fieldControllers) {
      c.dispose();
    }
    for (final t in _templateControllers) {
      t.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.noteTypeId == null ? 'New note type' : 'Edit note type',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save',
            onPressed: _loading ? null : _save,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 24),
                Text('Fields', style: Theme.of(context).textTheme.titleMedium),
                for (var i = 0; i < _fieldControllers.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _fieldControllers[i],
                            decoration: InputDecoration(
                              labelText: 'Field ${i + 1}',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _fieldControllers.length <= 1
                              ? null
                              : () => setState(
                                  () => _fieldControllers.removeAt(i).dispose(),
                                ),
                        ),
                      ],
                    ),
                  ),
                TextButton.icon(
                  onPressed: () => setState(
                    () => _fieldControllers.add(TextEditingController()),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add field'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Templates',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (var i = 0; i < _templateControllers.length; i++)
                  _TemplateEditor(
                    controllers: _templateControllers[i],
                    fieldControllers: _fieldControllers,
                    onRemove: _templateControllers.length <= 1
                        ? null
                        : () => setState(
                            () => _templateControllers.removeAt(i).dispose(),
                          ),
                  ),
                TextButton.icon(
                  onPressed: () => setState(
                    () => _templateControllers.add(
                      _TemplateControllers(
                        name: 'Card ${_templateControllers.length + 1}',
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add template'),
                ),
              ],
            ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final fieldNames = _fieldControllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    final templates = _templateControllers.map((t) => t.toDraft()).toList();
    if (name.isEmpty || fieldNames.isEmpty || templates.isEmpty) return;

    final repository = ref.read(noteTypeRepositoryProvider);
    final id = widget.noteTypeId;
    if (id == null) {
      await repository.create(name, fieldNames, templates);
    } else {
      await repository.update(id, name, fieldNames, templates);
    }
    if (mounted) Navigator.of(context).pop();
  }
}

class _TemplateControllers {
  _TemplateControllers({
    required String name,
    String front = '',
    String back = '',
    String css = '',
  }) : name = TextEditingController(text: name),
       front = TextEditingController(text: front),
       back = TextEditingController(text: back),
       css = TextEditingController(text: css);

  final TextEditingController name;
  final TextEditingController front;
  final TextEditingController back;
  final TextEditingController css;

  TemplateDraft toDraft() => TemplateDraft(
    name: name.text.trim(),
    front: front.text,
    back: back.text,
    css: css.text,
  );

  void dispose() {
    name.dispose();
    front.dispose();
    back.dispose();
    css.dispose();
  }
}

class _TemplateEditor extends StatelessWidget {
  const _TemplateEditor({
    required this.controllers,
    required this.fieldControllers,
    required this.onRemove,
  });

  final _TemplateControllers controllers;
  final List<TextEditingController> fieldControllers;
  final VoidCallback? onRemove;

  void _showPreview(BuildContext context) {
    final fields = <String, String>{
      for (final c in fieldControllers)
        if (c.text.trim().isNotEmpty) c.text.trim(): 'Sample ${c.text.trim()}',
    };
    const renderer = CardTemplateRenderer();
    final front = renderer.renderFront(controllers.front.text, fields);
    final back = renderer.renderBack(controllers.back.text, fields, front);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Preview')),
          body: Column(
            children: [
              const Padding(padding: EdgeInsets.all(8), child: Text('Front')),
              Expanded(
                child: CardWebView(
                  html: front,
                  css: controllers.css.text,
                  isDarkMode: isDarkMode,
                ),
              ),
              const Divider(height: 1),
              const Padding(padding: EdgeInsets.all(8), child: Text('Back')),
              Expanded(
                child: CardWebView(
                  html: back,
                  css: controllers.css.text,
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controllers.name,
                    decoration: const InputDecoration(
                      labelText: 'Template name',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.visibility_outlined),
                  tooltip: 'Preview',
                  onPressed: () => _showPreview(context),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: onRemove,
                ),
              ],
            ),
            TextField(
              controller: controllers.front,
              minLines: 2,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Front template'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controllers.back,
              minLines: 2,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Back template'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controllers.css,
              minLines: 2,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'CSS'),
            ),
          ],
        ),
      ),
    );
  }
}

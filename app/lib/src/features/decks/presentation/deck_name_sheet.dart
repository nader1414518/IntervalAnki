import 'package:flutter/material.dart';

/// A bottom sheet prompting for a deck name (create or rename). Supports
/// `::`-separated nesting (e.g. `"Spanish::Verbs"`), matching Anki's
/// convention.
Future<String?> showDeckNameSheet(
  BuildContext context, {
  required String title,
  String initialName = '',
}) {
  final controller = TextEditingController(text: initialName);
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Deck name',
                hintText: 'e.g. Spanish::Verbs',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        ),
      );
    },
  );
}

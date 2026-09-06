import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/repositories/deck_options_repository.dart';

/// Per-deck (or shared-preset) scheduling limits (PRD §4.1): new cards/day,
/// review limit, learning steps, and FSRS desired retention.
class DeckOptionsScreen extends ConsumerWidget {
  const DeckOptionsScreen({required this.deckOptionsId, super.key});

  static const routeName = 'deck-options';

  final int deckOptionsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(deckOptionsProvider(deckOptionsId));
    return Scaffold(
      appBar: AppBar(title: const Text('Deck options')),
      body: options.when(
        data: (options) => _DeckOptionsForm(options: options),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _DeckOptionsForm extends ConsumerStatefulWidget {
  const _DeckOptionsForm({required this.options});

  final DeckOption options;

  @override
  ConsumerState<_DeckOptionsForm> createState() => _DeckOptionsFormState();
}

class _DeckOptionsFormState extends ConsumerState<_DeckOptionsForm> {
  late final TextEditingController _newCardsController;
  late final TextEditingController _reviewsController;
  late final TextEditingController _learningStepsController;
  late final TextEditingController _relearningStepsController;
  late final TextEditingController _maxIntervalController;
  late double _desiredRetention;

  @override
  void initState() {
    super.initState();
    final o = widget.options;
    _newCardsController = TextEditingController(
      text: o.newCardsPerDay.toString(),
    );
    _reviewsController = TextEditingController(
      text: o.reviewsPerDay.toString(),
    );
    _learningStepsController = TextEditingController(
      text: o.learningStepsMinutes,
    );
    _relearningStepsController = TextEditingController(
      text: o.relearningStepsMinutes,
    );
    _maxIntervalController = TextEditingController(
      text: o.maximumIntervalDays.toString(),
    );
    _desiredRetention = o.desiredRetention;
  }

  @override
  void dispose() {
    _newCardsController.dispose();
    _reviewsController.dispose();
    _learningStepsController.dispose();
    _relearningStepsController.dispose();
    _maxIntervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _newCardsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'New cards/day'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _reviewsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Reviews/day'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _learningStepsController,
          decoration: const InputDecoration(
            labelText: 'Learning steps (minutes, comma-separated)',
            hintText: '1,10',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _relearningStepsController,
          decoration: const InputDecoration(
            labelText: 'Relearning steps (minutes, comma-separated)',
            hintText: '10',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _maxIntervalController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Maximum interval (days)',
          ),
        ),
        const SizedBox(height: 20),
        Text('Desired retention: ${(_desiredRetention * 100).round()}%'),
        Slider(
          value: _desiredRetention,
          min: 0.7,
          max: 0.99,
          divisions: 29,
          label: '${(_desiredRetention * 100).round()}%',
          onChanged: (value) => setState(() => _desiredRetention = value),
        ),
        const SizedBox(height: 20),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  Future<void> _save() async {
    final repository = ref.read(deckOptionsRepositoryProvider);
    await repository.update(
      widget.options.id,
      DeckOptionsCompanion(
        newCardsPerDay: Value(
          int.tryParse(_newCardsController.text) ??
              widget.options.newCardsPerDay,
        ),
        reviewsPerDay: Value(
          int.tryParse(_reviewsController.text) ?? widget.options.reviewsPerDay,
        ),
        learningStepsMinutes: Value(_learningStepsController.text),
        relearningStepsMinutes: Value(_relearningStepsController.text),
        maximumIntervalDays: Value(
          int.tryParse(_maxIntervalController.text) ??
              widget.options.maximumIntervalDays,
        ),
        desiredRetention: Value(_desiredRetention),
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }
}

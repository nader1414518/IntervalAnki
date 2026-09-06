import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/deck_repository.dart';

/// Placeholder deck-list home screen.
///
/// Replaced by the real deck tree + progress-ring cards (PRD §5.5) in M3.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Interval')),
      body: decks.when(
        data: (decks) => decks.isEmpty
            ? const Center(child: Text('Your decks will show up here.'))
            : ListView.builder(
                itemCount: decks.length,
                itemBuilder: (context, index) =>
                    ListTile(title: Text(decks[index].name)),
              ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

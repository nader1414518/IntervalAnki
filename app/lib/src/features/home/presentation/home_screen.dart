import 'package:flutter/material.dart';

/// Placeholder deck-list home screen.
///
/// Replaced by the real deck tree + progress-ring cards (PRD §5.5) in M3.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interval')),
      body: const Center(child: Text('Your decks will show up here.')),
    );
  }
}

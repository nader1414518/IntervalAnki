import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/app_database.dart';
import '../../../data/repositories/onboarding_repository.dart';
import '../../../data/repositories/settings_repository.dart';

/// The first-run wizard (PRD §5.1): a guided first deck (pre-filled with
/// sample cards), then a short explainer before the user's first review —
/// the differentiator PRD §5's "Onboarding" item calls out as something
/// Anki itself has none of.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _deckNameController = TextEditingController(text: 'My First Deck');
  var _page = 0;
  var _creating = false;

  @override
  void dispose() {
    _pageController.dispose();
    _deckNameController.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    setState(() => _page = page);
    _pageController.animateTo(
      page * MediaQuery.sizeOf(context).width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finish() async {
    setState(() => _creating = true);
    final deckName = _deckNameController.text.trim().isEmpty
        ? 'My First Deck'
        : _deckNameController.text.trim();
    final deckId = await ref
        .read(onboardingRepositoryProvider)
        .createFirstDeck(deckName);
    await ref
        .read(settingsRepositoryProvider)
        .update(
          (_) => const SettingsCompanion(onboardingCompleted: Value(true)),
        );
    if (!mounted) return;
    // `go` (not `push`) into the first review, on its own, replaces the
    // entire navigation history with just that one route — the review
    // screen would come up with nothing to pop back to, so AppBar never
    // shows a back button and the device back gesture does nothing.
    // Landing on the deck list first, then pushing review on top of it,
    // gives the guided first review a real "back"/"close" target instead
    // of being a dead end.
    context.go('/');
    if (!mounted) return;
    unawaited(context.push('/review/$deckId'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  _WelcomeStep(onNext: () => _goTo(1)),
                  _FirstDeckStep(
                    controller: _deckNameController,
                    onNext: () => _goTo(2),
                  ),
                  _HowReviewsWorkStep(
                    creating: _creating,
                    onStart: () => unawaited(_finish()),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _page ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.style_outlined,
      title: 'Welcome to Interval',
      body:
          'Interval helps you remember anything using spaced repetition — '
          "cards you're about to forget show up right when you need them.",
      button: FilledButton(onPressed: onNext, child: const Text('Get started')),
    );
  }
}

class _FirstDeckStep extends StatelessWidget {
  const _FirstDeckStep({required this.controller, required this.onNext});

  final TextEditingController controller;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.add_box_outlined,
      title: "Let's create your first deck",
      body:
          "We'll drop in a few sample cards so you have something to "
          'review right away — rename it, or keep the default.',
      extra: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(labelText: 'Deck name'),
        ),
      ),
      button: FilledButton(onPressed: onNext, child: const Text('Continue')),
    );
  }
}

class _HowReviewsWorkStep extends StatelessWidget {
  const _HowReviewsWorkStep({required this.creating, required this.onStart});

  final bool creating;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.touch_app_outlined,
      title: 'Your first review',
      body:
          'Tap a card to reveal its answer, then grade how well you knew '
          'it — swipe left for Again, right for Good, up for Easy. Buttons '
          'always work too.',
      extra: const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _GestureHint(icon: Icons.swipe_left, label: 'Again'),
            _GestureHint(icon: Icons.swipe_right, label: 'Good'),
            _GestureHint(icon: Icons.swipe_up, label: 'Easy'),
          ],
        ),
      ),
      button: FilledButton(
        onPressed: creating ? null : onStart,
        child: creating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Start reviewing'),
      ),
    );
  }
}

class _GestureHint extends StatelessWidget {
  const _GestureHint({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 28), const SizedBox(height: 4), Text(label)],
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.icon,
    required this.title,
    required this.body,
    required this.button,
    this.extra,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget button;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(body, textAlign: TextAlign.center),
          ?extra,
          const SizedBox(height: 24),
          button,
        ],
      ),
    );
  }
}

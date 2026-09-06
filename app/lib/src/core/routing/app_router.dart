import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/settings_repository.dart';
import '../../features/browse/presentation/browse_screen.dart';
import '../../features/decks/presentation/deck_list_screen.dart';
import '../../features/decks/presentation/deck_options_screen.dart';
import '../../features/import/presentation/import_screen.dart';
import '../../features/note_types/presentation/note_type_editor_screen.dart';
import '../../features/note_types/presentation/note_type_list_screen.dart';
import '../../features/notes/presentation/add_note_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/study/presentation/review_screen.dart';
import '../../features/tags/presentation/tag_list_screen.dart';

part 'app_router.g.dart';

/// Shows the first-run wizard until it's completed, then the deck list —
/// PRD §5.1's onboarding gate.
class _HomeGate extends ConsumerWidget {
  const _HomeGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return settings.onboardingCompleted
        ? const DeckListScreen()
        : const OnboardingScreen();
  }
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: DeckListScreen.routeName,
        builder: (context, state) => const _HomeGate(),
      ),
      GoRoute(
        path: '/settings',
        name: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/add-note',
        name: AddNoteScreen.routeName,
        builder: (context, state) {
          final noteId = state.uri.queryParameters['noteId'];
          return AddNoteScreen(
            noteId: noteId == null ? null : int.parse(noteId),
          );
        },
      ),
      GoRoute(
        path: '/review/:deckId',
        name: ReviewScreen.routeName,
        builder: (context, state) =>
            ReviewScreen(deckId: int.parse(state.pathParameters['deckId']!)),
      ),
      GoRoute(
        path: '/browse',
        name: BrowseScreen.routeName,
        builder: (context, state) => const BrowseScreen(),
      ),
      GoRoute(
        path: '/import',
        name: ImportScreen.routeName,
        builder: (context, state) => const ImportScreen(),
      ),
      GoRoute(
        path: '/tags',
        name: TagListScreen.routeName,
        builder: (context, state) => const TagListScreen(),
      ),
      GoRoute(
        path: '/deck-options/:id',
        name: DeckOptionsScreen.routeName,
        builder: (context, state) => DeckOptionsScreen(
          deckOptionsId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/note-types',
        name: NoteTypeListScreen.routeName,
        builder: (context, state) => const NoteTypeListScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NoteTypeEditorScreen(),
          ),
          GoRoute(
            path: ':id/edit',
            builder: (context, state) => NoteTypeEditorScreen(
              noteTypeId: int.parse(state.pathParameters['id']!),
            ),
          ),
        ],
      ),
    ],
  );
}

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/decks/presentation/deck_list_screen.dart';
import '../../features/decks/presentation/deck_options_screen.dart';
import '../../features/note_types/presentation/note_type_editor_screen.dart';
import '../../features/note_types/presentation/note_type_list_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: DeckListScreen.routeName,
        builder: (context, state) => const DeckListScreen(),
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

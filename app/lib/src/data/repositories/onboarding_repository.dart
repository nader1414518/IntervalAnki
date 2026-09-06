import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/app_database.dart';
import '../local/database_provider.dart';
import 'deck_repository.dart';
import 'note_repository.dart';

part 'onboarding_repository.g.dart';

/// Backs the first-run wizard (PRD §5.1): creates the user's first deck
/// pre-filled with a few sample cards, so the guided "first review"
/// walkthrough has something real to practice on.
class OnboardingRepository {
  OnboardingRepository(this._db, this._deckRepository, this._noteRepository);

  final AppDatabase _db;
  final DeckRepository _deckRepository;
  final NoteRepository _noteRepository;

  static const _sampleCards = [
    ('What is the capital of France?', 'Paris'),
    ('What is 7 × 6?', '42'),
    ('Which language and framework build Interval?', 'Dart, with Flutter'),
  ];

  Future<int> createFirstDeck(String deckName) async {
    final deckId = await _deckRepository.create(deckName);
    final basicNoteType = await (_db.select(
      _db.noteTypes,
    )..where((t) => t.name.equals('Basic'))).getSingle();
    for (final (front, back) in _sampleCards) {
      await _noteRepository.create(
        noteTypeId: basicNoteType.id,
        deckId: deckId,
        fieldValues: [front, back],
        tags: const [],
      );
    }
    return deckId;
  }
}

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  return OnboardingRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(deckRepositoryProvider),
    ref.watch(noteRepositoryProvider),
  );
}

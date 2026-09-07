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
    final deckId = await _deckRepository.create(await _uniqueName(deckName));
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

  /// Appends " (2)", " (3)", etc. until [name] doesn't collide with an
  /// existing deck. Onboarding's default deck name is always "My First
  /// Deck" regardless of whether the user changes it, so replaying the
  /// wizard (Settings → "Replay the welcome tour") after already having
  /// gone through it once — the tour resets `onboardingCompleted` but
  /// doesn't touch the deck it created — would otherwise hit deck names'
  /// UNIQUE constraint and crash rather than just... working.
  Future<String> _uniqueName(String name) async {
    var candidate = name;
    var suffix = 2;
    while (await (_db.select(
          _db.decks,
        )..where((d) => d.name.equals(candidate))).getSingleOrNull() !=
        null) {
      candidate = '$name ($suffix)';
      suffix++;
    }
    return candidate;
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

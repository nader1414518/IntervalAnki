import 'package:drift/drift.dart';

/// A card's current position in the scheduler, mirroring Anki's queue model.
enum CardQueue { newCard, learning, review, relearning, suspended, buried }

/// The grade a user gave a card when answering a review, per FSRS/SM-2.
enum ReviewRating { again, hard, good, easy }

/// The card's state *at the time of a review*, logged in [ReviewLog].
///
/// A subset of [CardQueue]: a review is never logged while a card is
/// suspended or buried, since those states are never shown for grading.
enum ReviewCardState { newCard, learning, review, relearning }

/// Scheduling limits/presets, shared by one or more [Decks].
class DeckOptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get newCardsPerDay => integer().withDefault(const Constant(20))();
  IntColumn get reviewsPerDay => integer().withDefault(const Constant(200))();

  /// Comma-separated minutes, e.g. `"1,10"`, matching Anki's step syntax.
  TextColumn get learningStepsMinutes =>
      text().withDefault(const Constant('1,10'))();
  TextColumn get relearningStepsMinutes =>
      text().withDefault(const Constant('10'))();
  IntColumn get maximumIntervalDays =>
      integer().withDefault(const Constant(36500))();

  /// Target probability of recall FSRS schedules intervals for, e.g. `0.9`.
  RealColumn get desiredRetention => real().withDefault(const Constant(0.9))();
}

/// A deck. Nested decks are represented by `::` in [name] (e.g.
/// `"Spanish::Verbs"`), matching Anki's convention, rather than a parent-id
/// column — the tree is derived by splitting on `::` where it's displayed.
@DataClassName('Deck')
class Decks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get deckOptionsId => integer().references(DeckOptions, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// A note type (Anki calls this a "model"): the set of fields a note has and
/// the templates used to turn those fields into one or more cards.
@DataClassName('NoteType')
class NoteTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

/// One field definition belonging to a [NoteTypes] entry.
@DataClassName('NoteField')
class Fields extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noteTypeId => integer().references(NoteTypes, #id)();
  TextColumn get name => text()();

  /// Display/storage order among this note type's fields.
  IntColumn get ord => integer()();
}

/// A card template belonging to a [NoteTypes] entry: the front/back HTML and
/// shared CSS that `packages/card_template` resolves against a note's field
/// values (see M5).
@DataClassName('CardTemplate')
class Templates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noteTypeId => integer().references(NoteTypes, #id)();
  TextColumn get name => text()();
  TextColumn get front => text()();
  TextColumn get back => text()();
  TextColumn get css => text().withDefault(const Constant(''))();

  /// Order among this note type's templates; a [Cards.templateOrd] of `n`
  /// renders using the template with `ord == n` (except for Cloze note
  /// types, which have a single template and reinterpret `templateOrd` as
  /// the cloze deletion number).
  IntColumn get ord => integer()();
}

/// A note: one set of field values, from which one or more [Cards] are
/// generated per its [NoteTypes]'s templates.
@DataClassName('Note')
@TableIndex(name: 'idx_notes_first_field_hash', columns: {#firstFieldHash})
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noteTypeId => integer().references(NoteTypes, #id)();

  /// JSON-encoded `List<String>`, ordered to match this note type's
  /// [Fields.ord].
  TextColumn get fieldValues => text()();

  /// Space-separated tags, padded with a leading/trailing space (Anki's
  /// convention), so a tag can be matched with a simple `LIKE '% tag %'`.
  TextColumn get tags => text().withDefault(const Constant(' '))();

  /// Hash of the first field's value, scoped to a note type, used to detect
  /// duplicate notes on creation/import.
  TextColumn get firstFieldHash => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// A card: one reviewable face generated from a [Notes] entry via one of its
/// note type's [Templates]. Scheduling fields ([stability], [difficulty])
/// are populated by the FSRS engine (`packages/fsrs`, M2).
///
/// Named `StudyCard` (not `Card`) to avoid colliding with Flutter's
/// `material.dart` `Card` widget, which most feature screens also import.
@DataClassName('StudyCard')
@TableIndex(name: 'idx_cards_deck_queue_due', columns: {#deckId, #queue, #due})
class Cards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noteId => integer().references(Notes, #id)();
  IntColumn get deckId => integer().references(Decks, #id)();
  IntColumn get templateOrd => integer()();
  TextColumn get queue => textEnum<CardQueue>()();

  /// Meaning depends on [queue]: a day number for `review`/`newCard`, or a
  /// Unix timestamp (seconds) while in `learning`/`relearning`.
  IntColumn get due => integer()();
  RealColumn get stability => real().nullable()();
  RealColumn get difficulty => real().nullable()();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  IntColumn get reps => integer().withDefault(const Constant(0))();

  /// `0` = no flag, `1`-`7` = one of Anki's seven flag colors.
  IntColumn get flag => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// An append-only log of graded reviews, one row per answer. Doubles as the
/// source data for the statistics dashboard (Phase 2).
@DataClassName('ReviewLogEntry')
@TableIndex(name: 'idx_review_log_card_id', columns: {#cardId})
class ReviewLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  DateTimeColumn get reviewedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get rating => textEnum<ReviewRating>()();
  RealColumn get elapsedDays => real()();
  RealColumn get scheduledDays => real()();
  TextColumn get state => textEnum<ReviewCardState>()();
}

/// A media file (image/audio/video) referenced by one or more notes' field
/// values, stored on disk and looked up by content hash for deduplication.
@DataClassName('MediaFile')
class Media extends Table {
  TextColumn get hash => text()();
  TextColumn get filename => text()();
  IntColumn get refCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {hash};
}

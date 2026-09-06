/// A field definition from an imported Anki note type.
class ImportedField {
  /// Creates a field.
  const ImportedField({required this.name, required this.ord});

  /// The field's name.
  final String name;

  /// Its order among the note type's fields.
  final int ord;
}

/// A card template from an imported Anki note type.
class ImportedTemplate {
  /// Creates a template.
  const ImportedTemplate({
    required this.name,
    required this.front,
    required this.back,
    required this.ord,
  });

  /// The template's name.
  final String name;

  /// The front template markup.
  final String front;

  /// The back template markup.
  final String back;

  /// Its order among the note type's templates.
  final int ord;
}

/// An imported Anki note type ("model").
class ImportedNoteType {
  /// Creates a note type.
  const ImportedNoteType({
    required this.ankiId,
    required this.name,
    required this.fields,
    required this.templates,
    required this.css,
  });

  /// The id this note type had in the source collection — used only to
  /// resolve [ImportedNote.noteTypeAnkiId] references during import; the
  /// app assigns its own id on insert.
  final int ankiId;

  /// The note type's name.
  final String name;

  /// Its fields, ordered.
  final List<ImportedField> fields;

  /// Its card templates, ordered.
  final List<ImportedTemplate> templates;

  /// Shared CSS for all of this note type's cards.
  final String css;
}

/// An imported Anki deck. Nested decks already use `Parent::Child` names,
/// same as this app's convention.
class ImportedDeck {
  /// Creates a deck.
  const ImportedDeck({required this.ankiId, required this.name});

  /// The deck's id in the source collection.
  final int ankiId;

  /// The deck's name.
  final String name;
}

/// An imported Anki note.
class ImportedNote {
  /// Creates a note.
  const ImportedNote({
    required this.ankiId,
    required this.noteTypeAnkiId,
    required this.fieldValues,
    required this.tags,
  });

  /// The note's id in the source collection.
  final int ankiId;

  /// The [ImportedNoteType.ankiId] this note belongs to.
  final int noteTypeAnkiId;

  /// Field values, ordered to match the note type's fields.
  final List<String> fieldValues;

  /// The note's tags.
  final List<String> tags;
}

/// Where an imported card lands in this app's scheduler.
///
/// Imported cards always start in [newCard] (except suspended/buried ones,
/// which keep that status) — see `ApkgImporter` for why prior Anki
/// scheduling state (interval/ease/due) isn't carried over.
enum ImportedCardQueue {
  /// Not yet reviewed.
  newCard,

  /// Excluded from study until manually unsuspended.
  suspended,

  /// Excluded from study until manually unburied.
  buried,
}

/// An imported Anki card.
class ImportedCard {
  /// Creates a card.
  const ImportedCard({
    required this.ankiId,
    required this.noteAnkiId,
    required this.deckAnkiId,
    required this.templateOrd,
    required this.queue,
    required this.lapses,
    required this.reps,
    required this.flag,
  });

  /// The card's id in the source collection.
  final int ankiId;

  /// The [ImportedNote.ankiId] this card was generated from.
  final int noteAnkiId;

  /// The [ImportedDeck.ankiId] this card lives in.
  final int deckAnkiId;

  /// Which of the note type's templates generated this card.
  final int templateOrd;

  /// The card's initial queue in this app.
  final ImportedCardQueue queue;

  /// Prior lapse count, preserved from the source collection.
  final int lapses;

  /// Prior review count, preserved from the source collection.
  final int reps;

  /// The card's flag (0 = none, 1-7 = a color), preserved as-is.
  final int flag;
}

/// Everything parsed out of a `.apkg` archive, ready for the app's data
/// layer to insert (id-remapping Anki's original ids to its own).
class ApkgImportResult {
  /// Creates an import result.
  const ApkgImportResult({
    required this.noteTypes,
    required this.decks,
    required this.notes,
    required this.cards,
    required this.mediaFiles,
  });

  /// The note types found in the archive.
  final List<ImportedNoteType> noteTypes;

  /// The decks found in the archive.
  final List<ImportedDeck> decks;

  /// The notes found in the archive.
  final List<ImportedNote> notes;

  /// The cards found in the archive.
  final List<ImportedCard> cards;

  /// Real filename -> file bytes, already resolved from the archive's
  /// numeric-filename media mapping.
  final Map<String, List<int>> mediaFiles;
}

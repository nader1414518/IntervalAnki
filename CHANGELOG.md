# Changelog

All notable changes to Interval are documented here. Dates mark when a change
landed in this repo, not necessarily a store release date.

## 1.0.0 — Initial release

The first complete build of Interval: local-first spaced repetition with an
Anki-compatible data model, FSRS scheduling, and full card authoring.

### Core study experience
- Deck management with nested decks (`Parent::Child`), per-deck options.
- Built-in note types (Basic, Basic and reversed, Basic type-in-answer,
  Cloze) plus a note-type builder for custom fields and templates.
- FSRS-based scheduling with a legacy SM-2 module for imports.
- Card review with gesture grading (swipe to grade, tap to reveal) and
  always-visible buttons as an accessible fallback, undo, flags, and
  suspend/bury.
- Rich card authoring: bold/italic/underline/superscript/subscript,
  cloze deletions with an in-app tutorial, embedded images (camera or
  gallery), and embedded audio (record in-app or import), with autoplay
  during review and a replay control.
- Image Occlusion note type: photograph or import a diagram, draw boxes
  over regions to hide, one card generated per box.
- Unified add/edit flow, per-deck and global card browsing/search, tag
  management, and a soft-delete trash with restore/empty.
- `.apkg` import from Anki (legacy `collection.anki2`/`anki21` schema),
  with a fidelity report; imported cards start fresh in the FSRS queue
  since interval/ease state has no faithful mapping from SM-2.

### Engagement & polish
- Day streaks with a freeze/protection mechanic, a statistics dashboard,
  and daily study-reminder notifications.
- First-run onboarding wizard, Material 3 theming with a selectable
  accent color, adjustable card font/size, and a reduced-motion setting.
- Automatic local backups plus manual export/import of your collection.

### Known limitations
- `.apkg` files exported in Anki's newer `anki21b` (zstd-compressed)
  format aren't supported yet — re-export with "Support older Anki
  versions" checked in Anki first. The import screen explains this.
- Image Occlusion notes can't be edited in place yet — delete and
  recreate them instead.
- Cloud sync across devices isn't implemented; all data is local to
  the device (with local backup/export as the way to move it).

# Interval — Store Listing Metadata

Copy-paste source for App Store Connect and Google Play Console. Character
counts are noted next to every field with a hard limit — verify against the
current console before submitting, since store limits do shift over time.

Privacy Policy URL (both stores): **https://claude.ai/code/artifact/9f10c530-43f3-4aa8-b816-f4e149658da8**
Support contact (both stores): **nader19113118@gmail.com**

---

## App Store Connect (iOS)

**App name** (30 char max) — 8 chars
```
Interval
```

**Subtitle** (30 char max) — 26 chars
```
Anki-Compatible Flashcards
```

**Promotional text** (170 char max, editable without a new review) — 120 chars
```
Already have Anki decks? Import them directly — .apkg support, FSRS scheduling, and audio flashcards, all fully offline.
```

**Keywords** (100 char max, comma-separated) — 99 chars
```
anki,ankidroid,anki alternative,flashcards,apkg,spaced repetition,srs,memory,study,vocabulary,cloze
```

**Category**
- Primary: Education
- Secondary: Productivity

**Age rating:** 4+ (no objectionable content — the questionnaire should come back clean; nothing in the app collects user-generated content that's shared with others, since there's no social/sharing feature)

**Copyright**
```
© 2026 Interval
```

**Description** (4000 char max) — see [description.md](description.md) (shared with Google Play's full description; App Store has no separate "short description" field, so the first ~3 lines before the fold matter most — keep the opening paragraph strong)

---

## Google Play Console (Android)

**App name** (30 char max) — 8 chars
```
Interval
```

**Short description** (80 char max) — 77 chars
```
Anki-compatible spaced repetition flashcards. Import .apkg decks. No account.
```

**Full description** (4000 char max): see [description.md](description.md)

**Category**
- Application type: Apps
- Category: Education

**Contact details**
- Email: nader19113118@gmail.com
- Privacy policy: https://claude.ai/code/artifact/9f10c530-43f3-4aa8-b816-f4e149658da8

**Content rating questionnaire:** answer "no" to every content category (violence, sexual content, gambling, user-generated content shared with others, location sharing, personal info collection) — the app has none of it, and should land on "Everyone" / "PEGI 3".

**Data safety section** (Play Console's data-collection disclosure form): declare **no data collected and no data shared**. Interval has no network calls, no analytics SDK, no ad SDK, and no account system — every field in that form should be answered "No data collected" or left at its default. See [../CHANGELOG.md](../CHANGELOG.md) and the privacy policy for the underlying facts if the form asks for detail.

**Feature graphic** (1024×500, required): `store/screenshots/feature_graphic.png`

**App icon** (512×512, required, high-res store listing icon — separate from the in-app launcher icon): `store/screenshots/icon_512.png`

---

## Assets checklist

| Asset | Location | Notes |
|---|---|---|
| iOS screenshots (6.1") | `store/screenshots/iphone/` | Captured on iPhone 16 simulator, 1179×2556 |
| Android/Play screenshots | `store/screenshots/android/` | Same UI (Flutter renders identically); Play Store accepts this resolution directly |
| Feature graphic | `store/screenshots/feature_graphic.png` | 1024×500, Play Store only |
| Store icon | `store/screenshots/icon_512.png` | 512×512, Play Store high-res icon |
| App icon source | `app/assets/icon/icon.png` | 1024×1024 master used to generate all platform icons |

## Notes on what's *not* included

- **iPad / 6.9" iPhone screenshots**: not captured. The larger Pro Max
  simulators need a one-time permission grant in the Simulator app that
  requires being at the keyboard — see the session notes. iPhone 16 (6.1")
  screenshots are a valid App Store Connect size bucket on their own; add the
  larger sizes later if Apple's submission flow asks for them.
- **Video preview**: not created — a 15–30s app preview video is optional on
  both stores and would need actual screen-recording tooling, not just
  screenshots.

## A note on the "Anki" mentions

The subtitle, keywords, promotional text, and description all lead with
Anki compatibility on purpose — a lot of people searching either store are
specifically looking for an Anki alternative or an app that can open their
existing .apkg decks, and this app genuinely does both. Every mention is
phrased as a *compatibility* claim ("Anki-compatible", "import your Anki
decks") rather than implying this is an official Anki product or that
Ankitects (Anki's maker) endorses it — that distinction is what keeps this
inside both stores' trademark/metadata policies, and it's what a lot of
other flashcard apps in this space (AnkiApp, RemNote, etc.) already do.
Worth a final read-through against the current App Store Review Guidelines
/ Play Console policies before submitting, since store policy specifics do
shift over time.

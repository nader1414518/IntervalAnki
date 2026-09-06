# Product Requirements Document: Interval
### A Flutter-based Spaced Repetition Learning App

**Version:** 1.0
**Status:** Draft
**Owner:** Product

---

## 1. Overview

Interval is a cross-platform (iOS/Android, with tablet and eventual desktop support) flashcard app built on spaced repetition, functionally equivalent to Anki but with a modern, friction-free UI/UX. It targets Anki's power (algorithm accuracy, customization, data ownership) while fixing its biggest complaint: a dated, confusing interface.

**Vision statement:** "Anki's brain, in an app people actually enjoy opening every day."

---

## 2. Goals & Non-Goals

### Goals
- Full feature parity with Anki's core study loop (cards, decks, scheduling, stats, sync).
- Import/export compatibility with `.apkg` files so Anki users can migrate freely.
- A UI/UX that feels like a modern consumer app (Duolingo-level polish), not a database front-end.
- Fast, offline-first local storage with reliable optional cloud sync.
- Accessible to both casual learners (language, trivia) and power users (med/law students with 10k+ card decks).

### Non-Goals (v1)
- Third-party add-on/plugin ecosystem (Anki's biggest differentiator for power users) — planned post-v1.
- Desktop-first authoring experience (mobile-first; desktop web companion is phase 3).
- AI-generated flashcards (candidate for v2, not core parity requirement).

---

## 3. Target Users

| Persona | Description | Key Need |
|---|---|---|
| Medical/Law student | Studies 500–2000+ cards/day across shared decks (AnKing, etc.) | Speed, reliability, large deck performance |
| Language learner | Daily habit, audio/image-heavy cards | Delightful daily ritual, streaks, media playback |
| Existing Anki user | Frustrated with Anki's UI, wants to switch | Import fidelity, algorithm trust, no data loss |
| Casual trivia/hobbyist | Small decks, infrequent power features | Zero setup friction, simple onboarding |

---

## 4. Core Feature Set (Parity with Anki)

### 4.1 Decks & Organization
- Create, rename, delete, nest decks (sub-decks via `Parent::Child` naming, shown as a real tree in UI).
- Deck options: new cards/day limit, review limit, learning steps, ease settings — per deck or shared presets.
- Move cards between decks; bulk deck operations.
- Filtered/custom study decks (build a temporary deck from search criteria: due date, tags, flags).

### 4.2 Note Types & Card Templates
- Built-in note types: Basic, Basic (and reversed), Basic (type-in-answer), Cloze deletion, Image Occlusion.
- Custom note type builder: define fields, card templates (front/back HTML+CSS), multiple card generation per note.
- Field types support: text, rich text, LaTeX rendering, audio, image, video.
- Template editor with live preview (side-by-side, not Anki's separate-window hunt).

### 4.3 Card Creation & Editing
- Rich text editor: bold/italic/underline, cloze wrapping, superscript/subscript, colored text, bullet/numbered lists.
- Media embedding: camera capture, gallery picker, audio recording, drawing/annotation on images.
- LaTeX support (rendered inline, not link-out).
- Image Occlusion tool: draw masks directly over an image, auto-generate one card per mask or grouped.
- Duplicate detection on note creation.
- Batch add mode (rapid entry without leaving the add screen).

### 4.4 Spaced Repetition Engine
- FSRS (Free Spaced Repetition Scheduler) as default algorithm — more accurate than legacy SM-2, matches modern Anki.
- Legacy SM-2 available as a compatibility/import mode.
- Per-card scheduling data: stability, difficulty, retrievability, due date, interval, ease factor, lapses.
- Configurable: desired retention %, learning/relearning steps, max interval, fuzz factor.
- Manual scheduling override (set due date directly).

### 4.5 Study Session
- Standard review flow: show question → reveal answer → grade (Again/Hard/Good/Easy).
- Undo last answer (single-tap, always available during session).
- Bury/suspend cards and notes.
- Flags (color-coded, 7 colors) for marking cards during review.
- Keyboard-free full gesture support: swipe to grade, tap to reveal (see UX section).
- Audio auto-play with configurable timing; TTS fallback for text fields.
- "Preview" mode to review without affecting scheduling.

### 4.6 Browse & Search
- Full card browser: table view, sortable columns (due, ease, lapses, deck, tags, note type).
- Anki-compatible search syntax (`deck:`, `tag:`, `is:due`, `flag:`, boolean operators) plus a friendly visual filter builder for non-power-users.
- Bulk actions: reschedule, suspend, delete, change deck, change note type, add/remove tags.
- Tag management: hierarchical tags, tag renaming/merging, autocomplete.

### 4.7 Statistics
- Per-deck and global stats: reviews/day, time studied, retention rate, forecast (upcoming due load), ease distribution, card maturity breakdown (new/learning/young/mature).
- Streaks and heatmap calendar (contribution-graph style).
- Exportable stats (CSV).

### 4.8 Import / Export
- Full `.apkg` and `.colpkg` import (notes, media, scheduling data, deck structure, note types).
- Export to `.apkg` for backup or sharing decks.
- CSV/text import/export with field mapping UI.
- Shared deck compatibility with popular community decks (AnKing, etc.) verified in QA.

### 4.9 Sync
- Account-based cloud sync (own backend, not dependent on AnkiWeb) — end-to-end encrypted option.
- Conflict resolution: last-write-wins with a merge-review screen for genuine conflicts.
- Manual "sync now" plus automatic background sync.
- Full offline functionality; sync is optional, not required.

### 4.10 Notifications & Habits
- Daily study reminders (customizable time, smart nudge if no cards done by evening).
- Streak tracking with freeze/protection mechanic.
- Widget support (home screen: cards due count, one-tap into review).

### 4.11 Settings & Customization
- Light/dark/system theme, plus optional custom accent colors.
- Font size/family controls for card rendering.
- Answer button layout customization (2–4 buttons, position).
- Backup management (automatic local backups, manual export).

---

## 5. UI/UX Differentiators (vs. Anki)

This is the product's core value proposition — parity alone isn't enough to win users.

1. **Onboarding**: guided first-deck creation, sample cards, and a "your first review" walkthrough — Anki has none of this.
2. **Gesture-first review**: swipe right = Good, swipe left = Again, swipe up = Easy, tap = reveal. Button mode available as an accessibility/preference toggle, not the only option.
3. **Visual hierarchy**: card content is the hero — minimal chrome during review, progress bar instead of raw new/learn/review counts (with an "advanced counts" toggle for power users who want the old view).
4. **Unified add/edit flow**: one bottom-sheet-based editor for adding cards, instead of Anki's separate modal-heavy windows.
5. **Deck home screen**: card-style deck list with progress rings (like Duolingo's skill tree) instead of a plain table.
6. **Micro-animations**: subtle transitions on card flip, answer feedback (color pulse on grade), streak celebrations — reinforcing habit without being gimmicky.
7. **Simplified settings**: progressive disclosure — basic settings up front, "Advanced" section for Anki-power-user options (fuzz, ease factors, etc.) so casual users aren't scared off.
8. **In-context help**: tooltips and inline explainers for scheduling concepts (e.g., "Why is this card due in 4 days?") instead of requiring a manual/wiki lookup.
9. **Search that doesn't require syntax knowledge**: visual filter chips build the query string live, with the raw syntax visible/editable for power users.

---

## 6. Technical Architecture (High-Level)

- **Framework**: Flutter (single codebase, iOS + Android; Material 3 + custom design system, not stock widgets).
- **Local storage**: SQLite via Drift (type-safe queries, migration support) — schema designed for Anki `.apkg` compatibility mapping.
- **State management**: Riverpod.
- **Scheduling engine**: FSRS implemented as a pure Dart package (portable, testable, no platform dependency) with legacy SM-2 module for import compatibility.
- **Media storage**: local file storage, referenced by hash (dedup, matching Anki's media model).
- **Sync backend**: custom API (language TBD by eng) with encrypted blob storage for media; conflict resolution via vector clocks or updated-at timestamps per note/card.
- **Rendering**: WebView or custom renderer for card templates (HTML/CSS/JS subset) to preserve Anki template compatibility; LaTeX via a Dart-native renderer (e.g., flutter_math) to avoid round-trip latency.

---

## 7. Non-Functional Requirements

- Must handle decks of 50,000+ cards without UI jank (virtualized lists, indexed queries).
- Cold start to first review card in under 2 seconds on mid-range devices.
- Offline-first: 100% of study/creation features work with no network connection.
- Data durability: no data loss on crash mid-review (write-ahead scheduling updates).
- Accessibility: screen reader support, scalable text, minimum touch target sizes, reduced-motion setting.

---

## 8. Success Metrics

- **D30 retention** vs. category benchmark (target: beat typical flashcard-app D30 by 20%+).
- **Import success rate** for `.apkg` files from top 50 community decks (target: 99%+ fidelity).
- **Daily review completion rate** among users who set a daily goal.
- App store rating ≥ 4.6, with UI/UX explicitly cited as a positive in reviews.
- Net Promoter Score among self-identified "switched from Anki" users.

---

## 9. Rollout Plan (Phased)

| Phase | Scope |
|---|---|
| Phase 1 (MVP) | Decks, basic + cloze note types, FSRS scheduling, review flow, browse/search, local-only (no sync), `.apkg` import |
| Phase 2 | Cloud sync, statistics dashboard, image occlusion, custom note types, notifications/streaks |
| Phase 3 | Widgets, `.apkg` export, CSV import/export, tablet-optimized layout, desktop companion web app |
| Phase 4 | Add-on/extension API, AI-assisted card generation, collaborative/shared decks marketplace |

---

## 10. Monetization

Interval is **100% free** — every feature described in this document (including cloud sync, statistics, unlimited decks/cards, and all future phases) is available to all users at no cost, with no paywalls, tiers, or feature gating.

- **Model**: optional, voluntary donations only.
- **Mechanism**: a "Support Interval" entry in Settings linking to a donation flow (e.g., one-time or recurring via Stripe/Ko-fi/GitHub Sponsors — platform TBD by eng/legal, chosen to minimize App Store/Play Store in-app-purchase fee cuts where policy allows).
- **No dark patterns**: no donation prompts during study sessions, no nagging modals, no artificial friction to nudge donations. At most a single, dismissible, infrequent mention (e.g., once after a milestone like a 30-day streak) plus the always-available Settings entry.
- **Transparency**: consider a public "where funds go" note (hosting/sync infra costs, development time) to build trust, especially with the ex-Anki audience who values openness.
- **Rationale**: removing monetization friction supports the core positioning ("Anki's brain, better UX") without alienating users who are switching specifically to escape cost or ecosystem lock-in; donations fund the optional cloud sync infrastructure (the one component with recurring operating cost).
- **Non-goals**: no ads, no data-selling, no premium tier, no "sync requires subscription" model.

---

## 11. Risks & Open Questions

- **Algorithm trust**: power users will scrutinize FSRS implementation correctness against upstream — needs rigorous unit testing against reference outputs.
- **Template rendering fidelity**: community decks use custom HTML/CSS/JS; imperfect rendering could break imported decks — needs a broad compatibility test suite.
- **Sync infrastructure cost**: media-heavy decks (audio/image) at scale could be expensive to host — needs storage tiering/limits strategy.
- **Open question**: Do we build our own sync backend from day one, or launch local-only and add sync in Phase 2 to reduce initial scope? (Recommendation: local-only MVP, per phased plan above.)
- **Open question**: How much of Anki's add-on ecosystem do we need to replicate to retain power users long-term, and via what mechanism (JS plugin API vs. Dart packages)?
- **Funding sustainability risk**: donation-only revenue may not cover sync/storage costs at scale — needs a fallback plan (e.g., storage caps for free sync, with donors getting higher caps as a thank-you rather than a paywall).

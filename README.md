# Interval

A modern, Anki-compatible spaced repetition app built with Flutter. See
[`anki-clone-flutter-prd.md`](./anki-clone-flutter-prd.md) for the product
requirements.

## Workspace layout

This is a [Dart pub workspace](https://dart.dev/tools/pub/workspaces) managed
with [melos](https://melos.invertase.dev):

- `app/` — the Flutter application.
- `packages/fsrs/` — pure-Dart FSRS scheduling engine.
- `packages/anki_format/` — `.apkg` parsing and Anki schema mapping.
- `packages/card_template/` — Anki-compatible card template renderer.

## Tooling

The Flutter/Dart SDK version is pinned via [fvm](https://fvm.app) in
`.fvmrc`. Always use `fvm flutter` / `fvm dart` (not a global install) so
everyone builds against the same SDK version:

```bash
fvm install   # first time only, installs the pinned SDK
fvm flutter pub get
fvm flutter run
```

Workspace-wide commands run through melos (activate once with
`dart pub global activate melos`, then run from the repo root):

```bash
dart pub get          # resolves the whole workspace
melos run analyze     # static analysis, every package
melos run test        # tests for the pure-Dart packages
melos run test:app    # widget/unit tests for the Flutter app
```

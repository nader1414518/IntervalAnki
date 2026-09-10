# Interval

Local-first spaced-repetition app — see [the root README](../README.md) for the
overall project, and [`../anki-clone-flutter-prd.md`](../anki-clone-flutter-prd.md)
for the product spec.

This is the Flutter front-end. The rest of the workspace is a Dart pub workspace:

- `../packages/fsrs/` — the FSRS scheduling engine (the only scheduler this
  app uses; SM-2 is intentionally not supported).
- `../packages/anki_format/` — `.apkg` import and Anki schema mapping.
- `../packages/card_template/` — Anki-compatible card template renderer.

## Run

This project pins its Flutter version via [fvm](https://fvm.app) — always use
`fvm flutter`, not a global install:

```bash
fvm install                  # one time
fvm flutter pub get
fvm flutter run -d "iPhone 17 Pro"
```

## Test

```bash
fvm flutter test
```

## App Store listing

All the metadata, copy, and privacy policy for the App Store / Google Play
submissions lives at `../store/`. The `store/listing.md` file is the source of
truth for the App Store Connect fields.

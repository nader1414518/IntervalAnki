# Interval — Store Listing Metadata

Copy-paste source for App Store Connect and Google Play Console. Character
counts are noted next to every field with a hard limit — verify against the
current console before submitting, since store limits do shift over time.

Privacy Policy URL (both stores): **https://nadersayed.github.io/interval-privacy/**
Support contact (both stores): **nader19113118@gmail.com**

---

## App Store Connect (iOS)

**App name** (30 char max) — 8 chars
```
Interval
```

**Subtitle** (30 char max) — 23 chars
```
FSRS-Powered Flashcards
```

**Promotional text** (170 char max, editable without a new review) — 149 chars
```
FSRS-powered flashcards, fully offline. Bring your own .apkg decks. Image occlusion, audio cards, and a free 2-freeze streak for every week of consistency.
```

**Keywords** (100 char max, comma-separated) — 98 chars
```
flashcards,spaced repetition,srs,study,fsrs,memory,cloze,vocabulary,offline,local,privacy,medicine,law
```

**Category**
- Primary: Education
- Secondary: Productivity

**Age rating:** 4+ (no objectionable content — the questionnaire should come back clean; nothing in the app collects user-generated content that's shared with others, since there's no social/sharing feature)

**Copyright**
```
© 2026 Nader Sayed
```

**Description** (4000 char max) — see [description.md](description.md) (shared with Google Play's full description; App Store has no separate "short description" field, so the first ~3 lines before the fold matter most — keep the opening paragraph strong)

**Support URL** (required by App Store Connect)
- Either point to a `support.html` page on the same domain as the privacy policy, or use the same GitHub Pages URL until a custom domain is set up.
- Recommended: `https://nadersayed.github.io/interval-privacy/support.html` (add that page when you publish the privacy policy site).

---

## Google Play Console (Android)

**App name** (30 char max) — 8 chars
```
Interval
```

**Short description** (80 char max) — 79 chars
```
FSRS-powered spaced repetition flashcards. Fully offline. No account, no tracking.
```

**Full description** (4000 char max): see [description.md](description.md)

**Category**
- Application type: Apps
- Category: Education

**Contact details**
- Email: nader19113118@gmail.com
- Privacy policy: https://nadersayed.github.io/interval-privacy/

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

---

## Privacy policy — publish in five minutes on GitHub Pages

Apple rejects apps whose privacy URL isn't permanently accessible. The previous
`claude.ai/code/artifact/...` URL is not acceptable. The fastest durable fix is
a one-page site on GitHub Pages. Steps:

1. Create a new **public** repo under your GitHub account, named
   `interval-privacy` (or any name you like — the URL is
   `https://<username>.github.io/<repo>/`).
2. In that repo, on the default branch, add a file `index.html` with the
   contents below. The markup is plain HTML; the body is copied from
   [`privacy_policy.md`](privacy_policy.md).
3. In the repo's **Settings → Pages**, set the source to "Deploy from a
   branch" → the default branch → `/ (root)`. Save. After a minute, the site
   is live at `https://nadersayed.github.io/interval-privacy/`.
4. Paste that URL into App Store Connect (Privacy Policy) and Google Play
   Console (Data safety). Done.
5. (Optional) Once a real domain is owned, point a `privacy.<your-domain>`
   subdomain at the same GitHub Pages site, and update the App Store / Play
   listings to that.

`index.html` to commit (this is the entire file):

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Interval Privacy Policy</title>
<style>
  body { font: 16px/1.6 -apple-system, system-ui, sans-serif;
         max-width: 720px; margin: 2rem auto; padding: 0 1rem; color: #222; }
  h1 { font-size: 1.6rem; }
  h2 { font-size: 1.2rem; margin-top: 1.6rem; }
  table { border-collapse: collapse; width: 100%; }
  td, th { border: 1px solid #ccc; padding: 0.4rem 0.6rem; text-align: left; }
  th { background: #f5f5f5; }
  code { background: #f5f5f5; padding: 0 0.3em; border-radius: 3px; }
</style>
</head>
<body>

<h1>Interval Privacy Policy</h1>
<p><em>Last updated September 10, 2026</em></p>

<h2>In short</h2>
<p>Interval keeps your flashcards, study history, and settings <strong>on your
device only</strong>. There is no account, no server, and nothing about your
decks or your study activity is sent anywhere.</p>
<ul>
  <li>No analytics, tracking, advertising, or third-party SDKs of any kind.</li>
  <li>No account or sign-in — there's nothing to link your data to.</li>
  <li>Camera, photo, and microphone access are used only to attach media to
      your own cards, and only when you choose to.</li>
</ul>

<h2>What Interval stores, and where</h2>
<p>Everything you create in Interval — decks, cards, note types, tags,
review history, streaks, and app settings — is stored in a local database
on your device. It is never transmitted to us or to any third party,
because Interval has no backend server to send it to.</p>
<p>If you turn on automatic backups, or use manual export, those backup
files are written to your device's own storage (or wherever you choose
to save them). We never see them.</p>

<h2>Permissions Interval may ask for</h2>
<table>
  <tr><th>Permission</th><th>Why Interval asks</th></tr>
  <tr><td>Camera</td><td>Attach a photo you take to a flashcard</td></tr>
  <tr><td>Photo library</td><td>Attach an existing photo to a flashcard</td></tr>
  <tr><td>Microphone</td><td>Record audio for an audio flashcard</td></tr>
  <tr><td>Notifications</td><td>Send the daily study reminder you opt into</td></tr>
</table>
<p>Each of these is only used when you take the action that triggers it
(opening the camera, recording audio, picking a photo, toggling the
reminder on). You can revoke any of them in iOS Settings / Android
Settings at any time, and the corresponding feature will simply stop
working.</p>

<h2>Children's privacy</h2>
<p>Interval does not collect any data from anyone, including children. The
app is suitable for all ages.</p>

<h2>Changes to this policy</h2>
<p>If we ever change this policy we'll update the date at the top and, for
material changes, surface a notice inside the app on next launch.</p>

<h2>Contact</h2>
<p>Questions? Email <a href="mailto:nader19113118@gmail.com">nader19113118@gmail.com</a>.</p>

</body>
</html>
```

---

## Submission checklist (re-submission after a 4.3(a) — Spam rejection)

1. Bundle id on iOS: `com.sayed.interval`. On Android: `applicationId = "com.sayed.interval"`. (The previous `com.ec.interval` was a generic two-letter prefix and read as a template throwaway.)
2. App icon: `app/assets/icon/icon.png` is a custom "Interval" mark — keep it. (Verify in the iOS / Android build outputs that the icon is the custom one, not the default Flutter "F".)
3. Launch screen: `app/ios/Runner/Base.lproj/LaunchScreen.storyboard` is now a branded, accent-coloured screen with the "Interval" wordmark. (Replaces the default white Flutter launch screen.)
4. iOS privacy manifest: `app/ios/Runner/PrivacyInfo.xcprivacy` is in the bundle. (Required since spring 2024.)
5. Privacy policy URL on App Store Connect and Google Play: `https://nadersayed.github.io/interval-privacy/` (publish per the section above).
6. No competitor's name (Anki) anywhere in App Store Connect metadata — see the keyword, subtitle, promo text, and description above.
7. Copyright on App Store Connect: `© 2026 Nader Sayed` (a real entity, not the app name).
8. Reply in the App Store Connect Resolution Center with the angle taken (FSRS + local-first), the changes made, and the new privacy policy URL.

## Notes on the app's differentiator

The position this app competes on, and the one that's both provable from the
binary and useful to a reviewer, is: **FSRS-only scheduling, fully local, no
account, no network, no third-party SDKs**. The first claim is a factual
property of the code (the FSRS scheduler is the only one; SM-2 is not
shipped). The second is a factual property of `pubspec.yaml` (no analytics
or networking dependencies) and the iOS privacy manifest. The third is a
factual property of the architecture (no backend, no sign-in). All three
hold up to review and are the line to lead with in any rejection reply.

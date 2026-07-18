# CourtU

Campus pickup-sports app for UT Dallas. V1 = volleyball courts on a live
map with check-ins. Deadline: Aug 24, 2026 (first day of UTD fall semester).

## Stack — do not deviate without approval
- **Flutter** (Dart SDK ^3.12.1). UI scaled with flutter_screenutil against
  a 375×812 design frame — always use `.w/.h/.sp/.r` units.
- **Firebase**: Auth (live today). Firestore + FCM are planned for check-in
  data and notifications but are NOT yet in pubspec — do not add them
  without an explicit approved plan.
- **Mapbox Maps SDK** via `mapbox_maps_flutter` — the *Maps* SDK only.
  NEVER add the Mapbox Navigation SDK; turn-by-turn is out of scope.
- Fonts via google_fonts: barlowCondensed (headlines, w900),
  dmSans (body), jetBrainsMono (tags/labels/counts).
- Colors: `lib/theme/colors.dart` (`AppColors`). Never hardcode hex values
  in screens; add to AppColors if a new color is truly needed.

## Branch rules — non-negotiable
- **NEVER commit or push to `main`.** Samer owns main and reviews PRs.
- All work happens on `pablo-ux` or feature branches off it
  (currently `fable-hail-mary`). Ask before creating new branches.

## Secrets & running
- Mapbox public token lives in `config/secrets.json` (gitignored).
  Template: `config/secrets.example.json`.
- Run: `flutter run -d emulator-5554 --dart-define-from-file=config/secrets.json`
- Android native builds also need a Mapbox *secret* download token
  (Downloads:Read scope) in gradle.properties — see docs/ROADMAP.md.
- iOS builds happen ONLY on Samer's Mac. Nothing iOS-build-related on
  this Windows machine.

## Working style (Pablo is non-technical)
- Explain every technical decision in plain language, with a one-sentence
  translation of any jargon, BEFORE implementing.
- One step at a time: one-paragraph plan → wait for explicit go-ahead →
  change → tell Pablo exactly what to run/press to SEE the result on the
  emulator (Pixel 10, emulator-5554).
- Mark guesses/unverified claims as such in the same sentence.
- Flag iOS/Android behavioral or visual differences before proceeding.

## V1 NON-GOALS — deliberately post-v1, do not build, suggest, or scaffold
- Streaks / badges
- Background location
- Multi-campus support
- Chat / friends
- Score keeper
- Roulette / invite rewards
- Leaderboards
- Character PNG assets (hats/pets/skins — current avatar is drawn in code)

If a task drifts toward any of these, stop and say so instead of building it.

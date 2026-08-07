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
- Fonts via google_fonts: **Poppins** for headlines and body,
  **jetBrainsMono** for tags/labels/counts (fixed-width, so live-updating
  digits don't jitter). Defined once in `lib/theme/app_theme.dart` —
  change the font there, not in screens. (Replaced the old
  barlowCondensed/dmSans/arimo mix in Aug 2026.)
- Colors: light and dark palettes live in `lib/theme/colors.dart`.
  Screens read the current mode's colors via `context.colors.<slot>`
  (background, surface, surfaceAlt, border, textPrimary, textSecondary,
  accent, steel, steelLight) — NEVER `Colors.black`/`Colors.white`/hex
  literals, which don't switch with the theme.
  `AppColors.*` is only for values identical in both modes (brand, status,
  sport). Its legacy block is for three dead files; do not use it in new code.

## UI map — where things live
Read this before reading commits. It's the fast way to tell what a UI
change touched without opening every diff.
- **Screens** — `lib/screens/`, one file (or subfolder) per screen.
  `profile_setup/` holds the multi-step flow; each step is its own file
  under `profile_setup/steps/`.
- **Shared widgets** — `lib/widgets/`. Reused across 2+ screens, so a
  change here ripples wider than a single-screen edit:
  - `gradient_button.dart` — the steel-gradient CTA button (onboarding,
    profile setup).
  - `step_dot_indicator.dart` — the step-progress dots (onboarding,
    profile setup).
  - `auth_field.dart` — text input used on sign-in/sign-up.
  - `sso_block.dart` — Google / university SSO button pair.
  - `logo_wordmark.dart` — the app logo mark.
- **Theme** — `lib/theme/`:
  - `colors.dart` — the only file with color hex values. `AppColorScheme`
    holds the light/dark slots screens read via `context.colors.*`;
    `AppColors` holds brand/status/sport colors that don't change with
    theme.
  - `app_theme.dart` — fonts (Poppins, jetBrainsMono) and `ThemeData`
    wiring. Change a font here, not in a screen.
  - `theme_controller.dart` — persists the user's Light/Dark/System
    choice via `shared_preferences` and notifies the app on change.
- **Config** — `lib/config/mapbox_config.dart` (Mapbox style URLs, incl.
  light/dark map styles).

If a change is confined to one screen file, it's cosmetic to that screen.
If it touches `lib/widgets/` or `lib/theme/`, expect it to affect
multiple screens — those are the files worth a closer look in review.

## Branch rules — non-negotiable
- **NEVER commit or push to `main`.** Samer owns main and reviews PRs.
- All work happens on `pablo-ux` or feature branches off it
  (currently `fable-hail-mary`). Ask before creating new branches.

## Commit conventions — applies going forward, do not rewrite past history
- One logical change per commit. Never bundle unrelated work into one
  commit (e.g. a `.gitignore` fix riding inside a feature commit).
- Format: `type(scope): what changed`
  ```
  feat(map): switch Mapbox style with light/dark theme
  fix(signup): status bar icons now follow theme
  chore(gitignore): exclude config/secrets.json
  refactor(theme): replace fixed AppColors with context.colors
  ```
  Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `build`.
- Config and dependency changes get their own commit, never bundled into a
  feature commit. Applies to `.gitignore`, `pubspec.yaml`,
  `build.gradle.kts`, `AndroidManifest.xml`, `Info.plist`.
- If a commit message needs "and", it's probably two commits.
- Body: one or two plain-English lines on WHY, not what — the diff already
  shows what.

## Secrets & running
- Mapbox public token lives in `config/secrets.json` (gitignored).
  Template: `config/secrets.example.json`.
- Run: `flutter run -d emulator-5554 --dart-define-from-file=config/secrets.json`
- Android native builds also need a Mapbox *secret* download token
  (Downloads:Read scope) in gradle.properties — see docs/ROADMAP.md.
- iOS builds happen ONLY on Samer's Mac. Nothing iOS-build-related on
  this Windows machine.
- If a build fails with "Unresolved reference" errors inside
  `mapbox_maps_flutter`'s own Kotlin source (e.g. `MapboxMapController.kt`
  can't resolve `CameraController`/`CompassController`/`ViewportController`,
  which sit right next to it in the same package), delete
  `build/mapbox_maps_flutter/` only — not the whole `build/` tree, not
  `.gradle`, not the pub cache — then rebuild. This is a stale incremental
  Kotlin compile cache, not a real version/config problem: pub occasionally
  re-extracts the plugin into the pub cache (all its source files get a
  fresh mtime) without changing the resolved version, and the incremental
  compiler's old bookkeeping (from the previous extraction) gets out of
  sync with the "new" files, so it doesn't recompile everything it needs
  to. Confirmed Aug 2026: plugin source mtimes matched the moment
  `.dart_tool/package_config.json` was last regenerated, while
  `build/mapbox_maps_flutter/kotlin/compileDebugKotlin` was ~3 weeks
  stale; deleting just that folder fixed it without touching pubspec.yaml,
  build.gradle.kts, or the pin.
- Known oddity, not currently a problem: `mapbox_maps_flutter` 2.27.0's
  own `android/build.gradle` declares `kotlin_version = '1.8.22'` and adds
  its own `kotlin-gradle-plugin:1.8.22` classpath, while the root
  `android/settings.gradle.kts` applies `org.jetbrains.kotlin.android`
  version `2.3.20`. Two different Kotlin plugin versions are in play for
  the same subproject. Ruled out as the cause of the Aug 2026 build
  failure (see above — that was the stale cache), but if
  `compileDebugKotlin` breaks again and the narrow cache fix above doesn't
  resolve it, this version mismatch is the next thing to look at —
  requires an actual config change, so don't touch it without a plan.
- No way to reach signed-in screens (map, settings, gear icon) during
  manual/agent verification without a live account: there's no Firebase
  emulator hookup (`auth_service.dart` talks straight to the real Firebase
  project), and the dev-only "replay onboarding" button in
  `settings_screen.dart` only works by signing out — see the
  `_DevResetTile` doc comment there for the deferred "replay without
  signing out" task this is paired with. Signing up a throwaway account to
  get past this writes real documents via `createProfile()`
  (`firestore_service.dart`), whose schema is still unsettled with Samer
  and which uses `.set()` without `merge`, so it overwrites whole docs —
  not worth it for a visual check. Not fixed as of Aug 2026; has cost
  verification time twice already.
- Orphaned files — kept on disk, not deleted, so Samer's branch review
  doesn't have to reason about deletions on top of an already-open schema
  conversation:
  - `lib/screens/profile_setup/steps/competitiveness_step.dart` — no
    longer called by `profile_setup_screen.dart` as of the Aug 2026
    two-step redesign (competitiveness was cut from Profile Setup
    entirely). Safe to delete once nobody minds losing it from the diff.
  - `lib/screens/user_profile.dart` — already dead before Aug 2026 (see
    the legacy `AppColors` comment in `colors.dart`), and has now caused
    two wrong-file mixups for whoever's reading it fresh: once over
    displayName/username naming, once over a hat picker that only exists
    in this file and not in the live Profile Setup flow. It's actively
    costing accuracy, not just disk space. Flag as a delete candidate
    once Samer confirms nothing of his depends on it.

## Known-good toolchain
Confirmed working on Pablo's **laptop** (Aug 2026) — the desk **PC**'s
versions aren't yet confirmed to match, so check before assuming parity
if something environment-shaped breaks on one machine and not the other:
- Flutter 3.44.8 (stable channel), Dart 3.12.2
- Java: OpenJDK 21.0.10 (Android Studio's bundled `jbr`, not a separate
  install — `JAVA_HOME` isn't set as a system/user env var on the laptop)
- Android SDK: platform-tools 37.0.0, build-tools 36.0.0, platforms
  34/35/36/36.1
- `JAVA_HOME`, `ANDROID_HOME`, and `ANDROID_SDK_ROOT` are all unset on the
  laptop. `flutter run` doesn't need them — Flutter finds Android Studio's
  bundled JDK on its own — but a raw `gradlew`/`gradlew.bat` command (e.g.
  to run a single Gradle task directly) needs `JAVA_HOME` set first in
  that terminal:
  ```
  $env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
  ```
  Same fix already documented for fresh terminals on the PC.

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

# CourtU

**Campus pickup sports, in real time.** CourtU shows you which volleyball
courts on campus are actually busy right now, so you can stop guessing and
just show up to a real game.

Built for UT Dallas. Flutter · Firebase · Mapbox.

> **Status:** in active development, pre-v1. Targeting first release for the
> start of the UTD fall semester (Aug 24, 2026). See
> [Current status](#current-status) for what works today.

---

## Team

- **[Samer Megla](https://github.com/samermegla)** — Development: Flutter implementation, Firebase auth, Firestore data model, Mapbox GeoLo integration 
- **[Pablo Nguyen](https://www.linkedin.com/in/pablo-nguyen-06pn/)** — Product Design: UX flow, Map Stylist, Feedback Research

---

## The problem

Pickup volleyball on campus runs on rumor. You text a group chat, get no
answer, walk fifteen minutes to the courts, and find them empty — or find
them full with a game you can't join. There's no way to see what's happening
before you commit the walk.

CourtU makes courts visible. Open the app, see a live map of campus, see how
many people are at each court right now, and tap "I'm going" so other people
can see you coming.

---

## Demo

(https://github.com/user-attachments/assets/e252f8dc-997f-4e77-878c-f6bd343f8676)

---

## How it works

The app is one continuous flow, gated on your sign-in state:

| Step | What the user sees |
|---|---|
| **1. Splash** | Animated CourtU logo while Firebase restores your session |
| **2. Onboarding** | Three slides introducing the map, the community, and check-ins |
| **3. Sign up / sign in** | Email + password (with email verification) or Google Sign-In |
| **4. Profile setup** | Two steps: your nickname, then how you play — position, experience level, and preferred court type |
| **5. Welcome** | A brief "Welcome, [nickname]!" hand-off |
| **6. Map** | A custom-styled Mapbox map of campus with each court as a tappable dot |

Instead of navigating imperatively from screen to screen, the top-level UI is
*derived* from Firebase's auth state (`AuthGate` in `lib/main.dart`). Signing
out anywhere in the app drops you back to onboarding automatically, with no
navigation cleanup to get wrong.

---

## Tech stack

| Area | Choice | Why |
|---|---|---|
| **Framework** | Flutter (Dart) | One codebase for iOS and Android |
| **Auth** | Firebase Auth | Email/password with verification, plus Google Sign-In |
| **Database** | Cloud Firestore | Realtime player counts — a check-in appears on everyone's map without polling |
| **Maps** | Mapbox Maps SDK | Custom map styling; the campus map is a hand-tuned Mapbox Studio style, not stock tiles |
| **Location** | geolocator | Locating the user relative to nearby courts |
| **Layout** | flutter_screenutil | Every dimension is authored against a 375×812 design frame and scaled proportionally, so the layout holds on any screen size |
| **Type** | google_fonts | Poppins for headings and body; JetBrains Mono for counts and tags — it's fixed-width, so live-updating digits don't jitter as they change |

### A few decisions worth calling out

- **Full light and dark themes.** Every color lives in one file
  (`lib/theme/colors.dart`) and screens read the current mode's palette
  through `context.colors.<slot>` — no hardcoded colors anywhere in the UI.
  The map itself swaps between two custom Mapbox Studio styles to match, and
  preserves your camera position across the swap so the map doesn't jump back
  to its default framing when the theme changes.
- **The theme choice persists** (Light / Dark / System) via
  `shared_preferences`, and is loaded *before the first frame* so the app
  never flashes the wrong theme on launch.
- **OS text scaling is clamped** to 1.2×, so extreme accessibility font sizes
  can't push tightly-designed screens into overflow.

---

## Project structure

```
lib/
├── main.dart              # App entry + AuthGate (the auth-driven flow)
├── screens/               # One file per screen
│   ├── onboarding_screen.dart
│   ├── signin_screen.dart / signup_screen.dart / verify_email_screen.dart
│   ├── profile_setup/     # Multi-step flow; each step is its own file
│   ├── map_screen.dart    # Mapbox map + court markers
│   └── settings_screen.dart
├── widgets/               # Shared across 2+ screens (buttons, inputs, logo)
├── theme/
│   ├── colors.dart        # The only file with color values
│   ├── app_theme.dart     # Fonts + ThemeData
│   └── theme_controller.dart
├── services/              # Firebase Auth, Firestore, geolocation
└── config/                # Mapbox style URLs
```


## Current status

**Working today:** the full pre-map flow — splash, onboarding, sign up and
sign in (email/password with verification, and Google(bugs WIP)), profile setup, and
the welcome hand-off. The map renders real Mapbox tiles centered on campus in
both the custom light and dark styles, with courts drawn as markers. Light /
dark / system theming works across every screen and persists between launches.

**In progress — the v1 finish line:**

- [ ] Persist profile setup to Firestore, so returning users skip it
- [ ] Venue sheet — tap a court for its name, live player count, and actions
- [ ] Check-in — "I'm going" now or scheduled, auto-expiring after ~2 hours
- [ ] Live player counts syncing across users in realtime
- [ ] Firestore security rules (required before any real check-in data flows)
- [ ] Onboard the rest of the UTD courts (one is in the map data today)
- [ ] AD Free Score Keeper
- [ ] Field-tested location services.
- [ ] Terms and Privacy.
- [ ] Upload to app stores.

**Deliberately out of scope for v1:** streaks and badges, leaderboards,
friends and chat, background location, and multi-sport
support. The goal for launch is that one flow — find a live court, say you're
going, show up — done well.


---

## Running it locally

### What you need first

- **Flutter 3.44+** ([install guide](https://docs.flutter.dev/get-started/install)) —
  confirmed working on Flutter 3.44.8 / Dart 3.12.2
- **Android Studio**, with an emulator created (or a physical Android device
  with USB debugging on)
- A **Mapbox account** (free) for two access tokens — see step 3

You don't need to set up Firebase — the project's Firebase config is already
checked in at `lib/firebase_options.dart`.

### 1. Clone and install dependencies

```bash
git clone https://github.com/samermegla/CourtU.git
cd CourtU
flutter pub get
```

### 2. Confirm Flutter sees your device

```bash
flutter devices
```

You should see your emulator listed (e.g. `emulator-5554`). If nothing shows
up, start an emulator from Android Studio's Device Manager first.

### 3. Add your Mapbox tokens

The map needs **two different tokens** from
[account.mapbox.com](https://account.mapbox.com/access-tokens/). This trips
people up, so to be explicit:

**a) The public token** — used by the app at runtime to load map tiles.
Copy the template and paste your token in:

```bash
cp config/secrets.example.json config/secrets.json
```

```jsonc
// config/secrets.json
{
  "MAPBOX_ACCESS_TOKEN": "pk.your_public_token_here"
}
```

This file is gitignored — your token never gets committed.

**b) The secret download token** — used by Gradle at *build* time to download
the Mapbox Android SDK. Create a token with the **`Downloads:Read`** scope
(it starts with `sk.`), then add it to your global Gradle properties, **not**
to this repo:

```
# ~/.gradle/gradle.properties   (Windows: C:\Users\<you>\.gradle\gradle.properties)
MAPBOX_DOWNLOADS_TOKEN=sk.your_secret_token_here
```

Without this, the Android build fails when it tries to resolve the Mapbox
SDK from Mapbox's authenticated Maven repo.

### 4. Run

```bash
flutter run -d emulator-5554 --dart-define-from-file=config/secrets.json
```

Swap `emulator-5554` for whatever `flutter devices` listed.

Once it's running, press `r` in the terminal to hot reload after a change,
`R` to hot restart, `q` to quit.

### Troubleshooting

- **Lots of `com.mapbox.common ClassNotFoundException` lines in the log at
  startup.** Expected and harmless — Mapbox probes for optional components
  that aren't bundled. The map renders fine through it. Don't chase it.
- **Build fails with "Unresolved reference" errors inside
  `mapbox_maps_flutter`'s own Kotlin source.** This is a stale incremental
  compile cache, not a version problem. Delete **only**
  `build/mapbox_maps_flutter/` and rebuild — not the whole `build/` folder,
  not `.gradle`, not the pub cache.
- **`gradlew` can't find Java.** Flutter finds Android Studio's bundled JDK
  on its own, but a raw Gradle command needs `JAVA_HOME` set in that
  terminal first:
  ```powershell
  $env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
  ```

---


## License

Not currently licensed for reuse. All rights reserved.

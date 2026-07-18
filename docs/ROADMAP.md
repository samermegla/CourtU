# CourtU Roadmap

Product vision: make campus pickup volleyball frictionless — see which
courts are live, say "I'm going," and show up to a real game.

## V1 — deadline Aug 24, 2026 (first day of UTD fall semester)

Full user flow, in order:
1. **Loading / splash** → logo moment
2. **Onboarding** → 3-slide intro (map, connect, play)
3. **Sign in / sign up** → email+password (verify email) or Google
4. **Profile setup** (once per account): nickname → avatar builder
   (skin tone / hairstyle / jersey) → position → experience → intensity
5. **Welcome screen** — "Welcome, [nickname]!" on every boot
6. **Map home screen** — dark custom-styled Mapbox map of UTD campus with
   highlighted, tappable volleyball courts
7. **Venue sheet** — bottom sheet with court name, live player count,
   check-in actions
8. **Check-in** — "I'm going" now, or scheduled for a set time;
   sessions auto-expire after ~2 hours
9. **Live counts** — other users see counts update in realtime (Firestore)
10. **Basic settings** — minimal; sign out, little else

## Post-V1 — explicitly OUT of scope for now
- Score keeper tab
- Groups
- Personalization / privacy settings expansion
- Friends + chat
- Character PNGs (hats, pets, skins)
- Invite → roulette wheel reward
- Local popularity / commendations

## Known state (honest, as of Jul 18, 2026)
- **Profile data is in-memory only** — deliberate; resets every boot.
  Persisting to Firestore `users/{uid}` is a planned, separate step.
- **Firestore security rules NOT written.** MUST be written before any
  real check-in data flows. Firestore itself is not yet a dependency.
- **Firebase Blaze plan + billing alert status: unconfirmed.**
- **Google Sign-In on Android**: known "[16] Account reauth failed"
  issue with Samer's account. Unresolved.
- **Onboarding slide 1**: unresolved 19px overflow.
- **Mapbox secret download token missing** — confirmed absent from
  android/gradle.properties; last build log showed ClassNotFoundException
  spam. Must be fixed before the map can render (Task 2).
- Map wiring (welcome → MapScreen) approved but never visually confirmed
  on the emulator.

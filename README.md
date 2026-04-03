# Standawaker

Standawaker is a small iOS SwiftUI app that mimics an always-on StandBy screen for older iPhones.

Important limitation:
- Third-party apps cannot force Apple's built-in iOS StandBy mode to stay on.
- This app provides a full-screen clock UI and keeps the display awake while the app is open.

## What this app does

- Swipeable multi-page StandBy-style layout (`Clock`, `Widgets`, `Photos`)
- Large landscape digital clock with optional seconds and 24-hour mode
- Full selectable color set (`Crimson`, `Orange`, `Amber`, `Lime`, `Emerald`, `Cyan`, `Cobalt`, `Indigo`, `Violet`, `Magenta`, `Slate`, `Mono`)
- Widget-style cards for date, time, battery, and charging status
- Photo slideshow page using in-app Photos picker
- Night red-tint mode (manual or automatic by time)
- Adjustable dimmer overlay for dark rooms
- Motion parallax and subtle drift to reduce static burn-in feel
- Forces screen awake while active using `UIApplication.shared.isIdleTimerDisabled`

## What this app cannot do

- It cannot hook, patch, or replace Apple's internal StandBy private frameworks.
- It cannot show lock-screen-only private widgets exactly as the system does.
- It cannot wake itself from locked/sleep state like system StandBy on supported hardware.

## Build and sideload (no Mac)

You can build a single `.ipa` file using GitHub Actions (Apple cloud runners):

1. Upload this folder to a GitHub repo.
2. In GitHub, open `Actions` tab.
3. Run workflow: `Build Unsigned IPA`.
4. When it finishes, download artifact: `Standawaker-unsigned-ipa`.
5. Extract it and use `Standawaker-unsigned.ipa` in Sideloadly on Windows.

## Build and sideload (with Mac)

1. On a Mac, create a new iOS App project in Xcode named `Standawaker` (SwiftUI, Swift, iOS 16+).
2. Or generate a project from this repo with `xcodegen generate`.
3. If you made your own project, replace the generated Swift files with the files in this repo.
4. In target settings:
   - Set supported iPhone orientations to landscape left/right.
   - Enable full screen only (`Requires full screen`).
5. Set your team and bundle identifier in Signing & Capabilities.
6. Open Terminal in the repo and run:
   - `chmod +x scripts/make_ipa.sh scripts/make_ipa.command`
   - `./scripts/make_ipa.sh`
7. Your single upload file will be created at:
   - `build/Standawaker.ipa`
8. Load that file into Sideloadly.

## Distributing to other people

- For normal Apple IDs, each person should sideload/sign the app with their own account.
- Pre-signed IPAs are usually short-lived and tied to the signer's certificates.

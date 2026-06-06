# Self-Build Pro

This repository is GPL-3.0 and can be built locally. The self-build Pro path compiles a Release app with `SELF_BUILD_PRO`, which starts the app in the Pro state without using the license server.

## Prerequisites

- Xcode command line tools available through `xcodebuild`
- A local code-signing identity named `Local Self-Signed`

Create the signing identity once:

```bash
scripts/codesign/setup_local.sh
```

macOS may ask you to approve trusting the generated certificate. Approve it, then confirm the identity is visible:

```bash
security find-identity -v -p codesigning
```

The output should include `Local Self-Signed`.

## Build

```bash
bash ai/build-self-pro.sh
```

The app is produced at:

```bash
DerivedData/Build/Products/Release/AltTab.app
```

The script builds the Release scheme with `SELF_BUILD_PRO`, then signs the final app with `Local Self-Signed`.

Self-built Pro disables Sparkle startup. That means automatic update checks, automatic downloads/installs, and manual update checks do not run in this build.

## Verify

```bash
codesign --verify --deep --strict --verbose=2 DerivedData/Build/Products/Release/AltTab.app
```

The output should end with:

```text
DerivedData/Build/Products/Release/AltTab.app: valid on disk
DerivedData/Build/Products/Release/AltTab.app: satisfies its Designated Requirement
```

## Install Over an Existing AltTab

You can install the self-built app over an existing AltTab because it keeps the same bundle identifier, `com.lwouis.alt-tab-macos`. Quit AltTab first, then replace `/Applications/AltTab.app` with the built app.

Recommended manual flow:

1. Quit AltTab from the menu bar.
2. Keep a copy of the current `/Applications/AltTab.app` if you want an easy rollback.
3. Drag `DerivedData/Build/Products/Release/AltTab.app` into `/Applications`.
4. Choose Replace when Finder asks.
5. Launch AltTab from `/Applications`.

Because the self-built app is signed by `Local Self-Signed` instead of the official Developer ID, macOS may treat it as a different security identity. You may need to re-grant Accessibility, Screen Recording, or Login Item permissions in System Settings. Existing preferences should remain because the bundle identifier is unchanged.

#!/bin/bash

set -e

xcodebuild \
  -project alt-tab-macos.xcodeproj \
  -scheme Release \
  -configuration Release \
  -derivedDataPath DerivedData \
  SWIFT_ACTIVE_COMPILATION_CONDITIONS=SELF_BUILD_PRO \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGN_IDENTITY="Local Self-Signed"

codesign \
  --force \
  --deep \
  --sign "Local Self-Signed" \
  --timestamp=none \
  --options runtime \
  --entitlements alt_tab_macos.entitlements \
  DerivedData/Build/Products/Release/AltTab.app

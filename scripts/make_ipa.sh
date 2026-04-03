#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./scripts/make_ipa.sh
# Optional env vars:
#   PROJECT_PATH=/path/to/Standawaker.xcodeproj
#   SCHEME=Standawaker
#   TEAM_ID=ABCDE12345
#   BUNDLE_ID=com.yourname.standawaker

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_PATH="${PROJECT_PATH:-$ROOT_DIR/Standawaker.xcodeproj}"
SCHEME="${SCHEME:-Standawaker}"
CONFIGURATION="${CONFIGURATION:-Release}"
TEAM_ID="${TEAM_ID:-}"
BUNDLE_ID="${BUNDLE_ID:-}"

ARCHIVE_PATH="$ROOT_DIR/build/${SCHEME}.xcarchive"
EXPORT_DIR="$ROOT_DIR/build/export"
EXPORT_OPTIONS_PLIST="$ROOT_DIR/build/ExportOptions.plist"
FINAL_IPA_PATH="$ROOT_DIR/build/${SCHEME}.ipa"

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "Missing Xcode project: $PROJECT_PATH"
  echo "Create/open the Xcode app project first, then run this script again."
  exit 1
fi

mkdir -p "$ROOT_DIR/build"
rm -rf "$ARCHIVE_PATH" "$EXPORT_DIR"

EXTRA_BUILD_ARGS=()
if [[ -n "$TEAM_ID" ]]; then
  EXTRA_BUILD_ARGS+=("DEVELOPMENT_TEAM=$TEAM_ID")
fi
if [[ -n "$BUNDLE_ID" ]]; then
  EXTRA_BUILD_ARGS+=("PRODUCT_BUNDLE_IDENTIFIER=$BUNDLE_ID")
fi

echo "Archiving app..."
xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_PATH" \
  clean archive \
  CODE_SIGN_STYLE=Automatic \
  "${EXTRA_BUILD_ARGS[@]}"

cat > "$EXPORT_OPTIONS_PLIST" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>development</string>
  <key>signingStyle</key>
  <string>automatic</string>
  <key>stripSwiftSymbols</key>
  <true/>
  <key>compileBitcode</key>
  <false/>
</dict>
</plist>
PLIST

echo "Exporting IPA..."
xcodebuild \
  -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_DIR" \
  -exportOptionsPlist "$EXPORT_OPTIONS_PLIST"

EXPORTED_IPA="$(find "$EXPORT_DIR" -maxdepth 1 -name "*.ipa" | head -n 1)"

if [[ -z "${EXPORTED_IPA:-}" ]]; then
  echo "Export succeeded but no IPA was found in $EXPORT_DIR"
  exit 1
fi

cp "$EXPORTED_IPA" "$FINAL_IPA_PATH"
echo
echo "Done. Single upload file ready:"
echo "  $FINAL_IPA_PATH"

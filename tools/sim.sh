#!/usr/bin/env bash
set -euo pipefail

# Enchanted Falcon — Launch simulator
# Rebuilds if needed, installs theme, launches the SDL simulator

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build-sim"
ROCKBOX_DIR="$PROJECT_DIR/rockbox"
SIMDISK="$BUILD_DIR/simdisk/.rockbox"

# Kill any existing simulator
pkill -f rockboxui 2>/dev/null || true

# Check if build exists
if [ ! -f "$BUILD_DIR/rockboxui" ]; then
    echo "No simulator build found. Building..."
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    echo "29
S" | "$ROCKBOX_DIR/tools/configure"
    make -j"$(sysctl -n hw.ncpu)"
    make install
fi

# Install/update theme files
echo "Installing Enchanted Falcon theme..."
mkdir -p "$SIMDISK/wps/enchanted-falcon"

# Generate assets if they don't exist
if [ ! -f "$SIMDISK/wps/enchanted-falcon/backdrop.bmp" ]; then
    python3 "$PROJECT_DIR/tools/generate-theme-assets.py"
fi

# Copy backdrop
cp "$SIMDISK/wps/enchanted-falcon/backdrop.bmp" "$SIMDISK/backdrops/enchanted-falcon.bmp" 2>/dev/null || true

# Copy theme files
cp "$PROJECT_DIR/themes/enchanted-falcon.wps" "$SIMDISK/wps/"
cp "$PROJECT_DIR/themes/enchanted-falcon.sbs" "$SIMDISK/wps/"
cp "$PROJECT_DIR/themes/enchanted-falcon.cfg" "$SIMDISK/themes/"

echo "Launching simulator..."
cd "$BUILD_DIR"
./rockboxui &
echo ""
echo "=== Enchanted Falcon Simulator ==="
echo "PID: $!"
echo ""
echo "Controls:"
echo "  Arrow keys  = Clickwheel scroll"
echo "  Enter       = Select (center button)"
echo "  Escape      = Menu"
echo "  +/-         = Volume"
echo "  Insert      = Play/Pause"
echo ""
echo "To navigate to music:"
echo "  Files → Music → select a track"
echo ""
echo "To apply theme manually:"
echo "  Settings → Theme Settings → Browse Theme Files → enchanted-falcon"

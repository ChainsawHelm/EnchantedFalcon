#!/usr/bin/env bash
set -euo pipefail

# Enchanted Falcon — Flash to iPod Classic
# Installs Enchanted Falcon firmware + theme to a connected iPod

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build-ipod"
ZIP="$BUILD_DIR/enchanted-falcon-ipod6g.zip"

echo "=== Enchanted Falcon — Flash to iPod ==="
echo ""

# Check for firmware zip
if [ ! -f "$ZIP" ]; then
    echo "ERROR: Firmware not built yet."
    echo "Run: ./tools/build.sh"
    exit 1
fi

# Find mounted iPod
IPOD_MOUNT=""
for mount in /Volumes/IPOD /Volumes/iPod /Volumes/IPOD\ CLASSIC /Volumes/IPOD*; do
    if [ -d "$mount" ] 2>/dev/null; then
        IPOD_MOUNT="$mount"
        break
    fi
done

if [ -z "$IPOD_MOUNT" ]; then
    echo "ERROR: No iPod found."
    echo ""
    echo "Connect your iPod via USB and put it in disk mode:"
    echo "  1. Reset: hold MENU + SELECT (center) until Apple logo"
    echo "  2. Immediately hold SELECT + PLAY to enter disk mode"
    echo "  3. The iPod should appear as a drive in Finder"
    echo ""
    echo "Or manually specify: $0 /Volumes/YOUR_IPOD"
    exit 1
fi

echo "Found iPod at: $IPOD_MOUNT"
echo ""

# Check if Rockbox bootloader is installed
if [ ! -f "$IPOD_MOUNT/.rockbox/rockbox.ipod" ] && [ ! -d "$IPOD_MOUNT/.rockbox" ]; then
    echo "WARNING: No existing Rockbox installation found."
    echo ""
    echo "You need to install the Rockbox bootloader first:"
    echo "  1. Download the Rockbox Utility from https://www.rockbox.org/download/"
    echo "  2. Run it and select 'Install Bootloader'"
    echo "  3. Then run this script again to install Enchanted Falcon"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

echo "Installing Enchanted Falcon..."
echo ""

# Unzip firmware to iPod
echo "[1/2] Extracting firmware + theme..."
unzip -o -q "$ZIP" -d "$IPOD_MOUNT"
echo "  Done."

# Install theme (regenerates assets, copies latest config)
echo "[2/2] Installing theme overlay..."
"$SCRIPT_DIR/install-theme.sh" "$IPOD_MOUNT/.rockbox"

echo ""
echo "=== Enchanted Falcon installed! ==="
echo ""
echo "Safely eject the iPod, then:"
echo "  1. Hold MENU + SELECT to reboot"
echo "  2. Rockbox will load with the Enchanted Falcon theme"
echo "  3. Navigate to Settings → General Settings → Database → Initialize Now"
echo "  4. After scanning, the Music browser will work (Artists/Albums/Songs)"
echo ""
echo "To return to Apple firmware: hold MENU + SELECT, then hold MENU on boot"

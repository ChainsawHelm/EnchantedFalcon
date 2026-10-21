#!/usr/bin/env bash
set -euo pipefail

# Enchanted Falcon — Flash to iPod
# Copies built firmware to a connected iPod Classic

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build"

echo "=== Enchanted Falcon Flash ==="
echo ""

# Find mounted iPod
IPOD_MOUNT=""
for mount in /Volumes/IPOD /Volumes/iPod /Volumes/IPOD\ CLASSIC; do
    if [ -d "$mount" ]; then
        IPOD_MOUNT="$mount"
        break
    fi
done

if [ -z "$IPOD_MOUNT" ]; then
    echo "ERROR: No iPod found mounted."
    echo "Connect your iPod via USB and put it in disk mode:"
    echo "  1. Reset: hold Menu + Select until Apple logo"
    echo "  2. Immediately hold Select + Play to enter disk mode"
    echo ""
    echo "The iPod should appear as a drive in /Volumes/"
    exit 1
fi

echo "Found iPod at: $IPOD_MOUNT"
echo ""

if [ ! -d "$BUILD_DIR/.rockbox" ]; then
    echo "ERROR: No build found. Run ./tools/build.sh first."
    exit 1
fi

echo "Copying .rockbox to iPod..."
rsync -av --progress "$BUILD_DIR/.rockbox/" "$IPOD_MOUNT/.rockbox/"

echo ""
echo "=== Flash complete ==="
echo "Eject the iPod safely, then reboot it."
echo "Hold Menu + Select to reboot, then hold Select + Play for disk mode if needed."

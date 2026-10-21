#!/usr/bin/env bash
set -euo pipefail

# Enchanted Falcon — Build script
# Builds Rockbox firmware with Enchanted Falcon customizations for iPod Classic

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ROCKBOX_DIR="$PROJECT_DIR/rockbox"
BUILD_DIR="$PROJECT_DIR/build"

TARGET="${1:-ipod6g}"  # ipod6g (Classic 7G, 320x240)

echo "=== Enchanted Falcon Build ==="
echo "Target: $TARGET"
echo ""

if [ ! -d "$ROCKBOX_DIR" ]; then
    echo "ERROR: Rockbox source not found at $ROCKBOX_DIR"
    echo "Run: git submodule update --init"
    exit 1
fi

# Apply patches if any exist
if [ -d "$PROJECT_DIR/patches" ] && ls "$PROJECT_DIR/patches"/*.patch &>/dev/null; then
    echo "[1/4] Applying Enchanted Falcon patches..."
    cd "$ROCKBOX_DIR"
    for patch in "$PROJECT_DIR/patches"/*.patch; do
        echo "  Applying: $(basename "$patch")"
        git apply --check "$patch" 2>/dev/null && git apply "$patch" || echo "  (already applied or conflict)"
    done
else
    echo "[1/4] No patches to apply (theme-only build)"
fi

# Create build directory
echo "[2/4] Configuring build..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Run Rockbox configure
"$ROCKBOX_DIR/tools/configure" <<EOF
$TARGET
N
EOF

# Build
echo "[3/4] Compiling firmware..."
make -j"$(sysctl -n hw.ncpu)" 2>&1

# Copy theme files
echo "[4/4] Installing Enchanted Falcon theme..."
if [ -d "$PROJECT_DIR/themes" ] && ls "$PROJECT_DIR/themes"/*.wps &>/dev/null; then
    cp "$PROJECT_DIR/themes"/*.wps "$BUILD_DIR/.rockbox/wps/" 2>/dev/null || true
    cp "$PROJECT_DIR/themes"/*.sbs "$BUILD_DIR/.rockbox/wps/" 2>/dev/null || true
    cp "$PROJECT_DIR/themes"/*.cfg "$BUILD_DIR/.rockbox/themes/" 2>/dev/null || true
    echo "  Theme files installed."
fi

echo ""
echo "=== Build complete ==="
echo "Firmware: $BUILD_DIR/rockbox.ipod"
echo ""
echo "To flash: ./tools/flash.sh"

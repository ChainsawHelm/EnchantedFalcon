#!/usr/bin/env bash
set -euo pipefail

# Enchanted Falcon — Install theme to a Rockbox installation
# Usage: ./install-theme.sh <rockbox-root>
# Example: ./install-theme.sh ./build-sim/simdisk/.rockbox
#          ./install-theme.sh /Volumes/IPOD/.rockbox

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$PROJECT_DIR/themes"

TARGET="${1:-}"
if [ -z "$TARGET" ]; then
    echo "Usage: $0 <rockbox-root>"
    echo "  e.g. $0 ./build-sim/simdisk/.rockbox"
    echo "  e.g. $0 /Volumes/IPOD/.rockbox"
    exit 1
fi

if [ ! -d "$TARGET" ]; then
    echo "ERROR: $TARGET does not exist"
    exit 1
fi

echo "=== Installing Enchanted Falcon to $TARGET ==="

# 1. Generate and install theme assets
echo "[1/5] Generating theme assets..."
mkdir -p "$TARGET/wps/enchanted-falcon"
python3 "$PROJECT_DIR/tools/generate-theme-assets.py" "$TARGET/wps/enchanted-falcon"

# 2. Copy backdrop
echo "[2/5] Installing backdrop..."
mkdir -p "$TARGET/backdrops"
cp "$TARGET/wps/enchanted-falcon/backdrop.bmp" "$TARGET/backdrops/enchanted-falcon.bmp"

# 3. Install skin files
echo "[3/5] Installing skins..."
cp "$THEMES_DIR/enchanted-falcon.wps" "$TARGET/wps/"
cp "$THEMES_DIR/enchanted-falcon.sbs" "$TARGET/wps/"
mkdir -p "$TARGET/themes"
cp "$THEMES_DIR/enchanted-falcon.cfg" "$TARGET/themes/"

# 4. Install iPod-style navigation
echo "[4/5] Installing iPod-style navigation..."
cp "$THEMES_DIR/tagnavi.config" "$TARGET/tagnavi.config"

# 5. Install master config
echo "[5/5] Installing config..."
cp "$THEMES_DIR/config.cfg" "$TARGET/config.cfg"

# 6. Convert and install fonts if convbdf is available
CONVBDF="$PROJECT_DIR/build-sim/tools/convbdf"
if [ -f "$CONVBDF" ]; then
    echo "[Bonus] Installing fonts..."
    FONTS_SRC="$PROJECT_DIR/rockbox/fonts"
    mkdir -p "$TARGET/fonts"
    for font in "18-Adobe-Helvetica.bdf" "18-Adobe-Helvetica-Bold.bdf" "16-Adobe-Helvetica.bdf" "16-Adobe-Helvetica-Bold.bdf" "21-Adobe-Helvetica.bdf" "21-Adobe-Helvetica-Bold.bdf" "14-Adobe-Helvetica-Bold.bdf" "10-Adobe-Helvetica.bdf"; do
        basename="${font%.bdf}.fnt"
        if [ ! -f "$TARGET/fonts/$basename" ]; then
            "$CONVBDF" -f -o "$TARGET/fonts/$basename" "$FONTS_SRC/$font" 2>/dev/null
        fi
    done
fi

echo ""
echo "=== Enchanted Falcon installed ==="
echo ""
echo "If this is a fresh install, you need to initialize the database:"
echo "  Settings → General Settings → Database → Initialize Now"
echo ""
echo "After that, the Music browser (Artists/Albums/Songs) will work."

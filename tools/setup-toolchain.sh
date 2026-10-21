#!/usr/bin/env bash
set -euo pipefail

# Enchanted Falcon — macOS toolchain setup
# Installs everything needed to cross-compile Rockbox for iPod Classic

echo "=== Enchanted Falcon Toolchain Setup ==="
echo ""

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    echo "ERROR: Homebrew not found. Install from https://brew.sh"
    exit 1
fi

echo "[1/4] Installing ARM cross-compiler..."
brew install --cask gcc-arm-embedded 2>/dev/null || brew install arm-none-eabi-gcc 2>/dev/null || {
    echo "Trying Rockbox's own toolchain builder..."
    echo "Will be handled in rockbox/tools/rockboxdev.sh"
}

echo "[2/4] Installing build dependencies..."
brew install sdl2 sdl2_image libpng libjpeg-turbo lzo texinfo bison flex

echo "[3/4] Installing utility tools..."
brew install mtools dosfstools

echo "[4/4] Verifying installation..."
echo ""

check_tool() {
    if command -v "$1" &>/dev/null; then
        echo "  ✓ $1 found: $(command -v "$1")"
    else
        echo "  ✗ $1 NOT FOUND"
    fi
}

check_tool arm-none-eabi-gcc
check_tool make
check_tool sdl2-config
check_tool mtools

echo ""
echo "=== Toolchain setup complete ==="
echo ""
echo "If arm-none-eabi-gcc is missing, run Rockbox's toolchain builder:"
echo "  cd rockbox/tools && ./rockboxdev.sh"
echo "  (Select 'a' for ARM when prompted)"
echo ""
echo "Next steps:"
echo "  1. git submodule update --init"
echo "  2. ./tools/build.sh"

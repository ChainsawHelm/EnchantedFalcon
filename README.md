# Enchanted Falcon

Modern firmware for the iPod Classic — built on top of [Rockbox](https://www.rockbox.org/).

Rockbox solved the hard problems (hardware drivers, audio codecs, filesystem, power management). Enchanted Falcon replaces the dated UI with a clean, minimal interface designed for how people actually use a music player in 2026.

## Target Hardware

- **iPod Classic 7th Generation** (primary target, 320×240 LCD)
- iFlash SD adapter recommended (replaces spinning HDD)

## What's Different from Rockbox

- Minimal, dark-mode-first UI
- Simplified navigation: Music → Now Playing → Files → Settings
- Smooth pixel-scrolling with clickwheel inertia
- Large album art, clean typography
- Stripped-down menus — no feature bloat

## Project Structure

```
EnchantedFalcon/
├── rockbox/          ← Rockbox source (git submodule)
├── themes/           ← Custom WPS/SBS/FMS theme files
├── patches/          ← C source patches against Rockbox UI layer
├── tools/            ← Build scripts, flash utilities
├── docs/             ← Hardware notes, dev journal
└── CLAUDE.md         ← Dev assistant context
```

## Development Phases

1. **Setup** — Dev environment, cross-compiler, build from source
2. **Theme** — Push Rockbox theming as far as it goes (no C required)
3. **UI Fork** — Modify C source for modern menus and navigation
4. **Daily Driver** — Polish, battery life, reliability

## Quick Start

```bash
# Install toolchain (macOS)
./tools/setup-toolchain.sh

# Build firmware
./tools/build.sh

# Flash to iPod (connected via USB)
./tools/flash.sh
```

## License

Rockbox is GPL v2. Enchanted Falcon modifications are also GPL v2.

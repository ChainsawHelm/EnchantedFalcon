# Enchanted Falcon — Dev Context

## What This Is

Custom iPod Classic firmware built on a Rockbox fork. The goal is a modern, minimal UI on top of Rockbox's proven hardware/codec stack.

## Architecture

- `rockbox/` is a git submodule pointing to the official Rockbox repo
- `themes/` contains custom WPS/SBS theme files (Rockbox's skin markup language)
- `patches/` contains C source modifications to Rockbox's UI layer
- `tools/` contains build and flash scripts

## Key Rockbox Directories (inside rockbox/)

- `firmware/` — Hardware drivers, kernel, codec engine. DO NOT MODIFY.
- `apps/` — Application layer, menus, UI. This is our playground.
- `apps/gui/` — Widget toolkit: lists, scrollbars, viewports
- `apps/gui/skin_engine/` — WPS/SBS/FMS theme engine
- `apps/menus/` — Menu definitions and navigation
- `wps/` — Stock theme files

## Build Target

- Primary: `ipod6g` (Classic 7G, 320×240 LCD)
- Simulator: `build-sim/` directory, run `./rockboxui` to test UI changes on desktop

## Rules

- Never modify anything in `rockbox/firmware/` — that's the stable foundation
- All UI changes go through `patches/` as discrete, documented patch files
- Theme-only changes go in `themes/` — no C required
- Test every change on real hardware before considering it done
- Keep the build reproducible — `tools/setup-toolchain.sh` must get a fresh Mac from zero to building

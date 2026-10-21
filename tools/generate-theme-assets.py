#!/usr/bin/env python3
"""Generate BMP assets for the Enchanted Falcon theme.
Target: iPod Classic 7G (320x240 LCD, 16-bit color)
"""

from PIL import Image, ImageDraw, ImageFont
import os
import sys

SCREEN_W, SCREEN_H = 320, 240

# Color palette — dark, modern
BG = (17, 17, 17)           # #111111 — near-black background
FG = (204, 204, 204)        # #CCCCCC — light grey text
ACCENT = (90, 200, 250)     # #5AC8FA — iOS-blue accent
DIM = (68, 68, 68)          # #444444 — dimmed elements
PROGRESS_BG = (40, 40, 40)  # #282828 — progress bar track
SELECT = (45, 45, 48)       # #2D2D30 — selection highlight

def output_dir():
    if len(sys.argv) > 1:
        return sys.argv[1]
    return os.path.join(os.path.dirname(__file__), '..', 'build-sim', 'simdisk', '.rockbox', 'wps', 'enchanted-falcon')

def ensure_dir(path):
    os.makedirs(path, exist_ok=True)

def save_bmp(img, path):
    img.save(path, 'BMP')
    print(f"  Created: {os.path.basename(path)}")

def make_backdrop(out):
    """320x240 solid dark backdrop"""
    img = Image.new('RGB', (SCREEN_W, SCREEN_H), BG)
    draw = ImageDraw.Draw(img)
    # Subtle gradient at top for status area
    for y in range(28):
        alpha = int(20 * (1 - y / 28))
        draw.line([(0, y), (SCREEN_W, y)], fill=(BG[0] + alpha, BG[1] + alpha, BG[2] + alpha))
    save_bmp(img, os.path.join(out, 'backdrop.bmp'))

def make_progress_bar(out):
    """300x6 progress bar — filled portion"""
    w, h = 280, 4
    img = Image.new('RGB', (w, h), ACCENT)
    save_bmp(img, os.path.join(out, 'pb-fill.bmp'))

def make_progress_bg(out):
    """280x4 progress bar — background track"""
    w, h = 280, 4
    img = Image.new('RGB', (w, h), PROGRESS_BG)
    save_bmp(img, os.path.join(out, 'pb-bg.bmp'))

def make_battery_strip(out):
    """Battery icon strip — 10 frames, each 20x10
    Frames: 0-9 representing 0-100% battery
    """
    frame_w, frame_h = 20, 10
    frames = 10
    img = Image.new('RGB', (frame_w, frame_h * frames), BG)
    draw = ImageDraw.Draw(img)

    for i in range(frames):
        y_off = i * frame_h
        # Battery outline
        draw.rectangle([0, y_off + 1, 16, y_off + frame_h - 2], outline=DIM)
        # Battery tip
        draw.rectangle([17, y_off + 3, 19, y_off + frame_h - 4], fill=DIM)
        # Fill level
        fill_w = int(14 * (i + 1) / frames)
        if i < 2:
            fill_color = (255, 59, 48)   # Red — low battery
        elif i < 4:
            fill_color = (255, 149, 0)   # Orange — medium
        else:
            fill_color = (52, 199, 89)   # Green — good
        draw.rectangle([2, y_off + 3, 2 + fill_w, y_off + frame_h - 4], fill=fill_color)

    save_bmp(img, os.path.join(out, 'battery.bmp'))

def make_playmode_strip(out):
    """Playmode icons — 5 frames (stop, play, pause, ff, rw), each 16x12"""
    frame_w, frame_h = 16, 12
    frames = 5
    img = Image.new('RGB', (frame_w, frame_h * frames), BG)
    draw = ImageDraw.Draw(img)

    for i in range(frames):
        y_off = i * frame_h
        cx, cy = frame_w // 2, y_off + frame_h // 2

        if i == 0:  # Stop
            draw.rectangle([4, y_off + 2, 12, y_off + 10], fill=FG)
        elif i == 1:  # Play
            draw.polygon([(4, y_off + 1), (13, cy), (4, y_off + 11)], fill=ACCENT)
        elif i == 2:  # Pause
            draw.rectangle([3, y_off + 2, 6, y_off + 10], fill=FG)
            draw.rectangle([9, y_off + 2, 12, y_off + 10], fill=FG)
        elif i == 3:  # FF
            draw.polygon([(2, y_off + 2), (8, cy), (2, y_off + 10)], fill=FG)
            draw.polygon([(8, y_off + 2), (14, cy), (8, y_off + 10)], fill=FG)
        elif i == 4:  # RW
            draw.polygon([(8, y_off + 2), (2, cy), (8, y_off + 10)], fill=FG)
            draw.polygon([(14, y_off + 2), (8, cy), (14, y_off + 10)], fill=FG)

    save_bmp(img, os.path.join(out, 'playmode.bmp'))

def make_volume_strip(out):
    """Volume icons — 10 frames, each 16x12"""
    frame_w, frame_h = 16, 12
    frames = 10
    img = Image.new('RGB', (frame_w, frame_h * frames), BG)
    draw = ImageDraw.Draw(img)

    for i in range(frames):
        y_off = i * frame_h
        # Speaker body
        draw.rectangle([1, y_off + 4, 4, y_off + 8], fill=FG)
        draw.polygon([(4, y_off + 4), (8, y_off + 1), (8, y_off + 11), (4, y_off + 8)], fill=FG)
        # Volume bars
        bars = int((i + 1) * 3 / frames)
        if bars >= 1:
            draw.arc([9, y_off + 3, 13, y_off + 9], -60, 60, fill=FG)
        if bars >= 2:
            draw.arc([11, y_off + 1, 16, y_off + 11], -60, 60, fill=FG)

    save_bmp(img, os.path.join(out, 'volume.bmp'))

def make_shuffle_icons(out):
    """Shuffle on/off — 12x12 each"""
    sz = 12
    # Shuffle on
    img = Image.new('RGB', (sz, sz), BG)
    draw = ImageDraw.Draw(img)
    draw.line([(1, 9), (5, 3), (7, 5), (11, 1)], fill=ACCENT, width=1)
    draw.line([(1, 3), (5, 9), (7, 7), (11, 11)], fill=ACCENT, width=1)
    save_bmp(img, os.path.join(out, 'shuffle-on.bmp'))

    # Shuffle off
    img = Image.new('RGB', (sz, sz), BG)
    draw = ImageDraw.Draw(img)
    draw.line([(1, 9), (5, 3), (7, 5), (11, 1)], fill=DIM, width=1)
    draw.line([(1, 3), (5, 9), (7, 7), (11, 11)], fill=DIM, width=1)
    save_bmp(img, os.path.join(out, 'shuffle-off.bmp'))

def make_repeat_strip(out):
    """Repeat icons — 4 frames (off, all, one, ab), each 16x12"""
    frame_w, frame_h = 16, 12
    frames = 4
    img = Image.new('RGB', (frame_w, frame_h * frames), BG)
    draw = ImageDraw.Draw(img)

    for i in range(frames):
        y_off = i * frame_h
        color = ACCENT if i > 0 else DIM
        # Loop arrows
        draw.arc([2, y_off + 2, 14, y_off + 10], 0, 360, fill=color)
        # Arrow head
        draw.polygon([(12, y_off + 2), (14, y_off + 4), (10, y_off + 4)], fill=color)

    save_bmp(img, os.path.join(out, 'repeat.bmp'))

def make_lock_strip(out):
    """Lock icon — 2 frames (unlocked, locked), each 16x16"""
    frame_w, frame_h = 16, 16
    frames = 2
    img = Image.new('RGB', (frame_w, frame_h * frames), BG)
    draw = ImageDraw.Draw(img)

    for i in range(frames):
        y_off = i * frame_h
        # Lock body
        draw.rectangle([3, y_off + 8, 13, y_off + 14], fill=DIM if i == 0 else ACCENT)
        # Lock shackle
        draw.arc([4, y_off + 2, 12, y_off + 10], 0, 180, fill=DIM if i == 0 else ACCENT)

    save_bmp(img, os.path.join(out, 'lock.bmp'))

if __name__ == '__main__':
    out = output_dir()
    ensure_dir(out)
    print(f"Generating Enchanted Falcon theme assets in: {out}")
    print(f"Target: {SCREEN_W}x{SCREEN_H}")
    print()

    make_backdrop(out)
    make_progress_bar(out)
    make_progress_bg(out)
    make_battery_strip(out)
    make_playmode_strip(out)
    make_volume_strip(out)
    make_shuffle_icons(out)
    make_repeat_strip(out)
    make_lock_strip(out)

    print()
    print("Done! Assets ready for Enchanted Falcon theme.")

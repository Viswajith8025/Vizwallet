"""Render premium full-bleed launcher icons (matches in-app VisWalletLogo).

Outputs:
  assets/icon/icon.png            1024x1024 edge-to-edge purple gradient
  assets/icon/icon_foreground.png same art (no white padding, no inset card)

Run:  python tool/make_icons.py
Then: dart run flutter_launcher_icons
"""
from __future__ import annotations

import math
import os

from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(ROOT, "assets", "icon")
SIZE = 1024

# Brand palette (vis_wallet_logo.dart)
BG_TOP = (0x7C, 0x5C, 0xBF)
BG_MID = (0x5B, 0x3F, 0xA6)
BG_BOT = (0x2E, 0x1F, 0x5C)
MARK = (0xE8, 0xDE, 0xFF)
MARK_SOFT = (0xC4, 0xB5, 0xFD)
CHIP = (0xC4, 0xB5, 0xFD, 0x55)
FOLD = (0xC4, 0xB5, 0xFD, 0x66)
GROWTH = (0xB7, 0x94, 0xF6)
ACCENT = (0xFF, 0xD1, 0x66)
SHINE = (0xC4, 0xB5, 0xFD, 0x38)


def _lerp(a: int, b: int, t: float) -> int:
    return int(a + (b - a) * t)


def _gradient_bg() -> Image.Image:
    img = Image.new("RGB", (SIZE, SIZE))
    px = img.load()
    for y in range(SIZE):
        t = y / (SIZE - 1)
        if t < 0.52:
            u = t / 0.52
            c = tuple(_lerp(BG_TOP[i], BG_MID[i], u) for i in range(3))
        else:
            u = (t - 0.52) / 0.48
            c = tuple(_lerp(BG_MID[i], BG_BOT[i], u) for i in range(3))
        for x in range(SIZE):
            # subtle diagonal depth
            d = (x + y) / (2 * (SIZE - 1))
            c2 = tuple(_lerp(c[i], BG_BOT[i], d * 0.12) for i in range(3))
            px[x, y] = c2
    return img


def _add_shine(base: Image.Image) -> Image.Image:
    overlay = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    cx, cy = int(SIZE * 0.22), int(SIZE * 0.18)
    for r in range(int(SIZE * 0.55), 0, -4):
        alpha = int(SHINE[3] * (1 - r / (SIZE * 0.55)))
        draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=(SHINE[0], SHINE[1], SHINE[2], alpha))
    return Image.alpha_composite(base.convert("RGBA"), overlay)


def _draw_logo(img: Image.Image) -> None:
    draw = ImageDraw.Draw(img, "RGBA")
    w = h = SIZE
    pad = SIZE * 0.08  # large mark — reads clearly on home screen

    # EMV chip
    chip_l, chip_t = w * 0.28, h * 0.30
    chip_r, chip_b = w * 0.40, h * 0.39
    draw.rounded_rectangle(
        (chip_l, chip_t, chip_r, chip_b),
        radius=SIZE * 0.018,
        fill=CHIP,
    )

    # Fold line
    draw.line(
        (w * 0.29, h * 0.42, w * 0.71, h * 0.42),
        fill=FOLD,
        width=max(2, int(SIZE * 0.014)),
    )

    # V stroke (thick rounded polyline via many segments)
    stroke = max(3, int(SIZE * 0.085))
    v_pts = [
        (w * 0.36, h * 0.46),
        (w * 0.50, h * 0.72),
        (w * 0.64, h * 0.46),
    ]
    for i in range(len(v_pts) - 1):
        draw.line(
            v_pts[i] + v_pts[i + 1],
            fill=MARK,
            width=stroke,
        )
    # soften V tip
    draw.ellipse(
        (
            w * 0.50 - stroke * 0.55,
            h * 0.72 - stroke * 0.55,
            w * 0.50 + stroke * 0.55,
            h * 0.72 + stroke * 0.55,
        ),
        fill=MARK_SOFT,
    )

    # Growth curve + gold dot
    gx0, gy0 = w * 0.64, h * 0.46
    gx1, gy1 = w * 0.74, h * 0.34
    draw.line((gx0, gy0, gx1, gy1), fill=GROWTH, width=max(2, int(SIZE * 0.038)))
    ar = SIZE * 0.028
    ax, ay = w * 0.755, h * 0.325
    draw.ellipse(
        (ax - ar * 1.9, ay - ar * 1.9, ax + ar * 1.9, ay + ar * 1.9),
        fill=(ACCENT[0], ACCENT[1], ACCENT[2], 90),
    )
    draw.ellipse((ax - ar, ay - ar, ax + ar, ay + ar), fill=ACCENT)


def _add_vignette(base: Image.Image) -> Image.Image:
    """Soft edge depth so the icon feels full-bleed, not flat."""
    overlay = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    for i in range(12):
        inset = i * (SIZE // 80)
        alpha = int(18 + i * 3)
        draw.rounded_rectangle(
            (inset, inset, SIZE - inset, SIZE - inset),
            radius=SIZE * 0.22,
            outline=(0, 0, 0, alpha),
            width=3,
        )
    return Image.alpha_composite(base.convert("RGBA"), overlay)


def render_icon() -> Image.Image:
    base = _gradient_bg().convert("RGBA")
    base = _add_shine(base)
    _draw_logo(base)
    base = _add_vignette(base)
    return base


def main() -> None:
    os.makedirs(OUT_DIR, exist_ok=True)
    icon = render_icon()
    path = os.path.join(OUT_DIR, "icon.png")
    fg_path = os.path.join(OUT_DIR, "icon_foreground.png")
    icon.convert("RGB").save(path, quality=95)
    icon.save(fg_path)
    print("Wrote:", path)
    print("Wrote:", fg_path)


if __name__ == "__main__":
    main()

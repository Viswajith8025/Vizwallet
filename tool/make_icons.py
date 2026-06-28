"""Prepare launcher-icon source images from the generated master art.

Produces:
  assets/icon/icon.png            1024x1024 full-bleed (legacy + Play Store)
  assets/icon/icon_foreground.png 1024x1024 padded, transparent (adaptive)

flutter_launcher_icons then fans these out to every mipmap density.
"""
import os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MASTER = os.path.join(
    os.path.expanduser("~"),
    ".cursor", "projects",
    "c-Users-Hp-OneDrive-Desktop-PROJECTS-Vibe-coding",
    "assets", "vizwallet_icon_master.png",
)
OUT_DIR = os.path.join(ROOT, "assets", "icon")
os.makedirs(OUT_DIR, exist_ok=True)

img = Image.open(MASTER).convert("RGB")
w, h = img.size
side = min(w, h)
left = (w - side) // 2
top = (h - side) // 2
square = img.crop((left, top, left + side, top + side)).resize(
    (1024, 1024), Image.LANCZOS
)
square.save(os.path.join(OUT_DIR, "icon.png"))

# Adaptive foreground: the gradient card scaled into the safe zone (~66%) on a
# transparent canvas, so Android's mask never clips the "V".
fg = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
scaled = square.convert("RGBA").resize((680, 680), Image.LANCZOS)
fg.paste(scaled, ((1024 - 680) // 2, (1024 - 680) // 2), scaled)
fg.save(os.path.join(OUT_DIR, "icon_foreground.png"))

print("Wrote:", os.listdir(OUT_DIR))

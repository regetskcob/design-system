"""Renders the app icon sets of every product from the SVG sources.

The sources come from web/partials/app-icon.html and mark.html: the doc
site publishes them under icons/<product>/*.svg. This builds the site,
copies the sources to icons/svg/, renders them with headless Chrome (the
same renderer as the web, so blur and shadow look as designed) and writes

  icons/export/<product>/
    ios/AppIcon.appiconset/        1024, single size, no alpha
    watchos/AppIcon-1024.png       no alpha, the system masks the circle
    macos/AppIcon.iconset/         the macOS template (824 on 1024, shadow)
    android/mipmap-*/              adaptive foreground, background,
                                   monochrome and the legacy icon
    android/playstore-512.png
    tvos/                          back and front layers, 400x240 @1x/@2x
                                   and 1280x768 for the App Store
    web/                           favicon.svg, favicon-32.png,
                                   apple-touch-icon.png, icon-192/512.png,
                                   icon-512-maskable.png

Needs Hugo, Google Chrome and Python with Pillow:

  python3 -m venv .venv && .venv/bin/pip install pillow
  .venv/bin/python tool/export_icons.py

CHROME overrides the path of the Chrome binary.
"""

import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
CHROME = os.environ.get(
    "CHROME", "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
)
PRODUCTS = ["regetskcob", "jagdaufseher", "knx", "panzergefecht"]
ANDROID = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}


def render(html: str, width: int, height: int, out: Path, workdir: Path) -> Image.Image:
    """Screenshots an HTML snippet at exactly width x height."""
    page = workdir / "page.html"
    page.write_text(
        "<!doctype html><html><head><style>html,body{margin:0;background:transparent;"
        f"width:{width}px;height:{height}px;overflow:hidden}}img{{display:block}}</style>"
        f"</head><body>{html}</body></html>"
    )
    subprocess.run(
        [
            CHROME, "--headless=new", "--disable-gpu", "--hide-scrollbars",
            "--force-device-scale-factor=1", "--default-background-color=00000000",
            f"--window-size={width},{height}", f"--screenshot={out}", page.as_uri(),
        ],
        check=True, capture_output=True,
    )
    return Image.open(out).convert("RGBA")


def img(src: Path, w: int, h: int, extra: str = "") -> str:
    return f'<img src="{src.as_uri()}" width="{w}" height="{h}" style="{extra}">'


def save(im: Image.Image, path: Path, size=None, alpha=True) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if size:
        im = im.resize(size, Image.LANCZOS)
    if not alpha:
        flat = Image.new("RGB", im.size, (0, 0, 0))
        flat.paste(im, mask=im.split()[3])
        im = flat
    im.save(path, optimize=True)


def main() -> None:
    work = Path(tempfile.mkdtemp())
    site = work / "site"
    subprocess.run(["hugo", "--quiet", "-s", str(ROOT), "-d", str(site)], check=True)
    for p in PRODUCTS:
        src = site / "icons" / p
        svg = ROOT / "icons" / "svg" / p
        shutil.rmtree(svg, ignore_errors=True)
        shutil.copytree(src, svg)
        out = ROOT / "icons" / "export" / p
        shutil.rmtree(out, ignore_errors=True)
        shot = work / "shot.png"

        bleed = render(img(svg / "bleed.svg", 1024, 1024), 1024, 1024, shot, work)
        rounded = render(img(svg / "rounded.svg", 1024, 1024), 1024, 1024, shot, work)

        # iOS: one 1024 icon without alpha; Xcode derives the rest.
        save(bleed, out / "ios/AppIcon.appiconset/AppIcon-1024.png", alpha=False)
        (out / "ios/AppIcon.appiconset/Contents.json").write_text(json.dumps({
            "images": [{"filename": "AppIcon-1024.png", "idiom": "universal",
                        "platform": "ios", "size": "1024x1024"}],
            "info": {"author": "horizont", "version": 1},
        }, indent=2) + "\n")
        save(bleed, out / "watchos/AppIcon-1024.png", alpha=False)

        # macOS: the art on an 824 rounded square in a 1024 canvas, with the
        # shadow of Apple's template.
        mac = render(
            '<div style="position:absolute;left:100px;top:100px;width:824px;height:824px;'
            'border-radius:185px;overflow:hidden;box-shadow:0 10px 20px rgba(0,0,0,.3)">'
            + img(svg / "bleed.svg", 824, 824) + "</div>",
            1024, 1024, shot, work,
        )
        for s in (16, 32, 128, 256, 512):
            save(mac, out / f"macos/AppIcon.iconset/icon_{s}x{s}.png", (s, s))
            save(mac, out / f"macos/AppIcon.iconset/icon_{s}x{s}@2x.png", (s * 2, s * 2))

        # Android: adaptive layers on the 108 dp canvas, the monochrome glyph
        # in the middle 72 dp, the legacy round-cornered icon at 48 dp.
        back = render(img(svg / "adaptive-back.svg", 432, 432), 432, 432, shot, work)
        front = render(img(svg / "adaptive-front.svg", 432, 432), 432, 432, shot, work)
        mono = render(
            img(svg / "glyph.svg", 288, 288, "position:absolute;left:72px;top:72px"),
            432, 432, shot, work,
        )
        for name, factor in ANDROID.items():
            s = round(108 * factor)
            save(back, out / f"android/mipmap-{name}/ic_launcher_background.png", (s, s))
            save(front, out / f"android/mipmap-{name}/ic_launcher_foreground.png", (s, s))
            save(mono, out / f"android/mipmap-{name}/ic_launcher_monochrome.png", (s, s))
            save(rounded, out / f"android/mipmap-{name}/ic_launcher.png", (round(48 * factor),) * 2)
        (out / "android/mipmap-anydpi-v26").mkdir(parents=True, exist_ok=True)
        (out / "android/mipmap-anydpi-v26/ic_launcher.xml").write_text(
            '<?xml version="1.0" encoding="utf-8"?>\n'
            '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
            '    <background android:drawable="@mipmap/ic_launcher_background"/>\n'
            '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
            '    <monochrome android:drawable="@mipmap/ic_launcher_monochrome"/>\n'
            "</adaptive-icon>\n"
        )
        save(bleed, out / "android/playstore-512.png", (512, 512), alpha=False)

        # tvOS: layered 5:3 icons; the system adds the parallax.
        tv_back = render(img(svg / "tv-back.svg", 1280, 768), 1280, 768, shot, work)
        tv_front = render(img(svg / "tv-front.svg", 1280, 768), 1280, 768, shot, work)
        for label, size in (("400x240", (400, 240)), ("800x480", (800, 480)), ("1280x768", (1280, 768))):
            save(tv_back, out / f"tvos/back-{label}.png", size, alpha=False)
            save(tv_front, out / f"tvos/front-{label}.png", size)

        # Web: the glyph favicon for small sizes, the illustration above.
        (out / "web").mkdir(parents=True, exist_ok=True)
        shutil.copy(svg / "favicon.svg", out / "web/favicon.svg")
        fav = render(img(svg / "favicon.svg", 128, 128), 128, 128, shot, work)
        save(fav, out / "web/favicon-32.png", (32, 32))
        save(bleed, out / "web/apple-touch-icon.png", (180, 180), alpha=False)
        save(rounded, out / "web/icon-192.png", (192, 192))
        save(rounded, out / "web/icon-512.png", (512, 512))
        save(bleed, out / "web/icon-512-maskable.png", (512, 512), alpha=False)
        print(f"{p}: done")
    shutil.rmtree(work)


if __name__ == "__main__":
    sys.exit(main())

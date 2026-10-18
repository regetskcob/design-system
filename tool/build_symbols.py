"""Cuts Material Symbols Sharp down to the icons Horizont uses.

The upstream font is variable (FILL, GRAD, opsz, wght) and holds some 3,800
icons. The products need about a hundred, at one setting: outlined (FILL 0),
GRAD 0, optical size 24, weight 300. This pins the axes, keeps only the
glyphs of the names in icons/material-symbols.txt (by codepoint, no
ligatures: Flutter and the web address them by codepoint) and writes

  flutter/fonts/MaterialSymbolsSharp-300.ttf
  web/fonts/MaterialSymbols/MaterialSymbolsSharp-300.woff2
  icons/material-symbols.json   name -> codepoint

Needs fontTools and brotli. Usage:

  python tool/build_symbols.py <MaterialSymbolsSharp[...].ttf> <...codepoints>

Source: https://github.com/google/material-design-icons/tree/master/variablefont
"""

import json
import sys
from pathlib import Path

from fontTools import subset
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer

ROOT = Path(__file__).resolve().parent.parent


def main(font_path: str, codepoints_path: str) -> None:
    names = [
        line.strip()
        for line in (ROOT / "icons/material-symbols.txt").read_text().splitlines()
        if line.strip() and not line.startswith("#")
    ]
    table = {}
    for line in Path(codepoints_path).read_text().splitlines():
        name, code = line.split()
        table.setdefault(name, int(code, 16))
    missing = [n for n in names if n not in table]
    if missing:
        sys.exit(f"not in Material Symbols: {', '.join(missing)}")
    chosen = {n: table[n] for n in names}

    font = TTFont(font_path)
    font = instancer.instantiateVariableFont(
        font, {"FILL": 0, "GRAD": 0, "opsz": 24, "wght": 300}
    )
    options = subset.Options()
    options.layout_features = []
    options.name_IDs = ["*"]
    options.notdef_outline = True
    sub = subset.Subsetter(options)
    sub.populate(unicodes=sorted(set(chosen.values())))
    sub.subset(font)

    ttf = ROOT / "flutter/fonts/MaterialSymbolsSharp-300.ttf"
    ttf.parent.mkdir(parents=True, exist_ok=True)
    font.flavor = None
    font.save(ttf)
    woff2 = ROOT / "web/fonts/MaterialSymbols/MaterialSymbolsSharp-300.woff2"
    woff2.parent.mkdir(parents=True, exist_ok=True)
    font.flavor = "woff2"
    font.save(woff2)
    (ROOT / "icons/material-symbols.json").write_text(
        json.dumps({n: f"0x{c:04x}" for n, c in chosen.items()}, indent=2) + "\n"
    )
    print(f"{len(chosen)} icons, {ttf.stat().st_size // 1024} KB ttf, "
          f"{woff2.stat().st_size // 1024} KB woff2")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])

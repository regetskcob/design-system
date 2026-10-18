# Horizont

Das Designsystem von regetskcob und seinen Projekten Jagdaufseher, KNX Monitor
und Panzergefecht. Leitbild: minimalistisch wie die niederrheinische Feldflur.

Dokumentation und Entwürfe: https://www.regetskcob.de/horizont/

Stand: v0.4, Entscheidungen getroffen (#1), Schriften gebündelt (#2), Flutter-Paket (#3) und Hugo-Komponenten da. Die Apps und ihre Landingpages nutzen das System noch nicht.

Wer Oberflächen umsetzt, ob Mensch oder Claude-Sitzung, beginnt mit
[CLAUDE.md](CLAUDE.md) (Leitbild, Regeln, Tokens, offene Entscheidungen,
Arbeitsweise) und liest dann [docs/flutter.md](docs/flutter.md) für die Apps
bzw. [docs/web.md](docs/web.md) für Hugo-Seiten.

## Aufbau

| Ordner | Inhalt |
| --- | --- |
| `tokens/horizont.json` | Die einzige Quelle aller Werte: Farben hell und dunkel, Produkt-Akzente, Status, Schrift, Abstand, Radien, Linien, Bewegung, Icon-Paletten |
| `web/css/` | Die Web-Schicht: `tokens.css` (Hugo-Template, erzeugt die CSS-Variablen aus den Tokens) und `components.css` (Knöpfe, Felder, Listen, Status, Tabellen) |
| `web/partials/` | Hugo-Partials: Marke, App-Icon, Lockup, Geräterahmen, Kennung, Badge, Symbol, Fakten, Feldseite (`feld/`) |
| `web/shortcodes/` | Hugo-Shortcodes für Inhalte: `hz-device`, `hz-kennung`, `hz-badge`, `hz-symbol`, `hz-facts` |
| `web/fonts/` | Literata, Mona Sans, Monaspace Argon (SIL OFL, `OFL.txt`) und Material Symbols Sharp als Subset (Apache 2.0), als WOFF2 |
| `flutter/` | Flutter-Paket `horizont`: Theme, Widgets, Schriften (`flutter/fonts/`), Showcase-App und Goldens (`flutter/example/`) |
| `icons/` | Liste der genutzten Material Symbols und ihre Codepoints |
| `tool/` | `generate_tokens.dart` (Tokens für Flutter), `build_symbols.py` (Material Symbols zuschneiden) |
| `site/` | Nur die Dokumentationsseite |
| `docs/` | Umsetzungsleitfäden für Flutter und Web |
| `CLAUDE.md` | Kurzfassung aller Regeln für Claude-Sitzungen |

Hugo bindet die Ordner über `module.mounts` in `hugo.toml` ein, das Repository
muss deshalb nicht wie eine Hugo-Seite aussehen.

## Lokal ansehen

```sh
hugo server --baseURL http://localhost:1313/horizont/
```

Dann http://localhost:1313/horizont/ öffnen.

## Deploy

Jeder Push auf `main` baut die Seite und veröffentlicht sie über GitHub Pages
(`.github/workflows/pages.yml`). Weil die Nutzerseite `regetskcob.github.io`
die Domain `www.regetskcob.de` trägt, erscheint dieses Repository als
Projektseite unter `/horizont/`.

## Geplant

- `icons/` mit SVG-Quellen und Export für iOS, Android und Favicons

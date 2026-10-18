# Horizont

Das Designsystem von regetskcob und seinen Projekten Jagdaufseher, KNX Monitor
und Panzergefecht. Leitbild: minimalistisch wie die niederrheinische Feldflur.

Dokumentation und Entwürfe: https://www.regetskcob.de/design-system/

Stand: v0.2, die Grundentscheidungen sind getroffen (#1). Die Apps und ihre Landingpages nutzen das System noch nicht.

Wer Oberflächen umsetzt, ob Mensch oder Claude-Sitzung, beginnt mit
[CLAUDE.md](CLAUDE.md) (Leitbild, Regeln, Tokens, offene Entscheidungen,
Arbeitsweise) und liest dann [docs/flutter.md](docs/flutter.md) für die Apps
bzw. [docs/web.md](docs/web.md) für Hugo-Seiten.

## Aufbau

| Ordner | Inhalt |
| --- | --- |
| `tokens/horizont.json` | Die einzige Quelle aller Werte: Farben hell und dunkel, Produkt-Akzente, Status, Schrift, Abstand, Radien, Linien, Bewegung, Icon-Paletten |
| `web/css/` | Die Web-Schicht: `tokens.css` (Hugo-Template, erzeugt die CSS-Variablen aus den Tokens) und `components.css` (Knöpfe, Felder, Listen, Status, Tabellen) |
| `web/partials/` | Marken (`mark.html`), illustrierte App-Icons (`app-icon.html`), Platzhalter-Ikonen (`icons.html`) |
| `web/fonts/` | Literata, Mona Sans, Monaspace Argon (SIL OFL, `OFL.txt`) und Material Symbols Sharp als Subset (Apache 2.0), als WOFF2 |
| `flutter/fonts/` | Dieselben Schriften als TTF/OTF für Flutter |
| `icons/` | Liste der genutzten Material Symbols und ihre Codepoints |
| `tool/` | `build_symbols.py`: schneidet Material Symbols Sharp auf die Liste zu |
| `site/` | Nur die Dokumentationsseite |
| `docs/` | Umsetzungsleitfäden für Flutter und Web |
| `CLAUDE.md` | Kurzfassung aller Regeln für Claude-Sitzungen |

Hugo bindet die Ordner über `module.mounts` in `hugo.toml` ein, das Repository
muss deshalb nicht wie eine Hugo-Seite aussehen.

## Lokal ansehen

```sh
hugo server --baseURL http://localhost:1313/design-system/
```

Dann http://localhost:1313/design-system/ öffnen.

## Deploy

Jeder Push auf `main` baut die Seite und veröffentlicht sie über GitHub Pages
(`.github/workflows/pages.yml`). Weil die Nutzerseite `regetskcob.github.io`
die Domain `www.regetskcob.de` trägt, erscheint dieses Repository als
Projektseite unter `/design-system/`.

## Geplant

- Flutter-Paket `horizont` unter `flutter/`, die Tokens daraus generiert, per
  Git-Abhängigkeit mit festem Tag in allen drei Apps
- `web/` als Hugo-Modul für den Blog und die Landingpages
- `icons/` mit SVG-Quellen und Export für iOS, Android und Favicons

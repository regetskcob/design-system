# Horizont – Hinweise für Claude

Horizont ist das Designsystem von regetskcob (Blog) und den Projekten
**Jagdaufseher**, **KNX Monitor** und **Panzergefecht**. Dieses Repository ist
die einzige Quelle: Tokens, Web-Schicht, Marken, Icons und die Dokumentation
unter https://www.regetskcob.de/horizont/.

Wer eine Oberfläche baut oder ändert, egal ob Flutter-App, Landingpage, Blog
oder Store-Bild, liest zuerst diese Datei und dann den passenden Leitfaden:

- [docs/flutter.md](docs/flutter.md): Umsetzung in den Flutter-Apps (iOS,
  iPadOS, Android, macOS, Windows, Linux, Web, tvOS, watchOS)
- [docs/web.md](docs/web.md): Umsetzung im Web (Hugo-Seiten, Landingpages,
  Blog, Web-Apps)

Im Zweifel gilt die gerenderte Dokumentation (`site/layouts/home.html`). Sie
liest dieselben Tokens und zeigt jede Regel an einem Beispiel.

## Leitbild

**Minimalistisch wie die niederrheinische Feldflur.** Weites Land, ein tiefer
Horizont, wenige klare Linien: Feldränder, Gräben, eine Reihe Kopfweiden.
Daraus folgen alle Regeln:

| Feldflur | Oberfläche |
| --- | --- |
| weiter Himmel | Weißraum, der Bildschirm darf leer sein |
| Feldränder, Gräben | 1-px-Haarlinien ordnen, nichts schwebt |
| Äcker, Wiesen | Flächen ohne Rahmen und Schatten, nur Ton und Linie |
| der eine Baum | genau ein Akzent: die Hauptaktion und die Auswahl |
| tiefer Horizont | die Linie auf dem unteren Drittel, in Marke und Hero |
| Jahreszeiten | hell und dunkel, beide von Hand gesetzt, gleichwertig |

Hinter dem System steht ein Anspruch: Die Projekte sollen ganzheitlich im
Alltag der Nutzer ankommen, vom Handgelenk bis zum Fernseher. Eine Funktion
wird daher für alle Formfaktoren mitgedacht, nicht nur für das Telefon.

## Die sechs Regeln

1. **Inhalt vor Oberfläche.** Werte, Bilder und Texte tragen. Karten und
   Rahmen nur, wo sie etwas ordnen, Listen bekommen keine Karte pro Zeile.
2. **Linien statt Schatten.** Keine Elevation, kein Glow und keine Verläufe
   in der Oberfläche. Systemschatten (macOS-Fenster, iOS-Menüs) bleiben.
   Ausnahme: App-Icons, die sind Bilder.
3. **Eine Farbe pro Produkt.** Alles andere ist Papier und Tinte. Der Akzent
   markiert nur die Hauptaktion und die Auswahl, Status hat eigene Farben.
4. **Drei Stimmen.** Literata für das, was man liest (Überschriften der
   Landingpages, Fließtext, Onboarding). Mona Sans für das, was man bedient
   (Überschriften von Panzergefecht: Mona Sans Display Expanded).
   Monaspace Argon für das, was gemessen wird (Werte, Zeiten, Adressen,
   IDs, Koordinaten), immer mit Tabellenziffern.
5. **Zustand nie nur als Farbe.** Jeder Status hat Wort, Zeichen und Farbe:
   Haken (positive), Dreieck (warning), Achteck (critical), Kreis (info).
6. **Plattform ja, Mode nein.** Navigation, Gesten, Systemdialoge,
   Tastenkürzel und Teilen folgen der Plattform. Farbe, Schrift, Linie,
   Abstand und Ton folgen Horizont.

## Erkennungszeichen

- **Kennung:** kleine Mono-Versalien mit Sperrung (`kennung` in der
  Typo-Skala, 11/16, 600, 0.08em, uppercase, `text-muted`). Sie benennt
  Abschnitte, IDs und Lagen, etwa `EINRICHTUNGEN · 14`, `HEGERING NORD ·
  412 HA` oder `01 — IN ENTWICKLUNG`. Sie ersetzt Eyebrow-Pillen und
  Abschnittstitel. Über dem Seitentitel steht eine Kennung statt eines Large
  Title (entschieden, siehe unten).
- **Auswahl ist eine Linie:** 2 px im Akzent, unter dem aktiven Tab bzw.
  über ihm in der Tab-Bar, links an der gewählten Zeile, unten im Segment.
  Nie eine Pille als Indikator. Ein Tint (`accent-tint`) darf dazukommen.
- **Fokus:** 2 px Akzent mit 2 px Abstand, auf dem Fernseher 3 px.
- **Lockup:** Steht eine Marke neben einem Namen, liegt ihre Horizontlinie
  auf der Grundlinie des Textes (web: `.hz-lockup`). Marke und Text nie
  mittig zueinander ausrichten.
- **Wert und Begriff:** In Faktenlisten stehen Begriff (Kennung) und Wert
  auf einer Grundlinie. Die Begriffsspalte hat eine feste Breite, damit
  Listen untereinander bündig stehen.
- **Status-Badge:** Fläche `*-tint`, Text und Zeichen in der Statusfarbe,
  Radius 2.

## Werte (Tokens)

Alle Werte stehen in [tokens/horizont.json](tokens/horizont.json). Dort und
nur dort werden sie geändert. Nie Farben, Größen oder Zeiten hart in eine App
oder Seite schreiben.

- **Neutrale** (hell/dunkel): `bg`, `surface`, `sunken`, `line`,
  `line-strong`, `text`, `text-muted`, `text-faint` (nur dekorativ, kein
  Lesetext). Sie haben einen Hauch Oliv, kein reines Grau.
- **Status:** `positive`, `warning`, `critical`, `info`, jeweils mit `-tint`.
- **Produkte** (`color.product.<id>`, ids `regetskcob`, `jagdaufseher`,
  `knx`, `panzergefecht`): `accent` (Fläche der Hauptaktion), `on-accent`,
  `accent-tint` (Auswahl-Hintergrund), `accent-text` (Text, Links, Linien,
  mindestens 4,5:1).

  | Produkt | Akzent | hell | dunkel |
  | --- | --- | --- | --- |
  | regetskcob | Tinte | #1B1C19 | #E7E7E0 |
  | Jagdaufseher | Tanne | #2F5D3A | #6CCB8A |
  | KNX Monitor | Bus | #437F18 | #9BD45E |
  | Panzergefecht | Signalgelb | #8F6400 | #FFB300 |

- **Gelände:** Panzergefecht hat im Dunkeln eigene, olivgetönte Neutrale
  (`neutralDark`). Das ist die einzige Ausnahme, und sie gilt nur für die
  Neutralen. Spielwelt-Farben (Teams, Tarnanstriche, Kartengelände) gehören
  dem Spiel, nicht dem System.
- **Typo-Skala:** `display`, `headline` (Literata 300), `title-1/2/3`,
  `body`, `callout`, `label`, `caption` (Mona Sans), `reading` (Literata
  18/28), `data` und `kennung` (Monaspace). Die Größen sind die
  Standardgröße. In Apps skaliert alles mit der Systemschrift, nichts wird
  geklemmt oder abgeschnitten.
- **Abstand:** 4er-Raster, nur `0 2 4 8 12 16 24 32 48 64 96`.
- **Radien:** `0` Tabellen, `2` Status und Kennzeichen, `6` Knöpfe und
  Felder, `10` Karten und Sheets, `16` nur große Sheets. Rund ist nur, was
  rund sein muss (Schalter, Ortspunkt, Avatar). Keine Pillen-Knöpfe, keine
  Pillen-Chips.
- **Linien:** 1 px Haarlinie, 2 px Auswahl und Fokus.
- **Bewegung:** 120 / 200 / 320 ms, Kurve `cubic-bezier(0.2, 0, 0, 1)`, ohne
  Federn. Bei reduzierter Bewegung 0.
- **Größen:** Tippziel 44, Zeile 44, dichte Zeile 28. Mit Zeiger (Mac,
  Web-App am Rechner) sind Steuerelemente 24 bis 28 hoch
  (`control-desktop`), die Werkzeugleiste 52 (`toolbar-desktop`).
- **Fenstergrößen:** kompakt < 600, mittel < 840, erweitert < 1200, groß ab
  1200. Gebaut wird nach verfügbarer Breite, nie nach Gerät.
- **Geräterahmen:** Hardwarefarben unter `device`.

## Formfaktoren

| Gerät | Aufteilung |
| --- | --- |
| iPhone (kompakt) | Kopf mit Kennung und kleinem Titel, höchstens eine Kennzahlenleiste, Abschnitte mit Kennzeile, Tab-Bar mit 3 bis 5 Zielen. Eine Hauptaktion oben rechts oder als FAB (Android). |
| iPad (mittel/erweitert) | Seitenleiste statt Tab-Bar, Kennzahlen am Fuß der Seitenleiste, Inhalt in der Mitte, Inspektor rechts (quer). Ebenen und Werkzeuge sitzen auf einer Fläche mit Haarlinie. |
| Mac (groß) | Werkzeugleiste 52 mit Umschalter und Suche, Seitenleiste 200 bis 240 mit Kennungen, Inhalt als Raster aus Karten (mindestens 240), Inspektor 280 bis 320. Dichte Zeilen, Tastatur zuerst. |
| Apple TV | Sicherer Rand 60/80, Schrift × 1,5. Titel mit Kennung, ein Regal aus großen Kacheln, unten Details und eine Aktion. Fokus: Kachel +6 % und Akzentring. HUD im Spiel nur in den Ecken, die Mitte bleibt frei. |
| Apple Watch | Uhrzeit oben rechts, ein Wert groß in Mono, eine Aktion. Die Krone blättert. Fläche schwarz oder Gelände. |
| Landingpage | „Feldseite“: Kopf mit Lockup, Hero links mit Kennung und Literata-Überschrift, rechts das Produkt im Geräterahmen, darunter die Horizontlinie (2 px Akzent), nummerierte Abschnitte mit Kennung links und Fakten in Mono, Fuß „ein Projekt von regetskcob“. Kein zentrierter Hero, kein Kachelraster, keine Badge-Pille. |

Karten (Jagdaufseher): Die Grundkarte bleibt ruhig wie die Feldflur. Farbe
tragen nur Reviergrenze (Akzent, 2,5 px), Auswahl und Zustand der
Einrichtungen.

## Marken und Icons

- **Marke:** eine Linie auf dem unteren Drittel, darauf ein Gegenstand:
  Buche (regetskcob), Kanzel (Jagdaufseher), Busklemme rot/grau auf dem
  grünen Buskabel (KNX Monitor), Panzer in Seitenansicht (Panzergefecht).
- **App-Icon:** illustriert (`web/partials/app-icon.html`). Die Bühne ist
  Himmel oben und Boden unten mit einer hellen Horizontlinie bei zwei
  Dritteln. Davor steht ein Gegenstand in drei Tönen mit dunkler Kontur (1,6
  von 100) und weichem Schatten nach rechts unten. Farben unter
  `color.product.<id>.icon`.
- **Plattform-Sätze:** `icons/export/<produkt>/` (iOS, watchOS, macOS,
  Android adaptiv mit monochrom, tvOS in Ebenen, Web). Erzeugt von
  `tool/export_icons.py` aus den Partials; Icons in den Apps nie von Hand
  zeichnen oder skalieren, sondern kopieren. Nach einer Änderung an Icon oder
  Farben das Skript neu laufen lassen.
- **Glyphe** für Kopf, Fuß und Favicon unter 32 px:
  `web/partials/mark.html`, Strich 7 von 100, eckige Enden.
- **Absender:** Jedes Produkt trägt in Fußzeile, Über-Dialog und Store-Text
  „ein Projekt von regetskcob“ mit der Glyphe.
- **UI-Ikonen:** Material Symbols **Sharp**, Strichstärke 300, als Subset
  (`flutter/fonts/MaterialSymbolsSharp-300.ttf`,
  `web/fonts/MaterialSymbols/…woff2`). Es enthält genau die Namen aus
  `icons/material-symbols.txt`, die Codepoints stehen in
  `icons/material-symbols.json`. Fehlt ein Symbol: Namen in die Liste
  eintragen, dann `tool/build_symbols.py` neu laufen lassen (Anleitung im
  Kopf der Datei). Nie den ganzen Font bündeln. Die SVGs in
  `web/partials/icons.html` sind Platzhalter der Doku.

## Screenshots

Jeder Screenshot steht in seinem Geräterahmen: iPhone, Android, iPad,
MacBook, Fernseher oder Watch. Minimal, aber realistisch: echte Proportionen,
Kamera-Aussparung, Seitentasten, Standfuß. Keine Spiegelung, keine
Perspektive, kein Schatten, nur Schwarz und Aluminium. Titelleisten und
Steuerelemente im Rahmen haben die Größe, die sie auf dem echten Bildschirm
hätten.

## Entscheidungen (v0.2)

Vom Nutzer entschieden (regetskcob/horizont#1). Nicht wieder aufmachen,
ohne zu fragen:

- **Zwei Grün bleiben.** Tanne für Jagdaufseher, Bus (Lime) für KNX Monitor.
  Im Dunkeln trägt Jagdaufseher ein leuchtendes Grün (#6CCB8A, Text
  #7ED399), kein blasses Mint.
- **Mona Sans** ist die Bedienschrift (SIL OFL 1.1, kostenlos, auch
  gewerblich und gebündelt in Apps nutzbar, nur nicht allein verkäuflich).
  Sie liegt mit Literata und Monaspace in `web/fonts/` (WOFF2) und
  `flutter/fonts/` (TTF/OTF).
- **Kennung statt Large Title auf iOS:** über dem kleinen Titel steht eine
  Kennung, der große iOS-Titel wird nicht genutzt.
- **Gelände** ist als einzige Ausnahme freigegeben: Panzergefecht hat im
  Dunkeln eigene Neutrale.

Neue offene Fragen kommen als Issue mit dem Label `question` und werden vom
Nutzer entschieden, nicht von der Sitzung.

## Arbeitsweise in diesem Repository

- Werte nur in `tokens/horizont.json` ändern. CSS (`web/css/tokens.css`)
  und Doku lesen sie von dort.
- Aufbau: `tokens/` (Quelle), `web/` (wiederverwendbare Web-Schicht: CSS,
  Partials, Schriften), `flutter/` (das Paket `horizont` mit Schriften,
  Showcase-App unter `flutter/example/` und Tests), `icons/` (Liste und
  Codepoints der Symbole), `tool/` (`generate_tokens.dart`,
  `build_symbols.py`), `site/` (nur die Dokumentationsseite).
- Nach jeder Änderung an `tokens/` oder `icons/`:
  `dart run tool/generate_tokens.dart`, dann `cd flutter && flutter test`.
  Die Kontrasttests sind die AA-Prüfung des ganzen Systems. Schlägt einer
  fehl, wird der Token korrigiert, nicht der Test. Goldens nach einer
  bewussten Änderung mit `cd flutter/example && flutter test
  --update-goldens` neu erzeugen und ansehen.
- Versionen: Tokens (`version` im JSON), Paket (`flutter/pubspec.yaml`) und
  Git-Tag (`v0.5.0`) laufen gemeinsam. Die Apps hängen an einem Tag, nie an
  `main`. Hugo hängt die
  Ordner per `module.mounts` ein (`hugo.toml`).
- Lokal ansehen:
  `hugo server --baseURL http://localhost:1313/horizont/`
- Prüfen vor jedem Commit: hell und dunkel, 375 px Breite ohne horizontalen
  Überlauf, keine Konsolenfehler. Bei Lockups und Faktenlisten die
  Grundlinien nachmessen, nicht nur ansehen.
- **Jeder Push auf `main` geht sofort live** (GitHub Pages, Projektseite
  unter `/horizont/`). Vor dem Push ausdrücklich nachfragen.
- Commit-Nachrichten auf Englisch, Betreff als Satz, im Text das Warum.
  Code-Kommentare englisch, Oberflächentexte deutsch. Keine Geburtsdaten,
  Wohnorte oder andere persönlichen Angaben in Texten.
- **Hugo:** Landingpages und Blog setzen sich aus den Partials unter
  `web/partials/` (Lockup, Geräterahmen, Kennung, Badge, Symbol, Fakten,
  Feldseite) und den Shortcodes unter `web/shortcodes/` (`hz-device`,
  `hz-kennung`, `hz-badge`, `hz-symbol`, `hz-facts`) zusammen, nie aus
  nachgebautem HTML. Die Mounts stehen in `docs/web.md`. Fehlt ein Baustein,
  kommt er hierher, nicht in die Seite.
- **Wer Horizont nutzt:** der Blog (Hugo-Modul, `hugo mod get
  github.com/regetskcob/horizont@main`) und die Vorschau unter
  `/preview/` (Repository `regetskcob/preview`). Die Apps und Landingpages
  sind noch nicht umgestellt, siehe die Reihenfolge in
  [docs/flutter.md](docs/flutter.md).

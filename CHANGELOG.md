# Änderungen

Jede Version gilt zugleich für Tokens (`tokens/horizont.json`), das
Flutter-Paket (`flutter/pubspec.yaml`) und den Git-Tag. Apps und Seiten hängen
an einem Tag; unter „Heben“ steht, was beim Wechsel zu tun ist.

## 0.7.6

### Neu

- Jedes Projekt in `tokens/flur.yaml` trägt einen Satz (`text`), etwa für
  die Abzweige der Landingpage im Blog.

### Geändert

- Die Doku verliert den Abschnitt „Was danach käme“; was noch offen ist,
  steht in den Umstellungs-Issues der Apps und in #5.

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.6`; nichts sonst.

## 0.7.5

Die Doku ist kein Feld der Familie.

### Neu

- `horizont/nav/horizon.html` nimmt `link` (`url`, `hint`) statt `karte`:
  das Zeichen ist dann ein einfacher Link, eine Flurkarte gibt es nicht.
  Der Hinweis beim Zeigen kommt aus `data-hint` („Karte“ oder der `hint`).
- Die Doku nutzt das: die Sonne führt zurück auf regetskcob.de.

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.5`; nichts sonst.

## 0.7.4

Der Sprachschalter ist zu sehen.

### Geändert

- **Sprachschalter am Ende der Linie:** beide Sprachen in einem kleinen
  Rahmen („DE | EN“), die aktuelle mit der Akzentlinie, die andere als Link;
  auf Touch 32 px hoch. Die Linie und ihre Striche enden davor. `lang` nimmt
  dafür `current` (die Sprache der Seite).

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.4`, in `lang` das Feld
  `current` ergänzen. Wer `.hz-horizon-lang` selbst anspricht: das ist jetzt
  der Rahmen, der Link liegt darin (`.hz-horizon-lang a`).

## 0.7.3

Zwei Zeichen mehr, und Horizont ist ein eigenes Projekt auf der Flurkarte.

### Neu

- **Glyphen „blog“ und „horizont“** in `mark.html`: das offene Buch auf der
  Linie für den Blog und die Sonne auf der Linie für Horizont. Nur als
  Glyphe, ohne App-Icon.
- `horizont/nav/horizon.html` nimmt `mark`: das Zeichen, das über die Linie
  wandert, wenn es nicht das des Produkts ist (im Blog das Buch).
- **Horizont als Projekt** in `tokens/flur.yaml`, hinter dem Feldweg neben
  den Apps; bei regetskcob übernimmt „Über“ seinen Platz. Felder und
  Gemarkungen können ein eigenes `mark` tragen.

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.3`; nichts sonst.

## 0.7.2

Der Horizont auf jeder Feldseite, und die Flurkarte stört sie nicht mehr.

### Behoben

- **Die Felder der Flurkarte heißen `.hz-parzelle`** (Liste
  `.hz-parzellen`, `.hz-parzelle-name`, `.hz-parzelle-count`). Seit 0.7.0
  hießen sie `.hz-feld` wie der Rahmen der Feldseite; dessen Seiten bekamen
  dadurch Schraffur, Rahmen und ein Flex-Layout, das auf schmalen
  Bildschirmen über den Rand lief.
- `body.hz` hat keinen Außenabstand mehr; eine Seite auf Horizont läuft von
  Rand zu Rand.

### Neu

- **`"marks" "auto"`** in `horizont/nav/horizon.html`: das Skript liest die
  Kapitel aus der Seite, auf einer Feldseite die nummerierten Abschnitte
  (`.hz-feld-section[id]`) mit ihrer Kennung als Titel. Ein anderer
  Selektor geht über `"auto"`.
- Auf einer Feldseite steht der Horizont direkt in `<body>` vor
  `.hz-feld` und hält deren Rahmen (Breite und Einzug).

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.2`. Wer die Klassen
  der Flurkarte im eigenen CSS anspricht, benennt sie um.

## 0.7.1

Die Flurkarte passt in jede Breite.

### Geändert

- **Flurkarte folgt ihrer eigenen Breite.** Sie richtet sich nach dem Platz,
  den sie hat (Container Query), nicht nach dem Fenster: im Dialog wie in
  einer Textspalte unter 760 px einspaltig, die Projekte darunter. Vorher
  liefen in schmalen Feldern Namen wie „Niederrhein.“ oder „Film-Rezepte“
  über den Feldrand.
- Schmale Felder (unter 150 px) setzen den Namen kleiner; lange Namen
  trennen mit Bindestrich (`lang="de"`, `hyphens: auto`).
- Die Horizontlinie richtet die Titel am Ende nach links aus und teilt sich
  den Platz mit dem Strich davor; eng stehende Striche zeigen keine Worte.

### Heben

- `hugo mod get github.com/regetskcob/horizont@v0.7.1`; nichts sonst.

## 0.7.0

Eine Navigation für alle Hugo-Seiten: der Horizont. Keine Farbe, kein Maß,
kein Widget der Apps ändert sich.

### Neu

- **Horizontlinie** (`horizont/nav/horizon.html`, `.hz-horizon`): keine
  Menüleiste, eine Linie mit dem Zeichen der Seite, das beim Lesen
  mitwandert; Kapitel als Striche an ihrer echten Stelle mit dem Titel
  darunter; mit Zeiger oben, auf Touch unten mit Streichen. Skript
  `web/js/horizon.js` (rund 3 KB, ohne Abhängigkeiten) über
  `horizont/nav/script.html`.
- **Flurkarte** (`horizont/nav/karte.html`, Shortcode `hz-karte`,
  `.hz-karte`): alle Seiten der Familie als Felder, Fläche nach Inhalt, die
  Produkte hinter einem Feldweg. Daten in `tokens/flur.yaml`.
- Die Doku nutzt beides; der Schalter Auto/Hell/Dunkel entfällt, die Seite
  folgt dem System.

### Heben

- Hugo-Seiten: neuer Mount `web/js` → `assets/js/horizont` (docs/web.md,
  „Einbinden“), dann den Kopf durch `horizont/nav/horizon.html` ersetzen und
  `horizont/nav/script.html` ans Ende der Seite setzen.
- `feld/head.html` bleibt bis 0.8.0, wird aber nicht mehr verwendet.
- Apps: nichts zu tun, `ref: v0.7.0` ist gleich 0.6.3.

## 0.6.3

Kleinere Schriften und die Symbole von Panzergefecht. Keine Farbe, kein Maß,
kein Widget ändert sich.

### Geändert

- **Schriften auf Latein gekürzt.** Literata, Mona Sans (auch Display
  Expanded) und Monaspace enthalten nur noch Latein mit seinen Erweiterungen,
  Satzzeichen, hoch- und tiefgestellte Ziffern, Pfeile, Rechenzeichen und die
  Zeichen, die die Produkte als Text setzen (✓, ★, ●, ▲, ⋯, ⏯), ohne
  Hinting; Layout-Features (Tabellenziffern, Texture Healing, Kerning)
  bleiben. Im Flutter-Paket 0,85 statt 2,3 MB (gzip 0,48 statt 1,28 MB), im
  Web 385 statt 930 KB WOFF2. Der Webbuild einer Flutter-App lädt jede Schrift
  vor dem ersten Bild; bei Panzergefecht war das über ein Megabyte Wartezeit.
  Geprüft gegen alle Texte von KNX Monitor, Jagdaufseher und Panzergefecht
  und gegen die Doku; kein Zeichen, das eine Schrift vorher hatte, fehlt dort.
  Gekürzt wird mit `tool/subset_fonts.py`, der Bereich steht im Kopf der
  Datei.

### Neu

- 65 Symbole für Panzergefecht: Modi, Fahrzeuge, Nachschub
  (`local_gas_station`, `inventory_2`, `local_fire_department`, `fort`,
  `military_tech` …), Gelände und Wetter (`landscape`, `terrain`, `park`,
  `waves`, `ac_unit`, `wb_sunny`, `nightlight_round`), Steuerung (`keyboard`,
  `mouse`, `settings_remote`, `qr_code_scanner`) und Menüs (`school`,
  `leaderboard`, `language`, `volume_up`, `volume_off`, `login`,
  `swap_horiz` …). Das Subset ist damit 31 KB als TTF und 15 KB als WOFF2
  (vorher 22 und 10).

### Heben

- Apps: `ref: v0.6.3`. Alle bisherigen Symbole behalten ihren Codepoint;
  Text, der Zeichen außerhalb des Bereichs nutzt (Griechisch, Kyrillisch),
  fällt auf die Systemschrift zurück.
- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.6.3`.

## 0.6.2

Zehn Symbole mehr, damit Jagdaufseher aufhören kann, vier verschiedene Dinge
mit demselben Zeichen zu benennen. Sonst ändert sich nichts: keine Farbe,
kein Maß, kein Widget.

### Neu

- Symbole für Jagdaufseher: `deck`, `cabin`, `tools_ladder`, `event_seat`
  (die vier Arten von Ansitzeinrichtung, an der Form unterscheidbar: Plattform
  auf Pfosten, geschlossene Kanzel, Leiter, Sitz am Boden), `grain`,
  `rice_bowl`, `diamond` (was eine Versorgungsstelle vorhält: gestreutes
  Korn, volle Schale, Salzblock), `yard` (Wildacker) und `gate` (Schranke).
- `undo` in den Aktionen. Es fehlte, und wer es brauchte, nahm `replay` -
  ein Kreispfeil, der „noch einmal abspielen“ heißt, nicht „zurücknehmen“.

Das Subset ist damit 22 KB als TTF und 10 KB als WOFF2 (vorher 20 und 10).

### Heben

- Apps: `ref: v0.6.2`. Nur nötig, wenn eines der neuen Symbole gebraucht
  wird; alles bisherige behält seinen Codepoint.
- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.6.2`.

## 0.6.1

Aufräumen nach der Umstellung von KNX Monitor: Code, Doku und gerenderte
Seite sagen wieder dasselbe, der Umriss hat genug Kontrast, und was KNX
Monitor gebaut hat, liegt jetzt im Paket.

### Geändert

- **`line-strong` ist dunkler** und hat jetzt mindestens 3:1 zu `bg`,
  `surface` und `sunken` (WCAG 1.4.11), in allen Neutralen. Seit 0.6.0 ist
  er der einzige Umriss von Feldern, Knöpfen, Karten und Dialogen und lag bei
  1,5 bis 2,3:1. Entschieden: eine Umrissfarbe bleibt, sie wird kräftiger.

  | Neutrale | vorher | jetzt | zu `bg` |
  | --- | --- | --- | --- |
  | hell | `#C8C9C0` | `#8A8B84` | 1,60 → 3,29 |
  | dunkel | `#42453E` | `#656760` | 1,91 → 3,25 |
  | Gelände dunkel | `#4A5838` | `#667154` | 2,32 → 3,43 |
  | Home Assistant hell | `#BDBDBD` | `#8B8B8B` | 1,80 → 3,26 |
  | Home Assistant dunkel | `#474747` | `#676767` | 2,03 → 3,34 |

- `onError` im `ColorScheme` ist jetzt `on-critical` (hell `#FFFFFF`, dunkel
  `#121311`); vorher hing es an `surface` bzw. `bg` und damit am Gastgeber.
- `HorizontRail` ist standardmäßig `HzSize.sidebar` breit (unverändert 240).
- Symbolgrößen im Paket kommen aus `HzIconSize` (Werte unverändert).

### Neu

- Tokens: `color.status.*.on-critical`; `color.data` (sequenzielle Rampe in
  fünf Stufen für Heatmaps, ein Ton, weder Akzent noch Status);
  `size.sidebar` 240, `size.inspector` 300, `size.grid-card` 240,
  `size.form` 400, `size.search` 320; `icon-size` (badge 14, inline 16, row
  18, bar 22, tab 24). Im CSS als `--on-critical`, `--data-1` bis `--data-5`,
  `--size-*` und `--icon-*`.
- Symbole: gefüllt `star_fill` und `push_pin_fill` (Codepoint 0xF0000 + der
  umrissene). `tool/build_symbols.py` kennt dafür die Zeile `name:fill`.
- Flutter, aus KNX Monitor übernommen:
  - `Kennung(text, count:, oneLine:)`: einzeilig kürzt der Begriff mit „…“,
    der Zähler bleibt; `horizontMetaSeparator` („ · “).
  - `HorizontSectionHeader`: Kennung mit Zähler und leise Aktionen rechts.
  - `HorizontMetric` und `HorizontMetricRow`.
  - `HorizontStatusLine`: Zustand im Fließtext, Zeichen und Wort in der
    Statusfarbe.
  - `HorizontLetterBadge`: Kürzel als quadratisches Kennzeichen.
  - `HorizontEmptyHint`.
  - `horizontDialogAction` mit `destructive`, und
    `HorizontTheme.of(context).criticalButton` für den `FilledButton` einer
    unumkehrbaren Aktion. KNX nutzte dafür bisher zwei verschiedene
    Vordergründe (`bg` und `onAccent`).
  - `HorizontColors.onCritical` und `HorizontColors.dataRamp`.
  - `package:horizont/testing.dart` mit `loadHorizontFonts()` für Goldens.
- Tests: `line-strong` 3:1 auf allen Flächen, `accent-text` auf
  `accent-tint`, `on-critical` auf `critical`, Statusfarben auf `bg` und
  `surface`, die Datenrampe (monoton, letzte Stufe 3:1).
- Showcase-Goldens mit `HorizontField`, FAB, Tablet (Seitenleiste, FAB mit
  Wort) und KNX in Home Assistant hell und dunkel.

### Doku

- Eine FAB-Regel statt zwei: unter 600 quadratisch mit Symbol und Tooltip,
  ab 600 mit Wort, auf iOS wie auf Android.
- Die bewussten Abweichungen von der Plattform nennen jetzt auch die getönte
  Tab-Bar und den FAB auf iOS.
- Tab-Bar überall gleich beschrieben und im Entwurf gleich gezeichnet: die
  Tönung umschließt Icon und Wort, Icon in `accent-text`, Wort halbfett in
  `text`.
- Felder mit `HorizontField` (Beschriftung darüber), „Ansichten unten, Menü
  links“ statt „ab 600 Seitenleiste“, Radius 6 für Kästen neben Feldern, ein
  Umriss in `line-strong`, Gastgeber nur in Flutter, gemessene Größe des
  Symbol-Subsets, der Blog hängt an einem Tag.

### Heben

- Apps: `ref: v0.6.1`. Eigene Zahlen für Formular, Suche, Seitenleiste,
  Inspektor und Kartenraster durch `HzSize.*` ersetzen, `critical`-Knöpfe auf
  `criticalButton` bzw. `horizontDialogAction(…, destructive: true)`,
  Heatmaps auf `colors.dataRamp`, eigene Kopien von SectionLabel, Metric,
  TypeBadge, EmptyHint und dem Schriftladen in Tests durch die Paket-Widgets.
  Goldens neu erzeugen: alle Umrisse sind dunkler.
- Seiten: `hugo mod get github.com/regetskcob/horizont@v0.6.1`.

## 0.6.0

KNX Monitor ist die erste App auf Horizont; was dort am Gerät entschieden
wurde, gilt für alle Apps.

- Hauptaktion als FAB auf jeder Touch-Plattform, auch iOS; mit Zeiger in der
  Werkzeugleiste.
- `HorizontField`: die Beschriftung über dem Feld, Feld und Beschriftung als
  eine Gruppe für den Screenreader.
- Ein Umriss für alles mit Rahmen: `line-strong`. `line` trennt nur Zeilen.
- Tab-Bar unten mit Tönung statt Linie, die Tönung umschließt Icon und Wort,
  die Leiste ist nur so hoch wie ihre Tabs.
- Kästen zwischen Feldern und Knöpfen nehmen deren Radius 6.
- Knöpfe behalten mit Zeiger die Steuerhöhe 28.
- Gastgeber-Neutrale für Home Assistant (`HorizontHost.homeAssistant`).
- Symbole für KNX Monitor, darunter Wetter, Seitenleiste auf und zu.
- Showcase-Goldens.

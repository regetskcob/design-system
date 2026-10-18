# Änderungen

Jede Version gilt zugleich für Tokens (`tokens/horizont.json`), das
Flutter-Paket (`flutter/pubspec.yaml`) und den Git-Tag. Apps und Seiten hängen
an einem Tag; unter „Heben“ steht, was beim Wechsel zu tun ist.

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

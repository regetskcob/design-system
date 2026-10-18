# Horizont in Flutter

Leitfaden für die Umstellung von Jagdaufseher, KNX Monitor und Panzergefecht.
Die Regeln selbst stehen in [CLAUDE.md](../CLAUDE.md), die Werte in
[tokens/horizont.json](../tokens/horizont.json).

Wenn in der Sitzung verfügbar, zusätzlich die Skills
`flutter:design-system-structure`, `flutter:adaptive-layout` und
`flutter:accessibility-as-code` laden. Sie decken sich mit dem, was hier
steht. Die CLAUDE.md der jeweiligen App (l10n, Zustandsverwaltung,
Commit-Regeln) gilt weiter.

## Das Paket

Das Paket `horizont` liegt unter `flutter/` (Anleitung: `flutter/README.md`).
Die Apps binden es per Git-Abhängigkeit mit festem Tag ein:

```yaml
dependencies:
  horizont:
    git:
      url: https://github.com/regetskcob/horizont.git
      path: flutter
      ref: v0.6.0
```

Es bringt mit:

- `buildHorizontTheme(product, brightness, density:)` mit dem von Hand
  gesetzten `ColorScheme` aus der Tabelle unten, der Typografie und allen
  Komponenten-Themes.
- Die Extension `HorizontTheme`, gelesen mit `HorizontTheme.of(context)`.
  Sie assertet, statt still auf einen Ersatz zurückzufallen.
- `HorizontColors`, `HorizontSymbols`, die Werte `HzSpace`, `HzRadius`,
  `HzLine`, `HzSize`, `HzBreakpoint`, `HzMotion`, `HzType`.
- Die Widgets `Kennung`, `HorizontBadge`, `HorizontTabBar`, `HorizontRail`,
  `HorizontMark` und `HorizontLockup`, dazu `resolveMotion`.
- `registerHorizontLicenses()` für die Lizenzseite.

Tests im Paket: Kontrast (AA) für jedes Produkt und jeden Modus, Theme,
Widgets inklusive Grundlinie des Lockups. Goldens der Showcase-App liegen in
`flutter/example/test/goldens/`.

In einer App gilt: Nichts davon nachbauen. Fehlt etwas, kommt es ins Paket,
mit Token, Test und neuem Tag.

## Plattformgefühl

Horizont legt Farbe, Schrift, Linie, Abstand und Ton fest. Wie sich eine App
anfühlt, also Gesten, Rückmeldung, Übergänge, Systemdialoge und Dichte, bleibt
bei der Plattform. Das Paket sorgt dafür, solange die App es nicht übersteuert:

- **Rückmeldung beim Tippen:** auf Android die native Welle (Sparkle). Auf
  iOS, macOS, Windows, Linux und im Web keine Welle, sondern nur das
  Abdunkeln beim Drücken und ein Hover-Ton.
- **Seitenübergänge und Zurück-Gesten:** auf iOS und macOS die
  Cupertino-Übergänge mit Wischen zurück, auf Android Predictive Back.
- **Dichte:** Die Plattform bestimmt sie (`HorizontDensity.forPlatform`). Mit
  Zeiger auf Mac, Windows und Linux, Touch auf Telefon und Tablet. Übergeben
  wird sie nur, wenn die App es besser weiß, etwa beim iPad mit Tastatur und
  Trackpad.
- **Cupertino-Theme:** `Switch.adaptive`, `showAdaptiveDialog`,
  `CupertinoDatePicker` und Action Sheets erscheinen nativ, im Akzent und auf
  der Fläche des Produkts, aber mit der Systemschrift.

Für die App selbst gilt:

- **Adaptive Bausteine nutzen:** `Switch.adaptive`, `Slider.adaptive`,
  `Checkbox.adaptive`, `CircularProgressIndicator.adaptive`,
  `AlertDialog.adaptive` bzw. `showAdaptiveDialog`, `Icons.adaptive.*` für
  Zurück, Teilen und Mehr. Auf iOS Datum und Uhrzeit mit
  `CupertinoDatePicker`, Auswahl aus wenigen Aktionen als
  `CupertinoActionSheet`.
- **System nie nachbauen:** Teilen über das System-Sheet, Berechtigungen,
  Dateiauswahl, Textauswahl und Kontextmenüs bleiben nativ. Kein eigener
  Dialog im Horizont-Look, wo das System einen hat.
- **Scrollen nicht anfassen:** Gummiband auf Apple-Plattformen, Glow bzw.
  Stretch auf Android. Keine eigene `ScrollPhysics` ohne Grund.
- **Desktop:** Menüleiste auf macOS (`PlatformMenuBar`), Tastenkürzel,
  Hover-Zustände, Rechtsklick-Menüs, Fenstertitel. Auf dem Mac sitzt die
  Seitenleiste unter der transparenten Titelleiste.
- **Haptik wie die Plattform:** `HapticFeedback.selectionClick` beim Wechsel
  einer Auswahl auf iOS, sonst nur, wo das System es auch tut. Nie zur Zier.
- **Fernseher und Uhr:** Fokus-Engine und Siri Remote auf tvOS, Krone und
  Seitentaste auf watchOS bleiben beim System.

Bewusst anders als die Plattform, so entschieden in regetskcob/horizont#1:
Mona Sans statt Systemschrift in der App-Oberfläche, die Kennung mit linkem
Titel statt des großen iOS-Titels, die Auswahl als Linie statt als Pille.
Darüber hinaus weicht nichts ab, ohne dass es entschieden ist.

## Grundsätze

- Nie `ColorScheme.fromSeed`, nie `dynamic_color`, nie `google_fonts`. Hell
  und dunkel werden von Hand gesetzt, Schriften gebündelt.
- Keine rohen Werte außerhalb von `lib/theme/`. `Color(0x…)`, `Colors.*`,
  feste `BorderRadius`, `Duration` und `fontSize` in Widgets sind Fehler.
  Prüfen mit
  `grep -rnE "Colors\.|Color\(0x|BorderRadius\.circular\(|fontSize:" lib --include=*.dart | grep -v lib/theme/`.
- Elevation 0 überall, `surfaceTintColor: Colors.transparent` (im Theme),
  keine Schatten, keine Verläufe.
- Der Zustand trägt immer Wort und Zeichen. Farbe allein ist ein Fehler.
- Reduzierte Bewegung: `MediaQuery.disableAnimationsOf(context)` setzt alle
  Dauern auf `Duration.zero`.

## ColorScheme

Von Hand je Produkt und Modus. Die Namen in der rechten Spalte sind
Token-Schlüssel, `p.` steht für `color.product.<id>.<mode>`, `n.` für
`color.neutral.<mode>`, `s.` für `color.status.<mode>`.

| ColorScheme | Token |
| --- | --- |
| primary | p.accent |
| onPrimary | p.on-accent |
| primaryContainer | p.accent-tint |
| onPrimaryContainer | p.accent-text |
| secondary | p.accent-text |
| onSecondary | p.on-accent |
| secondaryContainer | n.sunken |
| onSecondaryContainer | n.text |
| tertiary | s.info |
| tertiaryContainer | s.info-tint |
| error | s.critical |
| errorContainer | s.critical-tint |
| onErrorContainer | s.critical |
| surface | n.bg |
| onSurface | n.text |
| onSurfaceVariant | n.text-muted |
| surfaceContainerLowest, surfaceContainerLow | n.surface |
| surfaceContainer, surfaceContainerHigh | n.sunken |
| surfaceContainerHighest | n.line |
| outline | n.line-strong |
| outlineVariant | n.line |
| inverseSurface / onInverseSurface | n.text / n.bg |
| surfaceTint | transparent |

`onError` ist `#FFFFFF` in hell und `n.bg` in dunkel. Bei Panzergefecht
ersetzen im Dunkeln die Werte aus `neutralDark` die `n.*`.

## ThemeExtension

Was nicht ins `ColorScheme` passt, kommt in eine `HorizontTokens`-Extension
mit `static HorizontTokens of(BuildContext context)` (das assertet, wenn die
Extension fehlt):

- Farben: `positive`, `positiveTint`, `warning`, `warningTint`, `critical`,
  `criticalTint`, `info`, `infoTint`, `textFaint`, `accentText`
- Abstände `s2 … s96`, Radien `r0 r2 r6 r10 r16`, Linien `hairline` (1) und
  `selection` (2)
- Dauern `fast` (120), `base` (200), `slow` (320), Kurve
  `Cubic(0.2, 0, 0, 1)`
- Textstile `data` und `kennung` (Monaspace) sowie `reading` (Literata)

## Typografie

| TextTheme | Token |
| --- | --- |
| displaySmall | display (Literata 300, 44/48) |
| headlineMedium | headline (Literata 300, 30/36) |
| titleLarge | title-1 (24/30, 600) |
| titleMedium | title-2 (20/26, 600) |
| titleSmall | title-3 (17/24, 600) |
| bodyLarge | body (16/24) |
| bodyMedium | callout (14/20) |
| bodySmall | caption (12/16) |
| labelLarge | label (13/16, 500) |

`data` (14/20) und `kennung` (11/16, 600, Sperrung 0.08 em, Versalien über
`toUpperCase()` im Widget, nicht im String der ARB) liegen in der Extension.
Beide sind Monaspace mit `FontFeature.tabularFigures()`. Zeilenhöhe als
`height = line / size`.

Die Schriften liegen in `flutter/fonts/`: Literata (Light, Light Italic,
SemiBold), Monaspace Argon (Regular, SemiBold), Mona Sans (Regular, Medium,
SemiBold) und für Panzergefecht Mona Sans Display Expanded (Bold, Black).
Lizenzen: `OFL.txt`, `MaterialSymbols-LICENSE.txt`. Familien im
`pubspec.yaml`: `Literata`, `MonaspaceArgon`, `MonaSans`,
`MonaSansDisplayExpanded`, `MaterialSymbolsSharp`.

UI-Ikonen kommen aus `MaterialSymbolsSharp-300.ttf` (Subset, Codepoints in
`icons/material-symbols.json`), etwa
`IconData(0xea99, fontFamily: 'MaterialSymbolsSharp', fontPackage: 'horizont')` für `forest`.
Nicht das Paket `material_symbols_icons`, es bündelt alle Symbole.

## Komponenten im Theme

- **AppBar:** `elevation: 0`, `scrolledUnderElevation: 0`, Hintergrund
  `surface` (= n.bg), unten eine Haarlinie (`shape: Border(bottom:
  BorderSide(color: outlineVariant))`). Über dem Titel eine Kennung statt
  eines Large Title. Titel in `titleLarge`, Aktionen als Icon-Buttons im
  Akzent.
- **Card:** `elevation: 0`, Farbe n.surface, Radius 10, Rand
  `outlineVariant`. Sparsam einsetzen, Listen brauchen keine Karten.
- **Listen:** `ListTile` mit Trennlinie, die am Text beginnt (Einzug wie das
  Leading). Meta-Zeilen (IDs, Datum) im Stil `data` klein.
- **Knöpfe:** `FilledButton` (Akzent) nur für die eine Hauptaktion,
  `OutlinedButton` (Rand line-strong, Text n.text) für die zweite,
  `TextButton` (accent-text) für leise Aktionen. Radius 6, Mindesthöhe 44 auf
  Touch und 28 mit Zeiger.
- **Felder:** `OutlineInputBorder`, Radius 6, Rand line-strong, im Fokus
  Akzent 2 px, Fehler critical mit Zeichen in der Hilfezeile.
- **Status:** ein eigenes Widget `HorizontBadge(kind, label)` mit Fläche
  `*Tint`, Zeichen (Haken, Dreieck, Achteck, Kreis) und Wort, Radius 2.
- **Auswahl als Linie:** `TabBar` mit `UnderlineTabIndicator(borderSide:
  BorderSide(width: 2, color: primary))` und `dividerColor: outlineVariant`.
  Für Tab-Bar und `NavigationRail` ein eigenes schlankes Widget, das die
  2-px-Linie über dem Ziel bzw. links davon zeichnet. Den Pillen-Indikator
  von Material 3 nicht nachbauen
  (`indicatorColor: Colors.transparent` reicht nicht für die Linie).
- **SegmentedButton:** Radius 6, Rand line-strong, Auswahl mit
  accent-tint, `showSelectedIcon: false`.
- **Switch:** Spur accent, Daumen on-accent. Er ist die einzige runde Form
  neben Ortspunkt und Avatar.
- **FAB** (Touch: Telefon und Tablet, alle Plattformen; höchstens einer; mit Zeiger stattdessen in der Werkzeugleiste): `elevation: 0`, Radius 10, Akzent,
  als `FloatingActionButton.extended` mit Wort.
- **Dialog, BottomSheet:** `elevation: 0`, Radius 10 (große Sheets 16),
  Rand outlineVariant.
- **Divider:** outlineVariant, Dicke 1, Abstand 1.
- **Rückmeldung:** setzt das Paket je Plattform (Welle nur auf Android), siehe „Plattformgefühl“. Nicht in der App überschreiben.
- **Tab-Bar:** `HorizontTabBar` aus dem Paket. Lange Wörter bekommen in der
  ARB einen weichen Trennstrich (`Einrich\u00ADtungen`). Bei großer Schrift
  höchstens vier Ziele, sonst ab 600 die Rail. Labels nie kürzen,
  abschneiden oder verkleinern.

## Dichte und Formfaktoren

- Gebaut wird nach Breite: `LayoutBuilder` bzw.
  `MediaQuery.sizeOf(context).width` gegen 600 / 840 / 1200, nie
  `Platform.isIOS` für das Layout.
- Unter 600: Tab-Bar, eine Spalte, Rand 16. Ab 600: Seitenleiste
  (NavigationRail bzw. eigene Seitenleiste), Rand 24. Ab 840 quer:
  Inspektor rechts. Ab 1200: Raster aus Karten (mindestens 240 breit),
  Inspektor 280 bis 320.
- Mit Zeiger (macOS, Windows, Linux, Web am Rechner):
  `VisualDensity.compact`, Steuerelemente 28, Werkzeugleiste 52, Zeilen 28,
  Hover-Zustände, Tastenkürzel. Auf Touch bleibt jedes Ziel mindestens 44.
- tvOS und Android TV: Fokus statt Zeiger. Die fokussierte Kachel skaliert
  auf 1.06 und trägt einen Akzentring (3 px, Abstand 4). Schrift × 1,5,
  sicherer Rand 60/80.
- watchOS und Wear OS: ein Wert groß in `data`, eine Aktion, schwarze
  Fläche.

## Umstellung je App

Reihenfolge: KNX Monitor (hat schon Tokens), dann Jagdaufseher, dann
Panzergefecht. Jede App in einer eigenen Sitzung und einem eigenen Branch,
mit Goldens vorher und nachher.

### KNX Monitor (`~/Debug-KNX`, Repo `regetskcob/KNX-Monitor`)

- Theme in `lib/theme/`: `brand.dart`, `app_theme.dart` (heute
  `fromSeed(lime)` mit vielen Überschreibungen), `palette.dart` (auch für
  den PDF-Export), `tokens.dart`. Struktur behalten, Werte auf Horizont
  setzen, `fromSeed` durch das von Hand gesetzte Schema ersetzen.
- Radien 18/12/8 werden 10/6/2, Dialoge 20 werden 16, Popups 14 werden 10.
- Telegrammtypen: W (schreiben) = accent, R (lesen) = warning, A (Antwort) =
  info, immer mit Buchstabe. Die Serienfarben der Diagramme bleiben
  Datenfarben.
- Werte (Gruppenadressen, Zeiten, Messwerte) in Monaspace statt nur mit
  Tabellenziffern.
- Übernehmen, was gut ist: Aktivitätsleiste (Ø Tel./min mit Balken der
  letzten 60 s), Raumkarten mit ↙ Status und ↗ Befehl, große Werte mit
  Verlauf und Mittelwert. Abschnittsköpfe werden zu Kennungen mit Zähler.
- Icon: `LogoPainter` zeichnet heute das Telegramm. Neu ist die Busklemme
  auf dem Buskabel (siehe `web/partials/app-icon.html`, Produkt `knx`).
- Das Home-Assistant-Add-on übernimmt die Neutralen von HA, Akzent und
  Schrift bleiben: `buildHorizontTheme(HorizontProduct.knx, b, host:
  HorizontHost.homeAssistant)`, nur wenn die App in Ingress läuft.

### Jagdaufseher (`~/jagdaufseher`, Repo `regetskcob/jagdaufseher`)

- Theme in `lib/app/theme.dart` (`appTheme(Brightness)` mit `fromSeed`
  #2F5D3A). Ersetzen durch ein `lib/theme/` nach diesem Leitfaden.
- Harte Farben ersetzen: Aufgabenpriorität in
  `lib/features/tasks/model/task.dart` (`Colors.blueGrey/blue/deepOrange`)
  und Zustand der Einrichtungen in
  `lib/features/facilities/model/facility.dart` (`green/orange/red/grey`)
  werden Status-Tokens mit Zeichen und Wort (gut = positive, prüfen =
  warning, defekt = critical, unbekannt = neutral). Der Ortspunkt der Karte
  (`#1A73E8`) wird info.
- Radien 16/20/10/6/4 auf die Skala bringen.
- Fünf Ziele: Übersicht, Einrichtungen, Aufgaben, Wild, Karte. Auf dem iPad
  Seitenleiste mit den vier Kennzahlen (offene Aufgaben, überfällig, prüfen,
  Strecke) am Fuß.
- Karte: Grundkarte gedämpft, Reviergrenze im Akzent, Einrichtungen als
  eckige Marker mit Zustandsrand und Kennung (`K-07`).
- Laut App-CLAUDE.md: Texte über die ARB-Dateien, Zustand mit flutter_bloc,
  jeder FAB mit eigenem `heroTag`.
- Icon: die Kanzel am Waldrand ersetzt die Leiter auf dem Verlauf.

### Panzergefecht (`~/wargame`, Repo `regetskcob/wargame`)

- Theme in `lib/src/ui/theme.dart` (`GameColors`, `buildGameTheme`), Formen
  in `lib/src/ui/widgets/panel.dart` (`GameShapes`, `Plate`). Heute gibt es
  nur dunkel.
- Dunkel mit Gelände-Neutralen (`neutralDark`), Akzent Signalgelb #FFB300
  auf `on-accent` #1A1405. Hell (Store, Hilfe) mit den normalen Neutralen
  und #8F6400.
- Die Fasen an Panels entfallen, es gelten Radius 6/10 und Haarlinien. Die
  Überschriften bleiben in Versalien, schwer und gesperrt, als Spielcharakter
  (Mona Sans Display Expanded).
- Die Spielwelt bleibt unberührt: Gelände der Karten
  (`lib/src/game/map_theme.dart`), Team- und Tarnfarben
  (`lib/src/game/game_config.dart`), Flame-Komponenten.
- HUD nur in den Ecken: Panzerung oben links, Lage oben rechts, runde Karte
  unten rechts. Werte in Monaspace.
- Warteraum: Code groß in Mono, QR, „Besatzungen im Raum“, Fahrzeuge als
  Regal mit Wertebalken (Panzerung, Tempo, Wendigkeit, Feuerkraft).
- Watch: Start mit Name und einer Hauptaktion, im Gefecht nur „n übrig“ und
  die Panzerung.
- Icon: der Panzer in Seitenansicht auf dem Horizont.

## Prüfen vor dem Abschluss

- Goldens in hell und dunkel, bei Textgröße 1.0 und 2.0, LTR.
- Kein roher Wert außerhalb von `lib/theme/` (grep oben).
- Jeder Status mit Wort und Zeichen, Screenreader-Label inklusive.
- Kontrast: Text mindestens 4,5:1, große Schrift und Linien 3:1. Die
  Token-Paare sind geprüft, eigene Kombinationen nicht.
- Auf einem echten Gerät ansehen. Store-Screenshots kommen in den
  Geräterahmen der Doku.

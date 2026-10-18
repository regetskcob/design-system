# horizont (Flutter)

Das Flutter-Paket von Horizont: Tokens, Theme, Schriften, Symbole und die
Grund-Widgets, die jede App braucht. Regeln: [CLAUDE.md](../CLAUDE.md),
Leitfaden: [docs/flutter.md](../docs/flutter.md).

```yaml
dependencies:
  horizont:
    git:
      url: https://github.com/regetskcob/horizont.git
      path: flutter
      ref: v0.6.1
```

```dart
void main() {
  registerHorizontLicenses();
  runApp(MaterialApp(
    theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
    darkTheme: buildHorizontTheme(HorizontProduct.knx, Brightness.dark),
    themeAnimationStyle: AnimationStyle.noAnimation,
    home: const HomePage(),
  ));
}
```

| Baustein | Zweck |
| --- | --- |
| `buildHorizontTheme(product, brightness, density:, platform:, host:)` | `ThemeData` mit von Hand gesetztem `ColorScheme`, Typografie und Komponenten-Themes; Rückmeldung, Übergänge, Dichte und adaptive Widgets bleiben nativ |
| `HorizontTheme.of(context)` | Farb-Slots (`colors`, auch `onCritical` und `dataRamp`), Textstile `data`, `kennung`, `reading`, `display`, Dichte |
| `HorizontSymbols.*` | Material Symbols Sharp (Liste: `icons/material-symbols.txt`), wenige gefüllt (`starFill`, `pushPinFill`) |
| `Kennung('…', count:, oneLine:)` | Mono-Versalien, gelesen wie geschrieben; einzeilig kürzt der Begriff, der Zähler bleibt |
| `HorizontSectionHeader` | Kopf eines Abschnitts: Kennung mit Zähler, leise Aktionen rechts |
| `HorizontField(label:, help:, child:)` | Beschriftung über dem Feld, Hilfezeile darunter |
| `HorizontBadge(status, label:)` | Status mit Zeichen, Wort und Farbe |
| `HorizontStatusLine(status, text)` | Zustand im Fließtext: Zeichen und Wort in der Statusfarbe |
| `HorizontLetterBadge('W', semanticLabel:)` | Kürzel als quadratisches Kennzeichen, wächst mit der Schrift |
| `HorizontMetric`, `HorizontMetricRow` | Kennzahl: Kennung als Begriff, Wert in Mono; Reihe, die umbricht |
| `HorizontEmptyHint` | Leere Ansicht mit Satz, Erklärung und der nächsten Aktion |
| `horizontDialogAction(context, …)` | Knopf für `showAdaptiveDialog`, nativ auf Apple, `destructive` in critical |
| `HorizontTheme.of(context).criticalButton` | Stil des `FilledButton` einer unumkehrbaren Aktion (critical, on-critical) |
| `HorizontTabBar`, `HorizontRail` | Navigation: unten Tönung um Icon und Wort, in der Seitenleiste die 2-px-Linie |
| `HorizontMark`, `HorizontLockup` | Glyphe, Marke auf der Grundlinie des Namens |
| `resolveMotion(context, HzMotion.base)` | Dauer oder null bei reduzierter Bewegung |
| `HzSpace`, `HzRadius`, `HzLine`, `HzSize`, `HzIconSize`, `HzBreakpoint`, `HzType` | Werte für Layouts, nie eigene Zahlen |
| `loadHorizontFonts()` aus `package:horizont/testing.dart` | Lädt die Schriften in Tests, damit Goldens sie zeigen |

## Entwickeln

```sh
dart run tool/generate_tokens.dart   # nach jeder Änderung an tokens/ oder icons/
cd flutter && flutter test           # Kontraste (AA als Test), Theme, Widgets
cd example && flutter test           # Goldens, nur lokal (macOS)
cd example && flutter run -d chrome  # Showcase mit Umschaltern
```

`lib/src/tokens.g.dart` wird generiert und nie von Hand geändert. Die CI
prüft, dass die Datei frisch ist.

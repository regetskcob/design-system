# horizont (Flutter)

Das Flutter-Paket von Horizont: Tokens, Theme, Schriften, Symbole und die
Grund-Widgets, die jede App braucht. Regeln: [CLAUDE.md](../CLAUDE.md),
Leitfaden: [docs/flutter.md](../docs/flutter.md).

```yaml
dependencies:
  horizont:
    git:
      url: https://github.com/regetskcob/design-system.git
      path: flutter
      ref: v0.3.0
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
| `buildHorizontTheme(product, brightness, density:)` | `ThemeData` mit von Hand gesetztem `ColorScheme`, Typografie und Komponenten-Themes |
| `HorizontTheme.of(context)` | Farb-Slots (`colors`), Textstile `data`, `kennung`, `reading`, `display`, Dichte |
| `HorizontSymbols.*` | Material Symbols Sharp (Liste: `icons/material-symbols.txt`) |
| `Kennung('…')` | Mono-Versalien, gelesen wie geschrieben |
| `HorizontBadge(status, label:)` | Status mit Zeichen, Wort und Farbe |
| `HorizontTabBar`, `HorizontRail` | Navigation, Auswahl als 2-px-Linie |
| `HorizontMark`, `HorizontLockup` | Glyphe, Marke auf der Grundlinie des Namens |
| `resolveMotion(context, HzMotion.base)` | Dauer oder null bei reduzierter Bewegung |
| `HzSpace`, `HzRadius`, `HzLine`, `HzSize`, `HzBreakpoint`, `HzType` | Werte für Layouts, nie eigene Zahlen |

## Entwickeln

```sh
dart run tool/generate_tokens.dart   # nach jeder Änderung an tokens/ oder icons/
cd flutter && flutter test           # Kontraste (AA als Test), Theme, Widgets
cd example && flutter test           # Goldens, nur lokal (macOS)
cd example && flutter run -d chrome  # Showcase mit Umschaltern
```

`lib/src/tokens.g.dart` wird generiert und nie von Hand geändert. Die CI
prüft, dass die Datei frisch ist.

# Horizont im Web

Leitfaden für Hugo-Seiten: Blog, Landingpages, Dokumentation, Web-Apps. Die
Regeln stehen in [CLAUDE.md](../CLAUDE.md).

## Einbinden

Alle Web-Oberflächen sind Hugo-Seiten (der Blog, die Landingpages von KNX
Monitor und Panzergefecht, Jagdaufseher liegt im Blog unter
`/jagdaufseher/`). Horizont kommt als Hugo-Modul:

```toml
[module]
  [[module.imports]]
    path = 'github.com/regetskcob/design-system'
    [[module.imports.mounts]]
      source = 'tokens'
      target = 'data'
    [[module.imports.mounts]]
      source = 'web/css'
      target = 'assets/css/horizont'
    [[module.imports.mounts]]
      source = 'web/partials'
      target = 'layouts/_partials/horizont'
    # Only where the site does not ship Literata and Monaspace itself:
    [[module.imports.mounts]]
      source = 'web/fonts'
      target = 'static/fonts'
```

```bash
hugo mod get github.com/regetskcob/design-system@main
```

Das ändert `go.mod` und `go.sum`. Im CI braucht der Build Go, wie im
Workflow des Blogs.

CSS in der Reihenfolge Tokens, Komponenten, eigene Regeln. `tokens.css` ist
ein Template:

```go-html-template
{{ $hz := site.Data.horizont }}
{{ $css := slice
  (resources.Get "css/horizont/tokens.css" | resources.ExecuteAsTemplate "css/horizont-tokens.css" $hz)
  (resources.Get "css/horizont/components.css")
  (resources.Get "css/site.css")
  | resources.Concat "css/site.css" | minify | fingerprint }}
<link rel="stylesheet" href="{{ $css.RelPermalink }}">
```

`components.css` lädt die Schriften aus `../fonts/`, relativ zum CSS. Das
CSS liegt deshalb eine Ebene unter dem Ordner `fonts/`, etwa unter `css/`
oder `assets/`.

Auf `<html>` gehören:

- `data-product="jagdaufseher|knx|panzergefecht|regetskcob"`: setzt den
  Akzent (und bei Panzergefecht im Dunkeln das Gelände).
- `data-theme="light|dark"` nur, wenn der Modus erzwungen wird. Ohne das
  Attribut folgt die Seite dem System. Beides geht auch auf Teilbäumen, etwa
  für ein dunkles Mockup auf einer hellen Seite.
- `data-density="desktop"` für Web-Apps mit Zeiger (Steuerelemente 28,
  Zeilen 28).
- `class="hz"` auf `<body>`: Grundfarben und Schrift.

Ein bestehendes Theme (wie typo im Blog) wird nicht umgeschrieben. Eine
Brücke setzt seine Variablen aus den Tokens, siehe
`assets/css/horizont-blog.css` im Blog.

## Variablen

Neutrale `--bg --surface --sunken --line --line-strong --text --text-muted
--text-faint`, Status `--positive --warning --critical --info` (je mit
`-tint`), Produkt `--accent --on-accent --accent-tint --accent-text`,
Schriften `--font-serif --font-sans --font-mono`, Abstände `--s-<n>`, Radien
`--r-<n>`, Linien `--line-hairline --line-selection --line-focus`, Bewegung
`--motion-fast|base|slow --ease-standard`, Größen `--size-<name>`,
Hardware `--device-<name>`. Typo-Klassen `.t-display` bis `.t-kennung`.

## Komponenten

| Klasse | Zweck |
| --- | --- |
| `.hz-button` + `--primary --secondary --quiet --critical --dense` | Knöpfe, `--primary` nur einmal pro Ansicht |
| `.hz-field`, `.hz-input`, `.hz-help`, `.hz-error` | Formularfelder; `aria-invalid="true"` für Fehler |
| `.hz-list`, `.hz-row` (`--inset`), `.hz-row-lead/-title/-meta/-trail` | Listen mit Haarlinie ab dem Text; `aria-selected="true"` trägt die Linie |
| `.hz-section-head` | Kennzeile über einem Abschnitt |
| `.hz-badge` + `--positive --warning --critical --info --accent` | Status, immer mit Zeichen und Wort |
| `.hz-segmented` (Buttons mit `aria-pressed`) | Umschalter, Auswahl als Linie unten |
| `.hz-tabs` (Links mit `aria-current`) | Tabs, Auswahl als Linie |
| `.hz-switch` | Schalter (`input type=checkbox`) |
| `.hz-card` | Fläche mit Haarlinie, Radius 10, selten |
| `.hz-table`, `.hz-num`, `.hz-mono` | Datentabellen, Werte in Mono rechtsbündig |
| `.hz-kennung`, `.hz-muted`, `.hz-mono`, `.hz-rule` | Kennung, gedämpfter Text, Mono, Linie |
| `.hz-lockup` (`--mark`) | Marke und Name auf einer Grundlinie |
| `figure.hz-device.hz-device--<gerät>` + `.hz-device-screen` | Geräterahmen für Screenshots |

Die Geräterahmen gibt es als `iphone`, `android`, `ipad`, `laptop`, `tv` und
`watch`, dazu `--cropped` (Telefon endet am Abschnittsrand, `--h` gibt die
Höhe). `--w` ist die Außenbreite, alles andere folgt daraus:

```html
<figure class="hz-device hz-device--iphone" style="--w: 300px">
  <div class="hz-device-screen"><img src="…" alt="…"></div>
</figure>
```

## Partials

```go-html-template
{{/* Glyph in the text colour, for heads, footers, lockups */}}
{{ partial "horizont/mark.html" (dict "product" "knx" "size" 24) }}

{{/* Illustrated app icon; Panzergefecht has variant "side" (default) or "top" */}}
{{ partial "horizont/app-icon.html" (dict "product" "jagdaufseher" "size" 128) }}

{{/* SVG favicon from the app icon */}}
{{ $fav := partial "horizont/app-icon.html" (dict "product" "regetskcob" "size" 64) | resources.FromString "favicon.svg" }}
<link rel="icon" type="image/svg+xml" href="{{ $fav.RelPermalink }}">

{{/* Placeholder UI icons as a sprite: <svg><use href="#i-stand"/></svg> */}}
{{ partial "horizont/icons.html" . }}
```

Lockup mit Marke und Name:

```html
<a class="hz-lockup" href="/">{{ partial "horizont/mark.html" (dict "product" "regetskcob" "size" 22) }}<span>regetskcob</span></a>
```

## Landingpage („Feldseite“)

Aufbau, wie in der Doku unter „Entwürfe“:

1. Kopf: Lockup mit Glyphe im Akzent und Produktname (Mona Sans 600), rechts
   die Navigation leise.
2. Hero, links ausgerichtet: Kennung (`01 — IN ENTWICKLUNG · IPHONE ·
   ANDROID`), Überschrift in `.t-display` (Literata 300), ein Absatz in
   `text-muted`, eine Hauptaktion (`--primary`) und eine zweite
   (`--secondary`). Rechts das Produkt im Geräterahmen oder, bei Daten, die
   Daten selbst im Rahmen.
3. Die Horizontlinie: 2 px im Akzent über die volle Breite.
4. Abschnitte im Raster „Kennung links (`02 — EINRICHTUNGEN`) | Überschrift
   und Text | Fakten als Liste mit Begriff in Mono“. Begriffsspalte mit fester
   Breite, Begriff und Wert auf einer Grundlinie.
5. Fuß: Lockup „ein Projekt von regetskcob“ mit der Glyphe, rechts Impressum
   und Datenschutz.

Nicht verwenden: zentrierter Hero, Badge- oder Eyebrow-Pille, Kachelraster
mit Icon in getönter Fläche, abwechselnde Abschnittsfarben, Schatten unter
Screenshots, nackte Screenshots ohne Rahmen.

## Prüfen

- Hell und dunkel (Systemeinstellung und, wo vorhanden, Umschalter).
- 375 px Breite: kein horizontaler Überlauf. Schnell prüfbar mit
  `document.documentElement.scrollWidth === document.documentElement.clientWidth`.
- Grundlinien von Lockups und Faktenlisten nachmessen: die Horizontlinie
  der Marke (Oberkante + 2/3 der Höhe) liegt auf der Grundlinie des Textes.
- Keine Konsolenfehler, keine Assets über `http://` (Basis-URL immer
  `https://`).
- Keine externen Schriften oder Skripte (Datenschutz). Schriften liegen
  lokal.

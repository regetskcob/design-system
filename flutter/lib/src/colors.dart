import 'package:flutter/widgets.dart';

import 'tokens.g.dart';

/// The semantic colour slots of one product in one brightness: tier 2.
///
/// Widgets read these through `HorizontTheme.of(context).colors`, never the
/// raw values in `tokens.g.dart`. Panzergefecht's own neutrals in the dark
/// (Gelände) are already applied.
@immutable
class HorizontColors {
  /// Creates a set of slots. Prefer [HorizontColors.resolve].
  const HorizontColors({
    required this.bg,
    required this.surface,
    required this.sunken,
    required this.line,
    required this.lineStrong,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.accent,
    required this.onAccent,
    required this.accentTint,
    required this.accentText,
    required this.positive,
    required this.positiveTint,
    required this.warning,
    required this.warningTint,
    required this.critical,
    required this.criticalTint,
    required this.info,
    required this.infoTint,
  });

  /// The slots of [product] in [brightness], from the tokens.
  factory HorizontColors.resolve(HorizontProduct product, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final n = dark ? (product.neutralDark ?? HzColors.neutralDark) : HzColors.neutralLight;
    final s = dark ? HzColors.statusDark : HzColors.statusLight;
    final a = dark ? product.dark : product.light;
    return HorizontColors(
      bg: n.bg,
      surface: n.surface,
      sunken: n.sunken,
      line: n.line,
      lineStrong: n.lineStrong,
      text: n.text,
      textMuted: n.textMuted,
      textFaint: n.textFaint,
      accent: a.accent,
      onAccent: a.onAccent,
      accentTint: a.accentTint,
      accentText: a.accentText,
      positive: s.positive,
      positiveTint: s.positiveTint,
      warning: s.warning,
      warningTint: s.warningTint,
      critical: s.critical,
      criticalTint: s.criticalTint,
      info: s.info,
      infoTint: s.infoTint,
    );
  }

  /// Page background, paper.
  final Color bg;

  /// Raised surfaces: cards, sheets, inputs.
  final Color surface;

  /// Sunken surfaces: sidebars, sections, code.
  final Color sunken;

  /// Hairlines between rows and sections.
  final Color line;

  /// Stronger lines: input borders, outlined buttons.
  final Color lineStrong;

  /// Text, ink.
  final Color text;

  /// Secondary text, Kennungen, meta lines. At least 4.5:1.
  final Color textMuted;

  /// Decorative text only, never for reading.
  final Color textFaint;

  /// Fill of the one primary action.
  final Color accent;

  /// Text and icons on [accent].
  final Color onAccent;

  /// Background of the selection.
  final Color accentTint;

  /// Accent as text, link or line. At least 4.5:1 on [bg].
  final Color accentText;

  /// Status: good, done, connected.
  final Color positive;

  /// Background of [positive].
  final Color positiveTint;

  /// Status: check, attention.
  final Color warning;

  /// Background of [warning].
  final Color warningTint;

  /// Status: broken, error, destructive.
  final Color critical;

  /// Background of [critical].
  final Color criticalTint;

  /// Status: note, information.
  final Color info;

  /// Background of [info].
  final Color infoTint;

  /// Interpolates every slot; used by the theme's `lerp`.
  static HorizontColors lerp(HorizontColors a, HorizontColors b, double t) {
    Color l(Color x, Color y) => Color.lerp(x, y, t)!;
    return HorizontColors(
      bg: l(a.bg, b.bg),
      surface: l(a.surface, b.surface),
      sunken: l(a.sunken, b.sunken),
      line: l(a.line, b.line),
      lineStrong: l(a.lineStrong, b.lineStrong),
      text: l(a.text, b.text),
      textMuted: l(a.textMuted, b.textMuted),
      textFaint: l(a.textFaint, b.textFaint),
      accent: l(a.accent, b.accent),
      onAccent: l(a.onAccent, b.onAccent),
      accentTint: l(a.accentTint, b.accentTint),
      accentText: l(a.accentText, b.accentText),
      positive: l(a.positive, b.positive),
      positiveTint: l(a.positiveTint, b.positiveTint),
      warning: l(a.warning, b.warning),
      warningTint: l(a.warningTint, b.warningTint),
      critical: l(a.critical, b.critical),
      criticalTint: l(a.criticalTint, b.criticalTint),
      info: l(a.info, b.info),
      infoTint: l(a.infoTint, b.infoTint),
    );
  }
}

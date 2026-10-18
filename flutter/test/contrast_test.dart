import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  final cases = [
    for (final product in HorizontProduct.values) (product, null),
    for (final host in HorizontHost.values) (HorizontProduct.knx, host),
  ];
  for (final (product, host) in cases) {
    for (final brightness in Brightness.values) {
      final c = HorizontColors.resolve(product, brightness, host: host);
      group('${product.name}${host == null ? '' : ' in ${host.name}'} ${brightness.name}', () {
        // Reading text and anything that carries meaning: WCAG AA, 4.5:1.
        final pairs = <String, (Color, Color)>{
          'text on bg': (c.text, c.bg),
          'text on surface': (c.text, c.surface),
          'text on sunken': (c.text, c.sunken),
          'text-muted on bg': (c.textMuted, c.bg),
          'text-muted on surface': (c.textMuted, c.surface),
          'text-muted on sunken': (c.textMuted, c.sunken),
          'accent-text on bg': (c.accentText, c.bg),
          'accent-text on surface': (c.accentText, c.surface),
          'text on accent-tint': (c.text, c.accentTint),
          'on-accent on accent': (c.onAccent, c.accent),
          'positive on its tint': (c.positive, c.positiveTint),
          'warning on its tint': (c.warning, c.warningTint),
          'critical on its tint': (c.critical, c.criticalTint),
          'info on its tint': (c.info, c.infoTint),
          'critical on bg': (c.critical, c.bg),
        };
        pairs.forEach((name, pair) {
          test('$name >= 4.5:1', () {
            expect(_contrast(pair.$1, pair.$2), greaterThanOrEqualTo(4.5));
          });
        });
        // Lines that mark state (selection, focus, input border): 3:1.
        test('accent against bg >= 3:1 (selection line)', () {
          expect(_contrast(c.accent, c.bg), greaterThanOrEqualTo(3));
        });
      });
    }
  }
}

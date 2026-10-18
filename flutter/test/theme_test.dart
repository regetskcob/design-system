import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';

void main() {
  test('every product and brightness carries the extension and a hand-set scheme', () {
    for (final product in HorizontProduct.values) {
      for (final brightness in Brightness.values) {
        final theme = buildHorizontTheme(product, brightness);
        final ext = theme.extension<HorizontTheme>();
        expect(ext, isNotNull);
        expect(ext!.product, product);
        expect(theme.colorScheme.brightness, brightness);
        expect(theme.colorScheme.primary, ext.colors.accent);
        expect(theme.colorScheme.surface, ext.colors.bg);
        expect(theme.colorScheme.surfaceTint, Colors.transparent);
      }
    }
  });

  test('Panzergefecht uses Gelände in the dark only', () {
    final dark = HorizontColors.resolve(HorizontProduct.panzergefecht, Brightness.dark);
    final light = HorizontColors.resolve(HorizontProduct.panzergefecht, Brightness.light);
    final knxDark = HorizontColors.resolve(HorizontProduct.knx, Brightness.dark);
    expect(dark.bg, isNot(knxDark.bg));
    expect(light.bg, HorizontColors.resolve(HorizontProduct.knx, Brightness.light).bg);
  });

  test('pointer density uses 28 pt controls', () {
    final touch = buildHorizontTheme(HorizontProduct.knx, Brightness.light).extension<HorizontTheme>()!;
    final pointer = buildHorizontTheme(
      HorizontProduct.knx,
      Brightness.light,
      density: HorizontDensity.pointer,
    ).extension<HorizontTheme>()!;
    expect(touch.controlHeight, 44);
    expect(pointer.controlHeight, 28);
  });

  test('lerp interpolates colours and snaps the product', () {
    final a = buildHorizontTheme(HorizontProduct.knx, Brightness.light).extension<HorizontTheme>()!;
    final b = buildHorizontTheme(HorizontProduct.jagdaufseher, Brightness.dark).extension<HorizontTheme>()!;
    expect(a.lerp(b, 0.25).product, HorizontProduct.knx);
    expect(a.lerp(b, 0.75).product, HorizontProduct.jagdaufseher);
    expect(a.lerp(b, 0.5).colors.bg, Color.lerp(a.colors.bg, b.colors.bg, 0.5));
  });

  testWidgets('of() asserts when the theme was not built by Horizont', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            HorizontTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('resolveMotion collapses to zero under reduced motion', (tester) async {
    late Duration full;
    late Duration reduced;
    await tester.pumpWidget(
      Column(
        children: [
          Builder(builder: (context) {
            full = resolveMotion(context, HzMotion.base);
            return const SizedBox();
          }),
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Builder(builder: (context) {
              reduced = resolveMotion(context, HzMotion.base);
              return const SizedBox();
            }),
          ),
        ],
      ),
    );
    expect(full, const Duration(milliseconds: 200));
    expect(reduced, Duration.zero);
  });
}

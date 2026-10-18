@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';
import 'package:horizont_example/showcase.dart';

Future<void> _loadFonts() async {
  const fonts = {
    'Literata': ['Literata-Light.ttf', 'Literata-SemiBold.ttf'],
    'MonaSans': ['MonaSans-Regular.ttf', 'MonaSans-Medium.ttf', 'MonaSans-SemiBold.ttf'],
    'MonaspaceArgon': ['MonaspaceArgon-Regular.otf', 'MonaspaceArgon-SemiBold.otf'],
    'MaterialSymbolsSharp': ['MaterialSymbolsSharp-300.ttf'],
  };
  for (final entry in fonts.entries) {
    final loader = FontLoader('packages/horizont/${entry.key}');
    for (final file in entry.value) {
      loader.addFont(rootBundle.load('packages/horizont/fonts/$file'));
    }
    await loader.load();
  }
}

void main() {
  setUpAll(_loadFonts);

  for (final product in HorizontProduct.values) {
    for (final brightness in Brightness.values) {
      for (final scale in [1.0, 2.0]) {
        final name = '${product.name}_${brightness.name}_${scale.toStringAsFixed(0)}x';
        testWidgets(name, (tester) async {
          tester.view.physicalSize = const Size(393, 852) * 2;
          tester.view.devicePixelRatio = 2;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            MediaQuery(
              data: MediaQueryData(size: const Size(393, 852), textScaler: TextScaler.linear(scale)),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: buildHorizontTheme(product, brightness),
                home: const Showcase(),
              ),
            ),
          );
          await expectLater(find.byType(Showcase), matchesGoldenFile('goldens/$name.png'));
        });
      }
    }
  }
}

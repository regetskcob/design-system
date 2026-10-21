import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';
import 'package:horizont/testing.dart';

/// Every kind of field on [platform], one below the other, each with a key.
Widget _fields(TargetPlatform platform) => MaterialApp(
  theme: buildHorizontTheme(
    HorizontProduct.knx,
    Brightness.light,
    platform: platform,
  ),
  home: Scaffold(
    body: Builder(
      builder: (context) {
        final hz = HorizontTheme.of(context);
        return ListView(
          children: [
            TextField(key: const Key('empty'), style: hz.field),
            TextField(
              key: const Key('hint'),
              style: hz.field,
              decoration: const InputDecoration(hintText: 'Kanzel am Bruch'),
            ),
            TextField(
              key: const Key('filled'),
              style: hz.field,
              controller: TextEditingController(text: 'Kanzel am Bruch'),
            ),
            TextField(
              key: const Key('mono'),
              style: hz.data,
              decoration: const InputDecoration(hintText: '1/2/300'),
            ),
            TextField(
              key: const Key('icons'),
              style: hz.field,
              decoration: InputDecoration(
                hintText: 'Suchen',
                prefixIcon: const Icon(HorizontSymbols.search),
                suffixIcon: HorizontFieldIconButton(
                  icon: const Icon(HorizontSymbols.close),
                  tooltip: 'Leeren',
                  onPressed: () {},
                ),
              ),
            ),
            HorizontFieldDropdown<int>(
              key: const Key('dropdown'),
              value: 1,
              items: const [(1, 'UDP'), (2, 'TCP')],
              onChanged: (_) {},
            ),
          ],
        );
      },
    ),
  ),
);

const _keys = ['empty', 'hint', 'filled', 'mono', 'icons', 'dropdown'];

/// The height of the outlined part of the field under [key].
double _height(WidgetTester tester, String key) => tester
    .getSize(
      find
          .descendant(
            of: find.byKey(Key(key)),
            matching: find.byType(InputDecorator),
          )
          .first,
    )
    .height;

void main() {
  setUpAll(loadHorizontFonts);

  for (final (platform, height) in [
    (TargetPlatform.macOS, HzSize.controlDesktop),
    (TargetPlatform.windows, HzSize.controlDesktop),
    (TargetPlatform.iOS, HzSize.touch),
    (TargetPlatform.android, HzSize.touch),
  ]) {
    testWidgets('every field is $height high on ${platform.name}', (
      tester,
    ) async {
      await tester.pumpWidget(_fields(platform));
      for (final key in _keys) {
        expect(_height(tester, key), height, reason: key);
      }
      // The button in the field is the field's square.
      expect(
        tester.getSize(find.byType(HorizontFieldIconButton)),
        Size.square(height),
      );
    });
  }

  testWidgets('the dropdown reports its choice', (tester) async {
    var chosen = 1;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
        home: Scaffold(
          body: HorizontFieldDropdown<int>(
            value: chosen,
            items: const [(1, 'UDP'), (2, 'TCP')],
            onChanged: (v) => chosen = v,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(HorizontFieldDropdown<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('TCP').last);
    await tester.pumpAndSettle();
    expect(chosen, 2);
  });
}

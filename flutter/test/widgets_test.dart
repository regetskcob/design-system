import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizont/horizont.dart';

Widget _app(Widget child) => MaterialApp(
  theme: buildHorizontTheme(HorizontProduct.jagdaufseher, Brightness.light),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('a badge reads its word, not its glyph', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(const HorizontBadge(HorizontStatus.critical, label: 'Defekt')),
    );
    expect(find.bySemanticsLabel('Defekt'), findsOneWidget);
    expect(find.byIcon(HorizontSymbols.report), findsOneWidget);
    handle.dispose();
  });

  testWidgets('a Kennung is set in capitals but read as written', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(const Kennung('Revier Buchenhain')));
    expect(find.text('REVIER BUCHENHAIN'), findsOneWidget);
    expect(find.bySemanticsLabel('Revier Buchenhain'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('the tab bar reports the selection and taps', (tester) async {
    var tapped = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
        home: Scaffold(
          bottomNavigationBar: HorizontTabBar(
            destinations: const [
              HorizontDestination(
                icon: HorizontSymbols.dashboard,
                label: 'Übersicht',
              ),
              HorizontDestination(
                icon: HorizontSymbols.category,
                label: 'Objekte',
              ),
              HorizontDestination(icon: HorizontSymbols.bolt, label: 'Live'),
            ],
            selectedIndex: 0,
            onSelected: (i) => tapped = i,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Live'));
    expect(tapped, 2);
    final size = tester.getSize(
      find.ancestor(of: find.text('Live'), matching: find.byType(InkWell)),
    );
    expect(size.height, greaterThanOrEqualTo(44));
  });

  testWidgets("the lockup puts the mark's horizon on the text baseline", (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const HorizontLockup(
          HorizontProduct.jagdaufseher,
          label: 'Jagdaufseher',
        ),
      ),
    );
    final mark = tester.renderObject<RenderBox>(find.byType(CustomPaint).last);
    final horizon = mark.localToGlobal(Offset(0, mark.size.height * 2 / 3)).dy;
    final text = tester.renderObject<RenderParagraph>(
      find.text('Jagdaufseher'),
    );
    final painter = TextPainter(
      text: text.text,
      textDirection: TextDirection.ltr,
    )..layout();
    final baseline =
        text.localToGlobal(Offset.zero).dy +
        painter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    painter.dispose();
    expect(horizon, moreOrLessEquals(baseline, epsilon: 0.5));
  });

  testWidgets(
    'a field shows its label above the input and reads both together',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
          home: const Scaffold(
            body: HorizontField(
              label: 'Gateway',
              help: 'IP-Adresse',
              child: TextField(),
            ),
          ),
        ),
      );
      expect(
        tester.getBottomLeft(find.text('Gateway')).dy,
        lessThanOrEqualTo(tester.getTopLeft(find.byType(TextField)).dy),
      );
      expect(
        tester.getTopLeft(find.text('IP-Adresse')).dy,
        greaterThanOrEqualTo(tester.getBottomLeft(find.byType(TextField)).dy),
      );
    },
  );

  testWidgets('the tab bar is only as tall as its tabs', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
        home: Scaffold(
          bottomNavigationBar: HorizontTabBar(
            destinations: const [
              HorizontDestination(icon: HorizontSymbols.home, label: 'A'),
              HorizontDestination(icon: HorizontSymbols.map, label: 'B'),
            ],
            selectedIndex: 0,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(HorizontTabBar)).height, lessThan(120));
  });
}

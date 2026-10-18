/// Test helpers of Horizont. Import only from tests:
///
/// ```dart
/// import 'package:horizont/testing.dart';
///
/// void main() {
///   setUpAll(loadHorizontFonts);
///   …
/// }
/// ```
library;

import 'package:flutter/services.dart';

/// The bundled fonts by family, as declared in the package's pubspec.
const Map<String, List<String>> _fonts = {
  'Literata': [
    'Literata-Light.ttf',
    'Literata-LightItalic.ttf',
    'Literata-SemiBold.ttf',
  ],
  'MonaSans': [
    'MonaSans-Regular.ttf',
    'MonaSans-Medium.ttf',
    'MonaSans-SemiBold.ttf',
  ],
  'MonaSansDisplayExpanded': [
    'MonaSansDisplayExpanded-Bold.ttf',
    'MonaSansDisplayExpanded-Black.ttf',
  ],
  'MonaspaceArgon': [
    'MonaspaceArgon-Regular.otf',
    'MonaspaceArgon-SemiBold.otf',
  ],
  'MaterialSymbolsSharp': ['MaterialSymbolsSharp-300.ttf'],
};

/// Loads the fonts of Horizont into the test engine, so goldens show Mona
/// Sans, Literata, Monaspace and the symbols instead of the Ahem boxes.
/// Call it once in `setUpAll` of an app's golden tests.
Future<void> loadHorizontFonts() async {
  for (final MapEntry(key: family, value: files) in _fonts.entries) {
    final loader = FontLoader('packages/horizont/$family');
    for (final file in files) {
      loader.addFont(rootBundle.load('packages/horizont/fonts/$file'));
    }
    await loader.load();
  }
}

import 'package:flutter/widgets.dart';

import '../horizont_theme.dart';

/// A Kennung: small mono capitals that name a section, an id or a place,
/// e.g. `REVIER BUCHENHAIN · 412,5 HA`. Pass the text as written; the widget
/// sets it in capitals, so translations stay in normal case.
class Kennung extends StatelessWidget {
  /// Creates a Kennung for [text].
  const Kennung(this.text, {this.color, super.key});

  /// The text, in normal case.
  final String text;

  /// Overrides the muted text colour, e.g. with `accentText`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = HorizontTheme.of(context).kennung;
    return Text(
      text.toUpperCase(),
      style: color == null ? style : style.copyWith(color: color),
      semanticsLabel: text,
    );
  }
}

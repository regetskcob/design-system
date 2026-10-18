import 'package:flutter/widgets.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';

/// A form field the Horizont way: the [label] above the field (label,
/// 13/16, 500, in the text colour), the field itself, and an optional [help]
/// line below. Material's floating label inside the outline is not used.
///
/// ```dart
/// HorizontField(label: l10n.name, child: TextFormField(controller: c))
/// ```
///
/// The label and the field are merged for screen readers, so the field is
/// announced with its label.
class HorizontField extends StatelessWidget {
  /// Creates a field with [label] above [child].
  const HorizontField({
    required this.label,
    required this.child,
    this.help,
    super.key,
  });

  /// What the field asks for, in normal case.
  final String label;

  /// The input, usually a `TextFormField` without `labelText`.
  final Widget child;

  /// A short hint below the field.
  final String? help;

  @override
  Widget build(BuildContext context) {
    final c = HorizontTheme.of(context).colors;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: horizontTextStyle(HzType.label, c.text)),
          const SizedBox(height: HzSpace.s4),
          child,
          if (help != null) ...[
            const SizedBox(height: HzSpace.s4),
            Text(help!, style: horizontTextStyle(HzType.caption, c.textMuted)),
          ],
        ],
      ),
    );
  }
}

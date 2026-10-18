import 'package:flutter/widgets.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';
import 'kennung.dart';
import 'status.dart';

/// A key figure: a [Kennung] as the term, below it the value in Monaspace
/// at title-2 size, one size for all figures (`ZEITRAUM` / `14.10.2026,
/// 15:20 – 15:40`). With [status] the value carries the state's glyph and
/// colour; the word for the state belongs in [label] or next to it.
///
/// A new value fades in (zero under reduced motion).
class HorizontMetric extends StatelessWidget {
  /// Creates a key figure [label] with [value].
  const HorizontMetric({
    required this.label,
    required this.value,
    this.status,
    super.key,
  });

  /// The term, in normal case.
  final String label;

  /// The value as shown, already formatted.
  final String value;

  /// The state of the value: glyph before it, value in the state's colour.
  final HorizontStatus? status;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final fg = status?.color(theme.colors) ?? theme.colors.text;
    final style = theme.data.copyWith(
      fontSize: HzType.title2.size,
      height: HzType.title2.line / HzType.title2.size,
      fontWeight: FontWeight.w600,
      color: fg,
    );
    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Kennung(label),
          const SizedBox(height: HzSpace.s4),
          AnimatedSwitcher(
            duration: resolveMotion(context, HzMotion.base),
            switchInCurve: HzMotion.standard,
            switchOutCurve: HzMotion.exit,
            transitionBuilder: (child, a) =>
                FadeTransition(opacity: a, child: child),
            child: Row(
              key: ValueKey((value, status)),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (status != null) ...[
                  Icon(status!.icon, size: HzIconSize.row, color: fg),
                  const SizedBox(width: HzSpace.s4),
                ],
                Flexible(child: Text(value, style: style)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Key figures side by side. When the width runs out they wrap to the next
/// line; they never shrink, values scale with the system text size.
class HorizontMetricRow extends StatelessWidget {
  /// Creates a row of [children], usually [HorizontMetric]s.
  const HorizontMetricRow({
    required this.children,
    this.spacing = HzSpace.s24,
    super.key,
  });

  /// The figures.
  final List<Widget> children;

  /// Space between figures in a line.
  final double spacing;

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: spacing, runSpacing: HzSpace.s12, children: children);
}

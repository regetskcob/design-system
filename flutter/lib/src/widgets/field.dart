import 'package:flutter/material.dart';

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
/// Label and field form one group for screen readers: the label is read
/// right before the field. (Merging them would break fields that bring their
/// own semantics, such as dropdowns.)
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
    return Semantics(
      container: true,
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

/// A symbol button inside a field (search, clear, reveal), as high and wide
/// as the field: put it in `InputDecoration.suffixIcon` or `prefixIcon`. See
/// [HorizontTheme.fieldIconButton].
///
/// ```dart
/// TextField(
///   decoration: InputDecoration(
///     suffixIcon: HorizontFieldIconButton(
///       icon: const Icon(HorizontSymbols.close),
///       tooltip: l10n.clear,
///       onPressed: controller.clear,
///     ),
///   ),
/// )
/// ```
class HorizontFieldIconButton extends StatelessWidget {
  /// Creates a field button showing [icon].
  const HorizontFieldIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isSelected,
    super.key,
  });

  /// Usually an `Icon` from `HorizontSymbols`; its size comes from the style.
  final Widget icon;

  /// `null` disables the button.
  final VoidCallback? onPressed;

  /// What the button does, also read by screen readers.
  final String? tooltip;

  /// For a toggle (reveal a password): whether it is on.
  final bool? isSelected;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    isSelected: isSelected,
    style: HorizontTheme.of(context).fieldIconButton,
    icon: icon,
    onPressed: onPressed,
  );
}

/// A choice from a few fixed values, shaped like the other fields: a
/// `DropdownMenu` as high as a field, as wide as its parent, without typing
/// or search. Use it instead of a `SegmentedButton` inside a form.
///
/// ```dart
/// HorizontField(
///   label: l10n.tunnel,
///   child: HorizontFieldDropdown(
///     value: mode,
///     items: [(Mode.udp, 'UDP'), (Mode.tcp, 'TCP')],
///     onChanged: (m) => setState(() => mode = m),
///   ),
/// )
/// ```
class HorizontFieldDropdown<T> extends StatelessWidget {
  /// Creates a dropdown showing [value] out of [items].
  const HorizontFieldDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  /// The selected value.
  final T value;

  /// Value and label of each entry, in order.
  final List<(T, String)> items;

  /// Called with the chosen value; `null` disables the field.
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownMenu<T>(
      // Rebuild when the value changes from outside.
      key: ValueKey(value),
      initialSelection: value,
      expandedInsets: EdgeInsets.zero,
      enabled: onChanged != null,
      // Choose only: no keyboard, no search.
      requestFocusOnTap: false,
      enableSearch: false,
      // Explicit, so a local DropdownMenuTheme cannot make it taller than the
      // other fields.
      textStyle: HorizontTheme.of(context).field,
      inputDecorationTheme: theme.inputDecorationTheme,
      // A plain symbol instead of DropdownMenu's IconButton (48), which would
      // make the field taller.
      decorationBuilder: (context, menu) => InputDecoration(
        suffixIcon: Icon(
          menu.isOpen ? HorizontSymbols.expandLess : HorizontSymbols.expandMore,
          size: HzIconSize.row,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: HzSpace.s32 + HzSpace.s8,
          minHeight: 0,
        ),
      ),
      onSelected: (v) {
        if (v is T) onChanged?.call(v);
      },
      dropdownMenuEntries: [
        for (final (v, label) in items)
          DropdownMenuEntry(value: v, label: label),
      ],
    );
  }
}

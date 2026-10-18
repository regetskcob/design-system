import 'package:flutter/material.dart';

import 'colors.dart';
import 'horizont_theme.dart';
import 'tokens.g.dart';

/// The `ThemeData` of [product] in [brightness]: a hand-authored
/// `ColorScheme` (never `fromSeed`), the text theme of the three voices, the
/// component themes of Horizont and the [HorizontTheme] extension.
///
/// Build it once per brightness at the composition root:
///
/// ```dart
/// MaterialApp(
///   theme: buildHorizontTheme(HorizontProduct.knx, Brightness.light),
///   darkTheme: buildHorizontTheme(HorizontProduct.knx, Brightness.dark),
///   themeAnimationStyle: AnimationStyle.noAnimation,
/// )
/// ```
ThemeData buildHorizontTheme(
  HorizontProduct product,
  Brightness brightness, {
  HorizontDensity density = HorizontDensity.touch,
}) {
  final c = HorizontColors.resolve(product, brightness);
  final dark = brightness == Brightness.dark;
  final pointer = density == HorizontDensity.pointer;
  TextStyle t(HzTypeSpec spec, [Color? color]) => horizontTextStyle(spec, color ?? c.text);

  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.accent,
    onPrimary: c.onAccent,
    primaryContainer: c.accentTint,
    onPrimaryContainer: c.accentText,
    secondary: c.accentText,
    onSecondary: c.onAccent,
    secondaryContainer: c.sunken,
    onSecondaryContainer: c.text,
    tertiary: c.info,
    onTertiary: c.surface,
    tertiaryContainer: c.infoTint,
    onTertiaryContainer: c.info,
    error: c.critical,
    onError: dark ? c.bg : c.surface,
    errorContainer: c.criticalTint,
    onErrorContainer: c.critical,
    surface: c.bg,
    onSurface: c.text,
    onSurfaceVariant: c.textMuted,
    surfaceContainerLowest: c.surface,
    surfaceContainerLow: c.surface,
    surfaceContainer: c.sunken,
    surfaceContainerHigh: c.sunken,
    surfaceContainerHighest: c.line,
    outline: c.lineStrong,
    outlineVariant: c.line,
    shadow: Colors.transparent,
    scrim: c.text.withValues(alpha: 0.4),
    inverseSurface: c.text,
    onInverseSurface: c.bg,
    inversePrimary: product.dark.accent,
    surfaceTint: Colors.transparent,
  );

  final textTheme = TextTheme(
    displaySmall: t(HzType.display),
    headlineMedium: t(HzType.headline),
    titleLarge: t(HzType.title1),
    titleMedium: t(HzType.title2),
    titleSmall: t(HzType.title3),
    bodyLarge: t(HzType.body),
    bodyMedium: t(HzType.callout),
    bodySmall: t(HzType.caption, c.textMuted),
    labelLarge: t(HzType.label),
    labelMedium: t(HzType.label),
    labelSmall: t(HzType.caption),
  );

  final control = pointer ? HzSize.controlDesktop : HzSize.touch;
  const r6 = BorderRadius.all(Radius.circular(HzRadius.r6));
  const r10 = BorderRadius.all(Radius.circular(HzRadius.r10));
  final hairline = BorderSide(color: c.line, width: HzLine.hairline);
  final buttonText = t(HzType.label).copyWith(fontSize: pointer ? 13 : 15);
  final buttonPadding = EdgeInsets.symmetric(horizontal: pointer ? HzSpace.s12 : HzSpace.s16);
  final buttonSize = WidgetStatePropertyAll(Size(0, control));

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    textTheme: textTheme,
    fontFamily: HzFont.sans,
    package: HzFont.package,
    scaffoldBackgroundColor: c.bg,
    canvasColor: c.bg,
    dividerColor: c.line,
    visualDensity: pointer ? VisualDensity.compact : VisualDensity.standard,
    materialTapTargetSize: pointer ? MaterialTapTargetSize.shrinkWrap : MaterialTapTargetSize.padded,
    splashFactory: InkRipple.splashFactory,
    iconTheme: IconThemeData(color: c.text, size: 22, weight: 300),
    extensions: [
      HorizontTheme(
        product: product,
        brightness: brightness,
        density: density,
        colors: c,
        data: t(HzType.data),
        kennung: t(HzType.kennung, c.textMuted),
        reading: t(HzType.reading),
        display: t(HzType.display),
      ),
    ],
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      toolbarHeight: pointer ? HzSize.toolbarDesktop : 56,
      titleTextStyle: t(HzType.title1),
      actionsIconTheme: IconThemeData(color: c.accentText, size: 22),
      shape: Border(bottom: hairline),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: r10, side: hairline),
    ),
    dividerTheme: DividerThemeData(color: c.line, thickness: HzLine.hairline, space: HzLine.hairline),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: HzSpace.s16),
      minVerticalPadding: pointer ? HzSpace.s4 : HzSpace.s8,
      minTileHeight: pointer ? HzSize.rowDense : HzSize.row,
      dense: pointer,
      iconColor: c.textMuted,
      textColor: c.text,
      titleTextStyle: t(HzType.body),
      subtitleTextStyle: t(HzType.data, c.textMuted).copyWith(fontSize: 12, height: 16 / 12),
      selectedColor: c.text,
      selectedTileColor: c.accentTint,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? c.sunken : c.accent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? c.textFaint : c.onAccent,
        ),
        textStyle: WidgetStatePropertyAll(buttonText),
        minimumSize: buttonSize,
        padding: WidgetStatePropertyAll(buttonPadding),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: r6)),
        elevation: const WidgetStatePropertyAll(0),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(c.text),
        textStyle: WidgetStatePropertyAll(buttonText),
        minimumSize: buttonSize,
        padding: WidgetStatePropertyAll(buttonPadding),
        side: WidgetStatePropertyAll(BorderSide(color: c.lineStrong)),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: r6)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(c.accentText),
        textStyle: WidgetStatePropertyAll(buttonText),
        minimumSize: buttonSize,
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: HzSpace.s8)),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: r6)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(c.accentText),
        minimumSize: WidgetStatePropertyAll(Size.square(pointer ? HzSize.controlDesktop : HzSize.touch)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: c.accent,
      foregroundColor: c.onAccent,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      extendedTextStyle: buttonText,
      shape: const RoundedRectangleBorder(borderRadius: r10),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      isDense: pointer,
      contentPadding: EdgeInsets.symmetric(horizontal: HzSpace.s12, vertical: pointer ? HzSpace.s8 : HzSpace.s12),
      labelStyle: t(HzType.label),
      floatingLabelStyle: t(HzType.label, c.accentText),
      helperStyle: t(HzType.caption, c.textMuted),
      errorStyle: t(HzType.caption, c.critical),
      hintStyle: t(HzType.body, c.textFaint),
      border: OutlineInputBorder(borderRadius: r6, borderSide: BorderSide(color: c.lineStrong)),
      enabledBorder: OutlineInputBorder(borderRadius: r6, borderSide: BorderSide(color: c.lineStrong)),
      focusedBorder: OutlineInputBorder(
        borderRadius: r6,
        borderSide: BorderSide(color: c.accent, width: HzLine.focus),
      ),
      errorBorder: OutlineInputBorder(borderRadius: r6, borderSide: BorderSide(color: c.critical)),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: r6,
        borderSide: BorderSide(color: c.critical, width: HzLine.focus),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: c.sunken,
      selectedColor: c.accentTint,
      labelStyle: t(HzType.label),
      side: BorderSide(color: c.line),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(HzRadius.r2))),
      showCheckmark: false,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: c.text,
      unselectedLabelColor: c.textMuted,
      labelStyle: t(HzType.label),
      unselectedLabelStyle: t(HzType.label),
      dividerColor: c.line,
      dividerHeight: HzLine.hairline,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(borderSide: BorderSide(color: c.accent, width: HzLine.selection)),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.accentTint : Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.text : c.textMuted,
        ),
        textStyle: WidgetStatePropertyAll(t(HzType.label)),
        side: WidgetStatePropertyAll(BorderSide(color: c.lineStrong)),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: r6)),
        minimumSize: WidgetStatePropertyAll(Size(0, pointer ? 24 : 36)),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.onAccent : c.surface),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.accent : c.lineStrong),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.accent : Colors.transparent),
      checkColor: WidgetStatePropertyAll(c.onAccent),
      side: BorderSide(color: c.lineStrong, width: 1.5),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(HzRadius.r2))),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.accent,
      linearTrackColor: c.line,
      circularTrackColor: c.line,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: r10, side: hairline),
      titleTextStyle: t(HzType.title2),
      contentTextStyle: t(HzType.body),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surface,
      elevation: 0,
      modalElevation: 0,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: c.lineStrong,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(HzRadius.r16)),
        side: hairline,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: c.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      textStyle: t(HzType.body),
      shape: RoundedRectangleBorder(borderRadius: r10, side: hairline),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.text,
      contentTextStyle: t(HzType.callout, c.bg),
      actionTextColor: c.bg,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: r6),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: c.text, borderRadius: const BorderRadius.all(Radius.circular(HzRadius.r2))),
      textStyle: t(HzType.caption, c.bg),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(c.lineStrong),
      radius: const Radius.circular(HzRadius.r2),
    ),
  );
}

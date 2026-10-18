/// Horizont, the design system of regetskcob, Jagdaufseher, KNX Monitor and
/// Panzergefecht: minimalist like the fields of the Lower Rhine.
///
/// Build the theme with [buildHorizontTheme] for light and dark, read it
/// with [HorizontTheme.of], call [registerHorizontLicenses] in `main()`.
/// Rules and the reasoning behind them: CLAUDE.md and docs/flutter.md in
/// https://github.com/regetskcob/horizont.
library;

export 'src/colors.dart';
export 'src/horizont_theme.dart';
export 'src/licenses.dart';
export 'src/theme.dart';
export 'src/tokens.g.dart'
    show
        HorizontProduct,
        HorizontSymbols,
        HzBreakpoint,
        HzFont,
        HzLine,
        HzMotion,
        HzRadius,
        HzSize,
        HzSpace,
        HzType,
        HzTypeSpec,
        horizontTokensVersion;
export 'src/widgets/kennung.dart';
export 'src/widgets/mark.dart';
export 'src/widgets/navigation.dart';
export 'src/widgets/status.dart';

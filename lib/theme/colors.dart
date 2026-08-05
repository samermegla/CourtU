import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// THE ONLY FILE WITH COLOR VALUES IN IT.
///
/// Two kinds of color live here:
///
/// 1. [AppColorScheme] — colors that CHANGE between light and dark mode.
///    Screens never name these directly; they ask the current theme via
///    `context.colors.background`. Change a hex in [_light] or [_dark] below
///    and every screen updates.
///
/// 2. [AppColors] — colors that are the SAME in both modes: brand colors,
///    status colors, sport colors. A court marker is the same orange whether
///    the phone is in light or dark mode.
///
/// Slots are named for their JOB (background, border, textPrimary), not their
/// appearance, so a hex can change later without renaming anything.
/// ---------------------------------------------------------------------------

/// The set of theme-dependent color slots. Lives inside [ThemeData] as a
/// [ThemeExtension], which is Flutter's supported way to attach custom colors
/// to a theme — that's what makes them switch automatically with the mode.
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  /// Page background, behind everything.
  final Color background;

  /// Raised elements sitting on [background]: cards, input fields, sheets.
  final Color surface;

  /// A second surface tone for elements that need to read as distinct from
  /// [surface] (selected chips, subtle fills).
  final Color surfaceAlt;

  /// Hairlines, outlines, dividers.
  final Color border;

  /// Headlines and body copy.
  final Color textPrimary;

  /// Supporting copy, hints, captions, disabled labels.
  final Color textSecondary;

  /// Primary call-to-action fill (Let's Go, Create Account, Sign In).
  final Color accent;

  /// Mid blue-grey used for outlines, gradients and selected states. Kept as
  /// its own slot (rather than folded into [border]) because ~80 call sites
  /// use it at varying opacities where a single border tone would flatten the
  /// design.
  final Color steel;

  /// Lighter partner to [steel]; the bright end of button gradients and the
  /// tint for active icons.
  final Color steelLight;

  const AppColorScheme({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.steel,
    required this.steelLight,
  });

  static const light = AppColorScheme(
    background: Color(0xFFF7F6F9),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEFEDF3),
    border: Color(0xFFD8D5E0),
    textPrimary: Color(0xFF1A1823),
    textSecondary: Color(0xFF6B6878),
    accent: Color(0xFF4A6591),
    steel: Color(0xFF4A6591),
    steelLight: Color(0xFF6B84AD),
  );

  static const dark = AppColorScheme(
    background: Color(0xFF131722),
    surface: Color(0xFF1B2030),
    surfaceAlt: Color(0xFF232A3C),
    border: Color(0xFF333B50),
    textPrimary: Color(0xFFEEF1F7),
    textSecondary: Color(0xFF93A0B8),
    accent: Color(0xFF7B93B5),
    steel: Color(0xFF4B6D8A),
    steelLight: Color(0xFF6B9AB8),
  );

  @override
  AppColorScheme copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? accent,
    Color? steel,
    Color? steelLight,
  }) {
    return AppColorScheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
      steel: steel ?? this.steel,
      steelLight: steelLight ?? this.steelLight,
    );
  }

  /// Blends two schemes — used by Flutter to animate the color change when the
  /// mode flips, so screens cross-fade instead of snapping.
  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      steel: Color.lerp(steel, other.steel, t)!,
      steelLight: Color.lerp(steelLight, other.steelLight, t)!,
    );
  }
}

/// Reads the current mode's colors off the widget tree.
///
/// Usage in any screen: `color: context.colors.textPrimary`
extension AppColorSchemeX on BuildContext {
  AppColorScheme get colors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.dark;
}

/// Colors that are IDENTICAL in light and dark mode.
///
/// These are brand and content colors — they carry meaning that must not
/// change with the theme. A "hot" court is the same orange in both modes.
class AppColors {
  AppColors._();

  /// Brand orange. Distinct from the themed CTA color (`context.colors.accent`).
  static const brandOrange = Color(0xFFff6b35);

  /// Bright creamy red-orange — court markers on the map.
  static const courtMarker = Color(0xFFff6e4e);

  /// Pastel neon green — "I'M GOING!" check-in call-to-action.
  static const neonMint = Color(0xFFa6ffb2);

  /// Neon red — live-status indicator dot.
  static const neonRed = Color(0xFFff3b3b);

  static const green = Color(0xFF1ddf64);
  static const destructive = Color(0xFFef4444);

  // Court status colors.
  static const statusHot = Color(0xFFff6b35);
  static const statusActive = Color(0xFF1ddf64);
  static const statusQuiet = Color(0xFFf59e0b);
  static const statusEmpty = Color(0xFF6b7fa3);

  // Sport colors.
  static const volleyball = Color(0xFFff6b35);
  static const basketball = Color(0xFFf59e0b);
  static const tennis = Color(0xFF22d35a);
  static const badminton = Color(0xFF3b82f6);
  static const pickleball = Color(0xFFa855f7);

  // ---------------------------------------------------------------------
  // LEGACY — DO NOT USE IN NEW CODE.
  //
  // These are the old fixed color names from before the light/dark system.
  // They exist ONLY so three unreachable files still compile without being
  // edited: screens/user_profile.dart, screens/home_screen.dart and
  // pages/welcome_page.dart. Nothing in the running app reaches them.
  //
  // New or edited screens must use `context.colors.<slot>` instead — these
  // constants do not respond to light/dark mode. Delete this block once
  // those three files are removed.
  // ---------------------------------------------------------------------
  static const background = Color(0xFF131722);
  static const card = Color(0xFF1B2030);
  static const muted = Color(0xFF232A3C);
  static const dim = Color(0xFF333B50);
  static const steel = Color(0xFF4B6D8A);
  static const steelLight = Color(0xFF6B9AB8);
  static const mutedForeground = Color(0xFF93A0B8);
  static const foreground = Color(0xFFEEF1F7);
  static const accentBlue = Color(0xFF7B93B5);
  /// Legacy alias for [brandOrange].
  static const accent = Color(0xFFff6b35);

  static Color sportColor(String name) {
    switch (name) {
      case 'volleyball':
        return volleyball;
      case 'basketball':
        return basketball;
      case 'tennis':
        return tennis;
      case 'badminton':
        return badminton;
      case 'pickleball':
        return pickleball;
      default:
        return statusEmpty;
    }
  }
}

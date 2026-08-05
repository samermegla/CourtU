import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Builds the two [ThemeData] objects the app runs on.
///
/// TYPOGRAPHY LIVES HERE. To change the app-wide font, edit [_bodyFont] below
/// — one line, every screen follows. [AppFonts.mono] is deliberately separate:
/// it is fixed-width, which matters for live-updating counts like "22/24
/// PLAYERS" where a proportional font would make digits jitter as they change.
class AppTheme {
  AppTheme._();

  /// The app-wide typeface. Change this one function to swap the font.
  static TextStyle _bodyFont(TextStyle? base) => GoogleFonts.poppins(textStyle: base);

  static ThemeData get light => _build(AppColorScheme.light, Brightness.light);
  static ThemeData get dark => _build(AppColorScheme.dark, Brightness.dark);

  static ThemeData _build(AppColorScheme c, Brightness brightness) {
    final base = ThemeData(brightness: brightness);

    return base.copyWith(
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.accent,
        onPrimary: Colors.white,
        secondary: c.steelLight,
        onSecondary: Colors.white,
        surface: c.surface,
        onSurface: c.textPrimary,
        error: AppColors.destructive,
        onError: Colors.white,
      ),
      // Makes `context.colors` resolve to the right palette for this mode.
      extensions: [c],
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: c.textPrimary,
        displayColor: c.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        titleTextStyle: _bodyFont(
          TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.textPrimary),
        ),
      ),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: c.surface),
      dialogTheme: DialogThemeData(backgroundColor: c.surface),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.surfaceAlt,
        contentTextStyle: _bodyFont(TextStyle(color: c.textPrimary)),
      ),
      iconTheme: IconThemeData(color: c.textPrimary),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.accent),
    );
  }
}

/// Font helpers for the cases where a screen needs a specific face rather than
/// the theme default.
class AppFonts {
  AppFonts._();

  /// Fixed-width. Use for tags, counts, and anything where digits update live.
  static TextStyle mono({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// The app-wide proportional face — headlines and body.
  static TextStyle sans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    List<Shadow>? shadows,
  }) =>
      GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        shadows: shadows,
      );
}

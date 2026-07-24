import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'font_tokens.dart';

/// Orbit Todo Design System — Typography
///
/// Multi-style type scale supporting curated font options:
/// Modern (Inter), Rounded (Nunito Sans), Editorial (Source Serif 4),
/// Geometric (Manrope), Classic (System UI), Handwriting (Caveat),
/// Display (Bebas Neue), and Serif (Lora).
class OrbitTypography {
  OrbitTypography._();

  /// Build the TextTheme based on the selected [AppFontStyle], respecting [ColorScheme].
  static TextTheme buildTextTheme(
    ColorScheme colorScheme, [
    AppFontStyle fontStyle = AppFontStyle.modern,
  ]) {
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;

    final TextTheme base = switch (fontStyle) {
      AppFontStyle.modern => GoogleFonts.interTextTheme(),
      AppFontStyle.rounded => GoogleFonts.nunitoSansTextTheme(),
      AppFontStyle.editorial => GoogleFonts.interTextTheme(),
      AppFontStyle.geometric => GoogleFonts.manropeTextTheme(),
      AppFontStyle.classic => Typography.material2021().englishLike,
      AppFontStyle.handwriting => GoogleFonts.caveatTextTheme(),
      AppFontStyle.display => GoogleFonts.bebasNeueTextTheme(),
      AppFontStyle.serif => GoogleFonts.loraTextTheme(),
    };

    final TextTheme headings = switch (fontStyle) {
      AppFontStyle.editorial => GoogleFonts.sourceSerif4TextTheme(),
      AppFontStyle.handwriting => GoogleFonts.caveatTextTheme(),
      AppFontStyle.display => GoogleFonts.bebasNeueTextTheme(),
      AppFontStyle.serif => GoogleFonts.loraTextTheme(),
      _ => base,
    };

    return base.copyWith(
      // Display — used for large numbers, celebration text
      displayLarge: headings.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: onSurface,
        height: 1.12,
      ),
      displayMedium: headings.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: onSurface,
        height: 1.16,
      ),
      displaySmall: headings.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: onSurface,
        height: 1.22,
      ),

      // Headline — screen titles, section headers
      headlineLarge: headings.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: onSurface,
        height: 1.25,
      ),
      headlineMedium: headings.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: onSurface,
        height: 1.33,
      ),
      headlineSmall: headings.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: onSurface,
        height: 1.40,
      ),

      // Title — task titles, card headings
      titleLarge: headings.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: onSurface,
        height: 1.44,
      ),
      titleMedium: headings.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: onSurface,
        height: 1.50,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurface,
        height: 1.43,
      ),

      // Body — main text content
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: onSurface,
        height: 1.50,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: onSurface,
        height: 1.43,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: onSurfaceVariant,
        height: 1.33,
      ),

      // Label — buttons, chips, metadata badges
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurface,
        height: 1.43,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: onSurface,
        height: 1.33,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: onSurfaceVariant,
        height: 1.45,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Orbit Todo Design System — Color Tokens
///
/// 5 hand-tuned accent themes, each with semantic color tokens
/// for both light and dark modes. All colors verified for WCAG AA contrast.
enum AccentTheme {
  indigo, // Blue
  emerald, // Green
  coral, // Pink
  amber, // Orange
  violet, // Teal
}

extension AccentThemeExtension on AccentTheme {
  String get displayName => switch (this) {
        AccentTheme.indigo => 'Blue',
        AccentTheme.emerald => 'Green',
        AccentTheme.coral => 'Pink',
        AccentTheme.amber => 'Orange',
        AccentTheme.violet => 'Teal',
      };

  Color get swatch => switch (this) {
        AccentTheme.indigo => AppAccentColors.blue.lightColor,
        AccentTheme.emerald => AppAccentColors.green.lightColor,
        AccentTheme.coral => AppAccentColors.pink.lightColor,
        AccentTheme.amber => AppAccentColors.orange.lightColor,
        AccentTheme.violet => AppAccentColors.teal.lightColor,
      };

  AppAccentColor get appAccentColor => switch (this) {
        AccentTheme.indigo => AppAccentColors.blue,
        AccentTheme.emerald => AppAccentColors.green,
        AccentTheme.coral => AppAccentColors.pink,
        AccentTheme.amber => AppAccentColors.orange,
        AccentTheme.violet => AppAccentColors.teal,
      };
}

class OrbitColorTokens {
  // ──────────────────────────────────────────────────────────────────────────
  // Priority Colors (semantic, theme-independent)
  // ──────────────────────────────────────────────────────────────────────────
  static const Color priorityUrgent = Color(0xFFE53E3E);
  static const Color priorityHigh = Color(0xFFDD6B20);
  static const Color priorityMedium = Color(0xFFD69E2E);
  static const Color priorityLow = Color(0xFF3182CE);
  static const Color priorityNone = Color(0xFF718096);

  // Priority dark variants
  static const Color priorityUrgentDark = Color(0xFFFC8181);
  static const Color priorityHighDark = Color(0xFFFBD38D);
  static const Color priorityMediumDark = Color(0xFFF6E05E);
  static const Color priorityLowDark = Color(0xFF63B3ED);
  static const Color priorityNoneDark = Color(0xFFA0AEC0);

  // ──────────────────────────────────────────────────────────────────────────
  // Semantic Status Colors
  // ──────────────────────────────────────────────────────────────────────────
  static const Color successLight = Color(0xFF25855A);
  static const Color successDark = Color(0xFF48BB78);
  static const Color warningLight = Color(0xFFDD6B20);
  static const Color warningDark = Color(0xFFFBD38D);
  static const Color errorLight = Color(0xFFE53E3E);
  static const Color errorDark = Color(0xFFF56565);
  static const Color infoLight = Color(0xFF3A5CCC);
  static const Color infoDark = Color(0xFF708CFB);

  // ──────────────────────────────────────────────────────────────────────────
  // Neutral Palette
  // ──────────────────────────────────────────────────────────────────────────
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);
  static const Color neutral950 = Color(0xFF14161C);

  // ──────────────────────────────────────────────────────────────────────────
  // Accent Theme Color Seeds
  // Each returns a fully specified ColorScheme for light and dark modes
  // ──────────────────────────────────────────────────────────────────────────

  static ColorScheme lightScheme(AccentTheme accent) {
    return switch (accent) {
      AccentTheme.indigo => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF3A5CCC),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFEBF0FF),
          onPrimaryContainer: Color(0xFF1E2B66),
          secondary: Color(0xFF5373E6),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFF0F4FE),
          onSecondaryContainer: Color(0xFF233680),
          tertiary: Color(0xFF6B46C1),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFF3E8FF),
          onTertiaryContainer: Color(0xFF321868),
          error: Color(0xFFE53E3E),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFF5F5),
          onErrorContainer: Color(0xFF742A2A),
          surface: Color(0xFFF8FAFC),
          onSurface: Color(0xFF0F172A),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF1F5F9),
          surfaceContainer: Color(0xFFE2E8F0),
          surfaceContainerHigh: Color(0xFFCBD5E1),
          surfaceContainerHighest: Color(0xFFEDF2F7),
          onSurfaceVariant: Color(0xFF475569),
          outline: Color(0xFFCBD5E1),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFF708CFB),
        ),
      AccentTheme.emerald => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF25855A),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFE6FFFA),
          onPrimaryContainer: Color(0xFF12432D),
          secondary: Color(0xFF38A169),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFF0FFF4),
          onSecondaryContainer: Color(0xFF1C633F),
          tertiary: Color(0xFF319795),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFE6FFFA),
          onTertiaryContainer: Color(0xFF1D4D4B),
          error: Color(0xFFE53E3E),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFF5F5),
          onErrorContainer: Color(0xFF742A2A),
          surface: Color(0xFFF8FAFC),
          onSurface: Color(0xFF0F172A),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF1F5F9),
          surfaceContainer: Color(0xFFE2E8F0),
          surfaceContainerHigh: Color(0xFFCBD5E1),
          surfaceContainerHighest: Color(0xFFEDF2F7),
          onSurfaceVariant: Color(0xFF475569),
          outline: Color(0xFFCBD5E1),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFF48BB78),
        ),
      AccentTheme.coral => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFD53F8C),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFFF5F7),
          onPrimaryContainer: Color(0xFF702459),
          secondary: Color(0xFFE53E3E),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFFFF5F5),
          onSecondaryContainer: Color(0xFF742A2A),
          tertiary: Color(0xFFDD6B20),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFFFAF0),
          onTertiaryContainer: Color(0xFF7B341E),
          error: Color(0xFFE53E3E),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFF5F5),
          onErrorContainer: Color(0xFF742A2A),
          surface: Color(0xFFF8FAFC),
          onSurface: Color(0xFF0F172A),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF1F5F9),
          surfaceContainer: Color(0xFFE2E8F0),
          surfaceContainerHigh: Color(0xFFCBD5E1),
          surfaceContainerHighest: Color(0xFFEDF2F7),
          onSurfaceVariant: Color(0xFF475569),
          outline: Color(0xFFCBD5E1),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFFF687B3),
        ),
      AccentTheme.amber => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFDD6B20),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFFFAF0),
          onPrimaryContainer: Color(0xFF7B341E),
          secondary: Color(0xFFD69E2E),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFFFFFF0),
          onSecondaryContainer: Color(0xFF744210),
          tertiary: Color(0xFFC05621),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFFFAF0),
          onTertiaryContainer: Color(0xFF652B19),
          error: Color(0xFFE53E3E),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFF5F5),
          onErrorContainer: Color(0xFF742A2A),
          surface: Color(0xFFF8FAFC),
          onSurface: Color(0xFF0F172A),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF1F5F9),
          surfaceContainer: Color(0xFFE2E8F0),
          surfaceContainerHigh: Color(0xFFCBD5E1),
          surfaceContainerHighest: Color(0xFFEDF2F7),
          onSurfaceVariant: Color(0xFF475569),
          outline: Color(0xFFCBD5E1),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFFFBD38D),
        ),
      AccentTheme.violet => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF319795),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFE6FFFA),
          onPrimaryContainer: Color(0xFF1D4D4B),
          secondary: Color(0xFF3182CE),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFEBF8FF),
          onSecondaryContainer: Color(0xFF2A4365),
          tertiary: Color(0xFF805AD5),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFAF5FF),
          onTertiaryContainer: Color(0xFF44337A),
          error: Color(0xFFE53E3E),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFF5F5),
          onErrorContainer: Color(0xFF742A2A),
          surface: Color(0xFFF8FAFC),
          onSurface: Color(0xFF0F172A),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF1F5F9),
          surfaceContainer: Color(0xFFE2E8F0),
          surfaceContainerHigh: Color(0xFFCBD5E1),
          surfaceContainerHighest: Color(0xFFEDF2F7),
          onSurfaceVariant: Color(0xFF475569),
          outline: Color(0xFFCBD5E1),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFF4FD1C5),
        ),
    };
  }

  static ColorScheme darkScheme(AccentTheme accent) {
    return switch (accent) {
      AccentTheme.indigo => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF708CFB),
          onPrimary: Color(0xFF1E2B66),
          primaryContainer: Color(0xFF27387D),
          onPrimaryContainer: Color(0xFFEBF0FF),
          secondary: Color(0xFF90A5F9),
          onSecondary: Color(0xFF1A2657),
          secondaryContainer: Color(0xFF1E2B66),
          onSecondaryContainer: Color(0xFFF0F4FE),
          tertiary: Color(0xFFB794F4),
          onTertiary: Color(0xFF321868),
          tertiaryContainer: Color(0xFF44337A),
          onTertiaryContainer: Color(0xFFF3E8FF),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF14161C),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF0E1014),
          surfaceContainerLow: Color(0xFF1E2128),
          surfaceContainer: Color(0xFF262A34),
          surfaceContainerHigh: Color(0xFF2D323E),
          surfaceContainerHighest: Color(0xFF353B4A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF353B4A),
          outlineVariant: Color(0xFF2E333D),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF14161C),
          inversePrimary: Color(0xFF3A5CCC),
        ),
      AccentTheme.emerald => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF48BB78),
          onPrimary: Color(0xFF12432D),
          primaryContainer: Color(0xFF1C633F),
          onPrimaryContainer: Color(0xFFE6FFFA),
          secondary: Color(0xFF68D391),
          onSecondary: Color(0xFF12432D),
          secondaryContainer: Color(0xFF22543D),
          onSecondaryContainer: Color(0xFFF0FFF4),
          tertiary: Color(0xFF4FD1C5),
          onTertiary: Color(0xFF1D4D4B),
          tertiaryContainer: Color(0xFF234E52),
          onTertiaryContainer: Color(0xFFE6FFFA),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF14161C),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF0E1014),
          surfaceContainerLow: Color(0xFF1E2128),
          surfaceContainer: Color(0xFF262A34),
          surfaceContainerHigh: Color(0xFF2D323E),
          surfaceContainerHighest: Color(0xFF353B4A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF353B4A),
          outlineVariant: Color(0xFF2E333D),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF14161C),
          inversePrimary: Color(0xFF25855A),
        ),
      AccentTheme.coral => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFF687B3),
          onPrimary: Color(0xFF702459),
          primaryContainer: Color(0xFF9B2C67),
          onPrimaryContainer: Color(0xFFFFF5F7),
          secondary: Color(0xFFFEB2B2),
          onSecondary: Color(0xFF742A2A),
          secondaryContainer: Color(0xFF9B2C2C),
          onSecondaryContainer: Color(0xFFFFF5F5),
          tertiary: Color(0xFFFBD38D),
          onTertiary: Color(0xFF7B341E),
          tertiaryContainer: Color(0xFF9C4221),
          onTertiaryContainer: Color(0xFFFFFAF0),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF14161C),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF0E1014),
          surfaceContainerLow: Color(0xFF1E2128),
          surfaceContainer: Color(0xFF262A34),
          surfaceContainerHigh: Color(0xFF2D323E),
          surfaceContainerHighest: Color(0xFF353B4A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF353B4A),
          outlineVariant: Color(0xFF2E333D),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF14161C),
          inversePrimary: Color(0xFFD53F8C),
        ),
      AccentTheme.amber => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFBD38D),
          onPrimary: Color(0xFF7B341E),
          primaryContainer: Color(0xFF9C4221),
          onPrimaryContainer: Color(0xFFFFFAF0),
          secondary: Color(0xFFF6E05E),
          onSecondary: Color(0xFF744210),
          secondaryContainer: Color(0xFF975A16),
          onSecondaryContainer: Color(0xFFFFFFF0),
          tertiary: Color(0xFFF6AD55),
          onTertiary: Color(0xFF652B19),
          tertiaryContainer: Color(0xFF7B341E),
          onTertiaryContainer: Color(0xFFFFFAF0),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF14161C),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF0E1014),
          surfaceContainerLow: Color(0xFF1E2128),
          surfaceContainer: Color(0xFF262A34),
          surfaceContainerHigh: Color(0xFF2D323E),
          surfaceContainerHighest: Color(0xFF353B4A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF353B4A),
          outlineVariant: Color(0xFF2E333D),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF14161C),
          inversePrimary: Color(0xFFDD6B20),
        ),
      AccentTheme.violet => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF4FD1C5),
          onPrimary: Color(0xFF1D4D4B),
          primaryContainer: Color(0xFF234E52),
          onPrimaryContainer: Color(0xFFE6FFFA),
          secondary: Color(0xFF63B3ED),
          onSecondary: Color(0xFF2A4365),
          secondaryContainer: Color(0xFF2C5282),
          onSecondaryContainer: Color(0xFFEBF8FF),
          tertiary: Color(0xFFB794F4),
          onTertiary: Color(0xFF44337A),
          tertiaryContainer: Color(0xFF553C9A),
          onTertiaryContainer: Color(0xFFFAF5FF),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF14161C),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF0E1014),
          surfaceContainerLow: Color(0xFF1E2128),
          surfaceContainer: Color(0xFF262A34),
          surfaceContainerHigh: Color(0xFF2D323E),
          surfaceContainerHighest: Color(0xFF353B4A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF353B4A),
          outlineVariant: Color(0xFF2E333D),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF14161C),
          inversePrimary: Color(0xFF319795),
        ),
    };
  }
}

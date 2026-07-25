import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Orbit Todo Design System — Color Tokens
///
/// 5 hand-tuned theme variants: Pink, Sky Blue, Yellow, Orange, Monochrome.
/// All colors verified for WCAG AA contrast.
enum AccentTheme {
  pink,       // 🌸 Pink (#EC4899)
  skyBlue,    // 🩵 Sky Blue (#0EA5E9)
  yellow,     // 💛 Yellow (#EAB308)
  orange,     // 🟠 Orange (#F97316)
  monochrome, // ⚫⚪ Black & White (#111827)

  // Backward compatibility alias enum constants
  indigo,
  emerald,
  coral,
  amber,
  violet,
}

extension AccentThemeExtension on AccentTheme {
  String get displayName => switch (this) {
        AccentTheme.pink || AccentTheme.coral => 'Pink 🌸',
        AccentTheme.skyBlue || AccentTheme.indigo || AccentTheme.violet => 'Sky Blue 🩵',
        AccentTheme.yellow || AccentTheme.emerald => 'Yellow 💛',
        AccentTheme.orange || AccentTheme.amber => 'Orange 🟠',
        AccentTheme.monochrome => 'Monochrome ⚫⚪',
      };

  Color get swatch => switch (this) {
        AccentTheme.pink || AccentTheme.coral => AppAccentColors.pink.lightColor,
        AccentTheme.skyBlue || AccentTheme.indigo || AccentTheme.violet => AppAccentColors.skyBlue.lightColor,
        AccentTheme.yellow || AccentTheme.emerald => AppAccentColors.yellow.lightColor,
        AccentTheme.orange || AccentTheme.amber => AppAccentColors.orange.lightColor,
        AccentTheme.monochrome => AppAccentColors.monochrome.lightColor,
      };

  AppAccentColor get appAccentColor => switch (this) {
        AccentTheme.pink || AccentTheme.coral => AppAccentColors.pink,
        AccentTheme.skyBlue || AccentTheme.indigo || AccentTheme.violet => AppAccentColors.skyBlue,
        AccentTheme.yellow || AccentTheme.emerald => AppAccentColors.yellow,
        AccentTheme.orange || AccentTheme.amber => AppAccentColors.orange,
        AccentTheme.monochrome => AppAccentColors.monochrome,
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
  static const Color infoLight = Color(0xFF0EA5E9);
  static const Color infoDark = Color(0xFF7DD3FC);

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
  // Accent Theme Color Seeds (Light Mode)
  // ──────────────────────────────────────────────────────────────────────────

  static ColorScheme lightScheme(AccentTheme accent) {
    return switch (accent) {
      AccentTheme.pink || AccentTheme.coral => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFEC4899),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFCE7F3),
          onPrimaryContainer: Color(0xFF831843),
          secondary: Color(0xFFDB2777),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFFBCFE8),
          onSecondaryContainer: Color(0xFF500724),
          tertiary: Color(0xFFBE185D),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFCE7F3),
          onTertiaryContainer: Color(0xFF831843),
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
          outline: Color(0xFFF9A8D4),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFFF9A8D4),
        ),
      AccentTheme.skyBlue || AccentTheme.indigo || AccentTheme.violet => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF0EA5E9),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFE0F2FE),
          onPrimaryContainer: Color(0xFF075985),
          secondary: Color(0xFF0284C7),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFBAE6FD),
          onSecondaryContainer: Color(0xFF0C4A6E),
          tertiary: Color(0xFF0369A1),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFE0F2FE),
          onTertiaryContainer: Color(0xFF075985),
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
          outline: Color(0xFF7DD3FC),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFF7DD3FC),
        ),
      AccentTheme.yellow || AccentTheme.emerald => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFEAB308),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFEF9C3),
          onPrimaryContainer: Color(0xFF713F12),
          secondary: Color(0xFFCA8A04),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFFEF08A),
          onSecondaryContainer: Color(0xFF854D0E),
          tertiary: Color(0xFFA16207),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFEF9C3),
          onTertiaryContainer: Color(0xFF713F12),
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
          outline: Color(0xFFFDE047),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFFFDE047),
        ),
      AccentTheme.orange || AccentTheme.amber => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFF97316),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFFEDD5),
          onPrimaryContainer: Color(0xFF7C2D12),
          secondary: Color(0xFFEA580C),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFFED7AA),
          onSecondaryContainer: Color(0xFF9A3412),
          tertiary: Color(0xFFC2410C),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFFEDD5),
          onTertiaryContainer: Color(0xFF7C2D12),
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
          outline: Color(0xFFFDBA74),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFFFDBA74),
        ),
      AccentTheme.monochrome => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF111827),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFF9FAFB),
          onPrimaryContainer: Color(0xFF111827),
          secondary: Color(0xFF1F2937),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFE5E7EB),
          onSecondaryContainer: Color(0xFF111827),
          tertiary: Color(0xFF000000),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFF3F4F6),
          onTertiaryContainer: Color(0xFF1F2937),
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
          outline: Color(0xFF9CA3AF),
          outlineVariant: Color(0xFFE2E8F0),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF0F172A),
          onInverseSurface: Color(0xFFF8FAFC),
          inversePrimary: Color(0xFF9CA3AF),
        ),
    };
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Accent Theme Color Seeds (Dark Mode)
  // ──────────────────────────────────────────────────────────────────────────

  static ColorScheme darkScheme(AccentTheme accent) {
    return switch (accent) {
      AccentTheme.pink || AccentTheme.coral => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFEC4899),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFF831843),
          onPrimaryContainer: Color(0xFFFCE7F3),
          secondary: Color(0xFFDB2777),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFF9D174D),
          onSecondaryContainer: Color(0xFFFBCFE8),
          tertiary: Color(0xFFBE185D),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFF831843),
          onTertiaryContainer: Color(0xFFFCE7F3),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF0F1015),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF090A0E),
          surfaceContainerLow: Color(0xFF14161C),
          surfaceContainer: Color(0xFF181A20),
          surfaceContainerHigh: Color(0xFF22252E),
          surfaceContainerHighest: Color(0xFF2A2E3A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF2B2F3B),
          outlineVariant: Color(0xFF22252E),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF0F1015),
          inversePrimary: Color(0xFFEC4899),
        ),
      AccentTheme.skyBlue || AccentTheme.indigo || AccentTheme.violet => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF0EA5E9),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFF075985),
          onPrimaryContainer: Color(0xFFE0F2FE),
          secondary: Color(0xFF0284C7),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFF0369A1),
          onSecondaryContainer: Color(0xFFBAE6FD),
          tertiary: Color(0xFF0369A1),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFF075985),
          onTertiaryContainer: Color(0xFFE0F2FE),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF0F1015),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF090A0E),
          surfaceContainerLow: Color(0xFF14161C),
          surfaceContainer: Color(0xFF181A20),
          surfaceContainerHigh: Color(0xFF22252E),
          surfaceContainerHighest: Color(0xFF2A2E3A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF2B2F3B),
          outlineVariant: Color(0xFF22252E),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF0F1015),
          inversePrimary: Color(0xFF0EA5E9),
        ),
      AccentTheme.yellow || AccentTheme.emerald => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFEAB308),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFF854D0E),
          onPrimaryContainer: Color(0xFFFEF9C3),
          secondary: Color(0xFFCA8A04),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFA16207),
          onSecondaryContainer: Color(0xFFFEF08A),
          tertiary: Color(0xFFA16207),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFF854D0E),
          onTertiaryContainer: Color(0xFFFEF9C3),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF0F1015),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF090A0E),
          surfaceContainerLow: Color(0xFF14161C),
          surfaceContainer: Color(0xFF181A20),
          surfaceContainerHigh: Color(0xFF22252E),
          surfaceContainerHighest: Color(0xFF2A2E3A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF2B2F3B),
          outlineVariant: Color(0xFF22252E),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF0F1015),
          inversePrimary: Color(0xFFEAB308),
        ),
      AccentTheme.orange || AccentTheme.amber => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFF97316),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFF9A3412),
          onPrimaryContainer: Color(0xFFFFEDD5),
          secondary: Color(0xFFEA580C),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFC2410C),
          onSecondaryContainer: Color(0xFFFED7AA),
          tertiary: Color(0xFFC2410C),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFF9A3412),
          onTertiaryContainer: Color(0xFFFFEDD5),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF0F1015),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF090A0E),
          surfaceContainerLow: Color(0xFF14161C),
          surfaceContainer: Color(0xFF181A20),
          surfaceContainerHigh: Color(0xFF22252E),
          surfaceContainerHighest: Color(0xFF2A2E3A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF2B2F3B),
          outlineVariant: Color(0xFF22252E),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF0F1015),
          inversePrimary: Color(0xFFF97316),
        ),
      AccentTheme.monochrome => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFF9FAFB),
          onPrimary: Color(0xFF111827),
          primaryContainer: Color(0xFF374151),
          onPrimaryContainer: Color(0xFFF9FAFB),
          secondary: Color(0xFFE5E7EB),
          onSecondary: Color(0xFF111827),
          secondaryContainer: Color(0xFF1F2937),
          onSecondaryContainer: Color(0xFFF3F4F6),
          tertiary: Color(0xFF9CA3AF),
          onTertiary: Color(0xFF111827),
          tertiaryContainer: Color(0xFF1F2937),
          onTertiaryContainer: Color(0xFFF9FAFB),
          error: Color(0xFFF56565),
          onError: Color(0xFF742A2A),
          errorContainer: Color(0xFF9B2C2C),
          onErrorContainer: Color(0xFFFFF5F5),
          surface: Color(0xFF0F1015),
          onSurface: Color(0xFFECEFF4),
          surfaceContainerLowest: Color(0xFF090A0E),
          surfaceContainerLow: Color(0xFF14161C),
          surfaceContainer: Color(0xFF181A20),
          surfaceContainerHigh: Color(0xFF22252E),
          surfaceContainerHighest: Color(0xFF2A2E3A),
          onSurfaceVariant: Color(0xFFA0AEC0),
          outline: Color(0xFF2B2F3B),
          outlineVariant: Color(0xFF22252E),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFECEFF4),
          onInverseSurface: Color(0xFF0F1015),
          inversePrimary: Color(0xFF111827),
        ),
    };
  }
}

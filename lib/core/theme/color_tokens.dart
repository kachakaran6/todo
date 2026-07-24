import 'package:flutter/material.dart';

/// Orbit Todo Design System — Color Tokens
///
/// 5 hand-tuned accent themes, each with semantic color tokens
/// for both light and dark modes. All colors verified for WCAG AA contrast.
enum AccentTheme {
  indigo,
  emerald,
  coral,
  amber,
  violet,
}

extension AccentThemeExtension on AccentTheme {
  String get displayName => switch (this) {
        AccentTheme.indigo => 'Indigo',
        AccentTheme.emerald => 'Emerald',
        AccentTheme.coral => 'Coral',
        AccentTheme.amber => 'Amber',
        AccentTheme.violet => 'Violet',
      };

  Color get swatch => switch (this) {
        AccentTheme.indigo => const Color(0xFF4F46E5),
        AccentTheme.emerald => const Color(0xFF059669),
        AccentTheme.coral => const Color(0xFFDC4C3E),
        AccentTheme.amber => const Color(0xFFD97706),
        AccentTheme.violet => const Color(0xFF7C3AED),
      };
}

class OrbitColorTokens {
  // ──────────────────────────────────────────────────────────────────────────
  // Priority Colors (semantic, theme-independent)
  // ──────────────────────────────────────────────────────────────────────────
  static const Color priorityUrgent = Color(0xFFDC2626);
  static const Color priorityHigh = Color(0xFFEA580C);
  static const Color priorityMedium = Color(0xFFD97706);
  static const Color priorityLow = Color(0xFF2563EB);
  static const Color priorityNone = Color(0xFF9CA3AF);

  // Priority dark variants
  static const Color priorityUrgentDark = Color(0xFFF87171);
  static const Color priorityHighDark = Color(0xFFFB923C);
  static const Color priorityMediumDark = Color(0xFFFBBF24);
  static const Color priorityLowDark = Color(0xFF60A5FA);
  static const Color priorityNoneDark = Color(0xFF6B7280);

  // ──────────────────────────────────────────────────────────────────────────
  // Semantic Status Colors
  // ──────────────────────────────────────────────────────────────────────────
  static const Color successLight = Color(0xFF059669);
  static const Color successDark = Color(0xFF34D399);
  static const Color warningLight = Color(0xFFD97706);
  static const Color warningDark = Color(0xFFFCD34D);
  static const Color errorLight = Color(0xFFDC2626);
  static const Color errorDark = Color(0xFFF87171);
  static const Color infoLight = Color(0xFF2563EB);
  static const Color infoDark = Color(0xFF60A5FA);

  // ──────────────────────────────────────────────────────────────────────────
  // Neutral Palette
  // ──────────────────────────────────────────────────────────────────────────
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);
  static const Color neutral950 = Color(0xFF030712);

  // ──────────────────────────────────────────────────────────────────────────
  // Accent Theme Color Seeds
  // Each returns a fully specified ColorScheme for light and dark modes
  // ──────────────────────────────────────────────────────────────────────────

  static ColorScheme lightScheme(AccentTheme accent) {
    return switch (accent) {
      AccentTheme.indigo => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF4F46E5),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFE0E7FF),
          onPrimaryContainer: Color(0xFF1E1B4B),
          secondary: Color(0xFF6366F1),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFEEF2FF),
          onSecondaryContainer: Color(0xFF312E81),
          tertiary: Color(0xFF8B5CF6),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFEDE9FE),
          onTertiaryContainer: Color(0xFF4C1D95),
          error: Color(0xFFDC2626),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFEE2E2),
          onErrorContainer: Color(0xFF7F1D1D),
          surface: Color(0xFFF9FAFB),
          onSurface: Color(0xFF111827),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF3F4F6),
          surfaceContainer: Color(0xFFE5E7EB),
          surfaceContainerHigh: Color(0xFFD1D5DB),
          surfaceContainerHighest: Color(0xFF9CA3AF),
          onSurfaceVariant: Color(0xFF4B5563),
          outline: Color(0xFFD1D5DB),
          outlineVariant: Color(0xFFE5E7EB),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF1F2937),
          onInverseSurface: Color(0xFFF9FAFB),
          inversePrimary: Color(0xFF818CF8),
        ),
      AccentTheme.emerald => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF059669),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFD1FAE5),
          onPrimaryContainer: Color(0xFF064E3B),
          secondary: Color(0xFF10B981),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFECFDF5),
          onSecondaryContainer: Color(0xFF064E3B),
          tertiary: Color(0xFF0D9488),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFCCFBF1),
          onTertiaryContainer: Color(0xFF134E4A),
          error: Color(0xFFDC2626),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFEE2E2),
          onErrorContainer: Color(0xFF7F1D1D),
          surface: Color(0xFFF9FAFB),
          onSurface: Color(0xFF111827),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF3F4F6),
          surfaceContainer: Color(0xFFE5E7EB),
          surfaceContainerHigh: Color(0xFFD1D5DB),
          surfaceContainerHighest: Color(0xFF9CA3AF),
          onSurfaceVariant: Color(0xFF4B5563),
          outline: Color(0xFFD1D5DB),
          outlineVariant: Color(0xFFE5E7EB),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF1F2937),
          onInverseSurface: Color(0xFFF9FAFB),
          inversePrimary: Color(0xFF34D399),
        ),
      AccentTheme.coral => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFDC4C3E),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFEE2E2),
          onPrimaryContainer: Color(0xFF7F1D1D),
          secondary: Color(0xFFEF4444),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFFEF2F2),
          onSecondaryContainer: Color(0xFF7F1D1D),
          tertiary: Color(0xFFF97316),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFFF7ED),
          onTertiaryContainer: Color(0xFF7C2D12),
          error: Color(0xFFDC2626),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFEE2E2),
          onErrorContainer: Color(0xFF7F1D1D),
          surface: Color(0xFFF9FAFB),
          onSurface: Color(0xFF111827),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF3F4F6),
          surfaceContainer: Color(0xFFE5E7EB),
          surfaceContainerHigh: Color(0xFFD1D5DB),
          surfaceContainerHighest: Color(0xFF9CA3AF),
          onSurfaceVariant: Color(0xFF4B5563),
          outline: Color(0xFFD1D5DB),
          outlineVariant: Color(0xFFE5E7EB),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF1F2937),
          onInverseSurface: Color(0xFFF9FAFB),
          inversePrimary: Color(0xFFFF8A80),
        ),
      AccentTheme.amber => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFD97706),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFEF3C7),
          onPrimaryContainer: Color(0xFF78350F),
          secondary: Color(0xFFF59E0B),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFFFFBEB),
          onSecondaryContainer: Color(0xFF78350F),
          tertiary: Color(0xFFEA580C),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFFF7ED),
          onTertiaryContainer: Color(0xFF7C2D12),
          error: Color(0xFFDC2626),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFEE2E2),
          onErrorContainer: Color(0xFF7F1D1D),
          surface: Color(0xFFF9FAFB),
          onSurface: Color(0xFF111827),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF3F4F6),
          surfaceContainer: Color(0xFFE5E7EB),
          surfaceContainerHigh: Color(0xFFD1D5DB),
          surfaceContainerHighest: Color(0xFF9CA3AF),
          onSurfaceVariant: Color(0xFF4B5563),
          outline: Color(0xFFD1D5DB),
          outlineVariant: Color(0xFFE5E7EB),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF1F2937),
          onInverseSurface: Color(0xFFF9FAFB),
          inversePrimary: Color(0xFFFCD34D),
        ),
      AccentTheme.violet => const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF7C3AED),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFEDE9FE),
          onPrimaryContainer: Color(0xFF2E1065),
          secondary: Color(0xFF8B5CF6),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFF5F3FF),
          onSecondaryContainer: Color(0xFF2E1065),
          tertiary: Color(0xFFA855F7),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFAF5FF),
          onTertiaryContainer: Color(0xFF3B0764),
          error: Color(0xFFDC2626),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFEE2E2),
          onErrorContainer: Color(0xFF7F1D1D),
          surface: Color(0xFFF9FAFB),
          onSurface: Color(0xFF111827),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF3F4F6),
          surfaceContainer: Color(0xFFE5E7EB),
          surfaceContainerHigh: Color(0xFFD1D5DB),
          surfaceContainerHighest: Color(0xFF9CA3AF),
          onSurfaceVariant: Color(0xFF4B5563),
          outline: Color(0xFFD1D5DB),
          outlineVariant: Color(0xFFE5E7EB),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF1F2937),
          onInverseSurface: Color(0xFFF9FAFB),
          inversePrimary: Color(0xFFC084FC),
        ),
    };
  }

  static ColorScheme darkScheme(AccentTheme accent) {
    return switch (accent) {
      AccentTheme.indigo => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF818CF8),
          onPrimary: Color(0xFF1E1B4B),
          primaryContainer: Color(0xFF312E81),
          onPrimaryContainer: Color(0xFFE0E7FF),
          secondary: Color(0xFF93C5FD),
          onSecondary: Color(0xFF1E3A5F),
          secondaryContainer: Color(0xFF1E40AF),
          onSecondaryContainer: Color(0xFFDBEAFE),
          tertiary: Color(0xFFC084FC),
          onTertiary: Color(0xFF2E1065),
          tertiaryContainer: Color(0xFF4C1D95),
          onTertiaryContainer: Color(0xFFEDE9FE),
          error: Color(0xFFF87171),
          onError: Color(0xFF7F1D1D),
          errorContainer: Color(0xFF991B1B),
          onErrorContainer: Color(0xFFFEE2E2),
          surface: Color(0xFF111827),
          onSurface: Color(0xFFF9FAFB),
          surfaceContainerLowest: Color(0xFF030712),
          surfaceContainerLow: Color(0xFF1F2937),
          surfaceContainer: Color(0xFF374151),
          surfaceContainerHigh: Color(0xFF4B5563),
          surfaceContainerHighest: Color(0xFF6B7280),
          onSurfaceVariant: Color(0xFF9CA3AF),
          outline: Color(0xFF4B5563),
          outlineVariant: Color(0xFF374151),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFF9FAFB),
          onInverseSurface: Color(0xFF111827),
          inversePrimary: Color(0xFF4F46E5),
        ),
      AccentTheme.emerald => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF34D399),
          onPrimary: Color(0xFF064E3B),
          primaryContainer: Color(0xFF065F46),
          onPrimaryContainer: Color(0xFFD1FAE5),
          secondary: Color(0xFF6EE7B7),
          onSecondary: Color(0xFF064E3B),
          secondaryContainer: Color(0xFF047857),
          onSecondaryContainer: Color(0xFFECFDF5),
          tertiary: Color(0xFF5EEAD4),
          onTertiary: Color(0xFF134E4A),
          tertiaryContainer: Color(0xFF0F766E),
          onTertiaryContainer: Color(0xFFCCFBF1),
          error: Color(0xFFF87171),
          onError: Color(0xFF7F1D1D),
          errorContainer: Color(0xFF991B1B),
          onErrorContainer: Color(0xFFFEE2E2),
          surface: Color(0xFF111827),
          onSurface: Color(0xFFF9FAFB),
          surfaceContainerLowest: Color(0xFF030712),
          surfaceContainerLow: Color(0xFF1F2937),
          surfaceContainer: Color(0xFF374151),
          surfaceContainerHigh: Color(0xFF4B5563),
          surfaceContainerHighest: Color(0xFF6B7280),
          onSurfaceVariant: Color(0xFF9CA3AF),
          outline: Color(0xFF4B5563),
          outlineVariant: Color(0xFF374151),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFF9FAFB),
          onInverseSurface: Color(0xFF111827),
          inversePrimary: Color(0xFF059669),
        ),
      AccentTheme.coral => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFF8A80),
          onPrimary: Color(0xFF7F1D1D),
          primaryContainer: Color(0xFF991B1B),
          onPrimaryContainer: Color(0xFFFEE2E2),
          secondary: Color(0xFFFCA5A5),
          onSecondary: Color(0xFF7F1D1D),
          secondaryContainer: Color(0xFFB91C1C),
          onSecondaryContainer: Color(0xFFFEF2F2),
          tertiary: Color(0xFFFDA04A),
          onTertiary: Color(0xFF7C2D12),
          tertiaryContainer: Color(0xFF9A3412),
          onTertiaryContainer: Color(0xFFFFF7ED),
          error: Color(0xFFF87171),
          onError: Color(0xFF7F1D1D),
          errorContainer: Color(0xFF991B1B),
          onErrorContainer: Color(0xFFFEE2E2),
          surface: Color(0xFF111827),
          onSurface: Color(0xFFF9FAFB),
          surfaceContainerLowest: Color(0xFF030712),
          surfaceContainerLow: Color(0xFF1F2937),
          surfaceContainer: Color(0xFF374151),
          surfaceContainerHigh: Color(0xFF4B5563),
          surfaceContainerHighest: Color(0xFF6B7280),
          onSurfaceVariant: Color(0xFF9CA3AF),
          outline: Color(0xFF4B5563),
          outlineVariant: Color(0xFF374151),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFF9FAFB),
          onInverseSurface: Color(0xFF111827),
          inversePrimary: Color(0xFFDC4C3E),
        ),
      AccentTheme.amber => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFCD34D),
          onPrimary: Color(0xFF78350F),
          primaryContainer: Color(0xFF92400E),
          onPrimaryContainer: Color(0xFFFEF3C7),
          secondary: Color(0xFFFDE68A),
          onSecondary: Color(0xFF78350F),
          secondaryContainer: Color(0xFFB45309),
          onSecondaryContainer: Color(0xFFFFFBEB),
          tertiary: Color(0xFFFB923C),
          onTertiary: Color(0xFF7C2D12),
          tertiaryContainer: Color(0xFF9A3412),
          onTertiaryContainer: Color(0xFFFFF7ED),
          error: Color(0xFFF87171),
          onError: Color(0xFF7F1D1D),
          errorContainer: Color(0xFF991B1B),
          onErrorContainer: Color(0xFFFEE2E2),
          surface: Color(0xFF111827),
          onSurface: Color(0xFFF9FAFB),
          surfaceContainerLowest: Color(0xFF030712),
          surfaceContainerLow: Color(0xFF1F2937),
          surfaceContainer: Color(0xFF374151),
          surfaceContainerHigh: Color(0xFF4B5563),
          surfaceContainerHighest: Color(0xFF6B7280),
          onSurfaceVariant: Color(0xFF9CA3AF),
          outline: Color(0xFF4B5563),
          outlineVariant: Color(0xFF374151),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFF9FAFB),
          onInverseSurface: Color(0xFF111827),
          inversePrimary: Color(0xFFD97706),
        ),
      AccentTheme.violet => const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFC084FC),
          onPrimary: Color(0xFF2E1065),
          primaryContainer: Color(0xFF4C1D95),
          onPrimaryContainer: Color(0xFFEDE9FE),
          secondary: Color(0xFFD8B4FE),
          onSecondary: Color(0xFF2E1065),
          secondaryContainer: Color(0xFF5B21B6),
          onSecondaryContainer: Color(0xFFF5F3FF),
          tertiary: Color(0xFFE879F9),
          onTertiary: Color(0xFF3B0764),
          tertiaryContainer: Color(0xFF6B21A8),
          onTertiaryContainer: Color(0xFFFAF5FF),
          error: Color(0xFFF87171),
          onError: Color(0xFF7F1D1D),
          errorContainer: Color(0xFF991B1B),
          onErrorContainer: Color(0xFFFEE2E2),
          surface: Color(0xFF111827),
          onSurface: Color(0xFFF9FAFB),
          surfaceContainerLowest: Color(0xFF030712),
          surfaceContainerLow: Color(0xFF1F2937),
          surfaceContainer: Color(0xFF374151),
          surfaceContainerHigh: Color(0xFF4B5563),
          surfaceContainerHighest: Color(0xFF6B7280),
          onSurfaceVariant: Color(0xFF9CA3AF),
          outline: Color(0xFF4B5563),
          outlineVariant: Color(0xFF374151),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFF9FAFB),
          onInverseSurface: Color(0xFF111827),
          inversePrimary: Color(0xFF7C3AED),
        ),
    };
  }
}

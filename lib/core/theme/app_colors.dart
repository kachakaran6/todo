import 'package:flutter/material.dart';

/// App Accent Color definition representing dynamic accent themes with adaptive light and dark values.
class AppAccentColor {
  final String name;
  final Color lightColor;
  final Color darkColor;

  const AppAccentColor(this.name, this.lightColor, this.darkColor);

  /// Swatch color for UI preview elements.
  Color get swatch => lightColor;

  /// Returns appropriate accent color based on theme brightness.
  Color getColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkColor : lightColor;
  }

  /// Returns appropriate accent color based on BuildContext.
  Color of(BuildContext context) {
    return getColor(Theme.of(context).brightness);
  }
}

/// Collection of professionally smooth, non-glowing accent colors.
class AppAccentColors {
  // Smooth, Muted & Non-Glowing Accents
  static const blue = AppAccentColor('Blue', Color(0xFF3A5CCC), Color(0xFF708CFB));
  static const green = AppAccentColor('Green', Color(0xFF25855A), Color(0xFF48BB78));
  static const pink = AppAccentColor('Pink', Color(0xFFD53F8C), Color(0xFFF687B3));
  static const orange = AppAccentColor('Orange', Color(0xFFDD6B20), Color(0xFFFBD38D));
  static const teal = AppAccentColor('Teal', Color(0xFF319795), Color(0xFF4FD1C5));

  static const List<AppAccentColor> all = [
    blue,
    green,
    pink,
    orange,
    teal,
  ];

  /// Finds matching [AppAccentColor] from a light mode color, defaulting to blue.
  static AppAccentColor fromLightColor(Color color) {
    return all.firstWhere(
      (c) => c.lightColor.toARGB32() == color.toARGB32(),
      orElse: () => blue,
    );
  }

  /// Alias for backward compatibility.
  static AppAccentColor fromColor(Color color) => fromLightColor(color);

  /// Finds matching [AppAccentColor] from a hex string.
  static AppAccentColor fromHex(String hex) {
    try {
      final cleanHex = hex.replaceFirst('#', '');
      final colorValue = int.parse(cleanHex, radix: 16) | 0xFF000000;

      return all.firstWhere(
        (c) =>
            c.lightColor.toARGB32() == colorValue ||
            c.darkColor.toARGB32() == colorValue,
        orElse: () => blue,
      );
    } catch (_) {
      return blue;
    }
  }
}

/// Core color tokens for light mode, dark mode (smooth charcoal slate), and adaptive status colors.
class AppColors {
  // =========================
  // LIGHT MODE (Anti-glare, soft slate)
  // =========================

  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFEDF2F7);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = Color(0xFF64748B);
  static const Color lightTextDisabled = Color(0xFF94A3B8);

  // =========================
  // DARK MODE (Smooth Charcoal Slate — Soft & Glare Free)
  // =========================

  static const Color darkBg = Color(0xFF14161C);
  static const Color darkSurface = Color(0xFF1E2128);
  static const Color darkSurfaceElevated = Color(0xFF262A34);
  static const Color darkSurfaceHover = Color(0xFF2D323E);
  static const Color darkBorder = Color(0xFF2E333D);
  static const Color darkDivider = Color(0xFF282C36);
  static const Color darkTextPrimary = Color(0xFFECEFF4);
  static const Color darkTextSecondary = Color(0xFFA0AEC0);
  static const Color darkTextTertiary = Color(0xFF718096);
  static const Color darkTextDisabled = Color(0xFF4A5568);

  // =========================
  // FINANCIAL / FUNCTIONAL COLORS (Context Adaptive & Muted)
  // =========================

  static Color getSuccess(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF48BB78)
          : const Color(0xFF25855A);

  static Color getError(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF56565)
          : const Color(0xFFE53E3E);

  static Color getWarning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFBD38D)
          : const Color(0xFFDD6B20);

  static Color getInfo(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF708CFB)
          : const Color(0xFF3A5CCC);

  // Base fallback constants
  static const Color success = Color(0xFF25855A);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFDD6B20);
  static const Color info = Color(0xFF3A5CCC);
}

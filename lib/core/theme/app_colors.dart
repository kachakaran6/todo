import 'package:flutter/material.dart';

/// App Accent Color definition representing dynamic accent themes with adaptive light and dark values.
class AppAccentColor {
  final String name;
  final Color lightColor;
  final Color darkColor;
  final Color hoverColor;
  final Color activeColor;
  final Color lightTint;
  final Color focusColor;

  const AppAccentColor(
    this.name,
    this.lightColor,
    this.darkColor, {
    this.hoverColor = Colors.transparent,
    this.activeColor = Colors.transparent,
    this.lightTint = Colors.transparent,
    this.focusColor = Colors.transparent,
  });

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

/// Collection of 5 hand-tuned theme variants: Pink, Sky Blue, Yellow, Orange, Monochrome.
class AppAccentColors {
  // 🌸 Pink Theme
  static const pink = AppAccentColor(
    'Pink',
    Color(0xFFEC4899), // Primary #EC4899
    Color(0xFFEC4899), // Rich Vibrant Pink
    hoverColor: Color(0xFFDB2777),
    activeColor: Color(0xFFBE185D),
    lightTint: Color(0xFFFCE7F3),
    focusColor: Color(0xFFF9A8D4),
  );

  // 🩵 Sky Blue Theme
  static const skyBlue = AppAccentColor(
    'Sky Blue',
    Color(0xFF0EA5E9), // Primary #0EA5E9
    Color(0xFF0EA5E9), // Rich Vibrant Sky Blue
    hoverColor: Color(0xFF0284C7),
    activeColor: Color(0xFF0369A1),
    lightTint: Color(0xFFE0F2FE),
    focusColor: Color(0xFF7DD3FC),
  );

  // 💛 Yellow Theme
  static const yellow = AppAccentColor(
    'Yellow',
    Color(0xFFEAB308), // Primary #EAB308
    Color(0xFFEAB308), // Rich Vibrant Yellow
    hoverColor: Color(0xFFCA8A04),
    activeColor: Color(0xFFA16207),
    lightTint: Color(0xFFFEF9C3),
    focusColor: Color(0xFFFDE047),
  );

  // 🟠 Orange Theme
  static const orange = AppAccentColor(
    'Orange',
    Color(0xFFF97316), // Primary #F97316
    Color(0xFFF97316), // Rich Vibrant Orange
    hoverColor: Color(0xFFEA580C),
    activeColor: Color(0xFFC2410C),
    lightTint: Color(0xFFFFEDD5),
    focusColor: Color(0xFFFDBA74),
  );

  // ⚫⚪ Black & White (Monochrome) Theme
  static const monochrome = AppAccentColor(
    'Monochrome',
    Color(0xFF111827), // Primary #111827
    Color(0xFFF9FAFB), // Crisp White in Dark Mode
    hoverColor: Color(0xFF1F2937),
    activeColor: Color(0xFF000000),
    lightTint: Color(0xFFF9FAFB),
    focusColor: Color(0xFF9CA3AF),
  );



  // Backward compatibility getters
  static AppAccentColor get blue => skyBlue;
  static AppAccentColor get green => yellow;
  static AppAccentColor get coral => pink;
  static AppAccentColor get amber => orange;
  static AppAccentColor get teal => skyBlue;

  static const List<AppAccentColor> all = [
    pink,
    skyBlue,
    yellow,
    orange,
    monochrome,
  ];

  /// Finds matching [AppAccentColor] from a light mode color, defaulting to skyBlue.
  static AppAccentColor fromLightColor(Color color) {
    return all.firstWhere(
      (c) => c.lightColor.toARGB32() == color.toARGB32(),
      orElse: () => skyBlue,
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
        orElse: () => skyBlue,
      );
    } catch (_) {
      return skyBlue;
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
  // DARK MODE (Deep OLED Dark Charcoal — Premium & Rich)
  // =========================

  static const Color darkBg = Color(0xFF0F1015);
  static const Color darkSurface = Color(0xFF181A20);
  static const Color darkSurfaceElevated = Color(0xFF22252E);
  static const Color darkSurfaceHover = Color(0xFF2A2E3A);
  static const Color darkBorder = Color(0xFF262933);
  static const Color darkDivider = Color(0xFF1E212A);
  static const Color darkTextPrimary = Color(0xFFECEFF4);
  static const Color darkTextSecondary = Color(0xFFA0AEC0);
  static const Color darkTextTertiary = Color(0xFF718096);
  static const Color darkTextDisabled = Color(0xFF4A5568);

  // =========================
  // LUNA DESIGN SYSTEM TOKENS
  // =========================

  // Primary Accent Palette
  static const Color softRose = Color(0xFFF7D6D0); // Pastel pink highlights
  static const Color dustPink = Color(0xFFE8B4B8); // Muted pink / chips
  static const Color warmCoral = Color(0xFFF4978E); // Primary active accent
  static const Color deepCoralRose = Color(0xFFE05263); // Deep coral rose

  // Secondary Accent Palette
  static const Color lavender = Color(0xFFE2D4F0); // Soft violet / dark mode primary
  static const Color warmPurple = Color(0xFF7C6287); // Deep brand accent
  static const Color cream = Color(0xFFFAF6F0); // Warm cream backdrop
  static const Color softPeach = Color(0xFFFFE5D9); // Ambient glow tint

  // Neutrals (Light Theme)
  static const Color pureWhite = Color(0xFFFFFFFF); // Card background (Light)
  static const Color softOffWhite = Color(0xFFF8F6F2); // Scaffold background (Light)
  static const Color charcoal = Color(0xFF22252A); // Primary text (Light)

  // Neutrals (Dark Theme)
  static const Color slateDark = Color(0xFF0F1015); // Scaffold background (Dark)
  static const Color slateMedium = Color(0xFF181A20); // Card background (Dark)
  static const Color slateElevated = Color(0xFF22252E); // Input / Chip background (Dark)
  static const Color textSecondary = Color(0xFF7B7A87); // Subtitle / secondary text


  // Gradients
  static const LinearGradient fabCoralGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF4978E), // Warm Coral
      Color(0xFFE05263), // Deep Coral Rose
    ],
  );

  static const LinearGradient heroGlowLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFDF0ED),
      Color(0xFFF4E9F7),
      Color(0xFFFAF6F0),
    ],
  );

  static const LinearGradient heroGlowDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2B2228),
      Color(0xFF231E29),
      Color(0xFF181A20),
    ],
  );

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


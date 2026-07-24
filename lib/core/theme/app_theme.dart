import 'package:flutter/material.dart';
import 'color_tokens.dart';
import 'typography.dart';
import '../constants/app_constants.dart';

/// Orbit Todo Design System — ThemeData Builder
///
/// Builds complete Material 3 ThemeData for any combination of
/// [AccentTheme] and [Brightness]. Uses custom color tokens, Inter
/// typography, and hand-tuned component themes.
class OrbitTheme {
  OrbitTheme._();

  static ThemeData build({
    required AccentTheme accent,
    required Brightness brightness,
  }) {
    final colorScheme = brightness == Brightness.light
        ? OrbitColorTokens.lightScheme(accent)
        : OrbitColorTokens.darkScheme(accent);

    final textTheme = OrbitTypography.buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      brightness: brightness,

      // ──────────────────────────────────────────────────────────────────────
      // AppBar
      // ──────────────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: colorScheme.primary,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Bottom Navigation Bar
      // ──────────────────────────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Navigation Bar (Material 3)
      // ──────────────────────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary, size: 24);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Navigation Rail
      // ──────────────────────────────────────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(color: colorScheme.primary, size: 24),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        indicatorColor: colorScheme.primaryContainer,
        elevation: 0,
        useIndicator: true,
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Cards
      // ──────────────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.space4,
          vertical: AppConstants.space1,
        ),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // List Tiles
      // ──────────────────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space4,
          vertical: AppConstants.space1,
        ),
        minLeadingWidth: 24,
        minVerticalPadding: AppConstants.space2,
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Input Decoration
      // ──────────────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space4,
          vertical: AppConstants.space3,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Elevated Button
      // ──────────────────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space6,
            vertical: AppConstants.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusXL),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          minimumSize: const Size(0, AppConstants.touchTargetStd),
        ),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Text Button
      // ──────────────────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space4,
            vertical: AppConstants.space2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          minimumSize: const Size(0, AppConstants.touchTargetStd),
        ),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Outlined Button
      // ──────────────────────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space6,
            vertical: AppConstants.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusXL),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          minimumSize: const Size(0, AppConstants.touchTargetStd),
        ),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // FAB
      // ──────────────────────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        ),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space6,
          vertical: AppConstants.space4,
        ),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Chips
      // ──────────────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space3,
          vertical: AppConstants.space1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Bottom Sheet
      // ──────────────────────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusLG),
          ),
        ),
        elevation: 8,
        showDragHandle: true,
        dragHandleColor: colorScheme.outlineVariant,
        dragHandleSize: const Size(40, 4),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Dialog
      // ──────────────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),

      // ──────────────────────────────────────────────────────────────────────
      // SnackBar
      // ──────────────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Divider
      // ──────────────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        indent: AppConstants.space4,
        endIndent: AppConstants.space4,
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Checkbox
      // ──────────────────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(color: colorScheme.outline, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXS),
        ),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Switch
      // ──────────────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHigh;
        }),
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Popup Menu
      // ──────────────────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        textStyle: textTheme.bodyMedium,
      ),

      // ──────────────────────────────────────────────────────────────────────
      // Scaffold
      // ──────────────────────────────────────────────────────────────────────
      scaffoldBackgroundColor: colorScheme.surface,

      // ──────────────────────────────────────────────────────────────────────
      // Misc
      // ──────────────────────────────────────────────────────────────────────
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}

/// Orbit Todo Design System — App Constants
///
/// Spacing, radius, sizes, breakpoints, and other design tokens
/// that are geometry/layout-based (not color/typography).
class AppConstants {
  AppConstants._();

  // ──────────────────────────────────────────────────────────────────────────
  // 4pt Spacing Grid
  // ──────────────────────────────────────────────────────────────────────────
  static const double space0 = 0;
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;
  static const double space16 = 64;
  static const double space20 = 80;

  // ──────────────────────────────────────────────────────────────────────────
  // Border Radius
  // ──────────────────────────────────────────────────────────────────────────
  static const double radiusXS = 4;    // subtle (progress bar)
  static const double radiusSM = 8;    // chips, badges, small elements
  static const double radiusMD = 12;   // cards, inputs, containers
  static const double radiusLG = 16;   // sheets, dialogs, large cards
  static const double radiusXL = 24;   // FAB, pill buttons
  static const double radiusFull = 999; // fully rounded

  // ──────────────────────────────────────────────────────────────────────────
  // Touch Targets
  // ──────────────────────────────────────────────────────────────────────────
  static const double touchTargetMin = 44;  // WCAG minimum
  static const double touchTargetStd = 48;  // Material standard

  // ──────────────────────────────────────────────────────────────────────────
  // Task Tile Heights (density variants)
  // ──────────────────────────────────────────────────────────────────────────
  static const double tileHeightCompact = 52;
  static const double tileHeightComfortable = 64;
  static const double tileHeightSpacious = 80;

  // ──────────────────────────────────────────────────────────────────────────
  // Layout Breakpoints
  // ──────────────────────────────────────────────────────────────────────────
  static const double breakpointCompact = 600;   // phone portrait
  static const double breakpointMedium = 840;    // tablet / phone landscape
  static const double breakpointExpanded = 1200; // desktop / large tablet

  // ──────────────────────────────────────────────────────────────────────────
  // Navigation
  // ──────────────────────────────────────────────────────────────────────────
  static const double bottomNavHeight = 64;
  static const double navRailWidth = 80;
  static const double sidebarWidth = 280;
  static const double appBarHeight = 56;

  // ──────────────────────────────────────────────────────────────────────────
  // Elevation / Shadow Blur
  // ──────────────────────────────────────────────────────────────────────────
  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation4 = 4;
  static const double elevation8 = 8;

  // ──────────────────────────────────────────────────────────────────────────
  // Quick Add Sheet
  // ──────────────────────────────────────────────────────────────────────────
  static const double quickAddMinHeight = 100;
  static const double quickAddMaxHeight = 0.9; // fraction of screen

  // ──────────────────────────────────────────────────────────────────────────
  // Priority Icon Size
  // ──────────────────────────────────────────────────────────────────────────
  static const double priorityIconSize = 16;
  static const double checkboxSize = 24;
  static const double subtaskCheckboxSize = 20;

  // ──────────────────────────────────────────────────────────────────────────
  // Misc
  // ──────────────────────────────────────────────────────────────────────────
  static const double fabSize = 56;
  static const double listPadding = 16;
  static const double cardPadding = 16;
  static const double contentMaxWidth = 680; // max task list width on wide screens
}

/// Task display density variants
enum TaskDensity {
  compact,
  comfortable,
  spacious;

  String get label => switch (this) {
        TaskDensity.compact => 'Compact',
        TaskDensity.comfortable => 'Comfortable',
        TaskDensity.spacious => 'Spacious',
      };

  double get tileHeight => switch (this) {
        TaskDensity.compact => AppConstants.tileHeightCompact,
        TaskDensity.comfortable => AppConstants.tileHeightComfortable,
        TaskDensity.spacious => AppConstants.tileHeightSpacious,
      };

  double get verticalPadding => switch (this) {
        TaskDensity.compact => AppConstants.space2,
        TaskDensity.comfortable => AppConstants.space3,
        TaskDensity.spacious => AppConstants.space4,
      };
}

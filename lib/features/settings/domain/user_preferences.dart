import 'package:flutter/material.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/font_tokens.dart';
import '../../../core/constants/app_constants.dart';

/// User preferences domain model.
/// All values have sensible defaults for a first-run experience.
class UserPrefs {
  const UserPrefs({
    this.themeMode = ThemeMode.system,
    this.accentTheme = AccentTheme.indigo,
    this.fontStyle = AppFontStyle.modern,
    this.taskDensity = TaskDensity.comfortable,
    this.defaultLandingPage = 0,
    this.showCompletedInToday = false,
    this.firstRunComplete = false,
  });

  final ThemeMode themeMode;
  final AccentTheme accentTheme;
  final AppFontStyle fontStyle;
  final TaskDensity taskDensity;
  final int defaultLandingPage; // nav index
  final bool showCompletedInToday;
  final bool firstRunComplete;

  UserPrefs copyWith({
    ThemeMode? themeMode,
    AccentTheme? accentTheme,
    AppFontStyle? fontStyle,
    TaskDensity? taskDensity,
    int? defaultLandingPage,
    bool? showCompletedInToday,
    bool? firstRunComplete,
  }) {
    return UserPrefs(
      themeMode: themeMode ?? this.themeMode,
      accentTheme: accentTheme ?? this.accentTheme,
      fontStyle: fontStyle ?? this.fontStyle,
      taskDensity: taskDensity ?? this.taskDensity,
      defaultLandingPage: defaultLandingPage ?? this.defaultLandingPage,
      showCompletedInToday: showCompletedInToday ?? this.showCompletedInToday,
      firstRunComplete: firstRunComplete ?? this.firstRunComplete,
    );
  }
}

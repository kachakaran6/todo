import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/user_preferences.dart';

/// Keys for SharedPreferences storage.
abstract class _Keys {
  static const themeMode = 'theme_mode';
  static const accentTheme = 'accent_theme';
  static const taskDensity = 'task_density';
  static const defaultLandingPage = 'default_landing_page';
  static const showCompletedInToday = 'show_completed_in_today';
  static const firstRunComplete = 'first_run_complete';
}

/// Persists and retrieves user preferences using SharedPreferences.
/// This is appropriate for lightweight key-value settings;
/// heavy data lives in the Drift database.
class PreferencesRepository {
  PreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  /// Load all preferences, falling back to defaults if not set.
  UserPrefs loadPreferences() {
    final themeModeIndex = _prefs.getInt(_Keys.themeMode) ?? ThemeMode.system.index;
    final accentIndex = _prefs.getInt(_Keys.accentTheme) ?? AccentTheme.indigo.index;
    final densityIndex = _prefs.getInt(_Keys.taskDensity) ?? TaskDensity.comfortable.index;

    return UserPrefs(
      themeMode: ThemeMode.values[themeModeIndex.clamp(0, ThemeMode.values.length - 1)],
      accentTheme: AccentTheme.values[accentIndex.clamp(0, AccentTheme.values.length - 1)],
      taskDensity: TaskDensity.values[densityIndex.clamp(0, TaskDensity.values.length - 1)],
      defaultLandingPage: _prefs.getInt(_Keys.defaultLandingPage) ?? 0,
      showCompletedInToday: _prefs.getBool(_Keys.showCompletedInToday) ?? false,
      firstRunComplete: _prefs.getBool(_Keys.firstRunComplete) ?? false,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_Keys.themeMode, mode.index);
  }

  Future<void> setAccentTheme(AccentTheme accent) async {
    await _prefs.setInt(_Keys.accentTheme, accent.index);
  }

  Future<void> setTaskDensity(TaskDensity density) async {
    await _prefs.setInt(_Keys.taskDensity, density.index);
  }

  Future<void> setDefaultLandingPage(int index) async {
    await _prefs.setInt(_Keys.defaultLandingPage, index);
  }

  Future<void> setShowCompletedInToday(bool value) async {
    await _prefs.setBool(_Keys.showCompletedInToday, value);
  }

  Future<void> setFirstRunComplete(bool value) async {
    await _prefs.setBool(_Keys.firstRunComplete, value);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/color_tokens.dart';
import '../../../core/constants/app_constants.dart';
import '../data/preferences_repository.dart';
import '../domain/user_preferences.dart';

part 'preferences_provider.g.dart';

/// Provides the SharedPreferences instance (initialized before runApp).
/// Override this in main() after awaiting SharedPreferences.getInstance().
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences before creating ProviderScope');
});

/// Provides the PreferencesRepository.
@Riverpod(keepAlive: true)
PreferencesRepository preferencesRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesRepository(prefs);
}

/// The primary user preferences notifier.
/// Loaded synchronously from SharedPreferences (already initialized).
@Riverpod(keepAlive: true)
class PreferencesNotifier extends _$PreferencesNotifier {
  @override
  UserPrefs build() {
    return ref.watch(preferencesRepositoryProvider).loadPreferences();
  }

  PreferencesRepository get _repo => ref.read(preferencesRepositoryProvider);

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repo.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setAccentTheme(AccentTheme accent) async {
    await _repo.setAccentTheme(accent);
    state = state.copyWith(accentTheme: accent);
  }

  Future<void> setTaskDensity(TaskDensity density) async {
    await _repo.setTaskDensity(density);
    state = state.copyWith(taskDensity: density);
  }

  Future<void> setDefaultLandingPage(int index) async {
    await _repo.setDefaultLandingPage(index);
    state = state.copyWith(defaultLandingPage: index);
  }

  Future<void> setShowCompletedInToday(bool value) async {
    await _repo.setShowCompletedInToday(value);
    state = state.copyWith(showCompletedInToday: value);
  }

  Future<void> completeFirstRun() async {
    await _repo.setFirstRunComplete(true);
    state = state.copyWith(firstRunComplete: true);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/color_tokens.dart';
import '../../features/settings/application/preferences_provider.dart';
import 'routes.dart';

/// Root MaterialApp for Orbit Todo.
/// Reads theme preferences from Riverpod and builds the correct
/// ThemeData on the fly. Theme changes apply instantly without restart.
class OrbitTodoApp extends ConsumerWidget {
  const OrbitTodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesNotifierProvider);

    return MaterialApp.router(
      title: 'Orbit Todo',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: prefs.themeMode,
      theme: OrbitTheme.build(
        accent: prefs.accentTheme,
        fontStyle: prefs.fontStyle,
        brightness: Brightness.light,
      ),
      darkTheme: OrbitTheme.build(
        accent: prefs.accentTheme,
        fontStyle: prefs.fontStyle,
        brightness: Brightness.dark,
      ),
      // Global scroll behavior (more natural physics on all platforms)
      scrollBehavior: const _OrbitScrollBehavior(),
    );
  }
}

/// Custom scroll behavior: bouncing physics on iOS, clamping on Android.
/// Removes the glow effect on Android for a cleaner look.
class _OrbitScrollBehavior extends ScrollBehavior {
  const _OrbitScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const BouncingScrollPhysics();
      default:
        return const ClampingScrollPhysics();
    }
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // Suppress glow effect
  }
}

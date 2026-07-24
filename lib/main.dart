import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'features/settings/application/preferences_provider.dart';

Future<void> main() async {
  // Ensure Flutter bindings are ready before async work
  WidgetsFlutterBinding.ensureInitialized();

  // Load SharedPreferences synchronously before the first frame
  // so theme/accent are available immediately without a flash.
  final sharedPrefs = await SharedPreferences.getInstance();

  // Set preferred orientations (both portrait and landscape supported)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Edge-to-edge display on Android
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        // Provide the pre-initialized SharedPreferences instance
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const OrbitTodoApp(),
    ),
  );
}

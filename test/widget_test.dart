import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orbit_todo/app/app.dart';
import 'package:orbit_todo/features/settings/application/preferences_provider.dart';

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
        child: const OrbitTodoApp(),
      ),
    );

    expect(find.byType(OrbitTodoApp), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/core/l10n/generated/app_localizations.dart';
import 'package:foodhub/core/providers/shared_preferences_provider.dart';
import 'package:foodhub/features/favorites/presentation/favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _buildApp(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      home: FavoritesScreen(),
    ),
  );
}

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('shows empty state when no favorites', (tester) async {
    await tester.pumpWidget(_buildApp(prefs));
    await tester.pumpAndSettle();

    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.text('Add recipes you love here'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
  });

  testWidgets('shows Favorites in AppBar', (tester) async {
    await tester.pumpWidget(_buildApp(prefs));
    await tester.pumpAndSettle();

    expect(find.text('Favorites'), findsOneWidget);
  });

  testWidgets('shows list when favorites exist', (tester) async {
    SharedPreferences.setMockInitialValues({
      'favorites_list':
          '[{"id":"1","name":"Test Meal","thumb":"https://example.com/img.jpg","category":"Beef"}]',
    });
    final prefsWithData = await SharedPreferences.getInstance();

    await tester.pumpWidget(_buildApp(prefsWithData));
    await tester.pumpAndSettle();

    expect(find.text('Test Meal'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}

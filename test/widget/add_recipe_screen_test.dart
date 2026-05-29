import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/core/l10n/generated/app_localizations.dart';
import 'package:foodhub/core/providers/shared_preferences_provider.dart';
import 'package:foodhub/features/my_recipes/presentation/add_recipe_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _buildApp(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      home: AddRecipeScreen(),
    ),
  );
}

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('shows Add Recipe title', (tester) async {
    await tester.pumpWidget(_buildApp(prefs));
    await tester.pumpAndSettle();

    expect(find.text('Add Recipe'), findsOneWidget);
  });

  testWidgets('shows validation error on empty name submit', (tester) async {
    await tester.pumpWidget(_buildApp(prefs));
    await tester.pumpAndSettle();

    final button = find.byType(FilledButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Recipe name is required'), findsOneWidget);
  });

  testWidgets('shows all form fields', (tester) async {
    await tester.pumpWidget(_buildApp(prefs));
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
  });
}

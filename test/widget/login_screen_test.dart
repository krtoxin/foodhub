import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/core/l10n/generated/app_localizations.dart';
import 'package:foodhub/core/providers/shared_preferences_provider.dart';
import 'package:foodhub/features/auth/presentation/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _buildApp(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      home: LoginScreen(),
    ),
  );
}

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('shows FoodHub title on login screen', (tester) async {
    await tester.pumpWidget(_buildApp(prefs));
    await tester.pumpAndSettle();

    expect(find.text('FoodHub'), findsWidgets);
  });

  testWidgets('shows validation errors on empty form submit', (tester) async {
    await tester.pumpWidget(_buildApp(prefs));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('This field is required'), findsWidgets);
  });

  testWidgets('shows invalid email error', (tester) async {
    await tester.pumpWidget(_buildApp(prefs));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'not-an-email',
    );
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
  });
}

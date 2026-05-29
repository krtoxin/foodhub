import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/core/l10n/generated/app_localizations.dart';
import 'package:foodhub/features/auth/domain/auth_state.dart';
import 'package:foodhub/features/auth/presentation/auth_provider.dart';
import 'package:foodhub/features/auth/presentation/login_screen.dart';

class _FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => const AuthState();
  @override
  Future<void> signIn(String e, String p) async {}
  @override
  Future<void> signUp(String e, String p, String n) async {}
  @override
  Future<void> resetPassword(String e) async {}
  @override
  Future<void> signOut() async {}
  @override
  Future<void> updatePhotoUrl(String url) async {}
}

Widget _buildApp() {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(_FakeAuthNotifier.new),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      home: LoginScreen(),
    ),
  );
}

void main() {
  testWidgets('shows FoodHub title on login screen', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('FoodHub'), findsWidgets);
  });

  testWidgets('shows validation errors on empty form submit', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('This field is required'), findsWidgets);
  });

  testWidgets('shows invalid email error', (tester) async {
    await tester.pumpWidget(_buildApp());
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

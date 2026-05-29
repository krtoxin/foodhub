import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/core/l10n/generated/app_localizations.dart';
import 'package:foodhub/features/auth/presentation/auth_provider.dart';
import 'package:foodhub/features/favorites/domain/favorite_meal.dart';
import 'package:foodhub/features/favorites/presentation/favorites_provider.dart';
import 'package:foodhub/features/favorites/presentation/favorites_screen.dart';

Widget _buildApp({
  String? uid = 'test-uid',
  List<FavoriteMeal> favorites = const [],
}) {
  return ProviderScope(
    overrides: [
      currentUidProvider.overrideWithValue(uid),
      favoritesStreamProvider.overrideWithValue(Stream.value(favorites)),
      favoritesProvider.overrideWith(() => _FakeFavoritesNotifier(favorites)),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      home: FavoritesScreen(),
    ),
  );
}

class _FakeFavoritesNotifier extends FavoritesNotifier {
  final List<FavoriteMeal> _initial;
  _FakeFavoritesNotifier(this._initial);

  @override
  List<FavoriteMeal> build() => _initial;
}

void main() {
  testWidgets('shows empty state when no favorites', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
  });

  testWidgets('shows Favorites in AppBar', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Favorites'), findsOneWidget);
  });

  testWidgets('shows list when favorites exist', (tester) async {
    final meal = FavoriteMeal(
      id: '1',
      name: 'Test Meal',
      thumb: 'https://example.com/img.jpg',
      category: 'Beef',
    );

    await tester.pumpWidget(_buildApp(favorites: [meal]));
    await tester.pumpAndSettle();

    expect(find.text('Test Meal'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}

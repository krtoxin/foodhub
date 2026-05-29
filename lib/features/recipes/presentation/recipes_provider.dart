import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../data/meal_api_client.dart';
import '../data/meal_repository_impl.dart';
import '../domain/meal_category.dart';
import '../domain/meal_detail.dart';
import '../domain/meal_preview.dart';
import '../domain/meal_repository.dart';

final mealApiClientProvider = Provider<MealApiClient>((_) => MealApiClient());

final mealRepositoryProvider = Provider<MealRepository>(
  (ref) => MealRepositoryImpl(ref.watch(mealApiClientProvider)),
);

final categoriesProvider = FutureProvider<List<MealCategory>>(
  (ref) => ref.watch(mealRepositoryProvider).getCategories(),
);

final mealsByCategoryProvider =
    FutureProvider.family<List<MealPreview>, String>(
  (ref, category) =>
      ref.watch(mealRepositoryProvider).getMealsByCategory(category),
);

final mealDetailProvider = FutureProvider.family<MealDetail?, String>(
  (ref, id) => ref.watch(mealRepositoryProvider).getMealById(id),
);

class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
    if (query.isNotEmpty) {
      ref
          .read(sharedPreferencesProvider)
          .setString(AppConstants.prefLastSearch, query);
    }
  }

  void clear() => state = '';
}

final searchQueryProvider =
    NotifierProvider<SearchNotifier, String>(SearchNotifier.new);

final searchResultsProvider = FutureProvider<List<MealPreview>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return Future.value([]);
  return ref.watch(mealRepositoryProvider).searchMeals(query);
});

final randomMealProvider = FutureProvider<MealDetail?>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  final repo = ref.watch(mealRepositoryProvider);

  final today = DateTime.now().toIso8601String().split('T').first;
  final savedDate = prefs.getString(AppConstants.prefRandomMealDate);
  final savedId = prefs.getString(AppConstants.prefRandomMealId);

  if (savedDate == today && savedId != null && savedId.isNotEmpty) {
    return repo.getMealById(savedId);
  }

  final meal = await repo.getRandomMeal();
  if (meal != null) {
    await prefs.setString(AppConstants.prefRandomMealDate, today);
    await prefs.setString(AppConstants.prefRandomMealId, meal.id);
  }
  return meal;
});

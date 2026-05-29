import '../domain/meal_category.dart';
import '../domain/meal_detail.dart';
import '../domain/meal_preview.dart';
import '../domain/meal_repository.dart';
import 'meal_api_client.dart';

class MealRepositoryImpl implements MealRepository {
  final MealApiClient _client;

  MealRepositoryImpl(this._client);

  @override
  Future<List<MealCategory>> getCategories() => _client.getCategories();

  @override
  Future<List<MealPreview>> searchMeals(String query) =>
      _client.searchMeals(query);

  @override
  Future<List<MealPreview>> getMealsByCategory(String category) =>
      _client.getMealsByCategory(category);

  @override
  Future<MealDetail?> getMealById(String id) => _client.getMealById(id);

  @override
  Future<MealDetail?> getRandomMeal() => _client.getRandomMeal();
}

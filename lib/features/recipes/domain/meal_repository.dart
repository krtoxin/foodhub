import 'meal_category.dart';
import 'meal_detail.dart';
import 'meal_preview.dart';

abstract class MealRepository {
  Future<List<MealCategory>> getCategories();
  Future<List<MealPreview>> searchMeals(String query);
  Future<List<MealPreview>> getMealsByCategory(String category);
  Future<MealDetail?> getMealById(String id);
  Future<MealDetail?> getRandomMeal();
}

import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/features/recipes/domain/meal_detail.dart';

void main() {
  group('MealDetail.fromJson', () {
    test('parses basic fields', () {
      final json = _buildJson();

      final meal = MealDetail.fromJson(json);

      expect(meal.id, '52772');
      expect(meal.name, 'Teriyaki Chicken Casserole');
      expect(meal.category, 'Chicken');
      expect(meal.area, 'Japanese');
    });

    test('parses ingredients and measures', () {
      final json = _buildJson();

      final meal = MealDetail.fromJson(json);

      expect(meal.ingredients.length, 2);
      expect(meal.ingredients[0].$1, 'soy sauce');
      expect(meal.ingredients[0].$2, '3/4 cup');
      expect(meal.ingredients[1].$1, 'water');
      expect(meal.ingredients[1].$2, '1/2 cup');
    });

    test('skips empty ingredients', () {
      final json = _buildJson()..['strIngredient3'] = '';

      final meal = MealDetail.fromJson(json);

      expect(meal.ingredients.length, 2);
    });

    test('youtubeUrl is nullable', () {
      final json = _buildJson()..remove('strYoutube');

      final meal = MealDetail.fromJson(json);

      expect(meal.youtubeUrl, isNull);
    });
  });
}

Map<String, dynamic> _buildJson() => {
      'idMeal': '52772',
      'strMeal': 'Teriyaki Chicken Casserole',
      'strMealThumb': 'https://example.com/meal.jpg',
      'strCategory': 'Chicken',
      'strArea': 'Japanese',
      'strInstructions': 'Mix and bake.',
      'strYoutube': 'https://youtube.com/watch?v=abc',
      'strIngredient1': 'soy sauce',
      'strMeasure1': '3/4 cup',
      'strIngredient2': 'water',
      'strMeasure2': '1/2 cup',
      for (int i = 3; i <= 20; i++) 'strIngredient$i': '',
      for (int i = 3; i <= 20; i++) 'strMeasure$i': '',
    };

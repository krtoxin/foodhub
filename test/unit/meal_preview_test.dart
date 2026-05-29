import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/features/recipes/domain/meal_preview.dart';

void main() {
  group('MealPreview.fromJson', () {
    test('parses all fields correctly', () {
      final json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken',
        'strMealThumb': 'https://example.com/teriyaki.jpg',
      };

      final meal = MealPreview.fromJson(json);

      expect(meal.id, '52772');
      expect(meal.name, 'Teriyaki Chicken');
      expect(meal.thumb, 'https://example.com/teriyaki.jpg');
    });

    test('uses empty string when thumb is missing', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
      };

      final meal = MealPreview.fromJson(json);

      expect(meal.thumb, '');
    });

    test('preserves meal name exactly', () {
      const name = 'Beef Wellington';
      final json = {
        'idMeal': '42',
        'strMeal': name,
        'strMealThumb': '',
      };

      final meal = MealPreview.fromJson(json);

      expect(meal.name, name);
    });
  });
}

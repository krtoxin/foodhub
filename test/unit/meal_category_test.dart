import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/features/recipes/domain/meal_category.dart';

void main() {
  group('MealCategory.fromJson', () {
    test('parses all fields correctly', () {
      final json = {
        'idCategory': '1',
        'strCategory': 'Beef',
        'strCategoryThumb': 'https://example.com/beef.jpg',
        'strCategoryDescription': 'All beef dishes',
      };

      final category = MealCategory.fromJson(json);

      expect(category.id, '1');
      expect(category.name, 'Beef');
      expect(category.thumb, 'https://example.com/beef.jpg');
      expect(category.description, 'All beef dishes');
    });

    test('uses empty string when description is missing', () {
      final json = {
        'idCategory': '2',
        'strCategory': 'Chicken',
        'strCategoryThumb': 'https://example.com/chicken.jpg',
      };

      final category = MealCategory.fromJson(json);

      expect(category.description, '');
    });

    test('preserves category name exactly', () {
      final json = {
        'idCategory': '14',
        'strCategory': 'Vegetarian',
        'strCategoryThumb': 'https://example.com/veg.jpg',
        'strCategoryDescription': 'Vegetarian meals',
      };

      final category = MealCategory.fromJson(json);

      expect(category.name, 'Vegetarian');
    });
  });
}

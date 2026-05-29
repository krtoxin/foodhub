import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/features/my_recipes/domain/my_recipe.dart';

void main() {
  group('MyRecipe', () {
    test('fromJson parses all required fields', () {
      final json = {
        'id': 'abc123',
        'name': 'My Pasta',
        'category': 'Pasta',
        'ingredients': '200g pasta\n100ml cream',
        'steps': '1. Boil pasta\n2. Add cream',
        'imagePath': '/local/path/image.jpg',
        'createdAt': 1700000000000,
      };

      final recipe = MyRecipe.fromJson(json);

      expect(recipe.id, 'abc123');
      expect(recipe.name, 'My Pasta');
      expect(recipe.category, 'Pasta');
      expect(recipe.ingredients, '200g pasta\n100ml cream');
      expect(recipe.steps, '1. Boil pasta\n2. Add cream');
      expect(recipe.imagePath, '/local/path/image.jpg');
      expect(recipe.createdAt, 1700000000000);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': '1',
        'name': 'Simple Soup',
        'category': '',
        'ingredients': 'Water, salt',
        'steps': 'Boil water.',
        'createdAt': 0,
      };

      final recipe = MyRecipe.fromJson(json);

      expect(recipe.imagePath, isNull);
      expect(recipe.category, '');
    });

    test('toJson round-trips correctly', () {
      const recipe = MyRecipe(
        id: 'xyz',
        name: 'Test Recipe',
        category: 'Vegan',
        ingredients: 'Tofu, soy sauce',
        steps: 'Fry tofu.',
        createdAt: 999,
      );

      final json = recipe.toJson();
      final restored = MyRecipe.fromJson(json);

      expect(restored.id, recipe.id);
      expect(restored.name, recipe.name);
      expect(restored.category, recipe.category);
      expect(restored.ingredients, recipe.ingredients);
      expect(restored.steps, recipe.steps);
      expect(restored.createdAt, recipe.createdAt);
    });

    test('copyWith updates specified fields only', () {
      const original = MyRecipe(
        id: '1',
        name: 'Original',
        category: 'Beef',
        ingredients: 'beef',
        steps: 'grill it',
        createdAt: 1000,
      );

      final updated = original.copyWith(name: 'Updated', category: 'Chicken');

      expect(updated.id, original.id);
      expect(updated.name, 'Updated');
      expect(updated.category, 'Chicken');
      expect(updated.ingredients, original.ingredients);
      expect(updated.createdAt, original.createdAt);
    });

    test('toJson omits imagePath when null', () {
      const recipe = MyRecipe(
        id: '1',
        name: 'No Photo',
        category: 'Starter',
        ingredients: 'bread',
        steps: 'slice it',
        createdAt: 0,
      );

      final json = recipe.toJson();

      expect(json.containsKey('imagePath'), isFalse);
    });
  });
}

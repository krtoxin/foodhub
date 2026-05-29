import 'package:flutter_test/flutter_test.dart';
import 'package:foodhub/features/favorites/domain/favorite_meal.dart';

void main() {
  group('FavoriteMeal', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': '52772',
        'name': 'Teriyaki Chicken',
        'thumb': 'https://example.com/teriyaki.jpg',
        'category': 'Chicken',
      };

      final meal = FavoriteMeal.fromJson(json);

      expect(meal.id, '52772');
      expect(meal.name, 'Teriyaki Chicken');
      expect(meal.thumb, 'https://example.com/teriyaki.jpg');
      expect(meal.category, 'Chicken');
    });

    test('fromJson handles missing category', () {
      final json = {
        'id': '1',
        'name': 'Test Meal',
        'thumb': 'https://example.com/test.jpg',
      };

      final meal = FavoriteMeal.fromJson(json);

      expect(meal.category, isNull);
    });

    test('toJson round-trips correctly', () {
      const meal = FavoriteMeal(
        id: '42',
        name: 'Pasta Carbonara',
        thumb: 'https://example.com/pasta.jpg',
        category: 'Pasta',
      );

      final json = meal.toJson();
      final restored = FavoriteMeal.fromJson(json);

      expect(restored.id, meal.id);
      expect(restored.name, meal.name);
      expect(restored.thumb, meal.thumb);
      expect(restored.category, meal.category);
    });

    test('equality is based on id', () {
      const a = FavoriteMeal(id: '1', name: 'Meal A', thumb: 'a.jpg');
      const b = FavoriteMeal(id: '1', name: 'Meal B', thumb: 'b.jpg');
      const c = FavoriteMeal(id: '2', name: 'Meal A', thumb: 'a.jpg');

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('toJson omits null category', () {
      const meal = FavoriteMeal(id: '1', name: 'Test', thumb: 'test.jpg');

      final json = meal.toJson();

      expect(json.containsKey('category'), isFalse);
    });
  });
}

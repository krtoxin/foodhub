class MealDetail {
  final String id;
  final String name;
  final String thumb;
  final String category;
  final String area;
  final String instructions;
  final String? youtubeUrl;
  final List<(String ingredient, String measure)> ingredients;

  const MealDetail({
    required this.id,
    required this.name,
    required this.thumb,
    required this.category,
    required this.area,
    required this.instructions,
    this.youtubeUrl,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = <(String, String)>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = (json['strIngredient$i'] as String? ?? '').trim();
      final measure = (json['strMeasure$i'] as String? ?? '').trim();
      if (ingredient.isNotEmpty) {
        ingredients.add((ingredient, measure));
      }
    }
    return MealDetail(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumb: json['strMealThumb'] as String? ?? '',
      category: json['strCategory'] as String? ?? '',
      area: json['strArea'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      youtubeUrl: json['strYoutube'] as String?,
      ingredients: ingredients,
    );
  }
}

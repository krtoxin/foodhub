class MealPreview {
  final String id;
  final String name;
  final String thumb;

  const MealPreview({
    required this.id,
    required this.name,
    required this.thumb,
  });

  factory MealPreview.fromJson(Map<String, dynamic> json) => MealPreview(
        id: json['idMeal'] as String,
        name: json['strMeal'] as String,
        thumb: json['strMealThumb'] as String? ?? '',
      );
}

class MealCategory {
  final String id;
  final String name;
  final String thumb;
  final String description;

  const MealCategory({
    required this.id,
    required this.name,
    required this.thumb,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) => MealCategory(
        id: json['idCategory'] as String,
        name: json['strCategory'] as String,
        thumb: json['strCategoryThumb'] as String,
        description: json['strCategoryDescription'] as String? ?? '',
      );
}

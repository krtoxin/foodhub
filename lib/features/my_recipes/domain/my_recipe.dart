class MyRecipe {
  final String id;
  final String name;
  final String category;
  final String ingredients;
  final String steps;
  final String? imagePath;
  final int createdAt;

  const MyRecipe({
    required this.id,
    required this.name,
    required this.category,
    required this.ingredients,
    required this.steps,
    this.imagePath,
    required this.createdAt,
  });

  factory MyRecipe.fromJson(Map<String, dynamic> json) => MyRecipe(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String? ?? '',
        ingredients: json['ingredients'] as String,
        steps: json['steps'] as String,
        imagePath: json['imagePath'] as String?,
        createdAt: json['createdAt'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'ingredients': ingredients,
        'steps': steps,
        if (imagePath != null) 'imagePath': imagePath,
        'createdAt': createdAt,
      };

  MyRecipe copyWith({
    String? name,
    String? category,
    String? ingredients,
    String? steps,
    String? imagePath,
  }) =>
      MyRecipe(
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        ingredients: ingredients ?? this.ingredients,
        steps: steps ?? this.steps,
        imagePath: imagePath ?? this.imagePath,
        createdAt: createdAt,
      );
}

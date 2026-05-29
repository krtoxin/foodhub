class FavoriteMeal {
  final String id;
  final String name;
  final String thumb;
  final String? category;

  const FavoriteMeal({
    required this.id,
    required this.name,
    required this.thumb,
    this.category,
  });

  factory FavoriteMeal.fromJson(Map<String, dynamic> json) => FavoriteMeal(
        id: json['id'] as String,
        name: json['name'] as String,
        thumb: json['thumb'] as String,
        category: json['category'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'thumb': thumb,
        if (category != null) 'category': category,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteMeal &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

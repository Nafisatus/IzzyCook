/// A single ingredient with its measure.
class Ingredient {
  final String name;
  final String measure;

  const Ingredient({required this.name, required this.measure});
}

/// Data model for a recipe from TheMealDB.
class Meal {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final List<String> tags;
  final List<Ingredient> ingredients;

  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.tags,
    required this.ingredients,
  });

  /// Converts a JSON map into a [Meal] object.
  factory Meal.fromJson(Map<String, dynamic> json) {
    // The API stores ingredients as strIngredient1..20 and strMeasure1..20.
    // Combine them into one list and skip the empty ones.
    final ingredients = <Ingredient>[];
    for (var i = 1; i <= 20; i++) {
      final name = (json['strIngredient$i'] as String?)?.trim() ?? '';
      final measure = (json['strMeasure$i'] as String?)?.trim() ?? '';
      if (name.isNotEmpty) {
        ingredients.add(Ingredient(name: name, measure: measure));
      }
    }

    // strArea can be null, so fall back to strCountry.
    final area = (json['strArea'] as String?) ??
        (json['strCountry'] as String?) ??
        'Other';

    final rawTags = (json['strTags'] as String?) ?? '';
    final tags = rawTags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: (json['strCategory'] as String?) ?? '-',
      area: area,
      instructions: ((json['strInstructions'] as String?) ?? '')
          .replaceAll('\r\n', '\n')
          .trim(),
      thumbnail: (json['strMealThumb'] as String?) ?? '',
      tags: tags,
      ingredients: ingredients,
    );
  }
}
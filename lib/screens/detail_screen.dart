import 'package:flutter/material.dart';

import '../models/meal.dart';

/// Detail page: photo, category, ingredients, and cooking instructions.
class DetailScreen extends StatelessWidget {
  final Meal meal;

  const DetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(meal.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'meal-${meal.id}',
              child: Image.network(
                meal.thumbnail,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 240,
                  child: Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.name,
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(
                          avatar: const Icon(Icons.restaurant_menu, size: 18),
                          label: Text(meal.category)),
                      Chip(
                          avatar: const Icon(Icons.public, size: 18),
                          label: Text(meal.area)),
                      ...meal.tags.map((t) => Chip(label: Text(t))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Ingredients (${meal.ingredients.length})',
                      style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ...meal.ingredients.map(
                    (ing) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(
                            child: Text(ing.measure.isEmpty
                                ? ing.name
                                : '${ing.name} — ${ing.measure}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Instructions', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(meal.instructions, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
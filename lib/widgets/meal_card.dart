import 'package:flutter/material.dart';

import '../models/meal.dart';

/// Compact card for one recipe on the list page.
class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Hero(
              tag: 'meal-${meal.id}',
              child: Image.network(
                meal.thumbnail,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(Icons.broken_image),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text('${meal.category} • ${meal.area}'),
                    const SizedBox(height: 4),
                    Text('${meal.ingredients.length} ingredients',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
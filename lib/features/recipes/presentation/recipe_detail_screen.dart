import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/meal_detail.dart';
import 'recipes_provider.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final String mealId;
  final String mealName;
  final String mealThumb;

  const RecipeDetailScreen({
    super.key,
    required this.mealId,
    required this.mealName,
    required this.mealThumb,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mealAsync = ref.watch(mealDetailProvider(mealId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                mealName,
                style: const TextStyle(
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Hero(
                tag: 'meal_$mealId',
                child: mealThumb.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: mealThumb,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey.shade300),
                      )
                    : Container(color: Colors.grey.shade300),
              ),
            ),
          ),
          mealAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, st) => SliverFillRemaining(
              child: Center(child: Text(l10n.error)),
            ),
            data: (meal) => meal == null
                ? SliverFillRemaining(
                    child: Center(child: Text(l10n.noResults)),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate([
                      _DetailBody(meal: meal, l10n: l10n),
                    ]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final MealDetail meal;
  final AppLocalizations l10n;

  const _DetailBody({required this.meal, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (meal.category.isNotEmpty)
                Chip(
                  label: Text(meal.category),
                  avatar:
                      const Icon(Icons.category_outlined, size: 16),
                ),
              if (meal.area.isNotEmpty)
                Chip(
                  label: Text(meal.area),
                  avatar:
                      const Icon(Icons.public_outlined, size: 16),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            l10n.ingredients,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...meal.ingredients.map(
            (ing) => _IngredientRow(
              ingredient: ing.$1,
              measure: ing.$2,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.instructions,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            meal.instructions,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (meal.youtubeUrl != null && meal.youtubeUrl!.isNotEmpty) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(meal.youtubeUrl!)),
                );
              },
              icon: const Icon(Icons.play_circle_outline),
              label: Text(l10n.watchVideo),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final String ingredient;
  final String measure;
  final Color color;

  const _IngredientRow({
    required this.ingredient,
    required this.measure,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record, size: 8, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(ingredient,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            measure,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

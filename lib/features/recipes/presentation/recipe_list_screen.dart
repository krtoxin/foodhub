import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/meal_preview.dart';
import 'recipes_provider.dart';

class RecipeListScreen extends ConsumerWidget {
  final String category;

  const RecipeListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mealsAsync = ref.watch(mealsByCategoryProvider(category));

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(mealsByCategoryProvider(category)),
        child: mealsAsync.when(
          loading: _buildShimmer,
          error: (err, st) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.error),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(mealsByCategoryProvider(category)),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
          data: (meals) => meals.isEmpty
              ? Center(child: Text(l10n.noResults))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: meals.length,
                  itemBuilder: (ctx, i) => _MealCard(
                    meal: meals[i],
                    onTap: () => ctx.push(
                      '/recipe-detail/${meals[i].id}',
                      extra: {
                        'name': meals[i].name,
                        'thumb': meals[i].thumb,
                      },
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (ctx, i) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealPreview meal;
  final VoidCallback onTap;

  const _MealCard({required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Hero(
              tag: 'meal_${meal.id}',
              child: CachedNetworkImage(
                imageUrl: meal.thumb,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey.shade200),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  meal.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

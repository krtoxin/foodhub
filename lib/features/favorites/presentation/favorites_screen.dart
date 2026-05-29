import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/favorite_meal.dart';
import 'favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: favorites.isEmpty
          ? _EmptyState(l10n: l10n)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (ctx, i) =>
                  _FavoriteCard(meal: favorites[i], l10n: l10n),
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_outline, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            l10n.noFavorites,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noFavoritesSubtitle,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends ConsumerWidget {
  final FavoriteMeal meal;
  final AppLocalizations l10n;

  const _FavoriteCard({required this.meal, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(meal.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) =>
          ref.read(favoritesProvider.notifier).toggle(meal),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(
            '/recipe-detail/${meal.id}',
            extra: {'name': meal.name, 'thumb': meal.thumb},
          ),
          child: Row(
            children: [
              Hero(
                tag: 'meal_${meal.id}',
                child: CachedNetworkImage(
                  imageUrl: meal.thumb,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (ctx, url) =>
                      Container(color: Colors.grey.shade200),
                  errorWidget: (ctx, url, err) =>
                      Container(color: Colors.grey.shade200,
                          child: const Icon(Icons.restaurant, size: 40)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (meal.category != null && meal.category!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(meal.category!),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ],
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
      ),
    );
  }
}

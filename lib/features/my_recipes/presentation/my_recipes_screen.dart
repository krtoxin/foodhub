import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../data/my_recipes_firestore_service.dart';
import '../domain/my_recipe.dart';
import 'my_recipes_provider.dart';

class MyRecipesScreen extends ConsumerWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myRecipes)),
      body: uid == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<MyRecipe>>(
              stream: myRecipesFirestoreService.recipesStream(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final recipes = snapshot.data ?? [];

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .read(myRecipesProvider.notifier)
                      .syncFromFirestore(recipes);
                });

                if (recipes.isEmpty) return _EmptyState(l10n: l10n);

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recipes.length,
                  itemBuilder: (ctx, i) => _RecipeCard(
                    recipe: recipes[i],
                    onDelete: () => ref
                        .read(myRecipesProvider.notifier)
                        .delete(recipes[i].id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-recipe'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addRecipe),
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
          const Icon(Icons.menu_book_outlined, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            l10n.myRecipes,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to add your first recipe',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final MyRecipe recipe;
  final VoidCallback onDelete;

  const _RecipeCard({required this.recipe, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(recipe.id),
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
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            _RecipeImage(imagePath: recipe.imagePath),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (recipe.category.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(recipe.category),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  final String? imagePath;

  const _RecipeImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) return _placeholder();
    if (imagePath!.startsWith('http')) {
      return Image.network(
        imagePath!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, st) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        width: 100,
        height: 100,
        color: Colors.grey.shade200,
        child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
      );
}

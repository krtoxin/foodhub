import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';

class RecipeDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(mealName.isEmpty ? l10n.loading : mealName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Деталі рецепту',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

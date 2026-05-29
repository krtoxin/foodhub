import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.noFavorites,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(l10n.noFavoritesSubtitle,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

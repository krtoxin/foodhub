import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';

class RecipeListScreen extends StatelessWidget {
  final String category;

  const RecipeListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.list_alt_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.loading, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

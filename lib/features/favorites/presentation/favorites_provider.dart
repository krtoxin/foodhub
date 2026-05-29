import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../domain/favorite_meal.dart';

class FavoritesNotifier extends Notifier<List<FavoriteMeal>> {
  @override
  List<FavoriteMeal> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return _load(prefs);
  }

  List<FavoriteMeal> _load(SharedPreferences prefs) {
    final raw = prefs.getString(AppConstants.prefFavorites);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => FavoriteMeal.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> toggle(FavoriteMeal meal) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = List<FavoriteMeal>.from(state);
    final index = current.indexWhere((m) => m.id == meal.id);
    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.insert(0, meal);
    }
    await prefs.setString(
      AppConstants.prefFavorites,
      jsonEncode(current.map((m) => m.toJson()).toList()),
    );
    state = current;
  }

  bool isFavorite(String id) => state.any((m) => m.id == id);
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<FavoriteMeal>>(
        FavoritesNotifier.new);

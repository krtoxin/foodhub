import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../domain/my_recipe.dart';

class MyRecipesNotifier extends Notifier<List<MyRecipe>> {
  @override
  List<MyRecipe> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return _load(prefs);
  }

  List<MyRecipe> _load(SharedPreferences prefs) {
    final raw = prefs.getString(AppConstants.prefMyRecipes);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => MyRecipe.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> add(MyRecipe recipe) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final updated = [recipe, ...state];
    await _persist(prefs, updated);
    state = updated;
  }

  Future<void> delete(String id) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final updated = state.where((r) => r.id != id).toList();
    await _persist(prefs, updated);
    state = updated;
  }

  Future<void> _persist(SharedPreferences prefs, List<MyRecipe> list) async {
    await prefs.setString(
      AppConstants.prefMyRecipes,
      jsonEncode(list.map((r) => r.toJson()).toList()),
    );
  }
}

final myRecipesProvider =
    NotifierProvider<MyRecipesNotifier, List<MyRecipe>>(MyRecipesNotifier.new);

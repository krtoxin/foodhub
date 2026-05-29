import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/my_recipes_firestore_service.dart';
import '../domain/my_recipe.dart';

class MyRecipesNotifier extends Notifier<List<MyRecipe>> {
  @override
  List<MyRecipe> build() => [];

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> add(MyRecipe recipe) async {
    final uid = _uid;
    if (uid != null) await myRecipesFirestoreService.add(uid, recipe);
    state = [recipe, ...state];
  }

  Future<void> delete(String id) async {
    final uid = _uid;
    if (uid != null) await myRecipesFirestoreService.delete(uid, id);
    state = state.where((r) => r.id != id).toList();
  }

  void syncFromFirestore(List<MyRecipe> recipes) {
    state = recipes;
  }
}

final myRecipesProvider =
    NotifierProvider<MyRecipesNotifier, List<MyRecipe>>(MyRecipesNotifier.new);

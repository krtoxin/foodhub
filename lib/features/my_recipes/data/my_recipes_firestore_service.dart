import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/my_recipe.dart';

class MyRecipesFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('my_recipes');

  Stream<List<MyRecipe>> recipesStream(String uid) {
    return _col(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => MyRecipe.fromJson(doc.data())).toList());
  }

  Future<void> add(String uid, MyRecipe recipe) async {
    await _col(uid).doc(recipe.id).set(recipe.toJson());
  }

  Future<void> update(String uid, MyRecipe recipe) async {
    await _col(uid).doc(recipe.id).update(recipe.toJson());
  }

  Future<void> delete(String uid, String recipeId) async {
    await _col(uid).doc(recipeId).delete();
  }
}

final myRecipesFirestoreService = MyRecipesFirestoreService();

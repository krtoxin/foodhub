import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/favorite_meal.dart';

class FavoritesFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('favorites');

  Stream<List<FavoriteMeal>> favoritesStream(String uid) {
    return _col(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => FavoriteMeal.fromJson(doc.data()))
            .toList());
  }

  Future<void> add(String uid, FavoriteMeal meal) async {
    await _col(uid).doc(meal.id).set({
      ...meal.toJson(),
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> remove(String uid, String mealId) async {
    await _col(uid).doc(mealId).delete();
  }

  Future<bool> isFavorite(String uid, String mealId) async {
    final doc = await _col(uid).doc(mealId).get();
    return doc.exists;
  }
}

final favoritesFirestoreService = FavoritesFirestoreService();

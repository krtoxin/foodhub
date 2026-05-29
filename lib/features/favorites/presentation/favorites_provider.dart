import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/presentation/auth_provider.dart';
import '../data/favorites_firestore_service.dart';
import '../domain/favorite_meal.dart';

class FavoritesNotifier extends Notifier<List<FavoriteMeal>> {
  @override
  List<FavoriteMeal> build() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final sub = favoritesFirestoreService
          .favoritesStream(uid)
          .listen((meals) => state = meals);
      ref.onDispose(sub.cancel);
    }
    return [];
  }

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> toggle(FavoriteMeal meal) async {
    final uid = _uid;
    final current = List<FavoriteMeal>.from(state);
    final index = current.indexWhere((m) => m.id == meal.id);

    if (index >= 0) {
      current.removeAt(index);
      if (uid != null) await favoritesFirestoreService.remove(uid, meal.id);
    } else {
      current.insert(0, meal);
      if (uid != null) await favoritesFirestoreService.add(uid, meal);
    }
    state = current;
  }

  bool isFavorite(String id) => state.any((m) => m.id == id);

  void syncFromFirestore(List<FavoriteMeal> meals) {
    state = meals;
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<FavoriteMeal>>(
        FavoritesNotifier.new);

final favoritesStreamProvider = Provider<Stream<List<FavoriteMeal>>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return favoritesFirestoreService.favoritesStream(uid);
});


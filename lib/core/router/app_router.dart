import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_provider.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/my_recipes/presentation/add_recipe_screen.dart';
import '../../features/my_recipes/presentation/my_recipes_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/recipes/presentation/recipe_detail_screen.dart';
import '../../features/recipes/presentation/recipe_list_screen.dart';
import 'main_scaffold.dart';

class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isAuthenticated = false;

  _RouterNotifier(this._ref) {
    _isAuthenticated = _ref.read(authProvider).isAuthenticated;

    FirebaseAuth.instance.authStateChanges().listen((user) {
      final wasAuth = _isAuthenticated;
      _isAuthenticated = user != null;
      if (wasAuth != _isAuthenticated) notifyListeners();
    });

    _ref.listen(authProvider, (_, next) {
      final newVal = next.isAuthenticated;
      if (_isAuthenticated != newVal) {
        _isAuthenticated = newVal;
        notifyListeners();
      }
    });
  }

  bool get isAuthenticated => _isAuthenticated;
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuth = notifier.isAuthenticated;
      final loc = state.matchedLocation;
      final isAuthRoute =
          loc == '/login' || loc == '/register' || loc == '/forgot-password';

      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/my-recipes',
            builder: (context, state) => const MyRecipesScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/recipe-list/:category',
        builder: (context, state) {
          final category = state.pathParameters['category'] ?? '';
          return RecipeListScreen(category: category);
        },
      ),
      GoRoute(
        path: '/recipe-detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          return RecipeDetailScreen(
            mealId: id,
            mealName: extra?['name'] as String? ?? '',
            mealThumb: extra?['thumb'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/add-recipe',
        builder: (context, state) => const AddRecipeScreen(),
      ),
    ],
  );
});

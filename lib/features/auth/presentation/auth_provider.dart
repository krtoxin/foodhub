import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../domain/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyEmail = 'user_email';
  static const _keyName = 'user_name';
  static const _keyPhotoUrl = 'user_photo_url';

  @override
  AuthState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AuthState(
      isAuthenticated: prefs.getBool(_keyLoggedIn) ?? false,
      email: prefs.getString(_keyEmail),
      displayName: prefs.getString(_keyName),
      photoUrl: prefs.getString(_keyPhotoUrl),
    );
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool(_keyLoggedIn, true);
      await prefs.setString(_keyEmail, email);
      state = AuthState(isAuthenticated: true, email: email,
          displayName: prefs.getString(_keyName));
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool(_keyLoggedIn, true);
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyName, name);
      state = AuthState(isAuthenticated: true, email: email, displayName: name);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_keyLoggedIn);
    state = const AuthState();
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(isLoading: false);
  }

  Future<void> updatePhotoUrl(String url) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyPhotoUrl, url);
    state = state.copyWith(photoUrl: url);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

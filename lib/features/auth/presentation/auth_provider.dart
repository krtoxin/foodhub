import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  @override
  AuthState build() {
    final user = _auth.currentUser;
    return _fromUser(user);
  }

  AuthState _fromUser(User? user) {
    if (user == null) return const AuthState();
    return AuthState(
      isAuthenticated: true,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = _fromUser(_auth.currentUser);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _authError(e));
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user?.updateDisplayName(name);
      await cred.user?.reload();
      state = _fromUser(_auth.currentUser);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _authError(e));
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AuthState();
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _authError(e));
    }
  }

  Future<void> updatePhotoUrl(String url) async {
    await _auth.currentUser?.updatePhotoURL(url);
    state = state.copyWith(photoUrl: url);
  }

  String _authError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Authentication error.';
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final currentUidProvider = Provider<String?>((ref) {
  final isAuth = ref.watch(authProvider).isAuthenticated;
  if (!isAuth) return null;
  return FirebaseAuth.instance.currentUser?.uid;
});

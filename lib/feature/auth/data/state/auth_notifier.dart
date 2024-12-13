import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/core/providers/providers.dart';

import '../repository/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(Ref ref)
      : _repository = ref.read(authRepositoryProvider),
        super(
          const AuthState.initial(),
        ) {
    _listenToAuthStateChanges();
  }

  void _listenToAuthStateChanges() {
    final authStateStream = _repository.authStateChanges;
    authStateStream.listen((user) {
      if (user == null) {
        state = const AuthState.unauthenticated(message: 'User is signed out');
      } else {
        state = AuthState.authenticated(user: user);
      }
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    final response = await _repository.login(email: email, password: password);

    state = response.fold(
      (error) => AuthState.unauthenticated(message: error),
      (user) => AuthState.authenticated(user: user!),
    );
  }

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    final response = await _repository.signUp(email: email, password: password);

    state = response.fold(
      (error) => AuthState.unauthenticated(message: error),
      (user) => AuthState.authenticated(user: user),
    );
  }

  // Add the logout method
  Future<void> logout() async {
    final response = await _repository.logout();

    state = response.fold(
      (error) => AuthState.unauthenticated(message: error),
      (_) => const AuthState.unauthenticated(message: 'User logged out'),
    );
  }
}

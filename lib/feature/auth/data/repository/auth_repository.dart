// auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/core/providers/providers.dart';

import '../source/remote_source.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<Either<String, User>> signUp(
      {required String email, required String password});
  Future<Either<String, User?>> login(
      {required String email, required String password});
  Future<Either<String, void>> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _authRemoteSource;

  AuthRepositoryImpl(Ref ref)
      : _authRemoteSource = ref.read(authRemoteSourceProvider);

  @override
  Stream<User?> get authStateChanges => _authRemoteSource.authStateChanges;

  @override
  Future<Either<String, User>> signUp({
    required String email,
    required String password,
  }) {
    return _authRemoteSource.signUp(email: email, password: password);
  }

  @override
  Future<Either<String, User?>> login({
    required String email,
    required String password,
  }) {
    return _authRemoteSource.login(email: email, password: password);
  }

  // Add the logout method
  @override
  Future<Either<String, void>> logout() async {
    try {
      await _authRemoteSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

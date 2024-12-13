import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/constants/errors.dart';
import 'package:task_app/core/providers/providers.dart';

abstract class AuthRemoteSource {
  Stream<User?> get authStateChanges;
  String? get currentUserId;
  Future<Either<String, User>> signUp({
    required String email,
    required String password,
  });
  Future<Either<String, User?>> login({
    required String email,
    required String password,
  });
  Future<Either<String, void>> logout();
}

class AuthRemoteSourceImpl extends AuthRemoteSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteSourceImpl(Ref ref)
      : _firebaseAuth = ref.read(firebaseAuthProvider);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  Future<Either<String, User>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(response.user!);
    } on FirebaseAuthException catch (e) {
      return left(firebaseAuthErrMsg(e));
    }
  }

  @override
  Future<Either<String, User?>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(response.user);
    } on FirebaseAuthException catch (e) {
      return left(firebaseAuthErrMsg(e));
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return left(firebaseAuthErrMsg(e));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/feature/auth/data/source/remote_source.dart';
import 'package:task_app/feature/tasks/data/repository/task_repository.dart';
import 'package:task_app/feature/tasks/data/source/remote_source.dart';

import '../../feature/auth/data/repository/auth_repository.dart';
import '../../feature/auth/data/state/auth_notifier.dart';
import '../../feature/auth/data/state/auth_state.dart';
import '../../feature/tasks/data/state/task_cud_notifier.dart';
import '../../feature/tasks/data/state/task_cud_state.dart';
import '../../feature/tasks/data/state/task_stream_notifier.dart';
import '../../feature/tasks/data/state/task_stream_state.dart';

// Firebase
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Authentication
final authRemoteSourceProvider = Provider<AuthRemoteSource>(
  (ref) => AuthRemoteSourceImpl(ref),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

// Tasks
final taskRemoteSourceProvider = Provider<TaskRemoteSource>(
  (ref) => TaskRemoteSourceImpl(ref),
);

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepositoryImpl(ref),
);

final taskStreamProvider =
    StateNotifierProvider<TaskStreamNotifier, TaskStreamState>(
  (ref) => TaskStreamNotifier(ref),
);

final taskCudProvider = StateNotifierProvider<TaskCudNotifier, TaskCudState>(
  (ref) => TaskCudNotifier(ref),
);
